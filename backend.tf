# Backend remoto - REEMPLAZÁ los valores de abajo por tu propio storage
# account de tfstate (Terraform no permite variables acá, el backend se
# resuelve antes de que cualquier variable exista). Si todavia no tenés uno,
# armalo con un proyecto de bootstrap separado (RG + storage account +
# container dedicados, aplicado una sola vez, a mano, fuera de este repo -
# mismo problema de huevo-gallina que cualquier backend remoto de
# Terraform). use_azuread_auth = true es opcional pero recomendado: evita
# depender de storage account keys, el acceso queda 100% via RBAC (Storage
# Blob Data Contributor + Reader sobre la cuenta).
terraform {
  backend "azurerm" {
    resource_group_name  = "REPLACE_WITH_YOUR_TFSTATE_RESOURCE_GROUP"
    storage_account_name = "REPLACE_WITH_YOUR_TFSTATE_STORAGE_ACCOUNT"
    container_name       = "tfstate"
    key                  = "aks-cluster/terraform.tfstate"
    use_azuread_auth     = true
  }
}
