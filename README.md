# SeaweedFS Docker Swarm stack

This is a [Docker Swarm](https://docs.docker.com/engine/swarm/) stack for deploying a performant and highly available persistent storage system using [SeaweedFS](https://github.com/seaweedfs/seaweedfs).

## Architecture

This example stack is designed to operate on a Docker Swarm consisting of four nodes (`node1, node2, node3, node4`) spread out over different locations and connected in a [Wireguard](https://www.wireguard.com/) mesh. In this setup, some network latency is to be expected. Therefore, to reduce the amount of network hops, we configure the SeaweedFS [Filers](https://github.com/seaweedfs/seaweedfs/wiki/Components#filer-service) to prefer writing to [Volumes](https://github.com/seaweedfs/seaweedfs/wiki/Components#volume-concept) existing on the same node as itself, and likewise with the globally deployed [Mounts](https://github.com/seaweedfs/seaweedfs/wiki/Components#volume-concept) reading and writing to Filers.

## Deployment

Assuming you have adjusted the Docker stack files and configs to suit your environment (for instance, your nodes are probably not called `node1, node2...`, you may have another Swarm overlay network than the `public` of this example, etc.):

+ On every Swarm node:

```
mkdir /mnt/{cch,cld,seaweedfs}
mkdir /mnt/seaweedfs/{filer,master,volume}
```

+ On a Swarm master node:

```
docker stack deploy -c seaweed/docker-compose.yml seaweedfs
``` 
