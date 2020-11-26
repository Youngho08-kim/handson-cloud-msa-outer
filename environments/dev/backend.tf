terraform {
  backend "gcs" {
    bucket = "architect-certification-289902-13D-tfstate"
    prefix = "environments/dev"
  }
}
