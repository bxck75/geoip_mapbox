#!/bin/bash
iplist=$1
cat $iplist	
:>ip_geo_loc.lst
for i in $(cat $iplist |sort -R |tail -n 5); do 

    IP=$(echo $i |awk -F ':' '{print $1}')
    PORT=$(echo $i |awk -F ':' '{print $2}' | awk -F ',' '{print $1}')
    echo $IP":"$PORT":"| tr -d '/http' >> ip_geo_loc.lst
    #echo $IP":"$PORT | tr -d '/http'
command geoiplookup $IP -f /usr/bin/GeoLiteCity.dat
	command geoiplookup $IP -f /usr/bin/GeoLiteCity.dat >> ip_geo_loc.lst |awk -F ',' '{print $7":"$8}' 

done


cp ip_geo_loc.lst ip_geo_loc2l.lst
perl -pne 'if($.%2){s/\n//;}' ip_geo_loc2l.lst > ip_lat_lon.lst 
cat ip_lat_lon.lst 
exit
echo '{
                "type": "FeatureCollection",
                "features": [' >  outputfile.json
#cat  ip_lat_lon.lst
for i in $(cat ip_lat_lon.lst); do
   
    #echo $i && exit
	IP=$(echo $i |awk -F ':' '{print $1}')
	LON=$(echo $i |awk -F ':' '{print $2}')
	LAT=$(echo $i |awk -F ':' '{print $3}')
	#echo    '{ "type": "Feature", "properties": { "title": "'${IP}'", "mag": 2.3, "time": 1507425650893, "felt": null, "tsunami": 0 }, "geometry": { "type": "Point", "coordinates": ['${LAT}', '${LON}'] } },'>>  outputfile.json
    if echo "$LON" | grep -iq "BS" ;then
        echo "Bad data! "$LON
    elif echo "$LON" | grep -iq "EH" ;then
        echo "Bad data! "$LON
    elif echo "$LON" | grep -iq "HU" ;then
        echo "Bad data! "$LON
    else

        echo   '{
                    "type": "Feature",
                    "geometry": {
                        "type": "Point",
                        "coordinates": ['${LAT}', '${LON}']
                    },
                    "properties": {
                        "title": "'${IP}'", 
			"description": "<strong>Capital Pride Parade</strong><p>The annual <a href=\"http://www.capitalpride.org/parade\" target=\"_blank\" title=\"Opens in a new window\">Capital Pride Parade</a></p>",
                        "icon": "star"
                    }
                },' >>  outputfile.json
    fi
done
sed -i '$ s/.$//' outputfile.json
echo ']}' >> outputfile.json


TEMPLATE=$(cat map_template.txt)
#TEMPLATE=$(cat map_template_heat.txt)
JSON=$(cat outputfile.json)

part1=$(echo $TEMPLATE |awk -F '__REPLACE_THIS__' '{print $1}')
part2=$(echo $TEMPLATE |awk -F '__REPLACE_THIS__' '{print $2}')

echo $part1$JSON$part2 > map.html
#xterm -hold -e 'firefox map.html' &