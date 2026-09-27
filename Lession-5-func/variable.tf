variable "servers" {
  type = map(string)
}

variable "names" {
  default = [
    "docker",
    "kubernetes",
    "terraform"
  ]
}