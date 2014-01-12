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

args=`getopt k:c: ${*}`; errcode="${?}"; set -- ${args}

while :
do
	case "${1}" in
		-k) keywords="${keywords:+$keywords&}Keywords=`uriencode ${2}`"; shift; shift;;
		-c) comments="${comments:+$comments&}Comments=`uriencode ${2}`"; shift; shift;;
		--) shift; break;;
	esac
done

subject=`uriencode "[BOOKMARK] ${*}"`



url="mailto:foobar@local?subject=${subject}&keywords=bookmark${keywords:+&$keywords}${comments:+&$comments}"


echo $url
