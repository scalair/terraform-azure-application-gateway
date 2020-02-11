variable "resource_group_name" {
  description = "Name of the resource group to place App Gateway in."
}
variable "resource_group_location" {
  description = "Location of the resource group to place App Gateway in."
}
variable "name" {
  description = "Name of App Gateway"
}

variable "subnet_id" {
  description = "id of subnet Gateway"
}

variable "public_ip_address_id" {
  description = "id of the frontend publix ip "
}

variable "backend_address_pools" {
  description = "List of backend address pools."
  type = list(object({
    name         = string
    ip_addresses = list(string)
    #fqdns        = list(string)
  }))
}
variable "backend_http_settings" {
  description = "List of backend HTTP settings."
  type = list(object({
    name                                = string
    has_cookie_based_affinity           = bool
    path                                = string
    port                                = number
    is_https                            = bool
    request_timeout                     = number
    probe_name                          = string
    pick_host_name_from_backend_address = bool
    connection_draining_enabled         = bool
    drain_timeout                       = number
    trusted_root_certificate_name       = string
  }))
}
variable "ssl_certificates" {
  description = "List of ssl certificates"
  type = list(map(any))
  default = []
}
#variable "http_listeners" {
#  description = "List of HTTP listeners."
#  type = list(object({
#    name     = string
#    is_https = bool
#    ssl_certificate_name = string
#  }))
#}
variable "http_listeners" {
description = "List of HTTP listeners."
type = list(map(any))
}

variable "authentication_certificates" {
  description = "Authentication certificates for the backend"
  type = list(object({
    name                       = string
    use_vault                  = bool
    path_to_certificate_data   = string
  }))
  default = []
}

variable "trusted_root_certificates" {
  description = "Trusted root certificates for the backend"
  type = list(object({
    name                       = string
    use_vault                  = bool
    path_to_root_certificate_data   = string
  }))
  default = []
}

variable "request_routing_rules" {
  description = "Request routing rules to be used for listeners."
  type = list(object({
    name                       = string
    http_listener_name         = string
    backend_address_pool_name  = string
    backend_http_settings_name = string
    redirect_configuration_name = string
    is_path_based              = bool
    url_path_map_name          = string
  }))
}
variable "redirect_configurations" {
  description = "rule redirect configuration"
  type = list(map(any))
    default = []
}
#variable "is_public_ip_allocation_static" {
#  description = "Is the public IP address of the App Gateway static?"
#  default     = false
#}
variable "sku_name" {
  description = "Name of App Gateway SKU."
  default     = "Standard_Small"
}
variable "sku_tier" {
  description = "Tier of App Gateway SKU."
  default     = "Standard"
}
variable "probes" {
  description = "Health probes used to test backend health."
  default     = []
  type = list(object({
    name                                      = string
    path                                      = string
    is_https                                  = bool
    pick_host_name_from_backend_http_settings = bool
    host                                      = string
    interval                                  = number
    timeout                                   = number
    unhealthy_threshold                       = number
  }))
}
variable "url_path_maps" {
  description = "URL path maps associated to path-based rules."
  default     = []
  type = list(object({
    name                               = string
    default_backend_http_settings_name = string
    default_backend_address_pool_name  = string
    path_rules = list(object({
      name                       = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
      paths                      = list(string)
    }))
  }))
}

variable "custom_error_configurations" {
  description = "custom_error_configurations"
  type = list(object({
    status_code                  = string  # can take only the values HttpStatus403 or HttpStatus502
    custom_error_page_url        = string
  }))
  default = []
}


variable "path_certificate_data_on_vault" {
  description = "path to certificate data"
  type        = string
  default     = null
}

variable "pass_path_on_vault" {
  description = "password or  path to certificate password"
  type        = string
  default     = null
}

variable "vault_endpoint" {
  description = "vault endpoint"
  type        = string
  default     = null
}

variable "frontend_ip_configuration_name" {
description = "frontend ip name"
type        = string
default     = "frontend_ip_configuration_fip"
}

