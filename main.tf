resource "azurerm_linux_virtual_machine" "demo-vm" {
  size                            = "Standard_DS1_v2"
  resource_group_name             = azurerm_resource_group.demo-rg-1.name
  name                            = "demo-vm-001"
  location                        = "Korea Central"
  disable_password_authentication = true
  computer_name                   = "demovm"
  admin_username                  = "azureuser"

  admin_ssh_key {
    username = "azureuser"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.demo-storageaccount.primary_blob_endpoint
  }

  network_interface_ids = [
    azurerm_network_interface.demo-nic.id,
  ]

  os_disk {
    storage_account_type = "Premium_LRS"
    name                 = "demo-os-disk"
    caching              = "ReadWrite"
  }

  source_image_reference {
    version   = "latest"
    sku       = "18.04-LTS"
    publisher = "Canonical"
    offer     = "UbuntuServer"
  }

  tags = {
    env      = "Development"
    archUUID = "f080b5cd-0588-4c28-8733-4a1a5db959ac"
  }
}

resource "azurerm_virtual_network" "demo-vnet" {
  resource_group_name = azurerm_resource_group.demo-rg-1.name
  name                = "demo-vnet"
  location            = "Korea Central"

  address_space = [
    "10.1.0.0/16",
  ]

  tags = {
    env      = "Development"
    archUUID = "f080b5cd-0588-4c28-8733-4a1a5db959ac"
  }
}

resource "azurerm_network_interface_security_group_association" "demo-nsg-association" {
  network_security_group_id = azurerm_network_security_group.demo-nsg.id
  network_interface_id      = azurerm_network_interface.demo-nic.id
}

resource "azurerm_resource_group" "demo-rg-1" {
  name     = "demo-rg-1"
  location = "Korea Central"

  tags = {
    env      = "Development"
    archUUID = "f080b5cd-0588-4c28-8733-4a1a5db959ac"
  }
}

resource "azurerm_public_ip" "demo-publicip" {
  resource_group_name = azurerm_resource_group.demo-rg-1.name
  name                = "demo-publicip"
  location            = "Korea Central"
  allocation_method   = "Dynamic"

  tags = {
    env      = "Development"
    archUUID = "f080b5cd-0588-4c28-8733-4a1a5db959ac"
  }
}

resource "azurerm_subnet" "default-subnet" {
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  resource_group_name  = azurerm_resource_group.demo-rg-1.name
  name                 = "default"

  address_prefixes = [
    "10.1.0.0/24",
  ]
}

resource "azurerm_network_interface" "demo-nic" {
  resource_group_name = azurerm_resource_group.demo-rg-1.name
  name                = "demo-nic"
  location            = "Korea Central"

  ip_configuration {
    subnet_id                     = azurerm_subnet.default-subnet.id
    public_ip_address_id          = azurerm_public_ip.demo-publicip.id
    private_ip_address_allocation = "Dynamic"
    name                          = "demo-nic-configuration"
  }

  tags = {
    env      = "Development"
    archUUID = "f080b5cd-0588-4c28-8733-4a1a5db959ac"
  }
}

resource "azurerm_network_security_group" "demo-nsg" {
  resource_group_name = azurerm_resource_group.demo-rg-1.name
  name                = "demo-nsg"
  location            = "Korea Central"

  security_rule {
    source_port_range          = "*"
    source_address_prefix      = "*"
    protocol                   = "Tcp"
    priority                   = 1001
    name                       = "AllowSSH"
    direction                  = "Inbound"
    destination_port_range     = "22"
    destination_address_prefix = "*"
    description                = "A Rule that allows SSH from the public internet"
    access                     = "Allow"
  }

  tags = {
    env      = "Development"
    archUUID = "f080b5cd-0588-4c28-8733-4a1a5db959ac"
  }
}

resource "azurerm_storage_account" "demo-storageaccount" {
  resource_group_name      = azurerm_resource_group.demo-rg-1.name
  name                     = "demostroageaccountbb"
  location                 = "Korea Central"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    env      = "Development"
    archUUID = "f080b5cd-0588-4c28-8733-4a1a5db959ac"
  }
}

