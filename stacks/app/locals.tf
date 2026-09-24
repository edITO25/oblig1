locals {
  base_name = lower(format("%s-%s-%s", var.project, var.environment, var.shortname))

  subnet_id = data.terraform_remote_state.nettverk.outputs.subnet_ids[var.vm_subnet_key]

  tags = { //må ha "=" her
    environment = var.environment
    project    = var.project
    shortname  = var.shortname
    stack      = "app"
    managedby  = "terraform"
  }
}

