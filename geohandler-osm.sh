#!/bin/sh

geo_uri=`cat`
test -z "${geo_uri}" && geo_uri=$1
test -z "${geo_uri}" && exit 2

geo_format=json	#values: xml|json

#TODO: can lat/long/alt values appear behind uncertainty and crs?
geo_latitude=`echo "${geo_uri}" | cut -d ':' -f2 | cut -d ';' -f 1 | cut -d ',' -f 1`
geo_longitude=`echo "${geo_uri}" | cut -d ':' -f2 | cut -d ';' -f 1 | cut -d ',' -f 2`
geo_altitude=`echo "${geo_uri}" | cut -d ':' -f2 | cut -d ';' -f 1 | cut -d ',' -f 3`

#TODO: 
#TODO: ;u=VALUE
# geo_uncertainty=
#TODO: ;crs=VALUE
# geo_crs=


## geo2adr
#TODO: select zoomlevel by geo_uncertainty
geo_zoom= # zoom: 0 = country; 18 = house/buildung
geo_addressdetails=1

geo_service="http://nominatim.openstreetmap.org/reverse?format=${geo_format}&lat=${geo_latitude}&long=${geo_longitude}&zoom=${geo_zoom}&addressdetails=${geo_addressdetails}"

curl -s "$geo_service}"




## show map
#TODO: http://wiki.openstreetmap.org/wiki/Search
# http://nominatim.openstreetmap.org/search?params
# http://nominatim.openstreetmap.org/search/query?params
#
# format=html|xml|json
#
# street=<housenumber> <streetname>
 #city=<city>
 #county=<county>
 #state=<state>
 #country=<country>
 #postalcode=<postalcode>
#
#
#countrycodes=<countrycode>[,<countrycode>][,<countrycode>]...




## route
#Parameters
#start = longitude and latitude of the start position, e.g. '7.0892567,50.7265543'
#via (optional) = longitudes and latitudes of the via positions separated by blank, e.g. '7.0920891,50.7295968 7.1044487,50.7247613 7.1049637,50.7298142'
#end = longitude and latitude of the end position, e.g. '7.0986258,50.7323634'
#pref = the preference of the routing: 'Fastest', 'Shortest', 'Pedestrian' or 'Bicycle'
#lang = language of routeinstructions: 'de' (Deutsch), 'en' (English), 'it' (Italiano), 'fr' (Français), 'es' (Español)
#noMotorways = No Motorways? e.g. 'noMotorways=false' OR 'noMotorways=true'
#noTollways = No Tollways? e.g. 'noTollways=false' OR 'noTollways=true'
#lon = longitude (centre of the map)
#lat = latitude (centre of the map)
#zoom = zoom level
#All parameters are optional. If you do not use the PermaLink parameters (lon, lat, zoom), default values will be used which will make you see a map of Bonn.
#Example URL
#Normal: http://openrouteservice.org/index.php?start=7.0892567,50.7265543&end=7.0986258,50.7323634&lat=50.72905&lon=7.09574&zoom=15&pref=Fastest&lang=de
#Via-Points: http://openrouteservice.org/index.php?start=7.0892567,50.7265543&end=7.0986258,50.7323634&via=7.0920891,50.7295968%207.1044487,50.7247613%207.1049637,50.7298142&lat=50.72889&lon=7.09655&zoom=15&pref=Fastest&lang=de








##weather
#With country code
#http://api.openweathermap.org/data/2.1/find/name?q=London,UK
#units (imperial, metric, internal)
#http://api.openweathermap.org/data/2.1/find/name?q=London,%20UK&units=imperial
#http://api.openweathermap.org/data/2.1/find/name?q=London,%20UK&units=metric
#
#api.openweathermap.org/data/2.1/weather/city/{CITY_ID}?type={json|html}
#
#
#http://api.openweathermap.org/data/2.1/forecast/city/{CITY_ID}
#
#
#
#http://api.openweathermap.org/data/2.2/forecast/city/5128581?mode=daily_compact
#
#
#
#cityid karlsruhe: 2892794 (gefunden ueber
#http://api.openweathermap.org/data/2.1/find/name?q=karlsruhe,de )
#
#
#
#----
#
#
#auch METAR daten nutzen (oder TAF oder GAFOR):
#
#https://de.wikipedia.org/wiki/METAR
#http://www.nws.noaa.gov/tg/siteloc.shtml <--  stationen finder
#http://www.schwarzvogel.de/software-pymetar.shtml <-- pyMETAR
#http://www.deutscher-wetterdienst.de/lexikon/download.php?file=TAF.pdf
#http://www.dwd.de/sid_WQCqKJ0R4HptxPGtTNNwJLg0w1jykhnsMrLp27lRZnwy29vy7Kh8!274244207!902933057!1250522353616/bvbw/appmanager/bvbw/dwdwwwDesktop?_nfpb=true&_pageLabel=dwdwww_result_page&portletMasterPortlet_i1gsbDocumentPath=Navigation%2FForschung%2FAnalyse__Modellierung%2FFU__AM__copy__TAF__node.html__nnn%3Dtrue
#http://www.met.tamu.edu/class/atmo151/metar_decode.htm
#
#
#http://vortex.plymouth.edu/cgi-bin/gen_statlog-u.cgi?ident=EDSB&pl=none0&yy=13&mm=04&dd=08
#
#
#----
#
##
#openweathermap.org
#wunderground.com
