output "cluster_name" {
  value = google_container_cluster.platform.name
}

output "cluster_region" {
  value = google_container_cluster.platform.location
}

output "artifact_registry" {
  value = google_artifact_registry_repository.images.repository_id
}
