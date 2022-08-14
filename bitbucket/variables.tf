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

variable "workspace" {
  type = object({
    workspaceID = string
  })
  default = {
    workspaceID = "value"
  }
}

variable "repositories" {
  type = list(object({
    slug = string
  }))
  default = [
    {
      slug = "value"
    }
  ]
}

variable "deploy_keys" {
  type = list(object({
    repository_slug = string
      label = string
      key = string
  }))
  default = [
    {
      repository_slug = "value"
      label = "value"
      key = "value"
    }
  ]
}