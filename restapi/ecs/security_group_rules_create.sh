#!/bin/bash

HEC_USER_NAME=''
HEC_USER_PASSWD=''


# Region&Endpoints, 
# 具体定义请参考:http://developer.hwclouds.com/endpoint.html
HEC_REGION='cn-north-1'
HEC_IAM_ENDPOINT='https://iam.cn-north-1.myhwclouds.com'
HEC_ECS_ENDPOINT='https://ecs.cn-north-1.myhwclouds.com'
HEC_VPC_ENDPOINT='https://ecs.cn-north-1.myhwclouds.com'

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

    PROJECT_ID=`tail -n 1 /tmp/hec_auth_res|python -c 'import json,sys;print json.load(sys.stdin)["token"]["project"]["id"]'`

    CREATE_SGR_PARAMS='{
    "security_group_rule": {
        "from_port":"443",
        "ip_protocol":"tcp",
        "to_port":"443",
        "cidr":"0.0.0.0/0",
        "parent_group_id":"3f0ca751-3e30-4c2e-a72c-24f11d77ef49"
    }
  }'
   
    curl -i -X POST https://ecs.cn-north-1.myhwclouds.com/v2/${PROJECT_ID}/os-security-group-rules -H "X-Auth-Token:${TOKEN}" -d "$CREATE_SGR_PARAMS" 
}
