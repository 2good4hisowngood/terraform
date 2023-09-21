resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_machine_learning_compute_instance" "example" {
  name                          = "example-${random_string.unique_name.result}"
  location                      = azurerm_resource_group.example.location
  machine_learning_workspace_id = azurerm_machine_learning_workspace.example.id
  virtual_machine_size          = "STANDARD_DS11_V2"
  subnet_resource_id = azurerm_subnet.example.id
}