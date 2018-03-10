#!/bin/bash

#https://www.mapbox.com/mapbox-gl-js/example/data-driven-circle-colors/
#Get result
if [[ $1 -eq 1 ]]; then
    echo "Runnin censys for 100 targets"
    censys_io.py GoAhead \
      --api_id=<own censys.io api> \
      --api_secret=<own censys.io secret>  \
      --limit 100 --tsv -f ip,protocols |grep "\/http" \
       > Goahead_targets.json
    
    #filter out shit
    cat Goahead_targets.json         \
           |awk  '{print $1}'  >  ip.lst
elif [[ $1 -eq 2 ]];then
    nmap -iR 1000 -p 81 -Pn -n --open -oG - | awk '/Up$/{print $2}' > ip.lst
elif [[ $1 -eq 3 ]]; then
    cat $2 > ip.lst
fi


#get location
:> ip_geo_loc.lst

for i in $(cat ip.lst |sort -u); do 
	echo $i
    IP=$(echo $i |awk -F ':' '{print $1}')
	echo $IP":" >> ip_geo_loc.lst
	command geoiplookup $IP -f /usr/bin/GeoLiteCity.dat |awk -F ',' '{print $7":"$8}' |tr -d ' ' >> ip_geo_loc.lst
done

cp ip_geo_loc.lst ip_geo_loc2l.lst
perl -pne 'if($.%2){s/\n//;}' ip_geo_loc2l.lst > ip_lat_lon.lst 

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
