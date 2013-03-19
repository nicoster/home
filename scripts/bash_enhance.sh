#!/bin/bash

export GREP_OPTIONS="--exclude=\*.svn\*"
export CLICOLOR=1
export LSCOLORS=HxFxCxDxBxegedabagacad

alias xxd2='cut -c-55|sed '\''s/  / /g'\''|xxd -r -'
alias ll='ls -lh'
alias shp='vi ~/.bash_profile&&source ~/.bash_profile'
alias b64='openssl base64'
alias beep='echo -e "\a"'
PS1='\u:\w \$ '
alias sgrep='echo "Search source but ignore binary and .svn";grep -nIr --exclude "*.tmp"'
alias rmbuild='find . -name "build"|xargs rm -r'
alias jwbt='adb pull /data/local/jwcpp/wbxtrace/wbxConnectmap_live.wbt'

#alias goopy="ps -A|grep /Goopy|awk '{print \$1}'|xargs kill 2>nul"


#alias chrome='open -a /Applications/Google\ Chrome.app --args --enable-experimental-extension-apis'
alias chrome='open -a ~/chromium/src/xcodebuild/Debug/Chromium.app --args --enable-experimental-extension-apis'
alias jslint2='jslint --white --color --node --nomen'
alias m='mate'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'

function diffcount()
{
  if [[ $# -eq 0 ]]; then
      echo Usage: diffcount foo.diff
	else
			grep "^+" $1|grep -v "^+++"|sed 's/^.//'|sed '/^$/d'|wc -l	
	fi
	
}

function zipmov()
{
#	echo $1
 handbrake -i $1 -o $(basename $1 .MOV).mp4 --preset "AppleTV"
}

alias emu='emulator -avd android&'
