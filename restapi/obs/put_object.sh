#/bin/bash

echo `date`

bucket_name="bucket"`date +%Y%m%d%H%M%S`
echo "*******Create A Bucket [$bucket_name]********"

s3cmd mb s3://$bucket_name

object_name="object"`date +%Y%m%d%H%M%S`
dd if=/dev/zero of=$object_name bs=1M count=5
echo "******Put Object [$object_name]********"
s3cmd put $object_name s3://$bucket_name/$object_name

echo "********List Objects In Bucket [$bucket_name]********"
s3cmd ls s3://$bucket_name

echo "********Delete Object [$object_name]*********"
s3cmd del s3://$bucket_name/$object_name

echo "********Delete Bucket [$bucket_name]"
s3cmd rb s3://$bucket_name
rm -rf $object_name $local_object_name
