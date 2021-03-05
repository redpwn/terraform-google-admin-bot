variable "prefix" {
  type = string
  default = "admin-bot"
  description = "Prefix for all resources"
}
variable "image" {
  type = string
  description = "URI for redpwn/admin-bot based image on gcr.io or pkg.dev"
}
variable "recaptcha" {
  type = object({
    site = string
    secret = string
  })
  sensitive = true
  description = "Google reCAPTCHA credentials"
}
