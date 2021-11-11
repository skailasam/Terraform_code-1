resource "azurerm_resource_group" "stg-rg" {
  name     =  var.resource_group_name[1]
  location = "West Europe"
  
}

resource "azurerm_network_interface" "stg-test-nic" {
  #name                = "${var.resource_group_name[1]}-nic"
   name               = "stg-test-nic"
  location            = azurerm_resource_group.stg-rg.location
  resource_group_name = azurerm_resource_group.stg-rg.name
  
  ip_configuration {
    name                          = "stg-test-nic"
    subnet_id                     = azurerm_subnet.front_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.stg-test-pip.id
  }
}

resource "azurerm_public_ip" "stg-test-pip" {
  name                = "stg-test-pip"
  location            = azurerm_resource_group.stg-rg.location
  resource_group_name = azurerm_resource_group.stg-rg.name
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "name" {
   name                   = var.vm_name
   location               = azurerm_resource_group.stg-rg.location
   resource_group_name    = azurerm_resource_group.stg-rg.name
   network_interface_ids  = [azurerm_network_interface.stg-test-nic.id]
   vm_size                = "Standard_DS1_v2"


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }

}
