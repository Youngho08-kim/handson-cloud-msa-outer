terraform {
  required_version = ">= 0.12"
}
 
provider "google" {
  version = "~> 3.47.0"
  project = var.project_id
  region  = var.region
}
 
provider "google-beta" {
  version = "~> 3.47.0"
  project = var.project_id
  region  = var.region
}
 
/*****************************************
  Kubernetes provider configuration
 *****************************************/
provider "kubernetes" {
  version                = "~> 1.13"
  load_config_file       = false
  host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}
 
provider "helm" {
  kubernetes {
    load_config_file       = false
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
    host                   = google_container_cluster.primary.endpoint
    token                  = data.google_client_config.default.access_token
  }
}