#!/bin/sh

# README
#
# This is not a calendar nor a task management utility.
# This is not 'sane' software. It sucks. Hard.
# This only works with... it doesn't!
# This software kills cute kitties at random.
#
# Better rewrite it from scratch in your prefered language or just use
# taskwarrior (http://taskwarrior.org/projects/show/taskwarrior), a
# simple todo list or a full-blown iCal client/server.
#
# You have been warned.


taskdir=~/mail/tasks

dateformat="%a, %d %b %Y %H:%M:%S %z"
date=`LANG=C date +"${dateformat}"`
from=`whoami`'@'`hostname`

args=`getopt p:k:d:c:a:x ${*}`; errcode="${?}"; set -- ${args}

while :
do
	case "${1}" in
		-p) xpriority="${2}"; shift; shift;;
		-k) keywords="${2}, ${keywords}"; shift; shift;;
		-c) comments="${2} ${comments}"; shift; shift;;
		-a) arch="${2} ${arch}"; shift; shift;;
		-x) arg_x=1; shift;;
		-d) due="${2}"; shift; shift;;
		--) shift; break;;
	esac
done

test `test "${xpriority}" -gt 5; echo $?` -eq 2 && exit 1
test "${xpriority}" -lt 1 && exit 1
test "${xpriority}" -gt 5 && exit
#TODO# sanitycheck keywords
#TODO# sanitycheck comments
#TODO# sanitycheck arch
#TODO# sanitycheck arg_x
test `test "${due}" -gt 5; echo $?` -eq 2 && exit 1
#TODO# sanitycheck subject

for i in ${arch}
do
	subject="[${i}]${subject}"
done

subject="${subject} ${*}"
expires="${due}"         #TODO# convert $due to `LANG=C date +"${dateformat}"`
replyby="${due}"         #TODO# convert $due to `LANG=C date +"${dateformat}"`
keywords="${keywords}"   #TODO# remove trailing ",";  -k does not handle whitespaces; multiple Keywords: header are allowed
comments="${comments}"   #TODO# -c does not handle whitespaces; multiple Comments: header are allowed

case "${xpriority}" in
	1|2) importance="high"; priority="urgent";;
	3)   importance="normal"; priority="normal";;
	4|5) importance="low"; priority="non-urgent";;
	*)   importance="normal"; priority="normal";;	
esac

(
	echo "Subject: ${subject}"
	echo "Expires: ${expires}"
	echo "Reply-By: ${replyby}"
	echo "X-Priority: ${xpriority}"
	echo "Priority: ${priority}"
	echo "Importance: ${importance}"
	echo "Keywords: ${keywords}"
	echo "Comments: ${comments}"
	echo "From: ${from}"
	echo "Date: ${date}"
	echo "Category: ${category}"
	echo "Message-ID: ${messageid}"
	echo "Organization: ${organization}"
	echo "To: ${from}"
	# Status:    U    message is not downloaded and not deleted.
	#            R    message is read or downloaded.
	#            O    message is old but not deleted.
	#            D    to be deleted.
	#            N    new (a new message also sometimes is distinguished by not having any "Status:" header.
	#            Combinations of these characters can occur, such as "Status: OR" to indicate that a message is downloaded but not deleted.
	echo ""
	echo "foo"
) | cat
# to_maildir.sh -d "${taskdir}"




#bsd_date convert: date -jn -f input_fmt new_date +"${dateformat}"
#gnu_date convert: date -d new_date +"${dateformat}"






# +tag|-tag	=> Keywords

#     project:<project-name> Specifies the project to which a task is related to.  => In-Reply-To; References

# priority:H|M|L or priority:	=> Priority, X-Priority, Importance

#       due:<due-date> Specifies the due-date of a task. => Expiry-Date, Expires, Reply-By

#       recur:<frequency>              Specifies the frequency of a recurrence of a task.
#       until:<end-date-of-recurrence>              Specifies the Recurrence end-date of a task.

#      depends:<id1,id2 ...>	=> In-Reply-To; References; Supersedes; Obsoletes

# entry:<entry-date> For report purposes, specifies the date that a task was created. => Date, Received, Delivery-Date


# w3c/iso date => kann startpunkt/endpunkt sowie startpunkt+dauer darstellen!
