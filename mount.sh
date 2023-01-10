#!/bin/sh

cch=/mnt/cch
mnt=/mnt/cld
cnt_name=seaweedfs_mount_"$HOST"

filer1=node1
filer2=node2
filer3=node3

# prefer connecting to filer on the same node with the others as fallback
case $HOST in
	"$filer1")
		filer=seaweedfs_filer_"$filer1":8888,seaweedfs_filer_"$filer2":8888,seaweedfs_filer_"$filer3":8888
		;;
	"$filer2")
		filer=seaweedfs_filer_"$filer2":8888,seaweedfs_filer_"$filer1":8888,seaweedfs_filer_"$filer3":8888
		;;
	"$filer3")
		filer=seaweedfs_filer_"$filer3":8888,seaweedfs_filer_"$filer1":8888,seaweedfs_filer_"$filer2":8888
		;;
	*) # default value if no filers exist on the same node
		filer=seaweedfs_filer_"$filer2":8888,seaweedfs_filer_"$filer3":8888,seaweedfs_filer_"$filer1":8888
		;;
esac

trap 'cleanup' INT TERM

cleanup() {
	if [ -n "$mount_proc" ]; then
		kill -TERM "$mount_proc"
	else
		docker stop "$cnt_name" > /dev/null 2>&1
		sleep 5
	fi

	if mountpoint -q "$mnt"; then
		umount -f "$mnt" > /dev/null
		while mountpoint -q "$mnt"; do
			sleep 5
		done
	fi
}

cleanup
docker run \
	--rm \
	--name="$cnt_name" \
	--net=public \
	--cap-add SYS_ADMIN \
	--security-opt apparmor:unconfined \
	--device /dev/fuse \
	-v /mnt:/mnt:rshared \
	chrislusf/seaweedfs \
		mount \
		-dir="$mnt" \
		-cacheDir="$cch" \
		-cacheCapacityMB=15000 \
		-dirAutoCreate \
		-map.uid="1000:0" \
		-map.gid="1000:0" \
		-allowOthers=true \
		-filer="$filer" \
		-filer.path=/cld/ &

mount_proc=$!
wait "$mount_proc"
