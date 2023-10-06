terraform{
    backend "s3" {
        bucket = "infra-vpc-backend-45eac44e1f913e4a"
        encrypt = true
        region = "eu-north-1"
        key = "terraform_backend/terraform.tfstate"
    }
}