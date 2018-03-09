<?php
$json='{
  "features": [
    {
      "type": "Feature",
      "properties": {
        "title": "112.120.104.236",
		"description": "<strong>Capital Pride Parade</strong><p>The annual <a href=\"http://www.capitalpride.org/parade\" target=\"_blank\" title=\"Opens in a new window\">Capital Pride Parade</a></p>",
        "icon": "star"
      },
      "geometry": {
        "coordinates": [
          114.150002,
          22.2833
        ],
        "type": "Point"
      },
      "id": "000104bb278a7be5fa35eb491c8e5591"
    }
  ],
  "type": "FeatureCollection"
}';
$test = json_decode($json);
var_dump($test);
?>
