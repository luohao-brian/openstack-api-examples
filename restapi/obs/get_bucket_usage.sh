#/bin/bash

echo `date`

bucket_name="bucket"`date +%Y%m%d%H%M%S`
object_name="object"`date +%Y%m%d%H%M%S`
object_size=5

echo "********Create Bucket [$bucket_name]********"
s3cmd mb s3://$bucket_name
dd if=/dev/zero of=$object_name bs=1M count=$object_size

echo "*******Put A $objectSize MB Object To Bucket [$bucket_name]********"
s3cmd put $object_name s3://$bucket_name/$object_name

echo "*******Get The Usage Of Bucket [%bucket_name]*******"
s3cmd du s3://$bucket_name -H

echo "*******Clean Bucket [$bucket_name]********"
sh clean_bucket.sh $bucket_name

s3cmd rb s3://$bucket_name
rm -rf $object_name
