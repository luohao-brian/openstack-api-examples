#!/bin/bash

NAME=''
PASSWD=''
SERVER_ID='a23d5aff-af66-4a9e-a542-bff7991ef62d'

TOKEN_BODY='{
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

TOKEN=`curl -i -X POST   https://iam.cn-north-1.myhwclouds.com/v3/auth/tokens  -H 'content-type: application/json'   -d "$TOKEN_BODY" | grep "X-Subject-Token"| awk '{print$2}'`
PROJECT_ID=`curl -X POST   https://iam.cn-north-1.myhwclouds.com/v3/auth/tokens  -H 'content-type: application/json'   -d "$TOKEN_BODY"| python -mjson.tool| grep -A 3 project| grep id|awk -F "\"" '{print $4}'`

curl -i -X GET https://ecs.cn-north-1.myhwclouds.com/v2/${PROJECT_ID}/servers/${SERVER_ID} -H "X-Auth-Token:${TOKEN}"
