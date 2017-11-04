#! /bin/bash

if [ "$curr_projectId" = "" ];then
   source configs.cfg
fi

printHelp()
{
   echo    "Usage:  `basename $0`"
   echo    "        -j  job_id"
}

[ $# -eq 0 ] && printHelp

if [ "$1" = "--h" ];then
    printHelp
    exit 0
fi

ARG_JOBID=""

while getopts ":j:" arg
do
    case $arg in
        j)
            ARG_JOBID="$OPTARG"
            ;;
        \?)
            printHelp
            exit 1
            ;;
    esac
done

if [ "$ARG_JOBID" = "" ];then
    echo "parameter job_id missed."
    exit 1
fi

echo -e "\033[33m"
echo "   query job :  job_id=${ARG_JOBID}  "
echo -e "\033[0m"

        curl -i -X GET ${HEC_EVS_ENDPOINT}/v1/${curr_projectId}/jobs/${ARG_JOBID} \
        -H "content-type: application/json" \
        -H "X-Auth-Token: ${curr_token}" \
        -k
        echo "
             "


