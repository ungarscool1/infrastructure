resource "helm_release" "cluster_secret" {
  name             = "cluster-secret"
  repository       = "https://charts.clustersecret.io/"
  chart            = "cluster-secret"
  version          = "0.4.1"
  namespace        = "cluster-secret"
  create_namespace = true
}
