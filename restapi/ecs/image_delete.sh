#!/bin/bash

# 华为云账号，不是email
HEC_USER_NAME=''
# 华为云密码
HEC_USER_PASSWD=''

# Region&Endpoints, 
# 具体定义请参考:http://developer.hwclouds.com/endpoint.html
HEC_REGION='cn-north-1'
HEC_IAM_ENDPOINT='https://iam.cn-north-1.myhwclouds.com'
HEC_ECS_ENDPOINT='https://ecs.cn-north-1.myhwclouds.com'

IMAGE_ID=''

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

# Request for token and tanent id
curl -i -X POST ${HEC_IAM_ENDPOINT}/v3/auth/tokens -H 'content-type: application/json' -d "$AUTH_PARAMS" > /tmp/hec_auth_res && {
    # Retrieve token by account username and password      
    TOKEN=`cat /tmp/hec_auth_res | grep "X-Subject-Token"| awk '{print$2}'`

    # Retrieve tanent id(project id)
    PROJECT_ID=`tail -n 1 /tmp/hec_auth_res|python -c 'import json,sys;print json.load(sys.stdin)["token"]["project"]["id"]'`

    curl -s -X DELETE ${HEC_ECS_ENDPOINT}/v2/${PROJECT_ID}/images/${IMAGE_ID} -H "X-Auth-Token:${TOKEN}" 
}
