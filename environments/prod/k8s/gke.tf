# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-${var.member_id}-prod"
  location = var.region
  node_locations = var.zones
  provider = google-beta
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  master_auth {
    username = var.gke_username
    password = var.gke_password

    client_certificate_config {
      issue_client_certificate = false
    }
  }
  addons_config {
    istio_config {
      disabled = false
      auth     = "AUTH_MUTUAL_TLS"
    }
  }


  ## cluster_autoscaling configuration
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 4
      maximum       = 16

    }
    resource_limits {
      resource_type = "memory"
      minimum       = 15
      maximum       = 60
    }
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-np"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/compute",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = var.machine_type
    tags         = ["gke-node", "${var.project_id}-${var.member_id}-prod"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  autoscaling {
    max_node_count = 2 
    min_node_count = 1
  }
}

module "gke_auth" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version = "~> 9.1"
 
  project_id   = var.project_id
  cluster_name = google_container_cluster.primary.name
  location     = google_container_cluster.primary.location
}
 
resource "kubernetes_namespace" "default" {
    metadata {
        annotations      = {}
        labels           = {
          istio-injection = "enabled"
        }
        name             = "default"
    }
}