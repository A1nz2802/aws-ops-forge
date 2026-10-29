output "ci_publish_role_arn" {
  description = "ARN of the IAM role used by GitHub Actions to publish images."
  value       = aws_iam_role.ci_publish.arn
}

output "repository_url" {
  description = "URL of the ECR repository used for service images."
  value       = aws_ecr_repository.service.repository_url
}
