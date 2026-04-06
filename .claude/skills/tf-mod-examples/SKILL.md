---
name: tf-mod-examples
description: >
  Generates Terraform module example configurations covering all meaningful
  combinations of input variables. Use this skill when the user asks to
  generate examples, scaffold example directories, create tfvars combinations,
  or produce a complete examples/ folder for a Terraform module. Trigger when
  the user says "generate all examples", "scaffold examples", "create example
  combinations", or "fill in the examples directory". Also trigger when the
  user shares a variables.tf and asks for example usage across all options.
---

# Terraform Module Examples — Generator Skill

This skill generates a complete `examples/` directory tree for a Terraform
module by reading `variables.tf` and producing one standalone example per
meaningful feature combination.

---

## How to Use This Skill

1. Read `variables.tf` (and `versions.tf` if present) from the current module root.
2. Identify every optional field and enumerate its allowed values from `validation` blocks or type annotations.
3. Derive the example matrix using the rules below.
4. Write each example as a self-contained directory under `examples/` with its own `main.tf`, `variables.tf`, `terraform.tfvars`, and `README.md`.

---

## Step 1 — Enumerate Axes

For each optional field in the root `kms_crypto_key_config` object (or equivalent), record:

| Axis | Values |
|---|---|
| `purpose` | `ENCRYPT_DECRYPT`, `ASYMMETRIC_SIGN`, `ASYMMETRIC_DECRYPT`, `MAC` |
| `algorithm` | `GOOGLE_SYMMETRIC_ENCRYPTION`, `RSA_SIGN_PSS_2048_SHA256`, `EC_SIGN_P256_SHA256`, `HMAC_SHA256` |
| `protection_level` | `SOFTWARE`, `HSM`, `EXTERNAL` |
| `rotation_period` | absent, `7776000s` (90 days), `31536000s` (365 days) |
| `destroy_scheduled_duration` | absent, `86400s` (1 day) |
| `labels` | absent, present |

---

## Step 2 — Example Matrix

Do **not** generate the full cartesian product. Instead produce these named
examples, each exercising a distinct capability or realistic deployment pattern:

| Directory | Purpose | Key axes exercised |
|---|---|---|
| `basic/` | Minimal — symmetric encryption key | `purpose=ENCRYPT_DECRYPT`, software protection, no rotation |
| `with-rotation/` | Auto-rotation every 90 days | `rotation_period=7776000s` |
| `with-annual-rotation/` | Annual rotation | `rotation_period=31536000s` |
| `asymmetric-sign/` | Asymmetric signing key (EC P-256) | `purpose=ASYMMETRIC_SIGN`, `algorithm=EC_SIGN_P256_SHA256` |
| `asymmetric-decrypt/` | Asymmetric encryption key (RSA) | `purpose=ASYMMETRIC_DECRYPT`, `algorithm=RSA_SIGN_PSS_2048_SHA256` |
| `mac-signing/` | HMAC signing key | `purpose=MAC`, `algorithm=HMAC_SHA256` |
| `hsm-protected/` | Hardware security module | `protection_level=HSM` |
| `with-labels/` | Resource labelling | `labels` map with env/team/cost-centre |
| `with-destroy-schedule/` | Custom destroy schedule | `destroy_scheduled_duration=86400s` |
| `complete/` | All features on | rotation, HSM, labels, custom destroy schedule |

---

## Step 3 — File Structure per Example

Each example directory must contain exactly these four files:

```
examples/<name>/
├── main.tf            # module call block only — no provider block
├── variables.tf       # re-declare only the variables consumed in main.tf
├── terraform.tfvars   # concrete values for every variable in variables.tf
└── README.md          # one-paragraph description + usage snippet
```

### `main.tf` template

```hcl
module "<name>" {
  source = "../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  kms_crypto_key_config = {
    base_name     = var.base_name
    key_ring_name = var.key_ring_name
    # ... only include fields relevant to this example
  }
}
```

### `variables.tf` template

```hcl
variable "environment"    { type = string }
variable "project_code"  { type = string }
variable "region"        { type = string  default = "us-central1" }
variable "base_name"     { type = string }
variable "key_ring_name" { type = string }
```

### `terraform.tfvars` template

```hcl
environment  = "devl"
project_code = "demo"
region       = "us-central1"
base_name    = "<example-slug>"
```

### `README.md` template

```markdown
# <Example Title>

One sentence describing what this example demonstrates.

## Usage

\`\`\`bash
terraform init -backend=false
terraform validate
\`\`\`
```

---

## Step 4 — Validation Rules

After writing all files:

1. Run `terraform fmt -recursive examples/` to format all generated files.
2. Run `terraform init -backend=false && terraform validate` inside each example directory and report any errors.
3. Fix any errors before returning.

---

## Step 5 — Output Summary

After all files are written and validated, print a table:

| Example | Files written | Validated |
|---|---|---|
| `basic/` | 4 | ✓ |
| ... | ... | ... |
