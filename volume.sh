#!/bin/sh

weed volume \
	-mserver=seaweedfs_master:9333 \
	-max=100 \
	-preStopSeconds=1 \
	-dir=/data \
	-dataCenter="$HOST"

