variable "environment" {
  type        = string
  description = "Name of the environment (dev or prod)"
  default     = "prod"
}

variable "project_id" {
  description = "project id"
}

variable "member_id" {
  description = "member id"
}

variable "region" {
  description = "region"
  default = "us-central1"
}

variable "zones" {
  description = "zones"
  default = ["us-central1-a"]
}

variable "subnet_cidr" {
  type        = string
  description = "VPC Network CIDR to be assigned to the VPC being created"
  default     = "10.0.0.0/16"
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "machine_type" {
  default = "n1-standard-1"
  description = "Node pool machine type"
}


data "google_client_config" "default" {
}