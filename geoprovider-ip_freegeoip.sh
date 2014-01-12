#!/bin/sh

#
# GEOPROVIDER
#
# Geoproviders return the geo URI of the current position. This one tries to
# lookup your -- or the connecting ssh client's -- IP address in the GeoLite
# database provided by Maxmind <http://www.maxmind.com>. Updates and online
# lookup are provided by FreeGeoIp.net <http://freegeoip.net> -- GitHub:
# <https://github.com/fiorix/freegeoip/>
#

#
# REQUIREMENTS
# 
#INFO: requires 'curl' (curl)
#INFO: requires 'xmlstarlet' (xmlstarlet)
#INFO: requires 'sqlite3' (sqlite3)

geo_format=xml|json|csv|local
		
if [ -n "${SSH_CLIENT}" ]
then
	#TODO: works also with SSH_CONNECTION
	#TODO: koennen da auch hostnames und ipv6 adressen drin sein?
	geo_ip=`echo $SSH_CLIENT | cut -d ' ' -f1`
	#TODO: check for local addresses:
	#	0.0.0.0 - 0.255.255.255
	#	10.0.0.0 - 10.255.255.255
	#	100.64.0.0 - 100.127.255.255
	#	127.0.0.0 - 127.255.255.255
	#	169.254.0.0 - 169.254.255.255
	#	172.16.0.0 - 172.31.255.255
	#	192.0.0.0 - 192.0.0.255
	#	192.0.0.0 - 192.0.0.7
	#	192.0.2.0 - 192.0.2.255
	#	192.88.99.0 - 192.88.99.255
	#	192.168.0.0 - 192.168.255.255
	#	198.18.0.0 - 198.19.255.255
	#	198.51.100.0 - 198.51.100.255
	#	203.0.113.0 - 203.0.113.255
	#	224.0.0.0 - 239.255.255.255
	#	240.0.0.0 - 255.255.255.255
	#	255.255.255.255	
	#geo_ip=''
else
	#INFO: blank geo_ip tells freegeoip.net to check the sender ip	
	geo_ip= ''
fi

if [ "${geo_format}" -eq "local" ]
then

	#TODO: https://github.com/fiorix/freegeoip/blob/master/db/updatedb
	#TODO: https://github.com/fiorix/freegeoip/raw/master/db/updatedb
	#TODO: http://dev.maxmind.com/geoip/geoip2/geolite2/
	#TODO: http://dev.maxmind.com/geoip/legacy/geolite/

	geo_ip=
	geo_countrycode=
	geo_countryname=
	geo_regioncode=
	geo_regionname=
	geo_cityname=
	geo_zipcode=
	geo_latitude=
	geo_longitude=
	geo_metrocode=
	geo_areacode=
	geo_altitude=
	geo_uncertainty=
	geo_crs=
fi

geo_location=`curl -s "http://freegeoip.net/${geo_format}/${geo_ip}"`

if [ "${geo_format}" -eq "csv" ]
then
	geo_ip=`echo "${geo_location}" | cut -d ',' -f1 | tr -d \"`
	geo_countrycode=`echo "${geo_location}" | cut -d ',' -f2 | tr -d \"`
	geo_countyname=`echo "${geo_location}" | cut -d ',' -f3 | tr -d \"`
	geo_regioncode=`echo "${geo_location}" | cut -d ',' -f4 | tr -d \"`
	geo_regionname=`echo "${geo_location}" | cut -d ',' -f5 | tr -d \"`
	geo_cityname=`echo "${geo_location}" | cut -d ',' -f6 | tr -d \"`
	geo_zipcode=`echo "${geo_location}" | cut -d ',' -f7 | tr -d \"`
	geo_latitude=`echo "${geo_location}" | cut -d ',' -f8 | tr -d \"`
	geo_longitude=`echo "${geo_location}" | cut -d ',' -f9 | tr -d \"`
	geo_metrocode=`echo "${geo_location}" | cut -d ',' -f1 | tr -d \"`
	geo_areacode=`echo "${geo_location}" | cut -d ',' -f1 | tr -d \"` 
	geo_altitude=
	geo_uncertainty=
	geo_crs=
fi

if [ "${geo_format}" -eq "xml" ]
then
	geo_ip=`echo "${geo_location}" | xmlstarlet sel -t -v '//Ip'`
	geo_countrycode=`echo "${geo_location}" | xmlstarlet sel -t -v '//CountryCode'`
	geo_countyname=`echo "${geo_location}" | xmlstarlet sel -t -v '//CountryName'`
	geo_regioncode=`echo "${geo_location}" | xmlstarlet sel -t -v '//RegionCode'`
	geo_regionname=`echo "${geo_location}" | xmlstarlet sel -t -v '//RegionName'`
	geo_cityname=`echo "${geo_location}" | xmlstarlet sel -t -v '//City'`
	geo_zipcode=`echo "${geo_location}" | xmlstarlet sel -t -v '//ZipCode'`
	geo_latitude=`echo "${geo_location}" | xmlstarlet sel -t -v '//Latitude'`
	geo_longitude=`echo "${geo_location}" | xmlstarlet sel -t -v '//Longitude'`
	geo_metrocode=`echo "${geo_location}" | xmlstarlet sel -t -v '//MetroCode'`
	geo_areacode=`echo "${geo_location}" | xmlstarlet sel -t -v '//AreaCode'`
	geo_altitude=
	geo_uncertainty=
	geo_crs=
fi

if [ "${geo_format}" -eq "json" ]
then
	#TODO: use a real json parser
	geo_ip=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/ip\042/){print $(i+1)} } }'`
	geo_countrycode=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/country_code\042/){print $(i+1)} } }'`
	geo_countryname=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/country_name\042/){print $(i+1)} } }'`
	geo_regioncode=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/region_code\042/){print $(i+1)} } }'`
	geo_regionname=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/region_name\042/){print $(i+1)} } }'`
	geo_cityname=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/city_name\042/){print $(i+1)} } }'`
	geo_zipcode=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/zipcode\042/){print $(i+1)} } }'`
	geo_latitude=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/latitude\042/){print $(i+1)} } }'`
	geo_longitude=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/longitude\042/){print $(i+1)} } }'`
	geo_metrocode=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/metro_code\042/){print $(i+1)} } }'`
	geo_areacode=`echo "${geo_location}" | awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/areacode\042/){print $(i+1)} } }'`
	geo_altitude=
	geo_uncertainty=
	geo_crs=
fi

geo_uri="geo:${geo_latitude},${geo_longitude}${geo_altitude:+,${geo_altitude}}${geo_uncertainty:+;u=${geo_uncertainty}}${geo_crs:+;crs=${geo_crs}}"
echo $geo_uri