# terrafrom-azure-application-gateway

## Usage Example

```hcl
---

inputs = {
  frontend_ip_configuration_name = "frontend_ip_configuration_fip"

  public_ip_address_id = ""
  subnet_id     = ""
  sku_name      = "Standard_v2"
  sku_tier      = "Standard_v2"
  #is_public_ip_allocation_static = true
  resource_group_name       = "applicationgw"
  resource_group_location   = "France Central"
  name                      = "appgw"

  probes                    = [
    {   
        name                    = "probe1",
        path                    = "/",
        is_https                = false
        pick_host_name_from_backend_http_settings = false  # use this parameter if "host" is not used.
        host                    = "test1234.com"  # can't be set if "pick_host_name_from_backend_http_settings" is true
        interval                = 30
        timeout                 = 30
        unhealthy_threshold     = 3
    }
  ]


  backend_http_settings     = [
    {   name = "backend_http_settings",
        has_cookie_based_affinity = false,
        path                      = "/",
        port                      = 80,
        is_https                  = false,
        request_timeout           = 30,
        probe_name                = "probe1",
        pick_host_name_from_backend_address = true
        connection_draining_enabled = true
        drain_timeout 
    }
  ]
  backend_address_pools     = [
    {
        name                    = "backend_pool1",
        ip_addresses            = ["10.17.14.0"],
        fqdns                   = ["fqdns1"]
    }
  ]

  #authentication_certificates = [
  #  {
  #    name                = "XCL1MPRWEBP1",
  #    use_vault           = false  # if true "path_to_certificate_data" is not used. "path_vault_certificate_data" is used
  #    path_to_certificate_data = "/Users/yehia/Desktop/test/certificates/web2/localhost.crt"
  #  }
  #]

  ssl_certificates            = [
    {
        name                = "clochedor",
        use_vault = false
        path_to_certificate_data = "/Users/yehia/Desktop/test/certificates/certificate.pfx"
        password            = "cl0ched0R"
    }
  ]
  http_listeners            = [
    {
         name                   = "http1",
         is_https               = false
         host_name              = "www.testscalair.com"
    },
    {
      name                   = "https2",
      is_https               = true,
      ssl_certificate_name   = "clochedor"
      host_name              = "www.scalair234.com"
    }
  ]

  request_routing_rules     = [
    {
        name                     = "rule1",
        http_listener_name        = "http1",
        #backend_address_pool_name = "backend_pool1",
        #backend_http_settings_name = "backend_http_settings",
        backend_address_pool_name  = null  # use backend_address_pool_name or redirect_configuration_name
        backend_http_settings_name = null,
        redirect_configuration_name = "rule_redirection_1",
        is_path_based              = false,
        url_path_map_name          = null
    },
    {
      name                     = "rule2",
      http_listener_name        = "https2",
      backend_address_pool_name = "backend_pool1",
      backend_http_settings_name = "backend_http_settings",
      redirect_configuration_name = null,
      is_path_based              = false
      url_path_map_name          = null
    }
  ]

  redirect_configurations        = [
    {
        name                       = "rule_redirection_1"
        redirect_type              = "Permanent" # possible values Permanent, Temporary, Found
        target_listener_name       = "https2"
        include_path               = false
        include_query_string       = false

    }

  ]

  #custom_error_configurations    = [
  #  {
  #    status_code                = "HttpStatus403", # can take only the values HttpStatus403 or HttpStatus502
  #    custom_error_page_url      = "https://azure_blob/servererror.html"
  #  }
  #]

}
```
