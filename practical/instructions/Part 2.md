## Part 2

After several weeks of development work, Acme is now ready to beta test the mobile application. However, as the application collects user's specific data, Acme is concerned with the data security of the database. At the moment, the database is sitting in the same instance with the web tier.

Based on your knowledge, you recommend the following:
* Move the database to a new instance
* The database instance should not be publicly accessible, i.e. no public ingress in security groups
* Should only allow ingress to the DB port when it comes from the web instance
* Use the default MongoDB port of 27017

During your experiment, you have tested the following script will successfully provision a MongoDB instance:

```bash
#!/bin/bash
sudo yum -y update
sudo yum -y install unzip

echo "Running MongoDB Docker"
docker run --name database \
  -p 27017:27017 \
  -d mongo
```

And the following script can successfully connect the web instance to the MongoDB instance (assuming everything else is setup correctly):

```bash
#!/bin/bash
sudo yum -y update
sudo yum -y install unzip

docker network create --attachable parse-server-default

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
  --databaseURI mongodb://<db-private-ip>:27017/test

docker run -d --restart unless-stopped --name nginx-proxy \
  --network parse-server-default \
  -p 80:80 \
  -p 443:443 \
  --env VIRTUAL_PORT=1337 \
  --volume /var/run/docker.sock:/tmp/docker.sock:ro \
  jwilder/nginx-proxy
```

Make sure you replace the `<db-private-ip>` with the actual private IP of the database instance.

Tips:
* In the database security group, configure ingress to allow from the web's security group instead of IP address
* You will need database private IP address into the web instance's user_data script