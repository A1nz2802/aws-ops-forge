# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-push-iam.html
data "aws_iam_policy_document" "ci_publish" {
  statement {
    sid       = "GetAuthorizationToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "PushServiceImages"
    effect = "Allow"
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:BatchGetImage"
    ]
    resources = [aws_ecr_repository.service.arn]
  }
}

# https://docs.aws.amazon.com/AmazonECR/latest/userguide/ECR_on_ECS.html#ECR_on_ECS_required_IAM_permissions
data "aws_iam_policy_document" "image_pull" {
  statement {
    sid       = "GetAuthorizationToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "PullServiceImages"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = [aws_ecr_repository.service.arn]
  }
}
