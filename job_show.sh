#!/bin/bash

NAME=''
PASSWD=''
JOB_ID='8aace0c75b8f1654015ba4231e972301'

AUTH_PARAMS='{
  "auth": {
    "identity": {
      "methods": [
        "password"
      ],
      "password": {
        "user": {
          "name": '"\"$NAME\""',
          "password": '"\"$PASSWD\""',
          "domain": {
            "name": '"\"$NAME\""'
          }
        }
      }
    },
   "scope": {
      "project": {
        "name": "cn-north-1"
      }
    }
  }
}'

TOKEN=`curl -i -X POST   https://iam.cn-north-1.myhwclouds.com/v3/auth/tokens  -H 'content-type: application/json'   -d "$AUTH_PARAMS" | grep "X-Subject-Token"| awk '{print$2}'`
PROJECT_ID=`curl -X POST   https://iam.cn-north-1.myhwclouds.com/v3/auth/tokens  -H 'content-type: application/json'   -d "$AUTH_PARAMS"| python -mjson.tool| grep -A 3 project| grep id|awk -F "\"" '{print $4}'`

curl -i -X GET https://ecs.cn-north-1.myhwclouds.com/v1/${PROJECT_ID}/jobs/${JOB_ID} -H "X-Auth-Token:${TOKEN}"
