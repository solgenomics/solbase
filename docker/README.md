# Docker

* work in progress

## Docker Cloud Repository

Built docker containers for solbase are available here https://hub.docker.com/r/muellerlab/

## Running a Single Container

Container version numbers can be found in the docker repository above.

```
docker run -p 3000:3000 muellerlab/solbase:1.05
```

You should see the web service running on your browser if you go to localhost:3000

However, our docker deployment is a distribution of three containers: solbase, postgres, and nginx.
To bundle these three together, you can run a stack described below.

## Running a Stack of Containers

Clone this repository on your machine and go to docker directory, then execute:

```
docker swarm init
docker stack deploy -c docker-compose.yml solbase
```

You should see the complete web service running on your browser if you go to localhost