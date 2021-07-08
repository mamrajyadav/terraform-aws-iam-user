output "arn" {
  value       = module.iam-user.*.arn
  description = "The ARN assigned by AWS for this user."
}

output "unique_id" {
  value       = module.iam-user.*.unique_id
  description = "The unique ID assigned by AWS for this user."
}

output "key_id" {
  value       = module.iam-user.*.key_id
  description = "The access key ID."
}

output "secret" {
  value       = module.iam-user.*.secret
  description = "The secret access key. Note that this will be written to the state file. Please supply a pgp_key instead, which will prevent the secret from being stored in plain text."
  sensitive   = true
}

output "password" {
  value       = module.iam-user.*.password
  description = "The encrypted password, base64 encoded. Only available if password was handled on Terraform resource creation, not import."
  sensitive   = true
}

output "tags" {
  value       = module.iam-user.tags
  description = "A mapping of tags to assign to the resource."
}
