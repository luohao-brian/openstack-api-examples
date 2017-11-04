#!/bin/bash

# 华为云账号，不是email
HEC_USER_NAME='test'
# 华为云密码
HEC_USER_PASSWD='test$'

# Region&Endpoints, 
# 具体定义请参考:http://developer.hwclouds.com/endpoint.html
HEC_REGION='cn-north-1'
HEC_IAM_ENDPOINT='https://iam.cn-north-1.myhwclouds.com'
HEC_ECS_ENDPOINT='https://ecs.cn-north-1.myhwclouds.com'
HEC_VPC_ENDPOINT='https://vpc.cn-north-1.myhwclouds.com'

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

curl -i -X POST ${HEC_IAM_ENDPOINT}/v3/auth/tokens -H 'content-type: application/json' -d "$AUTH_PARAMS" > /tmp/hec_auth_res && {
    TOKEN=`cat /tmp/hec_auth_res | grep "X-Subject-Token"| awk '{print$2}'`
    echo "HEC Token is: $TOKEN"

    PROJECT_ID=`tail -n 1 /tmp/hec_auth_res|python -c 'import json,sys;print json.load(sys.stdin)["token"]["project"]["id"]'`
    echo "HEC Project ID is: $PROJECT_ID"
    
    UPT_VPC_PARAMS='{
        "vpc": {
            "name": "vpc-gtx11",
            "cidr": "192.168.0.0/16"
        }
    }'
    VPC_ID='1d8fdecb-986c-4a43-a1fd-b6de1189aff3'
    curl -i -X PUT https://vpc.cn-north-1.myhwclouds.com/v1/${PROJECT_ID}/vpcs/$VPC_ID -H 'content-type: application/json' -H "X-Auth-Token:${TOKEN}" -d "$UPT_VPC_PARAMS" -k
}

