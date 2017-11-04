#/bin/bash

bucket_name="`sh mk_bucket.sh`"
object_name_source="`sh mk_object_name.sh`"
object_name_dest="copy_"$object_name_source
object_size=5

echo "*******Create Bucket [$bucket_name]********"
s3cmd mb s3://$bucket_name

dd if=/dev/zero of=$object_name_source bs=1M count=$object_size

echo "*******Put An Object [$object_name_source]*******"
s3cmd put $object_name_source s3://$bucket_name/$object_name_source

echo "*******Copy Object [$object_name_source] To Object [$object_name_dest]"
s3cmd cp s3://$bucket_name/$object_name_source s3://$bucket_name/$object_name_dest

echo "*******List Objects In Bucket [$bucket_name]********"
s3cmd ls s3://$bucket_name

sh clean_bucket.sh $bucket_name

s3cmd rb s3://$bucket_name
rm -f $object_name_source
