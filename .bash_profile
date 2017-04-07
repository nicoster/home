export PATH=/usr/local/otp-profiling/bin:/usr/local/sbin:$PATH
export CFLAGS="-I/usr/local/opt/pcre/include/ -I/usr/local/opt/openssl/include -I/usr/local/include/"
export LDFLAGS="-L/usr/local/opt/pcre/lib/ -L/usr/local/opt/openssl/lib/ -L/usr/local/lib/"
export PS1='\W $ '
export HISTFILESIZE=2500
export HISTSIZE=2500
export GOPATH=/workspace/gocode
export JAVA_HOME=$(/usr/libexec/java_home)
export EDITOR=vim
export _SYMBOL_PATH=~/symbols
export OTP_HOME=/Users/nickx/local/lib/erlang

alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
alias eman='erl -man'
alias chkdsk='du -h -d 2 |grep "G\t"'
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport'
alias matlab='/Applications/MATLAB_R2016b.app/bin/matlab -nodisplay -nodesktop -nosplash -nojvm'

# . ~/bashx/git-completion.bash
function ssp(){ grep $1 ~/.ssh/config -A 4; }
function rget(){ ssh ${2:-dev1} "cd /tmp && wget -O ${3:-`basename $1`} $1" && scp ${2:-dev1}:/tmp/${3:-`basename $1`} . && echo http://`ifconfig | grep "inet "|grep -v "127.0.0.1"|cut -d " " -f 2`:8000/${3:-`basename $1`}|pbcopy && pbpaste && python -m SimpleHTTPServer; }

function beamdevs() { seq 1 6|parallel -j0 beam dev{} $*; }
function beamshards() { beam s0 $* && beam s1 $* && beam s2 $* && beam s3 $*; }
function zcfg()
{
	local URL
	if [[ $# -lt 1 ]]; then
		defaults read ZoomChat conf.webserver
	else
		defaults write ZoomChat com.zoom.client.zclist ""
		case $1 in
			www) 
				URL=http://www.zoom.us
				;;
			dev)
				URL=http://dev.zoom.us
				;;
			cn)
				URL=http://www.zoomus.cn
				;;
			*)
				URL=$1
		esac
		defaults write ZoomChat conf.webserver $URL
		killall zoom.us 
		$FUNCNAME
	fi
}

function timeconv() { python -c "import datetime as a; print '\n'.join([t + ':\t' + str(a.datetime.fromtimestamp(float(t if len(t) == 13 else t + '000')/1000.0)) for t in '$*'.split()])"; }

export JENKINS_URL=http://xmpp-jenkins.zoom.us:8080
alias jen="java -jar /usr/local/bin/jenkins-cli.jar -s $JENKINS_URL"
function rmake() { 
	JOB=build_ejabberd_specified_branch && U=$JENKINS_URL/job/$JOB/ && \
	jen build $JOB -p branch=${1:-`git st|grep "On branch"|cut -c11-`} -f -v && \
	wget -q -O - $U|egrep -o '<a href="lastSuccessfulBuild/artifact/rpmbuild/RPMS/noarch.*?\.rpm"'|awk -F \" '{print "'$U'" $2}'; 
}
function push2dev() { jen build update_usdev_to_latest_specified -f -v; }
function push2tcp() { jen build update_tcpcopy_to_latest_specified -f -v; }

function dns() {
	if [[ $# -lt 1 ]]; then
		echo DNS Settings:
		cat /etc/resolv.conf |grep -v '#'
	else
		case $1 in
			work)
				cp /usr/local/etc/work-dnsmasq.conf /usr/local/etc/dnsmasq.conf
				$FUNCNAME dnsmasq
				;;
			home)
				cp /usr/local/etc/home-dnsmasq.conf /usr/local/etc/dnsmasq.conf
				$FUNCNAME dnsmasq
				;;
			dnsmasq)
				$FUNCNAME reset
				cat /etc/resolv.conf |grep 'nameserver'| awk '{print $2}'|xargs sudo networksetup -setdnsservers Wi-Fi 127.0.0.1
				sudo killall dnsmasq 	# homebrew service will start dnsmasq for me
				$FUNCNAME
				echo dig:
				dig xmppdev002.zoom.us @localhost|grep IN
				;;
			reset)
				sudo networksetup -setdnsservers Wi-Fi empty
				;;
			*)
				echo "usage: $FUNCNAME [dnsmasq|home|work|reset]"
				echo "	dnsmasq - enable dnsmasq"
				echo "	home - copy home config then enable dnsmasq"
				echo "	work - copy work config then enable dnsmasq"
				echo "	reset - disable dnsmasq"
				echo
				$FUNCNAME
				;;
		esac

	fi
}





