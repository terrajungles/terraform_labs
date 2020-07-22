## Part 3

The beta testing is completed and Acme is ready to launch the application. However, Acme is worry about the increase in the user requests which might bring down the backend server. On the other hand, Acme also do not want to spend too much provisioning a large EC2 instance only to find out there are no users.

You suggested the following:
* Set up an Auto Scaling Group on the web tier. At the moment, you are still in discussion with the rules and config for the auto scaling group. So just keep it minimal with desired, min and max capacity of 1 EC2 instance.
* Provision a load balancer which will balance the load between the instances created by the auto scaling group.
* Block the ingress access of the EC2 instances to the public, and only allow access from the load balancer.

Once the this is set up, we should be able to create a user by running:

```bash
curl -X POST \
  -H "X-Parse-Application-Id: MY_APPLICATION_ID" \
  -H "Content-Type: application/json" \
  -d '{"age":37,"userName":"John Doe","email":"johndoe@example.com"}' \
  http://<load_balancer.public_dns>/parse/classes/Users
```

And verify that the user has been created:

```bash
curl -X GET \
  -H "X-Parse-Application-Id: MY_APPLICATION_ID" \
  -H "Content-Type: application/json" \
  http://<load_balancer.public_dns>/parse/classes/Users
```

Tips:
* You will first have to create a launch template that has the EC2 instance config. This launch template will be used by the auto scaling group to provision new instances.
* You will have to use of the `base64encode` terraform function to encode the user_data in base64, which is the requirement of launch template.
* This will be deployed in the default VPC in the region. Therefore, you need to query for the VPC ID and Subnet IDs
* To connect ASG and ALB, you have to:
  * Create a target group and specify the target group in ASG
  * Create a ALB listener which forward port 80 requests to the target group

Useful References:
* EC2 Launch Template (https://www.terraform.io/docs/providers/aws/r/launch_template.html)
* Load Balancer (https://www.terraform.io/docs/providers/aws/r/lb.html)
* Load Balancer Target Group (https://www.terraform.io/docs/providers/aws/r/lb_target_group.html)
* Auto Scaling Group (https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html)