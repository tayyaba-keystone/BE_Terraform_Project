# 🚀 Provisioning AWS Infrastructure Using Terraform

This is my final-year project aimed at automating the provisioning and management of AWS infrastructure using Terraform. The project demonstrates a scalable, secure, and modular Infrastructure-as-Code (IaC) approach using various AWS services.

## 📁 Project Structure

- `Autoscaling.tf` – Creates an Auto Scaling Group to maintain desired EC2 capacity.
- `host_application.tf` – Provisions EC2 instances and installs a web application using `user_data.sh`.
- `iam.tf` – Defines IAM roles and policies required for secure access.
- `s3.tf` – Creates an S3 bucket for storing application logs and other static data.
- `user_data.sh` – A bash script to configure the EC2 instance during launch.

## ☁️ AWS Services Used

- EC2 (Elastic Compute Cloud)
- S3 (Simple Storage Service)
- IAM (Identity and Access Management)
- VPC (Virtual Private Cloud)
- Auto Scaling

## 🛠️ Tools & Technologies

- **Terraform** – Infrastructure as Code tool for AWS automation
- **Shell Script** – Used in `user_data.sh` for EC2 configuration
- **AWS CLI** – For interacting with AWS services

## 🔧 How to Use

> 💡 Make sure you have AWS credentials configured and Terraform installed.

1. Clone the repository:
   ```bash
   git clone https://github.com/tayyaba-keystone/BE_Terraform_Project.git
   cd BE_Terraform_Project

2. Preview the resources to be created:
   - terraform plan
3. Apply the Terraform scripts:
   - terraform apply -auto-approve
4. To destroy the resources:
   - terraform destroy -auto-approve

## 🏆 Outcome
- ⚡ Improved infrastructure deployment speed and consistency.

- 📈 Ensured scalability and security using AWS best practices.

- 🔄 Reduced manual configuration effort by 90% through full automation.
