terraform {
  cloud {
    organization = "NinjaTF"

    workspaces {
      name = "TF-azDevOps"
    }
  }
}