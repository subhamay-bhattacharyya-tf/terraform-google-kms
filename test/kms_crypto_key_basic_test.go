package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

const (
	testRegion      = "us-central1"
	testKeyRingName = "terratest-kms-key-ring"
)

// TestKMSCryptoKeyBasic tests creating a basic KMS crypto key.
func TestKMSCryptoKeyBasic(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	baseName := fmt.Sprintf("tt-kms-%s", unique)
	projectID := mustEnv(t, "GOOGLE_CLOUD_PROJECT")

	// Ensure the test key ring exists (key rings cannot be deleted in GCP,
	// so we create once and reuse across test runs).
	ensureKeyRingExists(t, projectID, testRegion, testKeyRingName)

	tfOptions := &terraform.Options{
		TerraformDir: "..",
		NoColor:      true,
		Vars: map[string]interface{}{
			"environment":  "devl",
			"project_code": "tt",
			"region":       testRegion,
			"kms_crypto_key_config": map[string]interface{}{
				"base_name":     baseName,
				"key_ring_name": testKeyRingName,
				"location":      testRegion,
			},
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	keyName := terraform.Output(t, tfOptions, "key_name")
	require.NotEmpty(t, keyName)
	require.Contains(t, keyName, baseName)

	keyPurpose := terraform.Output(t, tfOptions, "key_purpose")
	require.Equal(t, "ENCRYPT_DECRYPT", keyPurpose)

	keyRing := terraform.Output(t, tfOptions, "key_ring")
	require.NotEmpty(t, keyRing)

	client := newKMSClient(t)
	defer client.Close()

	keyID := terraform.Output(t, tfOptions, "key_id")
	cryptoKeyExists(t, client, keyID)
}
