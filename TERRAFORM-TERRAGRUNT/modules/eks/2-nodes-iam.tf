// Lets create IAM policy and IAM role for eks nodes
// IAM policy
resource "aws_iam_role" "nodes" {
  name = "${var.env}-${var.eks_name}-eks-nodes-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nodes" {
  // iterate through all provided policies and attach it to iam role
  for_each   = var.node_iam_policies
  policy_arn = each.value
  role       = aws_iam_role.nodes.name
}