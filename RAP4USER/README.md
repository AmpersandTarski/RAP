
## Build rap4-student-prototype image

> `docker build -t ampersandtarski/rap4-student-prototype:<version here> .`

## Opstarten container using rap4-student-prototype

NOTE! Backticks need to be escaped when used in windows powershell. Therefore double backticks `` are used in command argument below. A single backtick is needed in the Host() argument.

```txt
echo "UEsDBBQAAgAIAPI13Fg8m1DWdwMAAFgKAAAIAAAAbWFpbi5hZGydVl1P2zAUfY+U/3CVlzEo/ACYkEIJXSZIqyZlSBWarMYQi9SOYoeu2sZv37XjpF/pyuhLK/vec8+5X25/GCXBQwIBL0WezylXEEYQRIPbMP7qOqPJeDSMA+jvmLnOrxPwYSbmRU4VxR9VKfUXl0wqCeIJJH2lJclhLtIqp/LMdWJVpehrbknrQjhQgwtPogTCl9YDVEYUMAkFKZV2UVkTB7FO/rgOEvSTJBhH0DfH0nVOTyExZnxGC4UHSL0fjBKwscGLxZwKTmGRCVgQzUYJkHi7BAynMgzIuFRMVYp6GynYwNEJ+E4hI69UA7xwsUBIRChoKQU3iIzKXcweSGGkyKVUdA6c0tRweKG0AFWS2YsVOz/TIpvAtUTwdpNu8lSUFPOEAU0SIWVFLuakQ4DF2cu/BpWaQEkBIT9K+K6uoudjfdNqRhQTHNsBk8fUEhZMZchTMv6MRvQnmXdwtRB7udrWQndsuv/l2TZLSXNDDovFU4PAOFMMuRaiqOo71xkHt34SDiNQ5AVDTm0jHNf5fHSdu8CPwmigKyRtk9SmZLtinmnd4WiygaiHzA+j2HWmcOSN0Lz0euDdEU6eqZ4577PrXOBVXEnC9dVVhemjUkKYNHffRNZ19agjtgqYHOFIDZ+mdX47JdgZbGbvoIY9mFuqbhgnOJndulrOY13UPQLbIx+baanYbJ9hmJwOBG6gNuB7bDZJbWetXn80vcERa+tf611PXrvm1tYaJbOsySnja6sM1yTmmCiaL721ntQbqmyNcX+gL82RzeQ2sGOxWsbnW9x+n9YtddEU5a2zOz+yeesBW29vT2PHsT8IEFvh4BVKD50FtqZH8rNdTFsRuFAbUaz9J9lseoS/D4e2BEcJPkJeu8p7EI/7EPbAHNuQNDWRNJiNhXbJIFnZLTKGxegIbiU2uE2JHy+MUGyIILq2L44uVYiP4vjG7wcwxB56ZXQB5+D9iDEbSNaDnc9sXKWuczV8gC+JfxVfuo45nkLbMedwP7X+x030bYhr6wbQIN0Gl+1Z+5m2ifIQdiVmi822Gw5BsJZH7bvZXLPx5LrTrZ547WD3Wafhoz3qNQ/RuuRmaezm7f2iVzRC2FeCDvb1TMlar52alcEhLdZ7Q4xdDP8icEjLGqmwU8uhSjRSNt0m3SlounCn5m+HU2BWJY6H/af4F1BLAQI/AxQAAgAIAPI13Fg8m1DWdwMAAFgKAAAIAAAAAAAAAAAAAACkgQAAAABtYWluLmFkbFBLBQYAAAAAAQABADYAAACdAwAAAAA= bWFpbi5hZGw= " | docker run --name student123 -i -p 8000:80 -a stdin --network proxy --label traefik.enable=true --label traefik.docker.network=proxy --label traefik.http.routers.student123-insecure.rule="Host(``student123.localhost``)" --label student-prototype -e AMPERSAND_DBHOST=db -e AMPERSAND_DBNAME=student123 -e AMPERSAND_DBPASS=somepasswordhere -e AMPERSAND_PRODUCTION_MODE=false -e AMPERSAND_DEBUG_MODE=true -e AMPERSAND_SERVER_URL="https://student123.localhost" ampersandtarski/rap4-student-prototype
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