terraform {
    source = "../../../modules/kubernetes-addons"
    // source = "git@github.com:ADITYA1234556/Terraform-Terragrunt.git//modules/kubernetes-addons?ref=kuebertes-modules"
}

include "root" {
    path = find_in_parent_folders()
}

include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
}

dependency "eks" {
    config_path = "../eks"
    mock_outputs = {
        eks_name = "demo"
        openid_provider_arn = "arn:aws:iam:123456789012:oidc-provider"
    }
}

inputs = {
    env = include.env.locals.env
    eks_name = dependency.eks.outputs.eks_name
    openid_provider_arn = dependency.eks.outputs.openid_provider_arn
    enable_cluster_autoscaler = true
    cluster_autoscaler_helm_version = "9.28.0"
    
}

generate "helm_provider" {
    path = "helm-provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    
data "aws_eks_cluster" "eks" {
    name = var.eks_name
}
data "aws_eks_cluster_auth" "eks" {
    name = var.eks_name
}

provider "helm" {
    kubernetes {
        host = data.aws_eks_cluster.eks.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
        exec {
            api_version = "client.authentication.k8s.io/v1beta1"
            args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks.name]
            command = "aws"
        }
    }
}
EOF
}

