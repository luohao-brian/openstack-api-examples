#! /bin/bash
if [ "$curr_projectId" = "" ];then
   source configs.cfg
fi

printHelp()
{
   echo    "Usage:  `basename $0`"
   echo    "        -n  name <optional>"
   echo    "        -c  count(default 1) <optional>"
   echo    "        -a availability_zone <optional>"
   echo    "        -s size <optional>"
   echo    "        -v volume_type(SSD/SATA) <optional>"
}


if [ "$1" = "--h" ];then
    printHelp
    exit 0
fi

ARG_NAME="volume-test"
ARG_COUNT="1"
ARG_AZ="cn-north-1a"
ARG_SIZE="10"
ARG_VT="SATA"

while getopts ":n:c:a:s:v" arg
do
    case $arg in
        n)
            ARG_NAME="$OPTARG"
            ;;
        c)
            ARG_COUNT="$OPTARG"
            ;;
        a)
            ARG_AZ="$OPTARG"
            ;;
        s)
            ARG_SIZE="$OPTARG"
            ;;
	v)
            ARG_VT="$OPTARG"
            ;;
        \?)
            printHelp
            exit 1
            ;;
    esac
done

echo -e "\033[33m"
echo "   create volume :   name=${ARG_NAME}   count=${ARG_COUNT}   availability_zone=${ARG_AZ}   size=${ARG_SIZE} volume_type=${ARG_VT}"
echo -e "\033[0m"

CREATE_VOLUME_PARAMS='{ 
	"volume": { 
                "count": "'${ARG_COUNT}'", 
                "availability_zone": "'${ARG_AZ}'", 
                "size": "'${ARG_SIZE}'", 
                "name": "'${ARG_NAME}'", 
                "volume_type": "'${ARG_VT}'" 
                } 
	}'

        curl -i -X POST ${HEC_EVS_ENDPOINT}/v2/${curr_projectId}/cloudvolumes \

        -H "content-type: application/json" \
        -H "X-Auth-Token: ${curr_token}" \
        -d "$CREATE_VOLUME_PARAMS" -k
        echo "
             "
