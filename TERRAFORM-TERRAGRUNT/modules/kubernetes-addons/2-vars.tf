variable "env" {
  description = "value of the environment"
  type        = string
}

variable "eks_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "enable_cluster_autoscaler" {
  description = "Determine if the cluster autoscaler is enabled"
  type        = bool
  default = false
}

variable "cluster_autoscaler_helm_version" {
    description = "Cluster autoscaler helm chart version"
    type        = string
}

variable "openid_provider_arn" {
  description = "ARN of the OpenID provider"
  type        = string
}