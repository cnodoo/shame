#!/bin/sh

# TODO: http://openbmap.org/api/getGPSfromCellular.html
#
# Description 
# This API returns GPS coordinates and polygon of the considered zone. 
# If the cell is not found in the database, it returns LAC data. 
# If the LAC is not found in the database, it returns the MNC data. 
# 
# This is the only freely available API that returns the polygon description. 
# 
# Type: HTTP POST 
# Url: http://www.openbmap.org/api/getGPSfromGSM.php 
# POST parameters:
# mcc : integer type : Mobile Country Code
# mnc : integer type : Mobile Network Code
# lac : integer type : Location Area Code
# cell_id : integer type : Cell Identification
# 
# Expected result: 
# <gsm mcc="208" mnc="1" lac="60112" cid="39562"> 
# <zone zoneType="mnc" lat="46.652651951475" lng="2.16259454620565" maxradius="560722.557282774" > 
# POLYGON((2.8681742 42.428088,-4.7614007 48.5280413,-4.7487103 48.5425838,-4.7475112 48.5436329,-4.7449301 48.5455234,-4.7300237 48.5555368,-4.7282248 48.5562829,1.8140777 50.9428025,1.8143609 50.9428708,1.8149105 50.9429813,1.8151675 50.9430318,2.4722807 51.0430719,2.4749316 51.0433923,2.4797363 51.0439613,2.4803594 51.0440082,2.4809714 51.044042,2.5343715 51.046791,2.5345615 51.0467882,2.5347485 51.0467474,2.5352852 51.0465569,4.89669978618622 50.1288825273514,7.9059105 48.8971103,7.2701759 43.6967236,6.25053215026855 43.0013198852539,6.19829636666667 42.9864031666667,3.1669455 42.440049,2.8681742 42.428088)) 
# </zone> 
# </gsm> 
geo_mcc=
geo_mnc=
geo_lac=
geo_cell=

geo_uri="geo:${geo_latitude},${geo_longitude}${geo_altitude:+,${geo_altitude}}${geo_uncertainity:+;u=${geo_uncertainty}}${geo_crs:+;crs=${geo_crs}}"
echo $geo_uri