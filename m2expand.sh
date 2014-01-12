#!/bin/sh

# README
#
# This script tries to decode URIs using the mailto scheme and prints
# out a draft message. It was written for testing purpose only. It is
# not tested. You should use your MUA's built in solution anyway.
#
# This is not 'sane' software.
# It sucks. Hard.
# This software kills cute kitties at random.
#
# You have been warned.
 
# TODO
# 
# This file is scattered with #FIXME, #TODO, #INFO and #DEBUG marks.
 
#INFO: https://tools.ietf.org/html/rfc2368
#INFO: https://tools.ietf.org/html/rfc1738
#TODO: multiple occurances of header fields


if [ $# -gt 0 ]
then
  uri="$1"
else
  uri=`cat -- | head -n 1`
fi

to=`echo "${uri}" | cut -d '?' -f1 | sed -e 's/^[Mm][Aa][Ii][Ll][Tt][Oo]://'`
to=`uridecode "${to}"`

headers=`echo "${uri}" | cut -d '?' -f2`

test "${headers}" = "${uri}" && unset headers

for header in `echo "${headers}" | tr '&' '\n'`
do
  hname=`echo "${header}" |  cut -d '=' -f1`
  hvalue=`echo "${header}" |  cut -d '=' -f2`

  case `echo "${hname}" | tr '[:upper:]' '[:lower:]'` in
    body) body="${hvalue}" ;;
    to) hvalue=`uridecode ${hvalue}`; to="${to:+$to ,} ${hvalue}" ;;
    cc) hvalue=`uridecode ${hvalue}`; cc="${cc:+$cc ,} ${hvalue}" ;;
    bcc) hvalue=`uridecode ${hvalue}`; bcc="${bcc:+$bcc ,} ${hvalue}" ;;
    from) hvalue=`uridecode ${hvalue}`; from="${from:+$from ,} ${hvalue}" ;;
    to) hvalue=`uridecode ${hvalue}`; to="${to:+$to ,} ${hvalue}" ;;
    *) echo "${hname}: `uridecode ${hvalue}`" ;;
  esac

done

cat <<EOT
From: ${from}
To: ${to}
Cc: ${cc}
Bcc: ${bcc}

`uridecode "${body}"`
EOT
