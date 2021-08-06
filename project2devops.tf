provider "azurerm" {

subscription_id = "300f0cbb-9a29-423e-afb3-66eb7941fb0b"
client_id       = "1d004ebb-2482-440d-82a0-e22b3dfe8025"
client_secret   = "XsQJ9N-paM38HIYfC_6LZvB_Lp4I_ik1l-"
tenant_id       = "360286fd-ae5d-4a12-9aee-0790e0d53ca9"

    features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "project2-rg"
  location = "West Europe"
}


resource "azurerm_container_registry" "acr" {
  name                     = "acrsj123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = false
  
}


resource "azurerm_mysql_server" "MySql" {
  name                = "sqlserversj123"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = "vmadmin"
  administrator_login_password = "Sambhavjain123"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "8.0"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

#
# - Create a Random integer to append to Storage account name
#

resource "random_integer" "sa_name" {
   min     = 1111
   max     = 9999  
  # Result will be like this - 1325
}

#
# - Create a Storage account with Network Rules
#


resource "azurerm_storage_account" "sa" {
  name                     = "sambhavsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_blob_public_access = "true"

  
}



