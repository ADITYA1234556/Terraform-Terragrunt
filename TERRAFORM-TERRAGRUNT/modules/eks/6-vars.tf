variable "env" {
  type        = string
  description = "name of the environment"
}

variable "eks_version" {
  type        = string
  description = "Desired kubernetes version"
}

variable "eks_name" {
  type        = string
  description = "name of the eks cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "list of subnet ids to use for the eks cluster"
}

variable "node_iam_policies" {
  description = "List of IAM Policies to attach to EKS-managed nodes."
  type        = map(any)
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "node_groups" {
  description = "EKS node groups"
  type        = map(any)
}

variable "enable_oidc" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}