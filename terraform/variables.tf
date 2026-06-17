variable "project_id" {
  description = "GCP project ID where all resources will be created."
  type        = string
}

variable "region" {
  description = "GCP region for the VM and static IP."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for the VM instance."
  type        = string
  default     = "us-central1-a"
}

variable "agent_name" {
  description = "Name prefix used for all resources (VM, Service Account, secrets, etc.)."
  type        = string
  default     = "hermess-agent"
}

variable "machine_type" {
  description = "Compute Engine machine type for the VM."
  type        = string
  default     = "e2-standard-2"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB for the VM."
  type        = number
  default     = 50
}

variable "ssh_allowed_cidr" {
  description = "CIDR range allowed to connect via SSH (port 22). Use your workstation IP or a VPN range."
  type        = string
  default     = "0.0.0.0/0"
}

variable "repo_url" {
  description = "URL of the GitHub repo to clone on the VM (e.g. https://github.com/user/repo)"
  type        = string
}
