variable "name" {
  type        = string
  default     = "terraform"
  description = "The name to use for resources related to Terraform State."

  validation {
    condition     = length(var.name) > 0
    error_message = "The length of the name must be greater than zero."
  }

  validation {
    condition     = length(var.name) < 16
    error_message = "The length of the name must be less than 16."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.name))
    error_message = "The name must be alphanumeric and lowercase."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "The name must be alphanumeric and may include dashes."
  }
}

variable "location" {
  type        = string
  description = "The location to create the resource group in for Terraform State."
  default     = "westus"
}

# TODO: Add check for location

variable "confluence_space" {
  type        = string
  description = "The confluence space to create the page in."
  default     = null

  validation {
    condition     = length(var.confluence_space) > 0
    error_message = "The length of the confluence_space must be greater than zero."
  }
}

variable "confluence_username" {
  type        = string
  description = "The confluence username to use for authentication."
  default     = null

  validation {
    condition     = length(var.confluence_username) > 0
    error_message = "The length of the confluence_username must be greater than zero."
  }
}

variable "confluence_token" {
  type        = string
  description = "The confluence token to use for authentication."
  default     = null

  validation {
    condition     = length(var.confluence_token) > 0
    error_message = "The length of the confluence_token must be greater than zero."
  }
}

variable "confluence_site" {
  type        = string
  description = "The confluence site where documentation should be stored."
  default     = null

  validation {
    condition     = length(var.confluence_site) > 0
    error_message = "The length of the confluence_site must be greater than zero."
  }
}

variable "github_repository_name" {
  default     = "devops"
  type        = string
  description = "The name of the GitHub repository to create"
}

variable "github_token" {
  type        = string
  description = "The GitHub token to use for authentication"
}

variable "github_owner" {
  type        = string
  description = "The GitHub organization to use for authentication"
}