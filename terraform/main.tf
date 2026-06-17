locals {
  sa_id          = "${var.agent_name}-sa"
  sa_display     = "${var.agent_name} Service Account"
  vm_name        = "${var.agent_name}-vm"
  static_ip_name = "${var.agent_name}-ip"
}

# --- Service Account ---

resource "google_service_account" "agent" {
  account_id   = local.sa_id
  display_name = local.sa_display
  project      = var.project_id
}

resource "google_project_iam_member" "agent_aiplatform" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.agent.email}"
}

resource "google_project_iam_member" "agent_secretmanager" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.agent.email}"
}

# --- Static IP ---

resource "google_compute_address" "agent" {
  name   = local.static_ip_name
  region = var.region
}

# --- VM ---

resource "google_compute_instance" "agent" {
  name         = local.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = var.disk_size_gb
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.agent.address
    }
  }

  service_account {
    email  = google_service_account.agent.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    startup-script = file("../scripts/startup.sh")
    agent-name     = var.agent_name
    repo-url       = var.repo_url
  }

  tags = ["${var.agent_name}-vm"]
}

# --- Secret Manager ---

resource "google_secret_manager_secret" "github_pat" {
  secret_id = "${var.agent_name}-github-pat"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "github_webhook_secret" {
  secret_id = "${var.agent_name}-github-webhook-secret"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "litellm_master_key" {
  secret_id = "${var.agent_name}-litellm-master-key"
  project   = var.project_id

  replication {
    auto {}
  }
}
