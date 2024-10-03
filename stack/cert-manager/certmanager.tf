resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.16.0"
  namespace  = "cert-manager"
  create_namespace = true
  
  set {
    name  = "crds.enabled"
    value = "true"
  }
  set {
    name  = "crds.keep"
    value = "true"
  }
  set {
    name  = "prometheus.enabled"
    value = "false"
  }
}

resource "kubectl_manifest" "cloudflare_credentials" {
  depends_on = [ helm_release.cert_manager ]
  sensitive_fields = [ "stringData.api-token" ]
  yaml_body = templatefile("./manifests/cf-creds.yaml", {
    CF_API_TOKEN = var.cloudflare_credentials
  })
}

resource "kubectl_manifest" "letsencrypt_prod" {
  depends_on = [ helm_release.cert_manager, kubectl_manifest.cloudflare_credentials ]
  yaml_body = file("./manifests/letsencrypt-prod.yaml")
}

resource "kubectl_manifest" "certificate" {
  depends_on = [ kubectl_manifest.letsencrypt_prod ]
  yaml_body = file("./manifests/certificate.yaml")
}
