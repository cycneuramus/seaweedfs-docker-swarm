#!/bin/sh

nodes="replicaof keydb_node1 6379
replicaof keydb_node2 6379
replicaof keydb_node3 6379
replicaof keydb_node4 6379"

nodes=$(echo "$nodes" | grep -v "$HOST")

cat > /etc/keydb.conf <<- EOF
	active-replica yes
	multi-master yes
	appendonly yes
	client-output-buffer-limit pubsub 64mb 32mb 120
	$nodes
EOF

