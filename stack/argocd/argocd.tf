resource "helm_release" "argocd" {
  chart = "../../apps/argocd"
  name = "argocd"
  namespace = "argocd"
  create_namespace = true
  dependency_update = true
  
  values = [ file("../../apps/argocd/values.yaml") ]
}

resource "helm_release" "argocd-apps" {
  chart = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  name = "argocd-apps"
  version = "2.0.1"
  namespace = "argocd"
  depends_on = [ helm_release.argocd ]
  
  values = [ file("./apps.yaml") ]
}