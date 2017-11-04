#! /bin/bash
if [ "$curr_projectId" = "" ];then
   source configs.cfg
fi

printHelp()
{
   echo    "Usage:  `basename $0`"
   echo    "        -n  name <optional>"
   echo    "        -v  volume_id"
   echo    "        -f  force flag true/false <optional>"
   echo    "        -m  metadata in json string <optional>"
}

[ $# -eq 0 ] && printHelp

if [ "$1" = "--h" ];then
    printHelp
    exit 0
fi

ARG_NAME="snap-test"
ARG_VOLUMEID=""
ARG_FORCE="true"
ARG_METADATA="{}"

while getopts ":n:v:f:m:" arg
do
    case $arg in
        n)
            ARG_NAME="$OPTARG"
            ;;
        v)
            ARG_VOLUMEID="$OPTARG"
            ;;
        f)
            ARG_FORCE="$OPTARG"
            ;;
        m)
            ARG_METADATA="$OPTARG"
            ;;
        \?)
            printHelp
            exit 1
            ;;
    esac
done
if [ "$ARG_VOLUMEID" = "" ];then
    echo "parameter volume_id missed."
    exit 1
fi

echo -e "\033[33m"
echo "   create snapshot :   name=${ARG_NAME}   volume_id=${ARG_VOLUMEID}   force=${ARG_FORCE}   metadata=${ARG_METADATA}"
echo -e "\033[0m"

CREATE_SNAP_PARAMS='{ 
                "snapshot": { 
                "name": "'${ARG_NAME}'", 
                "volume_id": "'${ARG_VOLUMEID}'",
                "force": '${ARG_FORCE}',
                "metadata": '${ARG_METADATA}'
                } 
        }' 

        curl -i -X POST ${HEC_CINDER_ENDPOINT}/v2/${curr_projectId}/snapshots \
        -H "content-type: application/json" \
        -H "X-Auth-Token: ${curr_token}" \
        -d "$CREATE_SNAP_PARAMS" -k
        echo "
             "
