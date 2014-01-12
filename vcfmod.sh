#!/bin/sh

#TODO: validation
#TODO: sanitation
#TODO: split, fold, unfold --> https://github.com/l0b0/vcard
#TODO: readline
#TODO: vcfadd / addvcf

output=/dev/null

if [ -t 0 ]
then
	echo kein filter	
else
	input=randomshit
	cat > "${input}"
fi


vcfemail()
{
	#TODO: validate email

	if [ "$1" == "mailto:"* ]
	then
		EMAIL="$1"
	else
		EMAIL="mailto:$1"
	fi
	printf "%s\r\n" "EMAIL:${EMAIL}"
	unset EMAIL
}


vcfxmpp()
{
	#TODO: validate xmpp

	if [ "$1" == "xmpp:"* ]
	then
		XMPP="$1"
	else
		XMPP="xmpp:$1"
	fi
	printf "%s\r\n" "IMPP:${XMPP}"
	unset XMPP
}


vcfsimple()
{
	printf "%s\r\n" "${1}:${2}"
}


vcfdata()
{
	if [ -e "${2}" ]
	then
		VALUE=`data-uri "${2}"`
	else
		VALUE="${2}"
		echo "INFO:${1}: storing link, not actual file" >&2
	fi
	printf "%s\r\n" "${1}:${VALUE}"
	unset VALUE
}


vcfhelp()
{
	cat <<- END
	vcfmod v0.2-testing
	
	usage:
	  vcfmod [switches] [params] [file]

	requirements:
	  uuidgen
	  data-uri
	  curl

	switches:
	  -v helpscreen
	  -d debug
	  -D download files instead of using links

	params:
	  -m mail => EMAIL
	  -j jabber => IMPP
	  -s sex => GENDER (1/2)
	  -i identity => GENDER (2/2)
	  -n name => FN
	  -a alias => NICKNAME
	  -t tel => TEL
	  -u url => URL
	  -b bday => BDAY
	  -k key => KEY
	  -l lang => LANG
	  -f file => PHOTO
	  -p postal => ADR
	  -c category => CATEGORIES
	  -z zone => TZ
	  -g geo => GEO
	  -o org => ORG
	  -r related => RELATED
	  -R role => ROLE
	  -S sound => SOUND
	  -T title => TITLE
	  -C comment => NOTE
	  -L logo => LOGO	
	  -M member => MEMBER
	  -A anniversary => ANNIVERSARY
	  -K kind => KIND
	  -q source => SOURCE
	  -H additional_name => N (3/5)
	  -G given_name => N (2/5)
	  -F family_name =>  N (1/5)
	  -X honorific_prefixe => N (4/5)
	  -Y honorific_suffixe => N(5/5) 	

	auto:
	  set UID if unset
	  bump REV
	  bump VERSION to 4.0
	  set PRODID if unset
	END
}


vcfmain()
{
	debug_output=
	download_files=

	additional_names=
	family_names=
	given_names=
	honorific_postfixes=
	honorific_suffixes=
	
	gender_sex=
	gender_identity=
	
	adr_pobox=	
	adr_extended=
	adr_street=
	adr_locality=
	adr_region=
	adr_postal=
	adr_country=

	args=`getopt vdDm:j:s:i:n:a:t:u:b:k:l:f:p:c:z:g:o:r:R:S:T:C:L:M:A:K:q:H:G:F:X:Y: ${*}`; errcode="${?}"; set -- ${args}
	
	while :
	do
		case "${1}" in
				-m) vcfemail "$2"; shift; shift;;
				-j) vcfxmpp "$2"; shift; shift;;
				-s) gender_sex="$2"; shift; shift;;
				-i) gender_identity="$2"; shift; shift;;
				-n) vcfsimple "FN" "$2"; shift; shift;;
				-a) vcfsimple "NICKNAME" "$2"; shift; shift;;
				-t) vcfsimple "TEL" "$2"; shift; shift;;
				-u) vcfsimple "URL" "$2"; shift; shift;;
				-b) vcfsimple "BDAY" "$2"; shift; shift;;
				-k) vcfdata "KEY" "$2"; shift; shift;;
				-l) vcfsimple "LANG" "$2"; shift; shift;;
				-f) vcfdata "PHOTO" "$2"; shift; shift;;
				-p) vcfsimple "ADR" "$2"; shift; shift;;
				-c) vcfsimple "CATEGORIES" "$2"; shift; shift;;
				-z) vcfsimple "TZ" "$2"; shift; shift;;
				-g) vcfsimple "GEO" $2; shift; shift;;
				-o) vcfsimple "ORG" "$2"; shift; shift;;
				-r) vcfsimple "RELATED" "$2"; shift; shift;;
				-R) vcfsimple "ROLE" "$2"; shift; shift;;
				-S) vcfdata "SOUND" "$2"; shift; shift;;
				-T) vcfsimple "TITLE" "$2"; shift; shift;;
				-C) vcfsimple "NOTE" "$2"; shift; shift;;
				-L) vcfdata "LOGO" "$2"; shift; shift;;
				-M) vcfsimple "MEMBER" "$2"; shift; shift;;
				-A) vcfsimple "ANNIVERSARY" "$2"; shift; shift;;
				-K) vcfsimple "KIND" "$2"; shift; shift;;
				-q) vcfsimple "SOURCE" "$2"; shift; shift;;
				-H) additional_names="${additional_names}${additional_names:+,}${2}"; shift; shift;;
				-G) given_names="${given_names}${given_names:+,}${2}"; shift; shift;;
				-F) family_names="${family_names}${family_names:+,}${2}"; shift; shift;;
				-X) honorific_prefixes="${honorific_prefixes}${honorific_prefixes:+,}${2}"; shift; shift;;
				-Y) honorific_suffixes="${honorific_postfixes}${honorific_postfixes:+,}${2}"; shift; shift;;
				-d) debug_output=true;;
				-D) download_files=true;;
				-v) vcfhelp; exit 0;;
				--) shift; break;;
		esac
	done

	
	#INFO: generate structured field "N"
	name="${family_names};${given_names};${additional_names};${honorific_prefixes};${honorific_postfixes}"
	test ";;;;" == "${name}" || vcfsimple "N" "${name}"
	#TODO: generate FN from N? 
	#TODO: generate N from FN?
	unset name family_names given_names additional_names honorific_prefixes honorific_postfixes
	
	
	#INFO: generate structured field "GENDER"
	gender="${gender_sex}${gender_identity:+;}${gender_identity}"
	test -z "${gender}" || vcfsimple "GENDER" "${gender}"
	unset gender gender_identity gender_sex
	
	
	#INFO: generate structured field "ADR"
	#TODO: curerntly not accessible from cli
	adr="${adr_pobox};${adr_extended};${adr_street};${adr_locality};${adr_region};${adr_postal};${adr_country}"
	test ";;;;;;" == "${adr}" || vcfsimple "ADR" "${adr}"
	unset adr adr_pobox adr_extended adr_street adr_locality adr_region adr_postal adr_country


	#INFO: prefer filter over file input
	input="${input:-${1}}"
	

	#INFO: get existing values
	if [ -f "${input}" ]
	then
		uid=`grep "^UID[;:]" "${input}" | cut -d ':' -f '2-'`
		prodid=`grep "^PRODID[;:]" "${input}" | cut -d ':' -f '2-'`
		version=`grep "^VERSION[:;]" "${input}" | cut -d ':' -f '2-'`
		revision=`grep "^REV[:;]" "${input}" | cut -d ':' -f '2-'`
		sed -e '/^UID[:;]/d' -e '/^PRODID[:;]/d' -e '/^VERSION[:;]/d' -e '/^REV[:;]/d' -e '/^BEGIN:VCARD/d' -e '/^END:VCARD/d' "${input}"
	fi
	
	cat <<- END
	UID:${uid:-urn:uuid:`uuidgen`}
	REV:`date -u +%Y-%m-%dT%H:%M:%S.00Z`
	PRODID:${prodid:-'-//FOO BAR//NONSGML Version 1//EN'}
	END
	
	unset uid prodid version revision
}

(
	vcfsimple "BEGIN" "VCARD"
	vcfsimple "VERSION" "4.0"
	vcfmain $@
	vcfsimple "END" "VCARD"
) | tee "${output}" 

unset input output download_files debug_output
