# ============================================================================
# KMS Crypto Key Module - Main
# Creates and manages a Google Cloud KMS Crypto Key.
# ============================================================================

data "google_kms_key_ring" "this" {
  name     = var.kms_crypto_key_config.key_ring_name
  location = var.kms_crypto_key_config.location
}

resource "google_kms_crypto_key" "this" {
  name            = local.key_name
  key_ring        = data.google_kms_key_ring.this.id
  purpose         = var.kms_crypto_key_config.purpose
  rotation_period = var.kms_crypto_key_config.rotation_period
  labels          = var.kms_crypto_key_config.labels

  destroy_scheduled_duration = var.kms_crypto_key_config.destroy_scheduled_duration

  version_template {
    algorithm        = var.kms_crypto_key_config.algorithm
    protection_level = var.kms_crypto_key_config.protection_level
  }

  lifecycle {
    prevent_destroy = false
  }
}
