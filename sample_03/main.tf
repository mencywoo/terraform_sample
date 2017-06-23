variable "stackname" {
  default = "tf_sample_03_default"
}

output "stackout" {
  value = "${var.stackname}"
}
