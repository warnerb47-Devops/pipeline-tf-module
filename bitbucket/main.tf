# terraform {
#   required_providers {
#     bitbucket = {
#       source  = "DrFaust92/bitbucket"
#       version = "2.17.0"
#     }
#   }
# }

terraform {
  required_providers {
    bitbucket = {
      source = "zahiar/bitbucket"
      version = "1.1.1"
    }
    bitbucket2 = {
      source  = "DrFaust92/bitbucket"
      version = "2.17.0"
    }
  }
}

# load config file
locals {
  input_file         = "./config.yml"
  input_file_content = fileexists(local.input_file) ? file(local.input_file) : "NoInputFileFound: true"
  input              = yamldecode(local.input_file_content)
}


# Configure the Bitbucket Provider
provider "bitbucket" {
  username = local.input.access.username
  password = local.input.access.password
}

# Configure the Bitbucket Provider
provider "bitbucket2" {
  username = local.input.access.username
  password = local.input.access.password
}

data "bitbucket_workspace" "workspace_selected" {
  provider = bitbucket
  id = local.input.workspace.workspaceID
}

# data "bitbucket_repository" "repositories_selected" {
#   provider = bitbucket
#   count = length(local.input.repositories)
#   workspace   = data.bitbucket_workspace.workspace_selected.uuid
#   name        = local.input.repositories[count.index].slug
# }

# # add deploy key
resource "bitbucket_deploy_key" "deploy_key" {
  provider= bitbucket
  count = length(local.input.deploy_keys)
  workspace  = data.bitbucket_workspace.workspace_selected.uuid
  repository = local.input.deploy_keys[count.index].repository_slug
  label      = local.input.deploy_keys[count.index].label
  key        = local.input.deploy_keys[count.index].key
}

# # add repository variable
# resource "bitbucket_pipeline_variable" "repository_variable" {
#   provider= bitbucket
#   workspace  = data.bitbucket_workspace.workspace_selected.uuid
#   repository = data.bitbucket_repository.repository_selected.name
#   key        = "some_variable_name"
#   value      = "some-variable-value"
#   secured    = false
# }

# # add deployment
# resource "bitbucket_deployment" "deployment" {
#   provider= bitbucket
#   workspace  = data.bitbucket_workspace.workspace_selected.uuid
#   repository = data.bitbucket_repository.repository_selected.name
#   name        = "Example environment"
#   environment = "Test"
# }
  

# # add deployment variable
# resource "bitbucket_deployment_variable" "deployment_variable" {
#   provider= bitbucket
#   workspace  = data.bitbucket_workspace.workspace_selected.uuid
#   repository = data.bitbucket_repository.repository_selected.name
#   deployment = bitbucket_deployment.deployment.id
#   key        = "someVariableName"
#   value      = "some-variable-value"
#   secured    = false
# }

# resource "bitbucket_pipeline_ssh_key" "ssh_key" {
#   provider = bitbucket2
#   workspace  = data.bitbucket_workspace.workspace_selected.uuid
#   repository = data.bitbucket_repository.repository_selected.name
#   public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3TYmESsR2bqxEbxU1V/gQWmGyMNNS9nX4qt4Oz+6sOohM4snRTHPdL7IoDADUIa0dlGHWltfwwnAOjaUcOUTjfzzza5xi7pp0Ed5Rqaf+zbdmY3bjWPe8KCNYhygy4GE2ligLrDelK8gYoe0ZNPHCLPvo4nHbQCn439rksODwZAxpsauwzP4Y8AGvZ4FfdiVooJs1DUypVDrmUvMOALWI2KNOI06MNcD/VoYgQi8SWnAXgFw4EdBM58rprwZdtagjys798JC46IVLb467taPwZcOwSQAxAf0/JmR3XSl4uLvw/7yf3lMn6S2m1lL92IWcmiqyzgujQbWNRbOjuyIJ"
#   private_key = "test-key"
# }

# resource "bitbucket_pipeline_ssh_known_host" "test" {
#   provider = bitbucket2
#   workspace  = data.bitbucket_workspace.workspace_selected.uuid
#   repository = data.bitbucket_repository.repository_selected.name
#   hostname   = "example.com:22"

#   public_key {
#     key_type = "Ed25519"  # Ed25519 ECDSA RSA DSA
#     key      = "AAAAC3NzaC1lZDI1NTE5AAAAIKqP3Cr632C2dNhhgKVcon4ldUSAeKiku2yP9O9/bDtY"
#   }
# }

# print result 
# output "workspace" {
#   value = data.bitbucket_repository.repositories_selected
# }