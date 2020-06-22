package test

import (
	"crypto/tls"
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestEc2Example(t *testing.T) {
	opts := &terraform.Options{
		TerraformDir: "../src",
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	// Get the URL of the instance
	instanceDNSName := terraform.OutputRequired(t, opts, "instance_public_dns")
	url := fmt.Sprintf("http://%s", instanceDNSName)

	// Test the instance is working
	expectedStatus := 200
	expectedBody := "Hello from tf var file"

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetry(t, url, &tls.Config{}, expectedStatus, expectedBody, maxRetries, timeBetweenRetries)

}
