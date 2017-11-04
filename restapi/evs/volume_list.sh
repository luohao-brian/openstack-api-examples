#! /bin/bash

HEC_USER_NAME=''
HEC_USER_PASSWD=''

HEC_REGION=''
HEC_IAM_ENDPOINT=''
HEC_EVS_ENDPOINT=''

AUTH_PARAMS='{
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
        "name": '"\"$HEC_REGION\""'
      }
    }
  }
}'

curl -i -X POST ${HEC_IAM_ENDPOINT}/v3/auth/tokens -H 'content-type: application/json' -d "$AUTH_PARAMS" -k > /tmp/hec_auth_res && {
    TOKEN=`cat /tmp/hec_auth_res | grep "X-Subject-Token"| awk '{print$2}'`
    echo "HEC Token is: $TOKEN"
	
	PROJECT_ID=`tail -n 1 /tmp/hec_auth_res|python -c 'import json,sys;print json.load(sys.stdin)["token"]["project"]["id"]'`
    echo "HEC Project ID is: $PROJECT_ID"
	
	curl -i -X GET ${HEC_EVS_ENDPOINT}/v1/${PROJECT_ID}/volumes?limit=100 -H "X-Auth-Token:${TOKEN}" -k
} 
