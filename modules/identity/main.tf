data "azurerm_client_config" "current" {}

locals {
  github_repositories = distinct(compact(concat([var.github_repository], var.github_additional_repositories)))
}

resource "azurerm_user_assigned_identity" "main" {
  name                = "id-${var.project_name}-${var.environment}-${var.student_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "github_main" {
  for_each                  = var.create_github_oidc ? toset(local.github_repositories) : toset([])
  name                      = "github-${lower(replace(each.value, "/", "-"))}-main"
  user_assigned_identity_id = azurerm_user_assigned_identity.main.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = "repo:${var.github_organization}/${each.value}:ref:refs/heads/main"
}

resource "azurerm_role_assignment" "github_oidc_contributor" {
  count                = var.create_github_oidc ? 1 : 0
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}
