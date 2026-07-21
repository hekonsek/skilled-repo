# Deploy One Argo CD Instance per Platform Deployment

## Context

The platform is deployed independently for development, staging, and
production. Application workloads follow the same progression: development
workloads run on the development platform, staging workloads run on the staging
platform, and production workloads run on the production platform.

Argo CD is part of the platform and has privileged access to its destination
cluster. Its versions, configuration, authentication, authorization, sync
behavior, and bootstrap process need the same progressive validation as other
platform components. A single Argo CD control plane shared by all environments
would couple their availability and credentials and would make an Argo CD
change affect every environment at once.

## Decision

We will deploy one independent Argo CD instance as part of every platform
deployment. For example, the development, staging, and production platform
deployments will each contain their own Argo CD instance.

Each instance will reconcile only the applications and platform configuration
intended for its own environment. It will not hold credentials for, or manage,
the other platform deployments. Argo CD versions and configuration will be
promoted through development, staging, and production in the same way as other
platform changes. The platform bootstrap process will install or restore the
environment's Argo CD instance before Argo CD takes over reconciliation of the
remaining platform and application resources.

## Consequences

Positive consequences:

- Argo CD upgrades and configuration changes can be validated progressively
  before reaching production.
- Production credentials, permissions, reconciliation, and failures are
  isolated from non-production Argo CD instances.
- Each platform deployment remains independently operable and recoverable.
- Application delivery is aligned with the platform lifecycle: development
  applications use the development delivery plane, staging applications use
  staging, and production applications use production.
- The bootstrap and disaster-recovery process is exercised outside production.

Negative consequences:

- Every platform deployment incurs the compute, storage, monitoring, backup,
  upgrade, and operational cost of an Argo CD installation.
- Shared configuration must be promoted and kept consistent across multiple
  instances while preserving intentional environment-specific differences.
- Operators must observe and troubleshoot several control planes instead of
  one central instance.
- Cross-environment views and operations require aggregated observability or
  separate access to each instance.

## Alternatives Considered

Use one central Argo CD instance to manage all platform deployments. This would
reduce the number of installations and provide one operational interface, but
it would create a shared failure domain, concentrate credentials for all
clusters, and prevent validating an Argo CD upgrade before that upgraded
instance controls production.

Install Argo CD only in production and use another delivery mechanism for
development and staging. This would reduce non-production resource usage, but
it would leave the production GitOps configuration, upgrade path, and recovery
process insufficiently exercised.

Install a separate Argo CD instance for every application. This could provide
stronger application-team isolation, but it would multiply operational cost
and complexity beyond what is needed. The platform deployment is the ownership
and failure boundary for the Argo CD instance; application isolation is handled
within that instance through repositories, projects, permissions, and
environment-specific configuration.
