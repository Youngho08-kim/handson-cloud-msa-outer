/*****************************************
  Jenkins GKE
 *****************************************/
module "jenkins-gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster/"
  version                  = "~> 7.0"
  project_id               = module.enables-google-apis.project_id
  name                     = "jenkins-13"
  regional                 = false
  region                   = var.region
  zones                    = var.zones
  network                  = module.jenkins-vpc.network_name
  subnetwork               = module.jenkins-vpc.subnets_names[0]
  ip_range_pods            = var.ip_range_pods_name
  ip_range_services        = var.ip_range_services_name
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  remove_default_node_pool = true
  service_account          = "create"
  identity_namespace       = "${module.enables-google-apis.project_id}.svc.id.goog"
  node_metadata            = "GKE_METADATA_SERVER"
  node_pools = [
    {
      name         = "butler-pool"
      min_count    = 1
      max_count    = 3
      auto_upgrade = true
    }
  ]
}

/*****************************************
  K8S secrets for configuring K8S executers
 *****************************************/
resource "kubernetes_secret" "jenkins-secrets" {
  metadata {
    name = var.jenkins_k8s_config
  }
  data = {
    project_id          = module.enables-google-apis.project_id
    kubernetes_endpoint = "https://${module.jenkins-gke.endpoint}"
    ca_certificate      = module.jenkins-gke.ca_certificate
    jenkins_tf_ksa      = module.workload_identity.k8s_service_account_name
  }
}