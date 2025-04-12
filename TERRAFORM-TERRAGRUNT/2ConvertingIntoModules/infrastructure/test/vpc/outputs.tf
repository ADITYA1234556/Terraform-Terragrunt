output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC" 
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
  description = "The IDs of the private subnets"
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
  description = "The IDs of the public subnets" 
}