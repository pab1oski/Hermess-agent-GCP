output "vm_ip" {
  description = "Static public IP address assigned to the agent VM."
  value       = google_compute_address.agent.address
}

output "sa_email" {
  description = "Email of the Service Account attached to the agent VM."
  value       = google_service_account.agent.email
}

output "vm_name" {
  description = "Name of the agent VM instance."
  value       = google_compute_instance.agent.name
}

output "vm_zone" {
  description = "GCP zone where the agent VM is running."
  value       = google_compute_instance.agent.zone
}

output "project_id" {
  description = "GCP project ID where all resources are deployed."
  value       = var.project_id
}
