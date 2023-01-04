#!/bin/sh

weed volume \
	-mserver=seaweedfs_master:9333 \
	-max=100 \
	-compactionMBps=2 \
	-dir=/data \
	-dataCenter="$HOST"
