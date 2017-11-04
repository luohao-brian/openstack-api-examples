#/bin/bash

bucket_name=`sh mk_bucket.sh`

echo "********Get Bucket [$bucket_name] Information Before Set It's ACL To Public*********"
s3cmd info  s3://$bucket_name

echo "*******Set Bucket [$bucket_name] ACL To Public********"
s3cmd setacl -P s3://$bucket_name

echo "********Get Bucket [$bucket_name] Information*********"
s3cmd info  s3://$bucket_name

s3cmd rb  s3://$bucket_name
