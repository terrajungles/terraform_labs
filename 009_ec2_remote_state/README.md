# EC2 With Remote State

In this example, we will set up the remote state and state locking in S3. To do that, we need to first create the S3 bucket and DynamoDB table. To do that, update the bucket name and DynamoDB table name in `backend/main.tf`, and then run the following:

```bash
cd backend
terraform init
terraform apply --auto-approve
```