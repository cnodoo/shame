#! /bin/bash

###########################################################################
# Configurable section
###########################################################################
#
# Any entry in the lists of programs that urlview handler will try out will
# be made of /path/to/program + ':' + TAG where TAG is one of
# XW: XWindows program
# XT: Launch with an xterm if possible or as VT if not
# VT: Launch in the same terminal

# The lists of programs to be executed are
https_prgs="/usr/bin/htmlview:XW /usr/bin/firefox:XW /usr/bin/seamonkey:XW /usr/bin/konqueror:XW /usr/bin/epiphany:XW /usr/bin/links:XT /usr/bin/lynx:XT"
http_prgs="/usr/bin/htmlview:XW /usr/bin/firefox:XW /usr/bin/seamonkey:XW /usr/bin/konqueror:XW /usr/bin/epiphany:XW /usr/bin/links:XT /usr/bin/lynx:XT"
mailto_prgs="/usr/bin/mutt:VT /usr/bin/elm:VT /usr/bin/pine:VT /usr/bin/mail:VT"
gopher_prgs="/usr/bin/lynx:XT"
ftp_prgs="/usr/bin/ncftp:XT /usr/bin/wget:XT /usr/bin/lynx:XT"

# Program used as an xterm (if it doesn't support -T you'll need to change
# the command line in getprg)
XTERM=/usr/bin/xterm


###########################################################################
# Change bellow this at your own risk
###########################################################################
function getprg()
{
    local ele tag prog

    for ele in $*
    do
	tag=${ele##*:}
	prog=${ele%%:*}
	if [ -x $prog ]; then
	    case $tag in
	    XW)
		[ -n "$DISPLAY" ] && echo "X:$prog" && return 0
		;;
	    XT)
		[ -n "$DISPLAY" ] && [ -x "$XTERM" ] && \
		    echo "X:$XTERM -e $prog" && return 0
		echo "$prog" && return 0
		;;
	    VT)
		echo "$prog" && return 0
		;;
	    esac
	fi
    done
}

url="$1"; shift

type="${url%%:*}"

if [ "$url" = "$type" ]; then
    type="${url%%.*}"
    case "$type" in
    www|web)
	type=http
	;;
    esac
    url="$type://$url"
fi

case $type in
https)
    prg=`getprg $https_prgs`
    ;;
http)
    prg=`getprg $http_prgs`
    ;;
ftp)
    prg=`getprg $ftp_prgs`
    ;;
mailto)
    prg=`getprg $mailto_prgs`
    url="${url#mailto:}"
    ;;
gopher)
    prg=`getprg $gopher_prgs`
    ;;
*)
    echo -n "Unknown URL type.  Press enter to continue."; read x
    exit
    ;;
esac

if [ -n "$prg" ]; then
   if [ "${prg%:*}" = "X" ]; then
    ${prg#*:} "$url" 2>/dev/null &
   else
    $prg "$url"
   fi
fi




