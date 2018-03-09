#!/bin/bash
#https://github.com/mapbox/mapbox-cli-py
export MAPBOX_ACCESS_TOKEN=sk.eyJ1IjoiYnhjazc1IiwiYSI6ImNqZWp2dGdodjA2enEzMm1nbXM2bmdvMzUifQ.g-hZvfVrMpEpb3bmjV_zGQ

function ListDataSet(){
	#Result=$(mapbox datasets list |awk -F ',' '{print $2}'|awk -F ':' '{print $2}'|tr -d "\"")
	Result=$(mapbox datasets list)
	echo $Result
}
function MakeDataSet(){
	dsname=$1
	dsdescr=$2
	Result=$(mapbox datasets create --name "${dsname}" --description "${dsdescr}")
	CreationId=$(echo $Result |awk -F ',' '{print $2}'|awk -F ':' '{print $2}'|tr -d "\"")
	echo $CreationId
}
function DeleteDataSet(){
	dsdelid=$1
	Result=$(mapbox datasets delete-dataset "${dsdelid}")
	echo $Result
}
function ReadDataSet(){
	dsreadid=$1
	Result=$(mapbox datasets read-dataset "${dsreadid}")
	echo $Result
}
function ListDataSetFeatures(){
        dsreadid=$1
        Result=$(mapbox datasets list-features "${dsreadid}")
        echo $Result
}
function PutDataSetFeature(){
	dsid=$1
	featureid=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
	featurejson=$(cat $2)
	mapbox datasets put-feature "${dsid}" "${featureid}" -i "${featurejson}"
}
#NewDsId=$(MakeDataSet 'test1' 'test dataset')
#echo "Made Dataset with id : "$NewDsId
#ListDataSet
#DelDsId=$(DeleteDataSet $NewDsId)
#echo "Deleted Dataset with id : "$DelDsId
ListDataSet
ListDataSetFeatures cjek141dw09mg33o85369b6cv
#PutDataSetFeature cjek141dw09mg33o85369b6cv pp22hengelo.json
#mapbox datasets delete-dataset
#mapbox datasets read-feature cjej42hwd0dx831mp2gkxhk6u 645dbd80c35e3db17049455e5fdc8ee1

#mapbox datasets put-feature cjej42hwd0dx831mp2gkxhk6u poep -input $(cat pp22hengelo.json)
