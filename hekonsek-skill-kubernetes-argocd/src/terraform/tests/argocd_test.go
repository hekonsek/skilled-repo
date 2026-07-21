package tests

import (
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestArgoCDDeploysToMinikube(t *testing.T) {
	if os.Getenv("RUN_MINIKUBE_INTEGRATION_TEST") != "true" {
		t.Skip("set RUN_MINIKUBE_INTEGRATION_TEST=true to run the Minikube integration test")
	}

	kubeconfigPath := os.Getenv("KUBECONFIG")
	if kubeconfigPath == "" {
		homeDirectory, err := os.UserHomeDir()
		if err != nil {
			t.Fatalf("resolve home directory: %v", err)
		}
		kubeconfigPath = filepath.Join(homeDirectory, ".kube", "config")
	}

	ctx := t.Context()
	currentContext := strings.TrimSpace(shell.RunCommandContextAndGetStdOut(t, ctx, &shell.Command{
		Command: "kubectl",
		Args:    []string{"config", "current-context"},
		Env:     map[string]string{"KUBECONFIG": kubeconfigPath},
	}))
	if currentContext != "minikube" {
		t.Fatalf("expected kubectl context minikube, got %q", currentContext)
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "fixtures/minikube",
		Vars: map[string]any{
			"kubeconfig_path": kubeconfigPath,
			"kube_context":    currentContext,
		},
		EnvVars: map[string]string{"KUBECONFIG": kubeconfigPath},
		NoColor: true,
	})

	defer terraform.DestroyContext(t, context.Background(), terraformOptions)
	terraform.InitAndApplyContext(t, ctx, terraformOptions)

	assertTerraformOutput(t, ctx, terraformOptions, "release_name", "argocd-e2e")
	assertTerraformOutput(t, ctx, terraformOptions, "namespace", "argocd-e2e")
	assertTerraformOutput(t, ctx, terraformOptions, "status", "deployed")

	runKubectl(t, ctx, kubeconfigPath,
		"wait",
		"--namespace", "argocd-e2e",
		"--for=condition=Available",
		"deployment/argocd-e2e-server",
		"--timeout=5m",
	)

	serviceType := strings.TrimSpace(runKubectl(t, ctx, kubeconfigPath,
		"get",
		"--namespace", "argocd-e2e",
		"service/argocd-e2e-server",
		"--output=jsonpath={.spec.type}",
	))
	if serviceType != "ClusterIP" {
		t.Fatalf("expected Argo CD server service type ClusterIP, got %q", serviceType)
	}
}

func assertTerraformOutput(
	t *testing.T,
	ctx context.Context,
	terraformOptions *terraform.Options,
	name string,
	expected string,
) {
	t.Helper()
	actual := terraform.OutputContext(t, ctx, terraformOptions, name)
	if actual != expected {
		t.Fatalf("expected Terraform output %s to be %q, got %q", name, expected, actual)
	}
}

func runKubectl(t *testing.T, ctx context.Context, kubeconfigPath string, arguments ...string) string {
	t.Helper()
	return shell.RunCommandContextAndGetStdOut(t, ctx, &shell.Command{
		Command: "kubectl",
		Args:    arguments,
		Env:     map[string]string{"KUBECONFIG": kubeconfigPath},
	})
}
