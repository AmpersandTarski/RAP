
## Build rap4-student-prototype image

> `docker build -t ampersandtarski/rap4-student-prototype:<version here> .`

## Opstarten container using rap4-student-prototype

NOTE! Backticks need to be escaped when used in windows powershell. Therefore double backticks `` are used in command argument below. A single backtick is needed in the Host() argument.

```txt
cat test.adl | docker run --name student123 --rm -i -a stdin --network proxy -e AMPERSAND_DBHOST=db -e AMPERSAND_DBNAME=student123 -l traefik.enable=true -l traefik.http.routers.student123-insecure.rule="Host(``student123.rap.cs.ou.nl``) || Host(``student123.localhost``)" -l student-prototype rap4-student-prototype
```

Also run the following command to attach the new container to the database network. Unfortunately we cannot attach to two networks in docker run command at the same time.

```txt
docker network connect rap_db student123
```

## Stop container for specific student

If no container exists with name=student123, docker gives an error. This is not a problem. Just ignore.
> `docker container stop $(docker container ls -q --filter name=student123)`
or
> `docker rm -f student123`

## Stop student prototype containers

> `docker container stop $(docker container ls -q --filter label=student-prototype)`