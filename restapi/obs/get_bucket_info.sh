#/bin/bash

bucket_name=`sh mk_bucket.sh`

echo "********Get Information Of Bucket [$bucket_name]********"
s3cmd info s3://$bucket_name

s3cmd rb s3://$bucket_name
