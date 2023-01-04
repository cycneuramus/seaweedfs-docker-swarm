#!/bin/sh

cch=/mnt/cch
mnt=/mnt/cld
cnt_name=juicefs_${HOST}
meta=keydb_${HOST}:6379/1

docker stop "$cnt_name" || true
sleep 1

docker run \
	--rm \
	--name="$cnt_name" \
	--net=public \
	--cap-add SYS_ADMIN \
	--security-opt apparmor:unconfined \
	--device /dev/fuse \
	-u 0:0 \
	-v "$cch":"$cch" \
	-v "$mnt":"$mnt":rshared \
	-v /mnt/keydb:/db \
	juicedata/mount:v1.0.3-4.8.3 \
	/usr/local/bin/juicefs mount \
	-o allow_other,writeback_cache,user_id=1000,group_id=1000 \
	--cache-dir $cch \
	--cache-size 16000 \
	--enable-xattr \
	--writeback \
	"$meta" \
	"$mnt"
