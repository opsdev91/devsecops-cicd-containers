terraform {
  backend "s3" {
    bucket = "tfstate-agileops"
    key    = "devsecops"
    region = "ap-southeast-1"
  }
}
