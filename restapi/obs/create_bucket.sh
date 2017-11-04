#/usr/bin

echo `date`

bucket_name="bucket"`date +%Y%m%d%H%M%S`
echo "**********Create Bucket********"
s3cmd mb s3://$bucket_name
echo "**********Delete Bucket********"
s3cmd rb s3://$bucket_name
