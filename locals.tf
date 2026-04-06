# ============================================================================
# KMS Crypto Key Module - Locals
# ============================================================================

locals {
  key_name = "${var.project_code}-${var.kms_crypto_key_config.base_name}-${var.kms_crypto_key_config.location}-${var.environment}"
}
