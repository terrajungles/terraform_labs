#!/bin/bash
sudo yum -y update
sudo yum -y install unzip

docker network create --attachable parse-server-default

echo "Running MongoDB Docker"
docker run --name database \
  --network parse-server-default \
  -d mongo

hostname=`curl http://169.254.169.254/latest/meta-data/public-hostname`

echo "Running Parse Server"
docker run --name web \
  --network parse-server-default \
  -v cloud-code-vol:/parse-server/cloud \
  -v config-vol:/parse-server/config \
  --env VIRTUAL_HOST=$hostname \
  -p 1337:1337 \
  -d parseplatform/parse-server \
  --appId MY_APPLICATION_ID \
  --masterKey MASTER_KEY \
  --databaseURI mongodb://database/test

docker run -d --restart unless-stopped --name nginx-proxy \
  --network parse-server-default \
  -p 80:80 \
  -p 443:443 \
  --env VIRTUAL_PORT=1337 \
  --volume /var/run/docker.sock:/tmp/docker.sock:ro \
  jwilder/nginx-proxy