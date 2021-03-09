output "submit_url" {
  value = google_cloud_run_service.submit.status[0].url
  description = "Public Cloud Run URL for submissions"
}
