# AWS CodeDeploy with Terraform

<img src=cover.png>

This project demonstrates how to deploy a Node.js application to an EC2 instance using AWS CodeDeploy with Terraform and GitHub Actions. The setup includes automatic provisioning of AWS resources and deployment of the application using a simple CI/CD pipeline.

## Project Structure

```
.
├── appspec.yml                     # AWS CodeDeploy configuration file
├── myapp/                          # Node.js application files
│   ├── index.js
│   └── ...                         # Other application files
├── scripts/                        # Deployment scripts
│   ├── install_dependencies.sh     # Script to install dependencies
│   └── start_application.sh        # Script to start the Node.js application
├── terraform/                      # Terraform configuration files
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── README.md                       # Project documentation
```

## Prerequisites

- AWS CLI configured with appropriate access.
- Terraform installed on your local machine.
- An AWS account with permissions to create and manage EC2, S3, IAM, and CodeDeploy resources.

## Setup Instructions

### 1. Configure Terraform

1. **Navigate to the `terraform/` directory:**

   ```bash
   cd terraform/
   ```

2. **Initialize Terraform:**

   ```bash
   terraform init
   ```

3. **Edit the `variables.tf` file:**

   - Define your desired settings for the deployment, such as the AWS region, EC2 instance type, and AMI ID.

4. **Create `terraform.tfvars` file:**

   - That include your public ssh key to be able to access the EC2.

5. **Apply the Terraform configuration:**
   ```bash
   terraform apply
   ```
   - This command will provision the necessary AWS resources, including an EC2 instance, S3 bucket, and IAM roles.

### 2. Prepare the Application for Deployment

1. **Zip your application files:**

   - Include the `appspec.yml`, `myapp/`, and `scripts/` directories in the root of the zip file.

   ```bash
   zip -r myapp.zip appspec.yml myapp/ scripts/
   ```

2. **Upload the zip file to S3:**
   - Use the AWS CLI to upload the deployment package to your S3 bucket.
   ```bash
   aws s3 cp myapp.zip s3://<your-s3-bucket>/myapp.zip
   ```

### 3. Deploy the Application with CodeDeploy

1. **Create a deployment using AWS CLI:**

   ```bash
   aws deploy create-deployment \
     --application-name MyCodeDeployApp \
     --deployment-config-name CodeDeployDefault.OneAtATime \
     --deployment-group-name MyDeploymentGroup \
     --s3-location bucket=<your-s3-bucket>,bundleType=zip,key=myapp.zip
   ```

2. **Monitor the Deployment:**
   - Use the AWS Management Console or the AWS CLI to monitor the progress of the deployment.
   - Check the logs if the deployment fails to troubleshoot issues.

### 4. Access Your Application

- Once the deployment is successful, access your application using the public IP or DNS of the EC2 instance:
  ```bash
  http://<public-ip-or-dns>
  ```

## Continuous Deployment with GitHub Actions

This project includes a GitHub Actions workflow to automate the deployment of a Node.js application to an EC2 instance using AWS CodeDeploy. The workflow is triggered on every push to the `main` branch, creating a deployment package, uploading it to S3, and then deploying it using CodeDeploy.

### GitHub Actions Workflow

The workflow is defined in `.github/workflows/deploy.yml` and includes the following steps:

1. **Checkout Code**:

   - The workflow checks out the latest version of the code from the `main` branch.

2. **Zip the Application**:

   - The application files are zipped into a single deployment package named `myapp.zip`.

3. **Upload to S3**:

   - The deployment package (`myapp.zip`) is uploaded to an S3 bucket (`dev-codedeploy-bucket-ajkgr8mu`).

4. **Deploy with CodeDeploy**:
   - A deployment is created using AWS CodeDeploy, specifying the application name, deployment group, and S3 location of the deployment package.

### Prerequisites

To use this workflow, you need to have the following in place:

- **AWS Credentials**: Store your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in the GitHub repository's secrets. These will be used by the workflow to authenticate with AWS.
- **S3 Bucket**: Ensure that the S3 bucket (`dev-codedeploy-bucket-ajkgr8mu`) exists in the specified AWS region (`eu-central-1`).
- **AWS CodeDeploy Setup**: An AWS CodeDeploy application and deployment group must be configured and ready to receive deployments.

2. **Configure AWS Secrets**:

   - In your GitHub repository, go to **Settings > Secrets and variables > Actions**.
   - Add the following secrets:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
     - Ensure these credentials have the necessary permissions to upload to S3 and create deployments in CodeDeploy.

3. **Trigger the Deployment**:
   - Push any changes to the `main` branch of your repository to trigger the workflow.
   - The workflow will automatically package the application, upload it to S3, and deploy it to your EC2 instances using AWS CodeDeploy.

## Troubleshooting

- **Deployment Failures:** Check the CodeDeploy logs at `/var/log/aws/codedeploy-agent/codedeploy-agent.log` on the EC2 instance for detailed error messages.

```
sudo service codedeploy-agent status
```

```
sudo tail -f /var/log/aws/codedeploy-agent/codedeploy-agent.log
```

- **IAM Role Issues:** Ensure the IAM role attached to the EC2 instance has the correct permissions for S3, CodeDeploy, and CloudWatch.
  `Make sure the CodeDeploy is using the same IAM role assigned with the EC2`:

```
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

- **AppSpec Issues:** Verify that the `appspec.yml` file is correctly formatted and that all file paths and scripts are correctly referenced.

## Clean Up

To clean up all AWS resources created by this project, run the following Terraform command:

```bash
terraform destroy
```
