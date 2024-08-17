variable "sso_domain" {
  description = "The domain name of the SSO service"
  type        = string
}

variable "sso_client_id" {
  description = "The client ID of the SSO service"
  type        = string
}

variable "sso_realm" {
  description = "The realm of the SSO service"
  type        = string
}

variable "groq_api_key" {
  description = "The API key for the Groq service"
  type        = string
  sensitive   = true
}

variable "jwt_pem" {
  description = "The PEM to use for JWT signing in base64"
  type        = string
  sensitive   = true
}