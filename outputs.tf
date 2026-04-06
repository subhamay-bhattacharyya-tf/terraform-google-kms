# ============================================================================
# KMS Crypto Key Module - Outputs
# ============================================================================

output "key_id" {
  description = "The globally unique identifier for the KMS crypto key."
  value       = google_kms_crypto_key.this.id
}

output "key_name" {
  description = "The name of the KMS crypto key."
  value       = google_kms_crypto_key.this.name
}

output "key_ring" {
  description = "The key ring that this crypto key belongs to."
  value       = google_kms_crypto_key.this.key_ring
}

output "key_purpose" {
  description = "The immutable purpose of the KMS crypto key."
  value       = google_kms_crypto_key.this.purpose
}

output "primary_version" {
  description = "The resource name of the primary version of the KMS crypto key."
  value       = try(google_kms_crypto_key.this.primary[0].name, null)
}
