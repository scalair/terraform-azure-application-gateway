# Changelog

## v2.3.0

- add support for managed identities.
- add support for SSL certificate in KeyVault.

## v2.2.2

- Fix output

## v2.2.1

- Add some outputs

## v2.2.0

- define 2 `azurerm_application_gateway`, but deploy only one regarding the `lifecycle_ignore_ssl` variable. Acts as a workaround of the unsupport of [dynamic terraform lifecycle](https://github.com/hashicorp/terraform/issues/24188)

## v2.1.0

- remove vault provider reference from the module.

## v2.0.3

- remove provider block configuration from the module  

## v2.0.2

## v2.0.1

## v2.0.0

## v1.0.0
