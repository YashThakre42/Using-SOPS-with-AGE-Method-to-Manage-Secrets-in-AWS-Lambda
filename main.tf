terraform {
  required_providers {
    sops = {
              source = "carlpett/sops"
              version = "0.6.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68"
    }
  }
  required_version = ">= 1.9.0"
}
provider "aws" {
  region = "eu-central-1"
  profile = "sandbox"
}

provider "sops" {}
# Step 1: Store Secrets in Secrets Manager
resource "aws_secretsmanager_secret" "my_secret" {
  name        = "my_secret"
  description = "Stores username and password"
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  secret_string = jsonencode(data.sops_file.sops-secret.data)
}

# Step 2: Create Lambda Role
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
     
      {
        Effect   = "Allow",
        Action   = "secretsmanager:GetSecretValue",
        Resource = aws_secretsmanager_secret.my_secret.arn
      }
    ]
  })
}

# Step 3: Lambda Function
#Create a ZIP file of the Python application
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python"
output_path = "${path.module}/lambda_function_1.zip"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "secretsManagerKeyRetriver_terra_ygt"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function_1.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda_function_1.zip"

  # Define environment variables
  environment {
    variables = {
      MY_ENV_VAR = "example_value"
    }
  }

}

# Step 4: Output the Secret details for verification
#output "db-user" {
#     value = data.sops_file.sops-secret.data["username"]
#     sensitive = true
#}
#output "db-password" {
#     value = data.sops_file.sops-secret.data["password"]
#     sensitive = true
#}
