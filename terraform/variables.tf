variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "Primary GCP region"
  default     = "europe-west1"
}

variable "cluster_name" {
  type        = string
  description = "GKE Autopilot cluster name"
  default     = "code-caravan-platform"
}

variable "artifact_registry_name" {
  type        = string
  description = "Artifact Registry repository name"
  default     = "code-caravan-images"
}
