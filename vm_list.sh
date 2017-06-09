#!/bin/bash

HEC_USER_NAME=''
HEC_USER_PASSWD=''

TOKEN_BODY='{
  "auth": {
    "identity": {
      "methods": [
        "password"
      ],
      "password": {
        "user": {
          "name": '"\"$HEC_USER_NAME\""',
          "password": '"\"$HEC_USER_PASSWD\""',
          "domain": {
            "name": '"\"$HEC_USER_NAME\""'
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


curl -i -X GET https://ecs.cn-north-1.myhwclouds.com/v2/${PROJECT_ID}/servers -H "X-Auth-Token:${TOKEN}"
