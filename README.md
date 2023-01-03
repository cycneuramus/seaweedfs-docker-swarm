### Architecture

This stack is designed to operate on a Docker Swarm consisting of four nodes (`node1, node2, node3, node4`) that are spread out over different locations and connected on a Wireguard mesh. In this setup, some network latency is to be expected. Therefore, to ensure good performance, we want every JuiceFS mount to communicate with a KeyDB metadata server _on the same node_; otherwise, the latency between a given mount and a given metadata server, which may be running on another node, will absolutely tank the I/O throughput.

So we deploy a global multi-master KeyDB setup and instruct the JuiceFS mounts, also running globally, only to connect to the KeyDB master that is running on the same node. Metadata replication across nodes will be handled by KeyDB in the background. This setup, along with the replication settings of SeaweedFS, should achieve high availability of our distributed storage.

### Deploy

```
docker stack deploy -c seaweedfs.yml seaweedfs
docker exec -it <SeaweedFS Master container> weed shell
> s3.bucket.create -name jfs

docker stack deploy -c keydb.yml keydb
docker stack deploy -c juicefs.yml juicefs
```
