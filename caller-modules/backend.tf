terraform {
  backend "s3" {
    profile = var.environment
    bucket  = "terraform-storage-bucket-name"
    region  = "eu-west-1"
    key     = "molecular/molecular.tfstate"
  }
}
