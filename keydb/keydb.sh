#!/bin/sh

if [ "$HOST" = "node1" ]; then
	replica=node2
elif [ "$HOST" = "node2" ]; then
	replica=node3
elif [ "$HOST" = "node3" ]; then
	replica=node4
elif [ "$HOST" = "node4" ]; then
	replica=node1
fi

cat > /etc/keydb.conf <<- EOF
	    appendonly yes
	    active-replica yes
	    multi-master yes
	    repl-backlog-size 100mb
	    repl-timeout 300
	    allow-write-during-load yes
	    client-output-buffer-limit normal 0 0 0
	    client-output-buffer-limit pubsub 0 0 0
	    client-output-buffer-limit replica 0 0 0
	    replicaof keydb_$replica 6379
EOF
