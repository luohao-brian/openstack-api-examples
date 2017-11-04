#!/bin/bash

HEC_USER_NAME='hwcloud5967'
HEC_USER_PASSWD='Here2go$'

#SERVER_ID='26314918-0858-4cb1-9c08-eb5a161adf77'
#VOLUME_ID='60d21d3c-ee94-4e70-bf4c-2edb94a5304c'

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
 

    CREATE_VOLUME_PARAMS='{
    "volume": {
        "availability_zone": "cn-north-1a",
        "display_description": "description",
        "size": 40,
        "snapshot_id": null,
        "display_name": "newsvolume",
        "volumetype": "SATA",
        "metadata": {"meta":"test"},
        "status":"createing",
        "user_id": null,
        "name": "volume-test",
        "multiattach": false,
        "attach_status":"detached",
        "consistencygroup_id": null,
        "source_volid":null,
        "shareable":false,
        "source_replica":null
    }
  }'
   
    curl -i -X POST https://ecs.cn-north-1.myhwclouds.com/v2/${PROJECT_ID}/os-volumes -H "X-Auth-Token:${TOKEN}" -d "$CREATE_VOLUME_PARAMS" 
}



