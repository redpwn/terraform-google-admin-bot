variable "prefix" {
  type = string
  default = "admin-bot"
  description = "Prefix for all GCP resources created by the module"
}
variable "image" {
  type = string
  description = "Docker image URI on gcr.io or docker.pkg.dev with redpwn/admin-bot base"
}
variable "recaptcha" {
  type = object({
    site = string
    secret = string
  })
  sensitive = true
  description = "Google reCAPTCHA credentials"
}
