variable "prefix" {
  type        = string
  default     = "admin-bot"
  description = "Prefix for all GCP resources created by the module"
}
variable "image" {
  type        = string
  description = "Docker image URI on gcr.io or pkg.dev with pwn.red/admin-bot base"
}
variable "recaptcha" {
  type = object({
    site   = string
    secret = string
  })
  default     = null
  sensitive   = true
  description = "Google reCAPTCHA credentials"
}
variable "submit_max_scale" {
  type        = number
  default     = 10
  description = "Maximum concurrent submit instances"
}
variable "visit_max_scale" {
  type        = number
  default     = 10
  description = "Maximum concurrent visit instances"
}
variable "submit_annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to apply to submit instances"
}
variable "visit_annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to apply to visit instances"
}
