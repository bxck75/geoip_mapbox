# geoip_mapbox


usage : ./censysmap.sh 1                       # censys.io api for GoAheadweb
        ./censysmap.sh 2                       # nmap random ips open port 81
        ./censysmap.sh 3 <path to iplist file> # list of ips
# MaxMind GeoIP PHP API #

## Requirements ##

This module has no external dependencies. You only need a MaxMind GeoIP
database. To download a free GeoIP Standard Country database, please see
our [GeoLite page](http://dev.maxmind.com/geoip/geolite).

### Install Dependencies ###
needs geoip-bin
needs censys_io.py in /usr/bin and api key + secret from censys.io account in censysmap.sh
needs nmap
needs mapbox account for api key in html template files
Run in your project root:

```
php composer.phar require geoip/geoip:~1.14
```

You should now have the files `composer.json` and `composer.lock` as well as
the directory `vendor` in your project directory. If you use a version control
system, `composer.json` should be added to it.

### Require Autoloader ###

```

## Support ##

koob404@gmail.com
php-prof-it.nl

## Copyright and License ##

This software is Copyright (c) 2018 by Php-prof-it.nl

This is free software, licensed under the GNU Lesser General Public License
version 2.1 or later.

## Thanks ##

Thanks to K00B404
cp censys_io.py /usr/bin/censys_io.py
