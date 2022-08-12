variable "access" {
  type = object({
    region     = string
    access_key = string
    secret_key = string
    key_name   = string
  })
  default = {
    region     = "value"
    access_key = "value"
    secret_key = "value"
    key_name   = "value"
  }
}



variable "security_groups" {
  type = list(object({
    name        = string
    description = string
    rules = list(object({
      protocol = string
      port      = number
    }))
  }))
  default = [
    {
      name        = "value"
      description = "value"
      rules       = []
    }
  ]
}
