resource "helm_release" "vault_agent" {
  name             = "vault-secrets-operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  version          = "0.7.1"
  namespace        = "vault-secrets-operator-system"
  create_namespace = true
}

resource "kubectl_manifest" "secret" {
  depends_on = [
    helm_release.vault_agent,
    hcp_service_principal_key.self,
    helm_release.cluster_secret
  ]
  yaml_body = templatefile("./manifests/vault-auth-secret.yaml", {
    clientId : base64encode(hcp_service_principal_key.self.client_id),
    clientSecret : base64encode(hcp_service_principal_key.self.client_secret)
  })
  sensitive_fields = ["data"]
}

resource "kubectl_manifest" "authentication" {
  depends_on = [
    kubectl_manifest.secret
  ]
  yaml_body = templatefile("./manifests/vault-auth.yaml", {
    organizationId : data.hcp_organization.organization.resource_id,
    projectId : hcp_project.self.resource_id,
  })
}
