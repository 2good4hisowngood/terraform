data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "rg-${random_string.unique_name.result}"
  location = var.location
}

resource "azurerm_application_insights" "example" {
  name                = "workspace-example-ai"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

resource "azurerm_key_vault" "example" {
  name                     = "kv-${random_string.unique_name.result}"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "premium"
  purge_protection_enabled = true
}

resource "azurerm_storage_account" "example" {
  name                     = "storage${random_string.unique_name.result}"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_machine_learning_workspace" "example" {
  name                    = "azml-${random_string.unique_name.result}"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id

  high_business_impact = true

  primary_user_assigned_identity = azurerm_user_assigned_identity.example.id
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.example.id,
    ]
  }

  encryption {
    user_assigned_identity_id = azurerm_user_assigned_identity.example.id
    key_vault_id              = azurerm_key_vault.example.id
    key_id                    = azurerm_key_vault_key.example.id
  }

  depends_on = [
    azurerm_role_assignment.example-role1, azurerm_role_assignment.example-role2, azurerm_role_assignment.example-role3,
    azurerm_role_assignment.example-role4,
    azurerm_key_vault_access_policy.example-cosmosdb,
  ]
}

resource "azurerm_key_vault_access_policy" "example-identity" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.example.principal_id

  // default set by service
  key_permissions = [
    "WrapKey",
    "UnwrapKey",
    "Get",
    "Recover",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore"
  ]
}

resource "azurerm_key_vault_access_policy" "example-sp" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
    "Create",
    "Recover",
    "Delete",
    "Purge",
    "GetRotationPolicy",
  ]
}

resource "azurerm_key_vault_key" "example" {
  name         = "example-keyvaultkey"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  depends_on = [azurerm_key_vault.example, azurerm_key_vault_access_policy.example-sp]
}



