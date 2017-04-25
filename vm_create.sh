#!/bin/bash

PROJECT_ID='c75709169d574f08b403ffc439a4e8e1'
NAME='hwcloud5967'
PASSWD='Huawei@123'

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

CREATE_VM_BODY='{
    "server": {
        "availability_zone": "cn-north-1b",
        "name": "newserver",
        "imageRef": "89c28901-af39-447a-9c28-b0cf567e8b36",
        "root_volume": {
            "volumetype": "SATA"
        },
        "flavorRef": "c1.medium",
        "vpcid": "0d9d392e-837e-41d0-8429-c18dfcc529ef",
        "nics": [
            {
                "subnet_id": "d292bc29-524d-4034-b080-a7aa39d83e60"
            }
        ],
        "count": 1
    }
}'

curl -i -X POST https://ecs.cn-north-1.myhwclouds.com/v1/${PROJECT_ID}/cloudservers -H "X-Auth-Token:${TOKEN}" -d "$CREATE_VM_BODY"
