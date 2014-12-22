#!/bin/sh

# folder containing all *vcf files
contactstore=~/ppl

temp=~/.tempcontacts

cat ${contactstore}/*vcf > $temp 
adb shell pm clear com.android.contacts
adb shell pm clear com.android.providers.contacts 
adb push $temp /sdcard/contacts-import.vcf
adb shell am start -t "text/vcard" -d "file:///sdcard/contacts-import.vcf" -a android.intent.action.VIEW com.android.contacts
# alternative mime-code:  text/x-vcard
