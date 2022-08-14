variable "access" {
  type = object({
    username = string
    password = string
  })
  default = {
    username = "value"
    password = "value"
  }
}

variable "global" {
  type = object({
    workspaceID = string
    repository_slug = string
    repository_uuid = string
  })
  default = {
    workspaceID = "value"
    repository_slug = "value"
    repository_uuid = "value"
  }
}

variable "deploy_keys" {
  type = list(object({
    label = string
    key = string
  }))
  default = [{
    label = "value"
    key = "value"
  }]
}

variable "repositories_variables" {
  type = list(object({
    value = string
    secure = bool
    key = string
  }))
  default = [{
    value = "value"
    secure = false
    key = "value"
  }]
}

variable "production_variables" {
  type = list(object({
    value = string
    secure = bool
    key = string
  }))
  default = [{
    value = "value"
    secure = false
    key = "value"
  }]
}

variable "staging_variables" {
  type = list(object({
    value = string
    secure = bool
    key = string
  }))
  default = [{
    value = "value"
    secure = false
    key = "value"
  }]
}


variable "ssh_key" {
  type = object({
  public_key = string
  private_key = string
  })
  default = {
    public_key = "value"
    private_key = "value"
  }
}
