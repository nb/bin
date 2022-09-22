#!/bin/bash
IP=192.168.0.37
# https://github.com/jeffisfast/Elgato-Light-Controller
case $1 in
    on)
        curl -X PUT -d '{"numberOfLights":1,"lights":[{"on":1}]}' "http://$IP:9123/elgato/lights"
        ;;
    off)
        curl -X PUT -d '{"numberOfLights":1,"lights":[{"on":0}]}' "http://$IP:9123/elgato/lights"
        ;;
    *)
        >&2 echo "USAGE $0 on|off"
        exit 1
        ;;
esac