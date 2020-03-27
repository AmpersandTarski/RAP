
## Build rap3-student-proto image
> `docker build -t rap3-student-proto .`

## Opstarten container using rap3-student-proto
> `cat test.adl | docker run --name student123 --rm -i -a stdin -p 8080:80 rap3-student-proto`

## Stop container for student
If no container exists with name=student123, docker gives an error. This is not a problem. Just ignore.
> `docker container stop $(docker container ls -q --filter name=student123)`


TODO: stop script when Amperand gives exitcode other than 0
