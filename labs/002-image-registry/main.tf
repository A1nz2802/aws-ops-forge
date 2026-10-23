resource "aws_ecr_repository" "service" {
  name                 = "forge-service-lab002"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = false
}

data "aws_ecr_lifecycle_policy_document" "service" {
  rule {
    priority    = 1
    description = "Expire release images beyond the latest 10"
    selection {
      tag_status      = "tagged"
      tag_prefix_list = ["release-"]
      count_type      = "imageCountMoreThan"
      count_number    = 10
    }
    action {
      type = "expire"
    }
  }

  rule {
    priority    = 2
    description = "Expire CI images beyond the latest 5, subject to release-rule priority"
    selection {
      tag_status      = "tagged"
      tag_prefix_list = ["ci-"]
      count_type      = "imageCountMoreThan"
      count_number    = 5
    }
    action {
      type = "expire"
    }
  }

  rule {
    priority    = 3
    description = "Expire untagged images older than 7 days"
    selection {
      tag_status   = "untagged"
      count_type   = "sinceImagePushed"
      count_unit   = "days"
      count_number = 7
    }
    action {
      type = "expire"
    }
  }
}

resource "aws_ecr_lifecycle_policy" "service" {
  repository = aws_ecr_repository.service.name
  policy     = data.aws_ecr_lifecycle_policy_document.service.json
}
