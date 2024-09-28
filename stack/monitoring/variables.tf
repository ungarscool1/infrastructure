variable "grafana_oauth" {
  description = "Grafana's OAuth configuration"
  type = object({
    enabled       = bool
    name          = string
    client_id     = string
    client_secret = string
    server        = string
    attributes    = string
  })
  default = {
    enabled = false
    name = "oauth"
    client_id = ""
    client_secret = ""
    server = ""
    attributes = ""
  }
}