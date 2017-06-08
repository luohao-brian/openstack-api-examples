#!/usr/bin/bash

TOKEN=`curl -s -i -X POST http://controller:35357/v3/auth/tokens -H "Content-type: application/json" -d '{"auth": {"identity": {"methods": ["password"], "password": {"user": {"name": "admin", "domain": {"name": "default"}, "password": "redhat"}}}}}' | grep "X-Subject-Token" | awk '{print $2}'`

echo
echo $TOKEN
echo

curl -s http://controller:9292/v2/images -H "X-Auth-Token:$TOKEN"|python -mjson.tool
