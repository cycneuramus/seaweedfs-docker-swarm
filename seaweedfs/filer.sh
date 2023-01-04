#!/bin/sh

cat > /etc/seaweedfs/filer.toml <<- EOF
	[leveldb3]
	enabled = true
	dir = "/data/filerdb"
EOF

volume_hosts="node1 node2 node3 node4"
if [ "${volume_hosts#*"$HOST"}" != "$volume_hosts" ]; then
	dc=$HOST
else
	dc=node1
fi

weed filer \
	-master=seaweedfs_master:9333 \
	-defaultReplicaPlacement=200 \
	-ip.bind=0.0.0.0 \
	-ip=seaweedfs_filer \
	-dataCenter="$dc" \
	-s3 \
	-s3.port=8333 \
	-s3.config=/etc/seaweedfs/s3.json \
	-s3.allowEmptyFolder=true
