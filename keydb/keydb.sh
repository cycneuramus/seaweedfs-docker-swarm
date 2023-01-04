#!/bin/sh

nodes="replicaof keydb_node1 6379
replicaof keydb_node2 6379
replicaof keydb_node3 6379
replicaof keydb_node4 6379"

nodes=$(echo "$nodes" | grep -v "$HOST")

cat > /etc/keydb.conf <<- EOF
	appendonly yes
	active-replica yes
	multi-master yes
	repl-backlog-size 1000mb
	repl-timeout 600
	client-output-buffer-limit normal 0 0 0
	client-output-buffer-limit pubsub 0 0 0
	client-output-buffer-limit replica 0 0 0
	$nodes
EOF

keydb-server /etc/keydb.conf
