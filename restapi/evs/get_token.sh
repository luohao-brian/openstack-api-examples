#! /bin/bash
CONFIG_FILE="configs.cfg"
source ${CONFIG_FILE}
curl -i -X POST ${HEC_IAM_ENDPOINT}/v3/auth/tokens -H 'content-type: application/json' -d "${AUTH_PARAMS}" -k > ${TEMP_DATA_FILE} && {
    TOKEN=`cat ${TEMP_DATA_FILE} | grep "X-Subject-Token"| awk '{print$2}' |tr -d '\n'`
    echo "HEC Token is: $TOKEN"
    sed -i 's/curr_token=.*/curr_token="'${TOKEN}'"/' ${CONFIG_FILE}
	PROJECT_ID=`tail -n 1 ${TEMP_DATA_FILE}|python -c 'import json,sys;print json.load(sys.stdin)["token"]["project"]["id"]'`
    echo "HEC Project ID is: $PROJECT_ID"
    sed -i 's/curr_projectId=.*/curr_projectId="'${PROJECT_ID}'"/' ${CONFIG_FILE}
    dos2unix ${CONFIG_FILE} &> /dev/null
}
