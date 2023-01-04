#!/bin/sh

meta=keydb_${HOST}:6379

juicefs format \
	--storage  s3 \
	--bucket  http://seaweedfs_filer:8333/jfs \
	--access-key  myAccessKey \
	--secret-key  mySecretKey \
	redis://"${meta}"/1 \
	jfs

