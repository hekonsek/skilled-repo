# Tests

The native Terraform tests use a mocked Helm provider and run without a
Kubernetes cluster:

```sh
terraform test
```

The Terratest suite performs a real installation into Minikube. Start
Minikube, select its context, and run:

```sh
minikube start
RUN_MINIKUBE_INTEGRATION_TEST=true go test -v -timeout 20m ./...
```

Run the Go command from this directory. The test applies the fixture under
`fixtures/minikube`, verifies the Helm release and Argo CD server resources,
and destroys the release during cleanup.
