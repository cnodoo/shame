#!/bin/sh

geo_uri="geo:${geo_latitude},${geo_longitude}${geo_altitude:+,${geo_altitude}}${geo_uncertainity:+;u=${geo_uncertainty}}${geo_crs:+;crs=${geo_crs}}"
echo $geo_uri