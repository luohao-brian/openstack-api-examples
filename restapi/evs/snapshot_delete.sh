#! /bin/bash

if [ "$curr_projectId" = "" ];then
   source configs.cfg
fi

printHelp()
{
   echo    "Usage:  `basename $0`"
   echo    "        -s  snapshot_id"
}

[ $# -eq 0 ] && printHelp

if [ "$1" = "--h" ];then
    printHelp
    exit 0
fi

ARG_SNAPSHOTID=""

while getopts ":s:" arg
do
    case $arg in
        s)
            ARG_SNAPSHOTID="$OPTARG"
            ;;
        \?)
            printHelp
            exit 1
            ;;
    esac
done
if [ "$ARG_SNAPSHOTID" = "" ];then
    echo "parameter snapshot_id missed."
    exit 1
fi

echo -e "\033[33m"
echo "   delete snapshot :  snapshot_id=${ARG_SNAPSHOTID}  "
echo -e "\033[0m"

        curl -i -X DELETE ${HEC_CINDER_ENDPOINT}/v2/${curr_projectId}/snapshots/${ARG_SNAPSHOTID} \
        -H "content-type: application/json" \
        -H "X-Auth-Token: ${curr_token}" \
        -k
        echo "
             "

