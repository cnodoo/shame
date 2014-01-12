#!/bin/sh

check_ready () {
	adb root
	adb remount
	#TODO: ...
}


show_help () {
# == REQUIREMENTS ==
# adb
# sqlite3
# dos2unix
# csplit
}


sync_calls () {
	calls_db="/data/data/com.android.providers.contacts/databases/contacts2.db"
	calls_table="calls"
	calls_query="SELECT number, date, duration, type, new FROM ${calls_table}"
	calls_cmd="sqlite3 -csv '${calls_db}' '${calls_query}'"
	calls_log="logfile"

	for call in `adb shell ${calls_cmd}`
	do
		NUMBER=`echo "${call}" | cut -d ',' -f 1`
		DATE=`echo "${call}" | cut -d ',' -f 2`
		DURATION=`echo "${call}" | cut -d ',' -f 3`
		TYPE=`echo "${call}" | cut -d ',' -f 4`
		NEW=`echo "${call}" | cut -d ',' -f 5`
	
		#INFO: Search contacts for name.
		NAME="unknown" #TODO: ...
	
		#INFO: Convert date to iso/w3c format.
		DATE=`expr "${DATE}" / 1000`
		DATE=`date -u -d "@${DATE}" +%Y-%m-%dT%H:%M:%S`
	
		#INFO: Convert number to tel-URI.
		NUMBER="tel:${NUMBER}"	#TODO: country p
	
		#INFO: Convert type to string.
		case "${TYPE}" in
			1) TYPE="incomming call from" ;;
			2) TYPE="outgoing call to" ;;
			3) TYPE="missed call from" ;;
			*) TYPE="undefined call;" ;;
		esac
	
		#INFO: Convert new to string.
		case "${NEW}" in
			1) NEW="unseen" ;;
			0) NEW="seen" ;;
			*) NEW="undefined" ;;
		esac
	
		#INFO: Append seconds marker to duration.
		DURATION="${DURATION}s"
	
		echo "${DATE} ${NEW} ${TYPE} \"${NAME}\" <${NUMBER}> for ${DURATION}" #TODO: output format? name lookup? output file?
	
		unset NUMBER DATE DURATION TYPE NEW NAME	
	done

	#INFO: Cleaning...
	#TODO: remove synced entries from database
	unset calls_db calls_table calls_query calls_cmd calls_log
}


sync_texts () {
	texts_db="/data/data/com.android.providers.telephony/databases/mmssms.db"
	texts_table="sms"
	texts_query="SELECT * FROM ${messages_table}"
	texts_cmd="sqlite3 -list '${texts_db}' '${texts_query}'"
	texts_tempdir=""

	#INFO: Write each message to a seperate file.
	mkdir -p "${texts_tempdir}"
	pushd "${texts_tempdir}"
	adb shell ${texts_cmd} | dos2unix | csplit -z -s -n 4 -f sms - '/^$/' '{*}'

	#INFO: Format, refile and delete every message.
	for sms in `ls -1`
	do
		#TODO: format text messages 
		#TODO: refile messages
		rm "${sms}"
	done

	#INFO: Cleaning...
	#TODO: remove synced entries from database
	popd
	rmdir "${texts_tempdir}"
	unset sms
	unset texts_db texts_table texts_query texts_cmd texts_tempdir
}


sync_pictures () {
	pictures_tempdir=
	pictures_targetdir=

	#INFO: Copy DCIM pictures to temporary directory.
	mkdir -p "${pictures_tempdir}"
	pushd "${pictures_tempdir}"
	adb pull /mnt/sdcard/DCIM/Camera/

	#INFO: Move them to target directory.
	mkdir -p "${pictures_targetdir}"
	mv -i * "${pictures_targetdir}"

	#INFO: Remove synced pictures from device.
	for pic in `adb shell 'ls /sdcard/DCIM/Camera/ '`
	do 
		file=`echo "${pic}" | tr -d  "\r\n"`
		file="/sdcard/DCIM/Camera/${file}"
		adb shell "rm ${file}"
	done

	#INFO: Cleaning...
	popd
	rmdir "${pictures_tempdir}"
	unset pic file
	unset pictures_tempdir pictures_targetdir
}


sync_calendars () {
# == calendar ==
# get: adb shell 'sqlite3 -line /data/data/com.android.providers.calendar/databases/calendar.db "SELECT * FROM todotodotodo"'
# del:
#
# Attendees             Events                _sync_state         
# CalendarAlerts        EventsRawTimes        _sync_state_metadata
# CalendarCache         ExtendedProperties    android_metadata    
# CalendarMetaData      Instances             view_events         
# Calendars             Reminders        
}

# http://cmanios.wordpress.com/2013/10/29/read-sms-directly-from-sqlite-database-in-android/
# http://minhdanh2002.blogspot.de/2012/02/raw-access-to-sms-database-on-android.html
# http://ajack.org/blog/grabbing-sms-from-android/
# http://www.droidforums.net/forum/android-hacks-help/147841-call-log-location.html

calendar_db="data/data/com.android.providers.calendar/databases/calendar.db"
contacts_db="/data/data/com.android.providers.contacts/databases/contacts.db"
