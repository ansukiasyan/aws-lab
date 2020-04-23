#Terraform configured to use S3 bucket as a backend to store tfstate files
#Run 'terraform init -backend-config=backend.hcl' command to merge patial configurations together
terraform {
  backend "s3" {    
    key    = "global/s3/terraform.tfstate"    
  }
}



provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "annas-terraform-state"

  #lifecycle {
  #  prevent_destroy = true
  #}

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


resource "aws_dynamodb_table" "tf_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}