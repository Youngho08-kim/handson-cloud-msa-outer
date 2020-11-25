/*****************************************
  IAM Bindings GKE SVC
 *****************************************/
# allow GKE to pull images from GCR
resource "google_project_iam_member" "gke" {
  project = module.enables-google-apis.project_id
  role    = "roles/storage.objectViewer"

  member = "serviceAccount:${module.jenkins-gke.service_account}"
}

/*****************************************
  Jenkins Workload Identity
 *****************************************/
module "workload_identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version             = "~> 7.0"
  project_id          = module.enables-google-apis.project_id
  name                = "jenkins-wi-${module.jenkins-gke.name}-MEMBER_ID"
  namespace           = "default"
  use_existing_k8s_sa = false
}

# enable GSA to add and delete pods for jenkins builders
resource "google_project_iam_member" "cluster-dev" {
  project = module.enables-google-apis.project_id
  role    = "roles/container.developer"
  member  = module.workload_identity.gcp_service_account_fqn
}

/*****************************************
  Grant Jenkins SA Permissions to store
  TF state for Jenkins Pipelines
 *****************************************/
resource "google_storage_bucket_iam_member" "tf-state-writer" {
  bucket = var.tfstate_gcs_backend
  role   = "roles/storage.admin"
  member = module.workload_identity.gcp_service_account_fqn
}

/*****************************************
  Grant Jenkins SA Permissions project editor
 *****************************************/
resource "google_project_iam_member" "jenkins-project" {
  project = module.enables-google-apis.project_id
  role    = "roles/editor"

  member = module.workload_identity.gcp_service_account_fqn

}
