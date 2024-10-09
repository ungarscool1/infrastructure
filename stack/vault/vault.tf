resource "helm_release" "vault_agent" {
  name             = "vault-secrets-operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  version          = "0.9.0"
  namespace        = "vault-secrets-operator-system"
  create_namespace = true
}

resource "kubectl_manifest" "secret" {
  depends_on = [
    helm_release.vault_agent,
    hcp_service_principal_key.self,
    helm_release.cluster_secret,
    kubernetes_namespace.vault
  ]
  yaml_body = templatefile("./manifests/vault-auth-secret.yaml", {
    globalClientId: base64encode(hcp_service_principal_key.self.client_id),
    globalClientSecret: base64encode(hcp_service_principal_key.self.client_secret)
  })
  sensitive_fields = ["data"]
}

resource "kubectl_manifest" "authentication" {
  depends_on = [
    kubectl_manifest.secret
  ]
  yaml_body = templatefile("./manifests/vault-auth.yaml", {
    name: "default",
    namespace: "vault-secrets-operator-system",
    organizationId : data.hcp_organization.organization.resource_id,
    projectId : hcp_project.self.resource_id,
    secretRef: "vault-auth"
  })
}

resource "hcp_vault_secrets_app" "vault" {
  app_name = "vault"
  description = "Self-managed Vault"
  project_id = hcp_project.self.resource_id
}

resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
  lifecycle {
    ignore_changes = [ metadata[0].annotations ]
  }
}

resource "kubernetes_secret" "vault" {
  metadata {
    name = "hcp-vault-auth"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }
  data = {
    "clientID" = hcp_service_principal_key.vault.client_id
    "clientSecret" = hcp_service_principal_key.vault.client_secret
  }
}
