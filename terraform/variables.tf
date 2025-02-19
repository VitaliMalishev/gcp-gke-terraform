variable "app_version" {
  description = "Application version tag"
  type        = string
  default     = "latest"
}
variable "project_id" {
  description = "project GCP"
  type        = string
  default     = "final-448512"
}

variable "region" {
  description = "Region for resources"
  type        = string
  default     = "europe-west1"
}
variable "zone" {
  description = "Zone for resources"
  type        = string
  default     = "europe-west1-b"
} #
