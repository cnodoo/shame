#/bin/sh

file=$1

gawk ' /BEGIN:VCARD/ { ++a; fn=sprintf("%02d.vcf", a); print "Writing: ", fn } { print $0 >> fn; } ' ${file}
