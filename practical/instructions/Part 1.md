# Scenario

## Part 1

As the DevOps engineer, you now need to deploy Parse Server in AWS `ap-northeast-1` region. You have just recently learnt Terraform and hope to make use of Terraform to automate the provisioning of the infrastructure and deployment.

As the application is still in internal testing, Acme wants to save on infrastructure costs.

Requirements:
* `appId` and `masterKey` must be environment variables that can be passed in.
* Provision and deploy Parse Server using docker in AWS
* Use the AMI ID - `ami-08d175f1b493f205f` for the EC2 instance
* Instance size should be `t2.micro`
* The instance should only exposed port 22 (for ssh), 80, port 443 to the public
* The Parse Server's default port `1337` should be used, but hidden from the public. You can make use of Nginx to reverse proxy to the server.
* Terraform run output should return the instance's public DNS and public IP address.
* Use the SSH key `ground-deployer`

Once the instance is up, we should be able to create a user by running:

```bash
curl -X POST \
  -H "X-Parse-Application-Id: MY_APPLICATION_ID" \
  -H "Content-Type: application/json" \
  -d '{"age":37,"userName":"John Doe","email":"johndoe@example.com"}' \
  http://<server.public_dns>/parse/classes/Users
```

And verify that the user has been created:

```bash
curl -X GET \
  -H "X-Parse-Application-Id: MY_APPLICATION_ID" \
  -H "Content-Type: application/json" \
  http://<server.public_dns>/parse/classes/Users
```

Before getting into Terraform, you have manually tested the below script will result in a working Parse Server that meets part of the above requirements:

```bash
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

echo "Running the Nginx Reverse Proxy"
docker run -d --restart unless-stopped --name nginx-proxy \
  --network parse-server-default \
  -p 80:80 \
  -p 443:443 \
  --env VIRTUAL_PORT=1337 \
  --volume /var/run/docker.sock:/tmp/docker.sock:ro \
  jwilder/nginx-proxy
```