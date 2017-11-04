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
    VPC_ID='80645a7b-935a-4018-86e2-8f273122db22'
    SUBNET_ID='742a3476-8c9e-4aa0-9107-2ad7e5876f96'
    curl -i -X DELETE https://vpc.cn-north-1.myhwclouds.com/v1/${PROJECT_ID}/vpcs/$VPC_ID/subnets/$SUBNET_ID -H 'content-type: application/json' -H "X-Auth-Token:${TOKEN}" -k
}
