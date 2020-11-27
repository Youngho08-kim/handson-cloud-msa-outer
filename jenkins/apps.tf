data "local_file" "helm_chart_values" {
  filename = "${path.module}/values.yaml"
}
 
data "local_file" "argo_cd_values" {
  filename = "${path.module}/argo-cd-values.yaml"
}
 
resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "2.17.1"
  timeout    = 1200
 
  values = [data.local_file.helm_chart_values.content]
 
  depends_on = [
    kubernetes_secret.jenkins-secrets,
  ]
}
 
resource "helm_release" "argo-cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "2.9.5"
  timeout    = 1200
 
  values     = [data.local_file.argo_cd_values.content]
}
