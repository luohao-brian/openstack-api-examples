
#!/bin/bash

HEC_USER_NAME='hwcloud5967'
HEC_USER_PASSWD='Here2go$'

VOLUME_ID='e836b196-ff8f-4ea4-8f0a-5bdb1e83c76c'

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

ATTACH_VOLUME_PARAMS='{
    "serverinfo":[
    "volumeAttachment": {
        "server_id": "6dd9b9c0-8b16-4e2b-b7c7-0f380927a3c9",
        "device": "/dev/sdb"
    }
    "volumeAttachment": {
        "server_id": "6dd9b9c0-8b16-4e2b-b7c7-0f380927a3c9",
        "device": "/dev/sdb"
    }
   ]
  }'

curl -i -X POST ${HEC_IAM_ENDPOINT}/v3/auth/tokens -H 'content-type: application/json' -d "$AUTH_PARAMS" > /tmp/hec_auth_res && {
    TOKEN=`cat /tmp/hec_auth_res | grep "X-Subject-Token"| awk '{print$2}'`

    PROJECT_ID=`tail -n 1 /tmp/hec_auth_res|python -c 'import json,sys;print json.load(sys.stdin)["token"]["project"]["id"]'`

    curl -i -X POST https://ecs.cn-north-1.myhwclouds.com/v1/${PROJECT_ID}/batchaction/attachvolumes/${VOLUME_ID} -H "X-Auth-Token:${TOKEN}" -d "$ATTACH_VOLUME_PARAMS"
}
