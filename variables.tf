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
    affinity_cookie_name                = string
    path                                = string
    port                                = number
    is_https                            = bool
    request_timeout                     = number
    probe_name                          = string
    pick_host_name_from_backend_address = bool
    connection_draining_enabled         = bool
    drain_timeout                       = number
    authentication_certificates         = list(map(any))
    trusted_root_certificate_name       = list(string)
  }))
}
variable "ssl_certificates" {
  description = "List of ssl certificates"
  type = list(map(any))
  default = []
}

variable "http_listeners" {
description = "List of HTTP listeners."
type = list(map(any))
}

variable "authentication_certificates" {
  description = "Authentication certificates for the backend"
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "trusted_root_certificates" {
  description = "Trusted root certificates for the backend"
  type = list(object({
    name                       = string
    data                       = string
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
    priority          = number
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
    status_code                               = list(string)
  }))
}
variable "url_path_maps" {
  description = "URL path maps associated to path-based rules."
  default     = []
  type = list(object({
    name                               = string
    default_backend_http_settings_name = string
    default_backend_address_pool_name  = string
    default_redirect_configuration_name = string
path_rules = list(object({
      name                       = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
      redirect_configuration_name = string
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

variable "frontend_ip_configuration_name" {
  description = "frontend ip name"
  type        = string
  default     = "frontend_ip_configuration_fip"
}

variable "frontend_http_port_name" {
  description = "frontend http port name  name"
  type        = string
}

variable "frontend_https_port_name" {
  description = "frontend https port name  name"
  type        = string
}

variable "lifecycle_ignore_ssl" {
  type          = bool
  description   = "Whether to ignore future changes on SSL certificates (e.g: handled by an external component). Changing this forces a new resource to be created."
  default       = false
}

variable "identity_ids" {
  type            = list(string)
  description     = "(Optional) For TLS termination with Key Vault certificates, define a list of user-assigned managed identity, which Application Gateway uses to retrieve certificates from Key Vault."
  default         = []
}

