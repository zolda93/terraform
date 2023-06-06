variable "resource_group_name" {
  description = "The name of the resource group"
}

variable "location" {
  description = "The name of the azure location"
  default     = "westus"
  validation {
    condition     = can(index(["westeurope", "westus"], var.location) >= 0)
    error_message = "The location must be westeurop or westus"
  }
}


