#!/bin/bash
set -e

mkdir -p tmp/

docker build -f Dockerfile.releaser -t rank_em:releaser .

export LC_ALL=C

DOCKER_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

docker run -ti --name rank_em_releaser_${DOCKER_UUID} rank_em:releaser /bin/true
docker cp rank_em_releaser_${DOCKER_UUID}:/opt/rank_em.tar.gz tmp/
docker rm rank_em_releaser_${DOCKER_UUID}
