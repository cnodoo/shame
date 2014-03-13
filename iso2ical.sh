#!/bin/sh

# converts simple iso8601 dates to ical format
# usage: ./iso2ical.sh iso8601string [single-line summary]

#TODO: designator default is "/", but could also be "--" (or even something completly differen?

datestring=`echo $1 | sed -e 's/-//g' -e 's/://g'`
shift

repeat=`echo $datestring | grep -o  ^R[0-9]*\/`
datestring=`echo $datestring | sed -e 's/^R[0-9]*\///g'`
repeat=`echo $repeat | sed -e 's/^R\//0/g' | sed -e 's/^R//g' -e 's/\/$//g'`
#INFO: repeat=0 => unlimited; repeat='' => kein interval, kein repeating

dtstart=`echo $datestring | cut -d / -f1`
dtend=`echo $datestring | cut -d / -f2`

test "${dtstart}" == "${dtend}" && test -n "${repeat}" \
	&& echo "ERR: REPEAT is ${repeat}: Interval was expected, but DTSTART and DTEND are identical." \
	&& exit -1

test "${dtstart}" == "${dtend}" && dtend=''

period1=`echo $dtstart | grep ^P`
period2=`echo $dtend | grep ^P`
test -n "${period1}" && period="${period1}" && dtstart=''
test -n "${period2}" && period="${period2}" && dtend=''
test -z "${period1}" && test -z "${period2}" && period=''

test -n "${period1}" && test -n "${period2}"\
	&& echo "ERR: PERIOD1 and PERIOD2 cannot both be set." \
  && exit -1

cn=`getent passwd "${USER}" | cut -d ':' -f 5 | cut -d ',' -f 1`

#TODO: Look up REPEAT, DURATION, PERIOD and RECUR in rfc5545

test -z "${period}" && test -z "${dtend}" && period=P1D

sed -e '/^$/d' <<EOT
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//`basename ${0}`//NONSGML v1.0//EN
BEGIN:VEVENT
UID:urn:uuid:`uuidgen`
DTSTAMP:`date -u +%Y%m%dT%H%M%SZ`
ORGANIZER${cn:+;CN=${cn}}:mailto:${USER}@`hostname -f`
${dtstart:+DTSTART:${dtstart}}
${dtend:+DTEND:${dtend}}
${period:+DURATION:${period}}
SUMMARY:$*
END:VEVENT
END:VCALENDAR
EOT
