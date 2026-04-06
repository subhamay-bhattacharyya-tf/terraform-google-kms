// File: test/helpers_test.go
package test

import (
	"context"
	"os"
	"strings"
	"testing"

	kms "cloud.google.com/go/kms/apiv1"
	kmspb "cloud.google.com/go/kms/apiv1/kmspb"
	"github.com/stretchr/testify/require"
)

// mustEnv retrieves a required environment variable, failing the test if absent.
func mustEnv(t *testing.T, key string) string {
	t.Helper()
	v := strings.TrimSpace(os.Getenv(key))
	require.NotEmpty(t, v, "Missing required environment variable %s", key)
	return v
}

// newKMSClient creates an authenticated Cloud KMS client.
func newKMSClient(t *testing.T) *kms.KeyManagementClient {
	t.Helper()
	ctx := context.Background()
	client, err := kms.NewKeyManagementClient(ctx)
	require.NoError(t, err, "Failed to create KMS client")
	return client
}

// cryptoKeyExists verifies the crypto key with the given resource name exists.
func cryptoKeyExists(t *testing.T, client *kms.KeyManagementClient, keyID string) {
	t.Helper()
	ctx := context.Background()
	_, err := client.GetCryptoKey(ctx, &kmspb.GetCryptoKeyRequest{Name: keyID})
	require.NoError(t, err, "Expected KMS crypto key %s to exist: %v", keyID, err)
}
