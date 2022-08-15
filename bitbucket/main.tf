terraform {
  required_providers {
    bitbucket = {
      source  = "DrFaust92/bitbucket"
      version = "2.17.0"
    }
    bitbucketpatch = {
      source = "zahiar/bitbucket"
      version = "1.1.1"
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
provider "bitbucketpatch" {
  username = local.input.access.username
  password = local.input.access.password
}


# create deploy keys
resource "bitbucket_deploy_key" "deploy_key" {
  # provider= bitbucket2
  provider= bitbucket
  count = length(local.input.deploy_keys)
  workspace  = local.input.global.workspaceID
  repository = local.input.global.repository_uuid
  label      = local.input.deploy_keys[count.index].label
  key        = local.input.deploy_keys[count.index].key
}

# add repositories variables
resource "bitbucket_pipeline_variable" "repositories_variables" {
  # provider= bitbucket2
  provider= bitbucketpatch
  count = length(local.input.repositories_variables)
  repository = local.input.global.repository_slug
  workspace  = local.input.global.workspaceID
  key        = local.input.repositories_variables[count.index].key
  value      = local.input.repositories_variables[count.index].value
  secured    = local.input.repositories_variables[count.index].secured
}

# add production deployment
resource "bitbucket_deployment" "production_deployment" {
  # provider= bitbucket2
  provider= bitbucketpatch
  repository = local.input.global.repository_slug
  workspace   = local.input.global.workspaceID
  name        = "Production Environment"
  environment = "Production" # must be either 'Test', 'Staging' or 'Production'
}


# add production deployment variable
resource "bitbucket_deployment_variable" "production_variables" {
  # provider= bitbucket2
  provider= bitbucketpatch
  count = length(local.input.production_variables)
  workspace   = local.input.global.workspaceID
  repository = local.input.global.repository_slug
  deployment = bitbucket_deployment.production_deployment.id
  key        = local.input.production_variables[count.index].key
  value      = local.input.production_variables[count.index].value
  secured    = local.input.production_variables[count.index].secured
}

# add staging deployment
resource "bitbucket_deployment" "staging_deployment" {
  provider= bitbucketpatch
  repository = local.input.global.repository_slug
  workspace   = local.input.global.workspaceID
  name        = "Staging Environment"
  environment = "Staging" # must be either 'Test', 'Staging' or 'Production'
}


# add staging deployment variable
resource "bitbucket_deployment_variable" "staging_variables" {
  # provider= bitbucket2
  provider= bitbucketpatch
  count = length(local.input.staging_variables)
  workspace   = local.input.global.workspaceID
  repository = local.input.global.repository_slug
  deployment = bitbucket_deployment.staging_deployment.id
  key        = local.input.staging_variables[count.index].key
  value      = local.input.staging_variables[count.index].value
  secured    = local.input.staging_variables[count.index].secured
}

# add ssh key
resource "bitbucket_pipeline_ssh_key" "ssh_key" {
  provider = bitbucket
  count = length(local.input.ssh_key)
  workspace   = local.input.global.workspaceID
  repository = local.input.global.repository_slug
  public_key  = local.input.ssh_key[count.index].public_key
  private_key = local.input.ssh_key[count.index].private_key
}

# add known host
resource "bitbucket_pipeline_ssh_known_host" "known_hosts" {
  count = length(local.input.known_hosts)
  provider = bitbucket
  workspace   = local.input.global.workspaceID
  repository = local.input.global.repository_slug
  hostname   = local.input.known_hosts[count.index].hostname

  public_key {
    key_type = local.input.known_hosts[count.index].key_type  # Ed25519 ECDSA RSA DSA
    key      = local.input.known_hosts[count.index].key
  }
}

# print result 
# output "workspace" {
#   value = length(values(local.input.production_deployments["api"]))
# }