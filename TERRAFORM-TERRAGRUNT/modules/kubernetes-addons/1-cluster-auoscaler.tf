data "aws_iam_openid_connect_provider" "this" {
  arn = var.openid_provider_arn
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"

    principals {
    identifiers = [data.aws_iam_openid_connect_provider.this.arn]
    type = "Federated"
        }

    condition {
        test = "StringEquals"
        variable = "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
        values = ["system:serviceaccount:kube-system:cluster-autoscaler"]
        }
    }
}

resource "aws_iam_role" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler.json
  name = "${var.eks_name}-cluster-autoscaler-role"
}
// Custom policy for cluster autoscaler
resource "aws_iam_policy" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  name = "${var.eks_name}-cluster-autoscaler"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeInstances",
          "eks:DescribeNodegroup",
          "ec2:DescribeImages"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
    count = var.enable_cluster_autoscaler ? 1 : 0
    
    policy_arn = aws_iam_policy.cluster_autoscaler[0].arn
    role       = aws_iam_role.cluster_autoscaler[0].name
  
}

resource "helm_release" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  name = "autoscaler"

  repository = "https://kubernetes.github.io/autoscaler"
  chart = "cluster-autoscaler"
  namespace = "kube-system"
  version = var.cluster_autoscaler_helm_version
  set {
    name = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  set {
    name = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler[0].arn
  }

  set {
    name = "autoDiscovery.clusterName"
    value = var.eks_name
  }
}

/* Condition 
We will get a URL like this from the EKS cluster OIDC provider
https://oidc.eks.<region>.amazonaws.com/id/<eks-cluster-oidc-id> oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/1D7668EFB35B89753D73DDB514C64816
It stips off the https:// so the URL will look like this
oidc.eks.<region>.amazonaws.com/id/<eks-cluster-oidc-id>
Only take the token whose sub claim is system:serviceaccount:kube-system:cluster-autoscaler AND issued by oidc.eks.<region>.amazonaws.com/id/<eks-cluster-oidc-id>
*/