variable "sso_domain" {
  description = "The domain name of the SSO service"
  type        = string
}

variable "sso_client_id" {
  description = "The client ID of the SSO service"
  type        = string
}

variable "sso_client_secret" {
  description = "The client secret of the SSO service"
  type        = string
}

variable "aws_s3_access_key" {
  description = "The access key of the AWS S3 service"
  type        = string
  sensitive   = true
}

variable "aws_s3_secret_key" {
  description = "The secret key of the AWS S3 service"
  type        = string
  sensitive   = true
}

variable "aws_s3_endpoint" {
  description = "The endpoint of the AWS S3 service"
  type        = string
}
