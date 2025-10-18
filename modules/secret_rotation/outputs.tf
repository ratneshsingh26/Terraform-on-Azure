output "rotated_password" {
  value     = random_password.rotated.result
  sensitive = true
}
