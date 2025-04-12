remote_state{
    backend = "s3"
    generate = {
        path = "state.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        bucket = "111-aditya-bucket"
        key = "${path_relative_to_include()}/terraform.tfstate"
        region = "eu-west-2"
    }
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    provider "aws" {
        region = "eu-west-2"
    }
    EOF
}