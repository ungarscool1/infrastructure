variable "cloudflare_credentials" {
  type = string
  description = "The Cloudflare API token to use for DNS challenges"
  sensitive = true
}