# Docker

* work in progress

## Docker Cloud Repository

Built docker containers for solbase are available here https://hub.docker.com/r/muellerlab/solbase/

## Running a Single Container

Container version numbers can be found in the docker repository above.

```
docker run muellerlab/solbase:1.05
```

## Running a Swarm of Containers

Copy this docker-compose.yml file onto your machine.

```
version: "3"
services:
  solbase:
    image: muellerlab/solbase:1.05
    links: postgres
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.1"
          memory: 100M
      restart_policy:
        condition: on-failure
    ports:
      - "80:80"
    networks:
      - webnet
  postgres:
    image: postgres:9.5
    ports:
    - "5432:5432"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=fixture
    volumes:
      - ./data/postgres:/var/lib/postgresql/data
    networks:
      - webnet
networks:
  webnet:
```

Then execute

```
docker swarm init
docker stack deploy -c docker-compose.yml solbase
```
