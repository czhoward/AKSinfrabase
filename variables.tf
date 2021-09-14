variable "client_id" {}
variable "client_secret" {}

variable "agent_count" {
  default = 3
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "aksdemo"
}

variable "cluster_name" {
  default = "aksdemo"
}

variable "resource_group_name" {
  default = "rgAKSdemo001"
}

variable "location" {
  default = "UK South"
}

variable "log_analytics_workspace_name" {
  default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable "log_analytics_workspace_location" {
  default = "uksouth"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}

variable "container_registry_name" {
  default = "ACRdemo"
}

variable "container_registry_sku" {
  default = "Basic"
}
