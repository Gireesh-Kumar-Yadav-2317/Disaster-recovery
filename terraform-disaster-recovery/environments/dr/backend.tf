terraform {
  backend "s3" {
    bucket         = "disaster-recovery-state-bucket"
    key            = "dr/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-dr-state-lock"
    encrypt        = true
  }
}