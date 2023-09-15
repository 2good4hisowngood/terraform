resource "azurerm_user_assigned_identity" "example" {
  name                = "example-identity"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

data "azuread_service_principal" "test" {
  display_name = "Azure Cosmos DB"
}

resource "azurerm_key_vault_access_policy" "example-cosmosdb" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.test.object_id

  key_permissions = [
    "Get",
    "Recover",
    "UnwrapKey",
    "WrapKey",
  ]
  depends_on = [data.azuread_service_principal.test, data.azurerm_client_config.current]
}

resource "azurerm_role_assignment" "example-role1" {
  scope                = azurerm_key_vault.example.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}

resource "azurerm_role_assignment" "example-role2" {
  scope                = azurerm_storage_account.example.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}

resource "azurerm_role_assignment" "example-role3" {
  scope                = azurerm_storage_account.example.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}

resource "azurerm_role_assignment" "example-role4" {
  scope                = azurerm_application_insights.example.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}