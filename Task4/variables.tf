variable "docker_host" {
  description = "Docker host socket"
  type        = string
  default     = "npipe:////./pipe/docker_engine"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "db_name" {
  description = "Analytics database name"
  type        = string
  default     = "analytics"
}

variable "db_user" {
  description = "Analytics database user"
  type        = string
  default     = "future20"
}

variable "db_password" {
  description = "Analytics database password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Host port for PostgreSQL"
  type        = number
  default     = 5432
}

variable "portal_port" {
  description = "Host port for self-service portal"
  type        = number
  default     = 8088
}
