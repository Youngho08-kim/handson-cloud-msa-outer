terraform {
  backend "gcs" {
    bucket = "architect-certification-289902-13-tfstate"
    prefix = "jenkins"
  }
}