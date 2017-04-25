#!/bin/bash

PROJECT_ID='c75709169d574f08b403ffc439a4e8e1'
NAME=''
PASSWD=''

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

curl -i -X GET https://ecs.cn-north-1.myhwclouds.com/v2/${PROJECT_ID}/servers -H "X-Auth-Token:${TOKEN}"
