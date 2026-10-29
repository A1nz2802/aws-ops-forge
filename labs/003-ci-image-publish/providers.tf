variable "expected_account_id" {
  description = "AWS account allowed for this lab."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[0-9]{12}$", var.expected_account_id))
    error_message = "The expected account ID must contain exactly 12 digits."
  }
}

provider "aws" {
  region              = "us-east-2"
  profile             = "forge"
  allowed_account_ids = [var.expected_account_id]
}
