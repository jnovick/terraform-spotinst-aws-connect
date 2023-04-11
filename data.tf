data "aws_iam_account_alias" "current" {
  count       = var.name == null ? 1 : 0
}

data "external" "install_dependencies" {
  program = [ "sh", "${path.module}/scripts/install.sh", "${path.module}" ]
}

# Retrieve the Spot Account ID
data "external" "account" {
  depends_on = [data.external.install_dependencies, null_resource.account]
  program = [
    local.cmd,
    "get",
    "--filter=name=${local.name}",
    "--token=${var.spotinst_token}"
  ]
}

data "external" "external_id" {
  depends_on = [data.external.install_dependencies, null_resource.account]
  program = [
    local.cmd,
    "create-external-id",
    local.account_id,
    "--token=${var.spotinst_token}"
  ]
  query = {
    cloudProvider = local.cloudProvider
  }
}