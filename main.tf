# since these variables are re-used - a locals block makes this more maintainable
provider "azurerm" {
  features {}
}
locals {
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
}
resource "azurerm_application_gateway" "application-gw" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet_id
  }
  frontend_port {
    name = var.frontend_http_port_name
    port = 80
  }
  frontend_port {
    name = var.frontend_https_port_name
    port = 443
  }
  frontend_ip_configuration {
    name = local.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_address_id
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value.name
      ip_addresses = backend_address_pool.value.ip_addresses
      #fqdns        = backend_address_pool.value.fqdns
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.has_cookie_based_affinity ? "Enabled" : "Disabled"
      path                                = backend_http_settings.value.path
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.is_https ? "Https" : "Http"
      request_timeout                     = backend_http_settings.value.request_timeout
      probe_name                          = backend_http_settings.value.probe_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
      connection_draining        {
        enabled = backend_http_settings.value.connection_draining_enabled
        drain_timeout_sec = backend_http_settings.value.connection_draining_enabled ? backend_http_settings.value.drain_timeout : 60
      }
      trusted_root_certificate_names = backend_http_settings.value.trusted_root_certificate_name
      dynamic authentication_certificate {
         for_each = backend_http_settings.value.authentication_certificates
         content {
            name = authentication_certificate.value.name
         }

      }
    }
  }

  dynamic "authentication_certificate" {
    for_each = var.authentication_certificates
    content {
      name                                      = authentication_certificate.value.name
      data                                      = authentication_certificate.value.use_vault ? data.vault_generic_secret.identity.data[authentication_certificate.value.name] : filebase64(authentication_certificate.value.path_to_certificate_data)
    }
  }
  
    dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificates
    content {
      name                                      = trusted_root_certificate.value.name
      data                                      = trusted_root_certificate.value.use_vault ? data.vault_generic_secret.identity.data[trusted_root_certificate.value.name] : filebase64(trusted_root_certificate.value.path_to_root_certificate_data)
    }
  }

  dynamic "probe" {
    for_each = var.probes
    content {
      interval                                  = probe.value.interval
      name                                      = probe.value.name
      path                                      = probe.value.path
      protocol                                  = probe.value.is_https ? "Https" : "Http"
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      host                                      = probe.value.host
      match {
        status_code =  probe.value.status_code
      }
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name                                      = ssl_certificate.value.name
      data                                      = ssl_certificate.value.use_vault ? data.vault_generic_secret.identity.data[ssl_certificate.value.name] : filebase64(ssl_certificate.value.path_to_certificate_data)
      password                                  = ssl_certificate.value.use_vault ? data.vault_generic_secret.passwords.data[ssl_certificate.value.name] : ssl_certificate.value.password
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.is_https ? var.frontend_https_port_name : var.frontend_http_port_name
      protocol                       = http_listener.value.is_https ? "Https" : "Http"
      ssl_certificate_name           = http_listener.value.is_https ? http_listener.value.ssl_certificate_name : null
      host_name                      = http_listener.value.host_name
      require_sni                    = http_listener.value.require_sni
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.is_path_based ? "PathBasedRouting" : "Basic"
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      url_path_map_name          = request_routing_rule.value.url_path_map_name
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configurations
    content {
      name                       = redirect_configuration.value.name
      redirect_type              = redirect_configuration.value.redirect_type
      target_listener_name       = redirect_configuration.value.target_listener_name
      include_path               = redirect_configuration.value.include_path
      include_query_string       = redirect_configuration.value.include_query_string
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_maps
    content {
      name                               = url_path_map.value.name
      default_backend_http_settings_name = url_path_map.value.default_backend_http_settings_name
      default_backend_address_pool_name  = url_path_map.value.default_backend_address_pool_name

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rules
        content {
          name                       = path_rule.value.name
          backend_address_pool_name  = path_rule.value.backend_address_pool_name
          backend_http_settings_name = path_rule.value.backend_http_settings_name
          paths                      = path_rule.value.paths
        }
      }
    }
  }

  dynamic "custom_error_configuration" {
    for_each = var.custom_error_configurations
    content {
      status_code                    = custom_error_configuration.value.status_code
      custom_error_page_url          = custom_error_configuration.value.custom_error_page_url
    }
  }
}
