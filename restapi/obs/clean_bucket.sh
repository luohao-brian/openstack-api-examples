#/bin/bash 

bucket_name=$1

function deleteObjectsAndPath()
{
    #url pattern s3://bucketname[/object_prefix]
    url=$1
    
    #delete objects
    for line in `s3cmd ls $url | egrep "^[0-9]"  | awk -F"s3://" '{print  "s3://"$2 }'`
    do 
    s3cmd del $line 
    done

    #delete folder
    if [ `s3cmd ls $url | egrep -v "^[0-9]"|wc -l` > 0 ]
    then
        for folder in `s3cmd ls $url | egrep -v "^[0-9]" | awk -F"s3://" '{print "s3://"$2}'`
        do 
            deleteObjectsAndPath $folder
        done
    #no files in folder
    else
        return
    fi
}

deleteObjectsAndPath s3://$bucket_name
