#!/bin/sh

#TODO: http://openbmap.org/api/getGPSfromCellular.html
# 
# Description 
# This API returns GPS coordinates and polygon of the considered zone. 
# If the basestation is not found in the database, it returns NetworkId data. 
# If the NetworkId is not found in the database, it returns the SystemId data. 
# 
# Type: HTTP POST 
# Url: http://www.openbmap.org/api/getGPSfromCDMA.php 
# POST parameters:
# mcc : integer type : Mobile Country Code
# system id : integer type : System Identification
# network id : integer type : Network Identification
# basestation id : integer type : Basestation Identification
# 
# Expected result: 
# <cdma mcc="310" systemid="202" networkid="11" basestationid="8671"> 
# <zone zoneType="basestationid" lat="28.0494" lng="-82.69829213619232" maxradius="1044.95"
# countryname="United States of America" localityname="Harbor Palms" act="EDV0_A" trusted="100" > 
# POLYGON((-82.6982921361923 28.0494958162308,-82.71 28.06,-82.6981 28.06,-82.6982921361923 28.0494958162308)) 
# </zone> 
# </cdma> 
geo_mcc=
geo_system=
geo_network=
geo_basestation=

geo_uri="geo:${geo_latitude},${geo_longitude}${geo_altitude:+,${geo_altitude}}${geo_uncertainity:+;u=${geo_uncertainty}}${geo_crs:+;crs=${geo_crs}}"
echo $geo_uri