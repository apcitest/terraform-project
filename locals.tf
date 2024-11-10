locals {
  project_tags = {
    contact      = "devops@apci.com"
    application  = "Jupiter"
    project      = "APCI"
    environment  = "${terraform.workspace}" # refers to your current workspace (dev, prod, etc)
    creationTime = timestamp()
  }
}