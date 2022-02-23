variable "project" {
  type    = string
  default = "konvoy-gcp-se"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "worker_count" {
  type    = number
  default = 4
}

variable "controlplane_count" {
  type    = number
  default = 3
}

variable "service_account" {
  type    = string
  default = "dswhitehouse@konvoy-gcp-se.iam.gserviceaccount.com"
}
variable "private_key" {
  type    = string
  default = "../keys/pega"
}

variable "ssh_username" {
  type    = string
  default = "dswhitehouse"
}

variable "cluster_name" {
  type    = string
  default = "pega-cluster"
}

variable "public_key" {
  type    = string
  default = "dswhitehouse:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDV5Qx5+2IDK1UvSqj4MOGLFQPABrWNQeWGHHtblO4bfb0SBRTJ4aBSxTGTBZzVUK14nvgPT2M/oogZdEytxhLTRSMKX0LraMww0BnRM1/rDtvfzk9qCRy7CH6H2r2N9Yh0jrvp18ZwwkvBvhl3i3P8cIDd1/y5VLq//4TWnHLf/PE/tDFOqESUYoYJglynKHZaQkPIj2Sh/0XIdRRWTrbSVt9wKAs2J9oNB57c4l8Ri2syZp1mZP7s4JQLqDSiYs4ghk9YrGqMW1Ps1KmNApWjkjfIPEPPkA3WwYg/x5hmSo+hwDMP2/8/IL8L2asLF8GP9zMQoVAga+k5tJ+umzxDkfGfwa16UphG0AbY+76zKy5O1BYGrYWE3pzmrZSSe+ukeilWowyjrdR4m/aAwI+5uubiw4b/zZ5Sbgx2P0SX9AektGWIkRSg0RPBcwUOCrrkpbn7Lo1+NKc5jzwP5Yzohs5b2PpaIDZ2vBP+i9ZFZzV4B+B6SPeKlHBns3tGQyc= dswhitehouse@DW-WIN-DESKTOP"
}

variable "owner" {
  type    = string
  default = "davewhitehouse"
}