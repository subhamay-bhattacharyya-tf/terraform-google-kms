module "kms_crypto_key" {
  source = "../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  kms_crypto_key_config = {
    base_name                  = var.base_name
    key_ring_name              = var.key_ring_name
    destroy_scheduled_duration = var.destroy_scheduled_duration
  }
}
