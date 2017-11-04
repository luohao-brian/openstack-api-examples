#! /bin/bash
if [ "$curr_projectId" = "" ];then
   source configs.cfg
fi

printHelp()
{
   echo    "Usage:  `basename $0`"
   echo    "        -v  volume_id"
}

[ $# -eq 0 ] && printHelp

if [ "$1" = "--h" ];then
    printHelp
    exit 0
fi

ARG_VOLUMEID=""

while getopts ":v:" arg
do
    case $arg in
        v)
            ARG_VOLUMEID="$OPTARG"
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
echo "   delete volume :  volume_id=${ARG_VOLUMEID}  "
echo -e "\033[0m"

        curl -i -X DELETE ${HEC_EVS_ENDPOINT}/v1/${curr_projectId}/volumes/${ARG_VOLUMEID} \
        -H "content-type: application/json" \
        -H "X-Auth-Token: ${curr_token}" \
        -k
        echo "
             "
