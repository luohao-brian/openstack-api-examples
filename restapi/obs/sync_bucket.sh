#/bin/bash

echo `date`

local_dir="testDataDir"

bucket_name="bucket"`date +%Y%m%d%H%M%S`
echo "********Create A Bucket [$bucket_name]********"
s3cmd mb s3://$bucket_name

echo "********Local Folder [$local_dir] Content are:"
ls -R $local_dir

echo "********Sync Local Folder [$local_dir] To Bucket [$bucket_name]********"
s3cmd sync $local_dir s3://$bucket_name

echo "********List Content Of Bucket [$bucket_name]********"
s3cmd ls s3://$bucket_name

echo "********Clean Objects In Bucket [$bucket_name]********"
sh clean_bucket.sh $bucket_name
echo "********Delete Bucket [%bucket_name]********"
s3cmd rb s3://$bucket_name
