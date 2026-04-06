# KMS Crypto Key with Custom Destroy Schedule

Creates a symmetric encryption key with a 1-day (`86400s`) scheduled destroy duration, giving a short recovery window before key material is permanently deleted.

## Usage

```bash
terraform init -backend=false
terraform validate
```
