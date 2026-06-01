resource "google_project_service" "services" {
  for_each = toset([
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "dns.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com"
  ])

  project = var.project_id
  service = each.value

  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "images" {
  depends_on = [google_project_service.services]

  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_registry_name
  description   = "Docker images for The Code Caravan client applications"
  format        = "DOCKER"
}

resource "google_container_cluster" "platform" {
  depends_on = [google_project_service.services]

  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  enable_autopilot = true
  deletion_protection = false

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }
}
