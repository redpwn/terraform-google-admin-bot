variable "prefix" {
  type = string
  default = "admin-bot"
  description = "Prefix for all GCP resources created by the module"
}
variable "image" {
  type = string
  description = "Docker image URI on gcr.io or pkg.dev with redpwn/admin-bot base"
}
variable "submit_concurrency" {
  type = number
  default = 10
  description = "Maximum concurrency for the submit service"
}
variable "visit_concurrency" {
  type = number
  default = 10
  description = "Maximum concurrency for the visit service"
}
variable "recaptcha" {
  type = object({
    site = string
    secret = string
  })
  sensitive = true
  description = "Google reCAPTCHA credentials"
}
