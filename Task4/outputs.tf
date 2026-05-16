output "portal_url" {
  description = "Self-service portal URL"
  value       = "http://localhost:${var.portal_port}"
}

output "db_host" {
  description = "Analytics DB connection string"
  value       = "postgresql://${var.db_user}@localhost:${var.db_port}/${var.db_name}"
}

output "network_name" {
  description = "Docker network name"
  value       = docker_network.main.name
}

output "db_container_name" {
  description = "Analytics DB container name"
  value       = docker_container.analytics_db.name
}

output "portal_container_name" {
  description = "Portal container name"
  value       = docker_container.portal.name
}
