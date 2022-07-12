variable "project" {
  type        = string
  description = "Project id"
  sensitive   = true
}

variable "location" {
  type        = string
  default = "europe-west3"
  description = "Project location"
}

variable "project_number" {
  type        = string
  description = "Project number"
  sensitive   = true
}

variable "name_prefix" {
  description = "prefix attached to every resource created."
  type        = string
  default = "myprojectprefix"
}

# resources
variable "cloud_function_repo_name" {
  description = "Cloud function's repo name on Github"
  type        = string
}

variable "twitter_api_token" {
  description = "Twitter API token"
  type = string
  sensitive   = true
}

# other

variable "common_labels" {
  description = "Common tags for all resources."
  type        = map(string)
  default     = {"project":"simple-data-stack", "env": "dev"}
}