# Docker

* work in progress

## Docker Cloud Repository

Built docker containers for solbase are available here https://hub.docker.com/r/muellerlab/

## Running a Single Container

Container version numbers can be found in the docker repository above.

```
docker run -p 3000:3000 muellerlab/solbase:1.05
```

Now you should see solbase running on your browser on localhost; however,
our docker deployment is a distribution of three containers: solbase, postgres, and nginx.
To bundle these three together, you can run a stack described below.

## Running a Stack of Containers

Clone this repository on your machine and go to docker directory, then execute:

```
docker swarm init
docker stack deploy -c docker-compose.yml solbase
```

Now you should see solbase running on your browser on localhost.