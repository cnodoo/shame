#!/bin/sh

#adb shell pm clear com.android.contacts
#adb shell pm clear com.android.providers.contacts 



adb push sample.ics /sdcard/sample.ics
adb shell am start -t "text/calendar" -d "file:///sdcard/sample.ics" -a android.intent.action.VIEW de.k3b.android.calendar.ics.adapter

#org.dgtale.icsimport
#de.k3b.android.calendar.ics.adapter
