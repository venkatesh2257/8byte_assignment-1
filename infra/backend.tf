terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket         = "venky-becket-for-8byte"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "venky_bucket_2257"
    encrypt        = true
  }
}
