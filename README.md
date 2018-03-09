# geoip_mapbox
needs censys_io.py in /usr/bin and api key + secret from censys.io account in censysmap.sh
needs nmap
needs mapbox account for api key in html template files

usage : ./censysmap.sh 1                       # censys.io api for GoAheadweb
        ./censysmap.sh 2                       # nmap random ips open port 81
        ./censysmap.sh 3 <path to iplist file> # list of ips
