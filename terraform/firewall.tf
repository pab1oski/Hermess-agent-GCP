resource "google_compute_firewall" "ssh" {
  name    = "${var.agent_name}-allow-ssh"
  network = "default"
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.ssh_allowed_cidr]
  target_tags   = ["${var.agent_name}-vm"]

  description = "Allow SSH access from the configured CIDR range."
}

resource "google_compute_firewall" "webhook" {
  name    = "${var.agent_name}-allow-webhook"
  network = "default"
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["8644"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.agent_name}-vm"]

  description = "Allow inbound webhook traffic on port 8644 from any source."
}
