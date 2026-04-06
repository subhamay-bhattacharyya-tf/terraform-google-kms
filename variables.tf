# ============================================================================
# KMS Crypto Key Module - Variables
# ============================================================================

variable "environment" {
  description = "Deployment environment. One of: devl, test, prod."
  type        = string

  validation {
    condition     = contains(["devl", "test", "prod"], var.environment)
    error_message = "environment must be one of: devl, test, prod."
  }
}

variable "project_code" {
  description = "Short project identifier used in resource naming."
  type        = string

  validation {
    condition     = length(var.project_code) > 0
    error_message = "project_code must not be empty."
  }
}

variable "region" {
  description = "GCP region for the provider. Defaults to us-central1."
  type        = string
  default     = "us-central1"
}

variable "kms_crypto_key_config" {
  description = "Configuration object for the Google KMS Crypto Key."
  type = object({
    base_name                  = string
    key_ring_name              = string
    location                   = optional(string, "us-central1")
    purpose                    = optional(string, "ENCRYPT_DECRYPT")
    algorithm                  = optional(string, "GOOGLE_SYMMETRIC_ENCRYPTION")
    protection_level           = optional(string, "SOFTWARE")
    rotation_period            = optional(string, null)
    destroy_scheduled_duration = optional(string, null)
    labels                     = optional(map(string), {})
  })

  validation {
    condition     = length(var.kms_crypto_key_config.base_name) > 0 && length(var.kms_crypto_key_config.base_name) <= 30
    error_message = "base_name must be between 1 and 30 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.kms_crypto_key_config.base_name))
    error_message = "base_name may only contain lowercase letters, digits, and dashes."
  }

  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "ASYMMETRIC_SIGN", "ASYMMETRIC_DECRYPT", "MAC"], var.kms_crypto_key_config.purpose)
    error_message = "purpose must be one of: ENCRYPT_DECRYPT, ASYMMETRIC_SIGN, ASYMMETRIC_DECRYPT, MAC."
  }

  validation {
    condition     = contains(["SOFTWARE", "HSM", "EXTERNAL"], var.kms_crypto_key_config.protection_level)
    error_message = "protection_level must be one of: SOFTWARE, HSM, EXTERNAL."
  }

  validation {
    condition = (
      var.kms_crypto_key_config.rotation_period == null ||
      var.kms_crypto_key_config.purpose == "ENCRYPT_DECRYPT"
    )
    error_message = "rotation_period can only be set when purpose is ENCRYPT_DECRYPT."
  }
}
