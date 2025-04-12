# 🌍 Terraform with Terragrunt

This project showcases how to efficiently manage infrastructure using **Terraform** and **Terragrunt**.

---

## 🏗️ What I Did

- **Started with Terraform**  
  Created a **VPC** setup for two environments: **dev** and **test**. Initially, each environment had its own set of Terraform files.

- **Introduced Terraform Modules**  
  To enable **code reusability**, I modularized the setup. Each environment could then pass its own variables to the same set of shared modules.

- **Simplified Management with Terragrunt**  
  Even with modules, managing multiple environments required duplication (like `backend.tf` and `provider.tf` per environment).  
  With **Terragrunt**, I centralized environment configuration in a **root directory**, drastically reducing redundancy.

- **Streamlined Multi-Environment Deployments**  
  Terragrunt made it possible to manage **dev** and **test** environments simultaneously, improving consistency and reducing manual overhead.

- **Built and Deployed EKS Clusters with Helm**  
  Using custom **EKS** and **Helm** modules, I deployed an **Amazon EKS cluster** on top of the VPC, along with **Kubernetes add-ons** like the **Cluster Auto-Scaler**.

---

## ✅ Key Benefits

- 💡 Reusable Terraform modules  
- ⚙️ Centralized environment management with Terragrunt  
- 🚀 Quick and clean multi-environment deployment  
- ☁️ Production-grade EKS infrastructure with Helm-based add-ons  

---

## 📁 Project Structure (Optional)

You can include a tree view of your folder structure here using `tree` or manually written hierarchy if you'd like.
```tree
+---1BasicWithouModules
|   |   README.md
|   |
|   \---environments
|       +---dev
|       |   \---vpc
|       |           0-provider.tf
|       |           1-vpc.tf
|       |           2-igw.tf
|       |           3-subnets.tf
|       |           4-nat.tf
|       |           5-routes.tf
|       |           6-outputs.tf
|       |
|       \---test
|           \---vpc
|                   0-provider.tf
|                   1-vpc.tf
|                   2-igw.tf
|                   3-subnets.tf
|                   4-nat.tf
|                   5-routes.tf
|                   6-outputs.tf
|
+---2ConvertingIntoModules
|   |   README.md
|   |
|   \---infrastructure
|       +---dev
|       |   \---vpc
|       |           main.tf
|       |           outputs.tf
|       |
|       \---test
|           \---vpc
|                   main.tf
|                   outputs.tf
|
+---3TERRAGRUNT-VPC
|   |   README.md
|   |   terragrunt.hcl
|   |
|   +---dev
|   |   \---vpc
|   |           terragrunt.hcl
|   |
|   \---test
|       \---vpc
|               terragrunt.hcl
|
+---4EKS-VPC-TERRAGRUNT
|   |   README.md
|   |   terragrunt.hcl
|   |
|   +---dev
|   |   |   env.hcl
|   |   |
|   |   +---eks
|   |   |       terragrunt.hcl
|   |   |
|   |   +---eks-addons
|   |   |       terragrunt.hcl
|   |   |
|   |   \---vpc
|   |           terragrunt.hcl
|   |
|   \---test
|       |   env.hcl
|       |
|       +---eks
|       |       terragrunt.hcl
|       |
|       +---eks-addons
|       |       terragrunt.hcl
|       |
|       \---vpc
|               terragrunt.hcl
|
+---kube-deployment-files
|       deployment.yaml
|       stress.yml
|
\---modules
    +---eks
    |       0-versions.tf
    |       1-eks.tf
    |       2-nodes-iam.tf
    |       3-nodes.tf
    |       4-OpenIDConnectorprovider.tf
    |       5-outputs.tf
    |       6-vars.tf
    |       README.md
    |
    +---kubernetes-addons
    |       0-versions.tf
    |       1-cluster-auoscaler.tf
    |       2-vars.tf
    |       README.md
    |
    \---vpc
            0-versions.tf
            1-vpc.tf
            2-igw.tf
            3-subnets.tf
            4-nat.tf
            5-routes.tf
            6-outputs.tf
            7-vars.tf
```
---

## 📌 Prerequisites

- Terraform
- Terragrunt
- AWS CLI
- kubectl
- Helm