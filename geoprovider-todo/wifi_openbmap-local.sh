#!/bin/sh

#TODO: http://openbmap.org/latest/wifi/processed/ov2/
#TODO: http://openbmap.org/latest/wifi/processed/sqlite/
#TODO: http://openbmap.org/latest/wifi/raw/wifi-input_raw.zip
#TODO: http://openbmap.org/latest/wifi/raw/wifi-input_raw2011.zip
geo_bssid=

geo_uri="geo:${geo_latitude},${geo_longitude}${geo_altitude:+,${geo_altitude}}${geo_uncertainity:+;u=${geo_uncertainty}}${geo_crs:+;crs=${geo_crs}}"
echo $geo_uri