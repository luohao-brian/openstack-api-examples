#! /bin/bash

if [ "$curr_projectId" = "" ];then
	source configs.cfg
fi

curl -i -X GET	${HEC_EVS_ENDPOINT}/v2/${curr_projectId}/cloudvolumes \
	-H "content-type: application/json" \
        -H "X-Auth-Token: ${curr_token}" \
        -k
        echo "
             "
