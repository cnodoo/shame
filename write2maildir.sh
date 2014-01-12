#!/bin/sh

# README
#
# This is not a mail delivery agent.
# This is not 'sane' software. It sucks. Hard.
# This is b0rked.
# This software kills cute kitties at random.
#
# Better rewrite it from scratch in your prefered language or choose
# an already available mda of your liking.
#
# You have been warned.

#
# URL: http://www.qmail.org/man/man5/maildir.html
# URL: http://cr.yp.to/proto/maildir.html
# URL: http://www.courier-mta.org/maildir.html
#


#
# CONFIGURATION
#
maildir=~/tmp-maildir							# maildir
args=`getopt d: ${*}`; errcode="${?}"; set -- ${args}
while :
do
        case "${1}" in
                -d) maildir="${2}"; shift; shift;;
                --) shift; break;;
        esac
done
date=`date +%s.%N`							# master date object: seconds since epoch and nanoseconds
LC_CTYPE=C
time=`echo "${date}" | cut -d '.' -f 1`					# time() or second counter of gettimeofday()
host=`hostname | tr ':' '\072' | tr '/' '\057'`                         # gethostname(); sanatized
ident=$$								# old-fashioned ident: pid or pid_deliverycount
filename="${time}"."${ident}"."${host}"
tempfile="${maildir}"/tmp/"${filename}"


#
# STEP 1 - chdir() to the maildir directory
#
mkdir -p "${maildir}"/tmp
mkdir -p "${maildir}"/new
mkdir -p "${maildir}"/cur
cd "${maildir}"


#
# STEP 2 - stat() tempfile
#
# stat(2) uniqe_file should return errno #2 (ENOENT), i.e. the
# file does not exist (0) and no other error was thrown. however,
# the shell command 'stat "${tempfile}"' does not distinguish
# between different non-zero exit codes. we use a simple 'test
# -e' instead.
#
if [ -e "${tempfile}" ]
then
	#
	# STEP 3 - retry except for ENOENT
	#
	sleep 2s
	# update time
	# retry (finite numbers, e.g. 3)
	exit 1
else
	#
	# STEP 4 - create tempfile
	#
	# start 24h timer; on expire kill delivery programm and (optional) unlink tempfile
	touch "${tempfile}"
fi


#
# STEP 6 - write() tempfile
#
# (1) as usual, checking the number of bytes returned from
#     each write() call;
# (2) calling fsync() and checking its return value;
# (3) calling close() and checking its return value. (Standard
#     NFS implementations handle fsync() incorrectly but make
#     up for it by abusing close().)
#
cat - > "${tempfile}"
# dd of=${tempfile}
# check number of bytes returned by write()
# fstat (ino, dev, size)


#
# GENERATE UNIQUE NAME
#
pid=$$									# Pn: decimal process id
deliverycount=1								# Qn: decimal number of deliveries made by this process
microseconds=`echo "${date}" | cut -d '.' -f 2 | cut -c 1-6`		# Mn: decimal microsecond counter of the SAME gettimeofday() used above
rand=`cat /dev/urandom | env LC_CTYPE=C tr -cd 'a-f0-9' | head -c 1` 	# Rn: hexadecimal output of unix_cryptorandomnumber() or /dev/urandom
sequence='foobar'							# #n: unix_sequencenumber(); each call self + 1
bootcount=`last reboot | grep reboot | wc -l`				# Xn: hexadecimal output of unix_bootnumber() [derzeit: approximated]
inode=$(printf "%x\n" `stat -c %i "${tempfile}"`)			# In: hexadecimal output of unix inode number of file 
device=`stat -c %D "${tempfile}"`					# Vn: hexadecimal output of unix device number of this file 
uniqueident="P${pid}M${microseconds}R${rand}X${bootcount}I${inode}V${device}"
uniquename="${time}"."${uniqueident}"."${host}"
newfile="${maildir}"/new/"${uniquename}"
# stat() newfile

#
# STEP 6 - link() tempfile to newfile
#
mv "${tempfile}" "${newfile}"

