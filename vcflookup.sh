#!/bin/sh

contacts=~/ppl/
count=0

# TODO: -n NUMBER => show only the first NUMBER of vcards
# TODO: -f FIELDNAME => show only FIELDNAME fields

for i in `grep -l -i "${*}" "${contacts}"*`
do
	count=`expr "${count}" + 1`
	filename=`basename "${i}" ".vcf"`
	path="${i}"
	cat "${path}"
done
