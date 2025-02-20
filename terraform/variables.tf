variable "app_version" {
  description = "Application version tag"
  type        = string
  }
variable "project_id" {
  description = "project GCP"
  type        = string
  
}

variable "region" {
  description = "Region for resources"
  type        = string
  
}
variable "zone" {
  description = "Zone for resources"
  type        = string
  
} 
variable "machine_type" {
  description = "machine type for node "
  type        = string
 
} 
variable "logs_bucket_name" {
  description = "Name of the bucket for storing logs"
  type        = string
  
}
variable "image_repository" {
  description = "The Docker image repository for the hello-app"
  type        = string
  
}
