terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.8.0"
    }
  }
}

provider "azuredevops" {
  # Configuration options
    #  org_service_url = var.org_url
    #  personal_access_token = var.pat
}

#creating project
resource "azuredevops_project" "terraform_ado_project" {
  name               = var.project_name
  visibility         = var.visibility
  version_control    = var.version_control
  work_item_template = var.work_item_template
  description        = var.description
}

#project feature
resource "azuredevops_project_features" "custom-features" {
  project_id = azuredevops_project.terraform_ado_project.id
  features = {
    "boards"       = "enabled",
    "repositories" = "enabled",
    "pipelines"    = "enabled",
    "testplans"    = "disabled"
    "artifacts"    = "enabled"
  }
}

#Grab Role (The Group Principal to assign permission)
data "azuredevops_group" "role-readers" {
  project_id = azuredevops_project.terraform_ado_project.id
  name       = "Readers"
}

#Enable Permission
resource "azuredevops_project_permissions" "readers-permission" {
  project_id = azuredevops_project.terraform_ado_project.id
  principal  = data.azuredevops_group.role-readers.id
  permissions = {
    DELETE              = "Deny"
    EDIT_BUILD_STATUS   = "NotSet"
    WORK_ITEM_MOVE      = "Allow"
    DELETE_TEST_RESULTS = "Deny"
  }
}