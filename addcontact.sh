#!/bin/sh

#INFO: needs uuidgen
#INFO: needs unix2dos
#INFO: needs datauri, e.g. via data-uri.py https://gist.github.com/jsocol/1089733
#INFO: needs get-unique-filename

#  http://quimby.gnus.org/circus/face/

contactsdir=~/ppl/
output="${contactsdir}`get-unique-filename`.vcf"

#TODO: test before write; write to tmp
#TODO: http://tools.ietf.org/html/rfc6350


#
# BEGIN: text (1)
#
echo "BEGIN:VCARD" >> "${output}"


#
# VERSION: text (1)
#
echo "VERSION:4.0" >> "${output}"


#
# N: structured name (*1)
#        
read -p "family names:" familynames
read -p "given names:" givennames
read -p "additional names:" additionalnames
read -p "honorific prefixes:" prefixes
read -p "honorifix suffixes:" suffixes
n="${familynames};${givennames};${additionalnames};${prefixes};${suffixes}"
if [ "${n}" = ";;;;" ]
then
	unset n
else
	n="N:${n}"
	#TODO: type and parameters
	echo "${n}" >> "${output}"
fi
unset familynames givennames additionalnames prefixes suffixes


#
# FN: formated name (1*)
#
read -p "formated name:" fn
test -z "${fn}" && exit 1
#TODO: cardinality 1 -> 1*
fn="FN:${fn}"
echo "${fn}" >> "${output}"
unset fn


#
# NICKNAME: freeform text (*)
#
nickname=set
until [ -z $nickname ]
do
	read -p "nickname:" nickname
        if [ -z $nickname ]
        then
                unset nickname
        else
                nickname="NICKNAME:${nickname}"
                #TODO: type and parameters
                echo "${nickname}" >> "${output}"
        fi
        unset nickname
done


#
# BDAY: datetime (*1)
#
read -p "birthday:" bday
test -n "${bday}" && echo "BDAY:${bday}" >> "${output}"
unset bday


#
# ANNIVERSARY: datetime (*1)
#
read -p "anniversary:" anniversary
test -n "${anniversary}" && echo "ANNIVERSARY:${anniversary}" >> "${output}"
unset anniversary


#
# EMAIL: mail adr or mailto uri (*)
#
email=set
until [ -z $email ]
do
        read -p "email:" email
        if [ -z $email ]
        then
                unset email
        else
                email="EMAIL:${email}"
                #TODO: type and parameters (pref..)
                echo "${email}" >> "${output}"
        fi
        unset email
done


#
# TEL: teluri (*)
#
tel=set
until [ -z $tel ]
do
        read -p "tel:" tel
        if [ -z $tel ]
        then
                unset tel
        else
                tel="TEL:${tel}"
                #TODO: type and parameters (pref..)
                echo "${tel}" >> "${output}"
        fi
        unset tel
done


#
# IMPP: uri (*)
#
impp=set
until [ -z $impp ]
do
        read -p "impp (uri):" impp
        if [ -z $impp ]
        then
                unset impp
        else
                impp="IMPP:${impp}"
                #TODO: type and parameters (pref..)
                echo "${impp}" >> "${output}"
        fi
        unset impp
done


#
# URL: url (*)
#
url=set
until [ -z $url ]
do
        read -p "url:" url
        if [ -z $url ]
        then
                unset url
        else
                url="URL:${url}"
                #TODO: type and parameters
                echo "${url}" >> "${output}"
        fi
        unset url
done


#
# CATEGORIES: freeform text (*)
#
categories=set
until [ -z $categories ]
do
        read -p "categories:" categories
        if [ -z $categories ]
        then
                unset categories
        else
                categories="CATEGORIES:${categories}"
                #TODO: type and parameters
                echo "${categories}" >> "${output}"
        fi
        unset categories
done


#
# ADR: structured address (*)
#
adr=set
until [ -z $adr ]
do
	read -p "post office box:" pobox
	read -p "extended address (e.g. apartment number):" extended
	read -p "street address:" street
	read -p "locality (e.g. city):" locality
	read -p "region (e.g. state or province):" region
	read -p "postal code:" postal
	read -p "country name:" country
	adr="${pobox};${extended};${street};${locality};${region};${postal};${country}"
	if [ "${adr}" = ";;;;;;" ]
	then
		unset adr
	else
		adr="ADR:${adr}"
		#TODO: type and parameters
		echo "${adr}" >> "${output}"
	fi
	unset pobox extended street locality region postal country
done


#
# GENDER: structured text (*1)
#
read -p "sex ([M]ale, [F]emale, [O]ther, [N]one or not applicable, [U]nknown, []empty):" sex
read -p "gender identity (freeform or empty):" identity
gender="${sex}${identity:+;${identity}}"
if [ "${gender}" != "" ]
then
	gender="GENDER:${gender}"
	echo "${gender}" >> "${output}"
fi
unset sex identity gender


cat <<EOT
==TODO==
SOURCE: uri (*)
KIND: text (*1)
XML: text (*)
PHOTO: uri (*)
LANG: iso language-tag (*)
TZ: text, uri, utc-offset (*)
GEO: uri (*)
TITLE: text (*)
ROLE: text (*)
LOGO: uri (*)
ORG: structured text (*)
MEMBER: uri (*)
RELATED: uri (*)
NOTE: text (*)
SOUND: uri (*)
CLIENTPIDMAP: ... (*)
KEY: uri; text (*)
FBURL: uri (*)
CALADRURI: uri (*)
CALURI: uri (*)
EOT


#
# REV: datetime (*1)
#
echo "REV:`date -u +%Y%m%dT%H%M%SZ`" >> "${output}"


#
# PRODID: uri, text (*1)
#
echo "PRODID:-//FOO BAR//NONSGML Version 1//EN" >> "${output}"


#
# UID: uri (*1)
#
echo "UID:urn:uuid:`uuidgen`" >> "${output}"


#
# END: text (1)
#
echo "END:VCARD" >> "${output}"


unix2dos "${output}"

#TODO: validate file (check cardinalities, check 1 = BEGIN, check 2 = VERSION; check n = END; CRLF
#TODO: manual edit output
