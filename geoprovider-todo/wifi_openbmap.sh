#!/bin/sh

# TODO: http://openbmap.org/api/getGPSfromWifi.html
#
# Description 
# This API returns GPS coordinates. 
# 
# Type: HTTP POST 
# Url: http://realtimeblog.free.fr/api/getGPSfromWifiAPBSSID.php5 
# POST parameters:
# bssid : string type : BSSID or wifi MAC address
# 
# Expected result: 
# <wifiap bssid="0EFEFF7D2194"> 
# <zone zoneType="wifiap" lat="46.652651951475" lng="2.16259454620565"> 
# </zone> 
# </wifiap> 
geo_bssid=

geo_uri="geo:${geo_latitude},${geo_longitude}${geo_altitude:+,${geo_altitude}}${geo_uncertainity:+;u=${geo_uncertainty}}${geo_crs:+;crs=${geo_crs}}"
echo $geo_uri