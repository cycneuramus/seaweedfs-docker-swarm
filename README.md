# SeaweedFS + JuiceFS Docker Swarm stack

This is a draft of a performant and highly available persistent storage system for [Docker Swarm](https://docs.docker.com/engine/swarm/) using [SeaweedFS](https://github.com/seaweedfs/seaweedfs) mounted on [JuiceFS](https://github.com/juicedata/juicefs/). 

[Edited to add: There may be some false assumptions behind my architecture here. See [this](https://github.com/seaweedfs/seaweedfs/discussions/4105) discussion.]

## Architecture

This example stack is designed to operate on a Docker Swarm consisting of four nodes (`node1, node2, node3, node4`) spread out over different locations and connected in a [Wireguard](https://www.wireguard.com/) mesh. In this setup, some network latency is to be expected. Therefore, to ensure good performance, we want every JuiceFS mount to communicate with a metadata server _running on the same node_; otherwise, the latency between a given mount and a given metadata server, which may be running on another node, will absolutely tank the I/O throughput.

So we deploy a global multi-master [KeyDB](https://github.com/Snapchat/KeyDB) setup and instruct the JuiceFS mounts, also running globally, only to connect to the KeyDB master that is running on the same node. Metadata replication across nodes will be handled by KeyDB in the background. This setup, along with the replication settings of SeaweedFS, should achieve high availability of our distributed storage (and, hopefully, great performance).

## Deployment

Assuming you have adjusted the Docker stack files and configs to suit your environment (for instance, your nodes are probably not called `node1, node2...`, you may have another Swarm overlay network than the `public` of this example, etc.):

+ On every Swarm node:

```
mkdir /mnt/{cch,cld,keydb,seaweedfs}
mkdir /mnt/seaweedfs/{filer,master,volume}
```

+ On a Swarm master node:

```
docker stack deploy -c seaweed/docker-compose.yml seaweedfs
docker exec -it <SeaweedFS Master container> weed shell
> s3.bucket.create -name jfs

docker stack deploy -c keydb/docker-compose.yml keydb
docker stack deploy -c juicefs/docker-compose.yml juicefs
```
