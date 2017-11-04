#/bin/bash
bucket_name="bucket"`date +%Y%m%d%H%M%S`
s3cmd mb s3://$bucket_name > /dev/null

echo $bucket_name
