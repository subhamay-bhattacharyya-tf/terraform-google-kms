# Terraform Template Specification

Generate these files in the `/` directory:

**main.tf:** _(delegate to `tf-mod-main` skill)_

- Google KMS Crypto Key using the `google_kms_crypto_key` resource
- Follow the GCP provider reference and core authoring patterns from the `tf-mod-main` skill

**locals.tf:**

A map type variable must be created from the input variable and the KMS crypto key name must be in the following format:

```text
<project_code>-<base_name>-<location>-<environment>
```

**variables.tf:** _(delegate to `tf-mod-vars` skill)_

Use the `tf-mod-vars` skill to author this file. Apply the GCP provider reference and validation patterns. The variable schema is:

| Variable | Type | Required | Notes |
| --- | --- | --- | --- |
| `environment` | `string` | Yes | One of: `devl`, `test`, `prod` |
| `project_code` | `string` | Yes | Short identifier for naming standardization |
| `region` | `string` | No | Default: `us-central1` |
| `kms_crypto_key_config` | `object` | Yes | See attribute table below |

`kms_crypto_key_config` attributes:

| Attribute | Type | Required | Default | Validation |
| --- | --- | --- | --- | --- |
| `base_name` | `string` | Yes | — | Alphanumeric or dashes, max length ≤ 30 |
| `key_ring_name` | `string` | Yes | — | Name of the existing KMS key ring |
| `location` | `string` | No | `us-central1` | GCP location of the key ring |
| `purpose` | `string` | No | `ENCRYPT_DECRYPT` | One of: `ENCRYPT_DECRYPT`, `ASYMMETRIC_SIGN`, `ASYMMETRIC_DECRYPT`, `MAC` |
| `algorithm` | `string` | No | `GOOGLE_SYMMETRIC_ENCRYPTION` | Version template algorithm |
| `protection_level` | `string` | No | `SOFTWARE` | One of: `SOFTWARE`, `HSM`, `EXTERNAL` |
| `rotation_period` | `string` | No | `null` | e.g. `"7776000s"` (90 days); only valid for `ENCRYPT_DECRYPT` |
| `destroy_scheduled_duration` | `string` | No | `null` | e.g. `"86400s"` (1 day) |
| `labels` | `map(string)` | No | `{}` | GCP labels to attach to the key |

**outputs.tf:**

- Outputs for all standard Google KMS Crypto Key attributes:
  - `key_id`
  - `key_name`
  - `key_ring`
  - `key_purpose`
  - `primary_version`


**versions.tf:**

- Versions.tf should be in the following format

```hcl

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.23.0"
    }
  }
}

provider "google" {
  region = var.region
}
```

**examples/:** _(delegate to `tf-mod-examples` skill)_

Use the `tf-mod-examples` skill to scaffold the full example matrix. Each example must be a self-contained, independently validatable Terraform configuration under `examples/<name>/` with its own `main.tf`, `variables.tf`, `terraform.tfvars`, and `README.md`.

**test/:**

- `test/kms_crypto_key_basic_test.go`: This Terratest tests the basic KMS crypto key configuration.

**package.json:**

- `github/workflows/ci.yaml`: This is the CI Pipeline. Add all the tests in the terratest job.

Ensure the name is always the repository name.

**package-lock.json:**

Ensure the name is always the repository name.

**CONTRIBUTING.md:**

Ensure in the CONTRIBUTING.md, Reporting Issues must always links to the current repository.

**README.md:** _(delegate to `tf-mod-readme` skill)_

Use the `tf-mod-readme` skill to generate this file. The skill will:

- Auto-resolve the repository name from the current git root
- Check and create the gist badge file if missing
- Populate all badge URLs pointing to the current repository
- Produce terraform-docs-compatible inputs/outputs tables
- Follow markdownlint rules (MD060 table column style)
