# Terraform Code for Deployment of Ec2 Instances

This script deployes 4 Ec2 instances,
  1) First for api server with publically exposed port(80) for api access with help of public subnet.
  2) Second Instance for Service#1 with private subnet.
  3) Third Instance for service#2 with private subnet.
  4) Fourth instance for Nats server.

> Note: All four instances's port 80 is accesible by each other instances for communication between them.

## To Run the script:

1. Prerequisite

   - Terraform : https://learn.hashicorp.com/terraform/getting-started/install.html
   - AWS IAM Account API Keys (Access Key & Secret Key)
   - AWS CLI : https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

2. Initialize our directory with terraform

   - From the root directory run the command
     `terraform init`
     This will initialize the provider and download all the required modules.

3. Validate the code

   - run command
     `terraform validate`
     This validates the configuration files in our directory.

4. Plan

   - run command
     `terraform plan`
     The "terraform plan" is a command which is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files. This command is useful to check whether our execution plan matches our expectations without making any changes to real resources.

5. Deployment

   - finally run the command
     `terraform apply`
     This will deploy all the resources which are defined in the script to the AWS account for which access keys were provided.

> Note: Incase you would want to delete all created resources, `terraform destroy` will clean up all the resources created for you.
