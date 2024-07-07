resource "kubectl_manifest" "help_option" {
  yaml_body = file("../../k3s/traefik/service.yaml")
}