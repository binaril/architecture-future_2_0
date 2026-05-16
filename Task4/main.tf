terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "docker" {
  host = var.docker_host
}

locals {
  prefix = "future20-${var.environment}"
}

# ─── NETWORK ──────────────────────────────────────────────────────────────────

resource "docker_network" "main" {
  name   = "${local.prefix}-network"
  driver = "bridge"
}

# ─── VOLUMES ──────────────────────────────────────────────────────────────────

resource "docker_volume" "db_data" {
  name = "${local.prefix}-db-data"
}

# ─── IMAGES ───────────────────────────────────────────────────────────────────

resource "docker_image" "postgres" {
  name         = "postgres:16-alpine"
  keep_locally = true
}

resource "docker_image" "superset" {
  name         = "nginx:alpine"
  keep_locally = true
}

# ─── CONTAINER: Analytics DB (PostgreSQL — замена ClickHouse для demo) ────────

resource "docker_container" "analytics_db" {
  name    = "${local.prefix}-analytics-db"
  image   = docker_image.postgres.image_id
  restart = "unless-stopped"

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
  ]

  networks_advanced {
    name = docker_network.main.name
  }

  mounts {
    target = "/var/lib/postgresql/data"
    type   = "volume"
    source = docker_volume.db_data.name
  }

  ports {
    internal = 5432
    external = var.db_port
  }

  labels {
    label = "service"
    value = "analytics-db"
  }

  labels {
    label = "project"
    value = "future20"
  }
}

# ─── CONTAINER: Self-Service Portal (Nginx — замена Superset для demo) ────────

resource "docker_container" "portal" {
  name    = "${local.prefix}-portal"
  image   = docker_image.superset.image_id
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.main.name
  }

  ports {
    internal = 80
    external = var.portal_port
  }

  labels {
    label = "service"
    value = "portal"
  }

  labels {
    label = "project"
    value = "future20"
  }

  depends_on = [docker_container.analytics_db]
}
