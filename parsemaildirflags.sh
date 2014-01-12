#!/bin/sh


#file=~/mail/tasks/cur/fooobar:2,psd
#base=`basename ${file}`
#info=`echo ${base} | cut -d ':' -f 2`
#flags=`echo ${info}  | cut -d ',' -f 2`
flags=psd

args=`getopt psrftdn ${flags}`; errcode="${?}"; set -- ${args}

while :
do

	case "${i}" in 
		-p) echo passed; shift;;
		-s) echo seen; shift;;
		-r) echo replied; shift;;
		-f) echo flagged; shift;;
		-t) echo trashed; shift;;
		-d) echo draft; shift;;
		-n) echo new; shift;;
		--) shift; break;;
	esac

done



