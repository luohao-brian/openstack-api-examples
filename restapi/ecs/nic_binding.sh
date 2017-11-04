
#!/bin/bash

HEC_USER_NAME='hwcloud5967'
HEC_USER_PASSWD='Here2go$'

NIC_ID='e836b196-ff8f-4ea4-8f0a-5bdb1e83c76c'


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

    CREATE_SG_PARAMS='{
    "nic": {
        "subnet_id": "c281cb9c-1403-483b-999c-ba07ea984bf4",
        "ip_address": "192.168.10.207",
        "reverse_binding": true
    }
  }'
   
    curl -i -X PUT https://ecs.cn-north-1.myhwclouds.com/v1/${PROJECT_ID}/cloudservers/nics/${NIC_ID} -H "X-Auth-Token:${TOKEN}" -d "$CREATE_SG_PARAMS" 
}

