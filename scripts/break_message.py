import lldb
import re

def lldb_run(command):
    res = lldb.SBCommandReturnObject()
    lldb.debugger.GetCommandInterpreter().HandleCommand(command, res)
    return res

def lldb_call(command):
    res = lldb_run('call ' + command)
    out = res.GetOutput()
    r = re.compile(r'^[^=]*= (.*)\n$')
    m = r.search(out)
    return m.groups()[0]

def __lldb_init_module(debugger, internal_dict):
    lldb_run('command script add -f break_message.{0} {0}'.format('break_message'))

def break_message(debugger, command, result, internal_dict):
    r = re.compile(r'([+-])\s*\[\s*(\S+)\s+([^\]]+)\]')
    m = r.search(command)
    if not m:
        print 'Error in message format!'
        return

    typ, cls, sel = m.groups()
    sel = re.sub(r'\s+', '', sel)

    meta = typ == '+'

    clsptr = lldb_call('(id)objc_getClass("{}")'.format(cls))
    if clsptr == 'nil':
        print "Couldn't find class: " + cls
        return

    selptr = lldb_call('(id)sel_registerName("{}")'.format(sel))
    if selptr == 'nil':
        print "Couldn't register selector: " + sel
        return

    func = 'class_getClassMethod' if meta else 'class_getInstanceMethod'
    method = lldb_call('(id){}({}, {})'.format(func, clsptr, selptr))
    if method == 'nil':
        print "Couldn't find method for: " + sel
        return

    imp = lldb_call('(id)method_getImplementation({})'.format(method))

    lldb_run('breakpoint set -a {}'.format(imp))
