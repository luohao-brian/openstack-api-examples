#/usr/bin

echo `date`

bucket_name="bucket"`date +%Y%m%d%H%M%S`
echo "**********List Buckets Before Creating********"
s3cmd ls
echo "**********Create Bucket********"
s3cmd mb s3://$bucket_name
echo "********List Buckets After Creating********"
s3cmd ls 
s3cmd rb s3://$bucket_name
