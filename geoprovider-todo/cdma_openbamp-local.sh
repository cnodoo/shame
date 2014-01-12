#!/bin/sh

#TODO http://openbmap.org/latest/cellular/processed/sqlite/
geo_mcc=
geo_system=
geo_network=
geo_basestation=

geo_uri="geo:${geo_latitude},${geo_longitude}${geo_altitude:+,${geo_altitude}}${geo_uncertainity:+;u=${geo_uncertainty}}${geo_crs:+;crs=${geo_crs}}"
echo $geo_uri