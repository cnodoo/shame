#!/bin/sh

#TODO: http://openbmap.org/latest/cellular/processed/sqlite/
#TODO: http://openbmap.org/latest/cellular/raw/input_raw2009.zip
#TODO: http://openbmap.org/latest/cellular/raw/input_raw2010.zip
#TODO: http://openbmap.org/latest/cellular/raw/input_raw2011.zip
#TODO: http://openbmap.org/latest/cellular/raw/input_raw2012.zip
#TODO: http://openbmap.org/latest/cellular/raw/input_raw.zip
geo_mcc=
geo_mnc=
geo_lac=
geo_cell=

geo_uri="geo:${geo_latitude},${geo_longitude}${geo_altitude:+,${geo_altitude}}${geo_uncertainity:+;u=${geo_uncertainty}}${geo_crs:+;crs=${geo_crs}}"
echo $geo_uri