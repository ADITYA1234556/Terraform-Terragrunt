terraform {
    source = "../../../modules/eks"
}

include "root" {
    path = find_in_parent_folders()
}

include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
}

dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        private_subnet_ids = ["subnet-1", "subnet-2"] // When done terraform plan it verifies that the output from vpc is similar to mock_outputs
    }
}

// Passing inputs to eks module 
inputs = {
    env = include.env.locals.env
    eks_version = "1.26"
    eks_name = "demo"
    subnet_ids = dependency.vpc.outputs.private_subnet_ids
    node_groups = {
        general = {
            capacity_type = "ON_DEMAND"
            instance_types = ["t3a.xlarge"]
            scaling_config = {
                desired_size = 1
                max_size = 10
                min_size = 1
            }
        }
    }
}

