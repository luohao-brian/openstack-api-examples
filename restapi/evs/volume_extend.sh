#! /bin/bash
if [ "$curr_projectId" = "" ];then
   source configs.cfg
fi

printHelp()
{
   echo    "Usage:  `basename $0`"
   echo    "        -v  volume_id"
   echo    "	    -s  new_size"
}

[ $# -eq 0 ] && printHelp

if [ "$1" = "--h" ];then
    printHelp
    exit 0
fi

ARG_VOLUMEID=""
ARG_NEWSIZE=""

while getopts ":v:s:" arg
do
    case $arg in
        v)
            ARG_VOLUMEID="$OPTARG"
            ;;
	s)
	    ARG_NEWSIZE="$OPTARG"
	    ;;
        \?)
            printHelp
            exit 1
            ;;
    esac
done
if [ "$ARG_VOLUMEID" = "" ] || [ "$ARG_NEWSIZE" = "" ];then
    echo "parameter volume_id or new_size missed."
    exit 1
fi

echo -e "\033[33m"
echo "   extend volume :  volume_id=${ARG_VOLUMEID}  new_size=${ARG_NEWSIZE} "
echo -e "\033[0m"

	EXTEND_VOLUME_PARAMS='{ 
                "os-extend": {"new_size": "'${ARG_NEWSIZE}'"} 
        }'
        
	curl -i -X POST ${HEC_EVS_ENDPOINT}/v1/${curr_projectId}/volumes/${ARG_VOLUMEID}/action \
        -H "content-type: application/json" \
        -H "X-Auth-Token: ${curr_token}" \
	-d "$EXTEND_VOLUME_PARAMS" \
        -k
        echo "
             "
