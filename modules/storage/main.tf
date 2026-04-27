resource "azurerm_storage_account" "main" {
  name                = "st${replace(var.project_name, "-", "")}${var.environment}${var.student_suffix}${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled   = var.public_network_access_enabled
  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "blob" {
  name                = "pep-${var.project_name}-storage-blob-${var.environment}-${var.student_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-storage-blob"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-group-blob"
    private_dns_zone_ids = [var.private_dns_zone_blob_id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "file" {
  name                = "pep-${var.project_name}-storage-file-${var.environment}-${var.student_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-storage-file"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-group-file"
    private_dns_zone_ids = [var.private_dns_zone_file_id]
  }

  tags = var.tags
}

resource "azurerm_storage_container" "datasets" {
  name                  = "datasets"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "blob_owner" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.managed_identity_principal_id
  depends_on           = [azurerm_storage_account.main]
}

resource "azurerm_role_assignment" "queue_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = var.managed_identity_principal_id
  depends_on           = [azurerm_storage_account.main]
}

resource "azurerm_role_assignment" "table_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = var.managed_identity_principal_id
  depends_on           = [azurerm_storage_account.main]
}

resource "azurerm_role_assignment" "file_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage File Data Privileged Contributor"
  principal_id         = var.managed_identity_principal_id
  depends_on           = [azurerm_storage_account.main]
}
