---
description: "Guidelines for implementing effective GitOps workflows and architecture for infrastructure and application deployment"
globs: "*.yaml,*.yml,*.tf,*.json"
---

# GitOps Stack Best Practices

## Core Principles

- Implement declarative infrastructure and application definitions
- Design for Git as the single source of truth
- Consider appropriate repository structure
- Implement proper separation of configuration and code
- Design for self-documenting infrastructure
- Document GitOps principles and workflows
- Consider immutable infrastructure patterns
- Implement proper rollback mechanisms
- Design for appropriate reconciliation patterns
- Consider continuous delivery vs. continuous deployment

## Repository Structure

- Design clear separation between application and infrastructure repositories
- Implement appropriate monorepo vs. multi-repo strategy
- Consider repository organization by environment or component
- Design for proper branch protection rules
- Implement appropriate tagging strategy
- Document repository organization and conventions
- Consider appropriate permission management
- Implement proper code ownership definitions
- Design for clear documentation within repositories
- Consider repository template usage

## Automation Implementation

- Choose appropriate GitOps tools (Flux, ArgoCD, etc.)
- Implement proper pull-based deployment mechanisms
- Design for appropriate reconciliation frequencies
- Consider drift detection and remediation
- Implement proper health checking
- Document automation architecture
- Consider appropriate pipeline integration
- Implement proper notification mechanisms
- Design for appropriate event-based triggers
- Consider automated rollback mechanisms

## Environment Management

- Implement proper environment promotion workflows
- Design for clear separation between environments
- Consider appropriate configuration management
- Implement proper secret management
- Design for scalable environment definitions
- Document environment architecture
- Consider multi-tenant environments
- Implement proper environment isolation
- Design for appropriate environment parity
- Consider environment-specific customizations

## Security

- Implement proper access controls for repositories
- Design for appropriate secret management
- Consider proper scanning of manifests and code
- Implement signed commits and verification
- Design for appropriate key rotation
- Document security controls and policies
- Consider vulnerability management in GitOps workflow
- Implement proper audit logging
- Design for appropriate network policies
- Consider compliance requirements in GitOps implementation

## Kubernetes Integration

- Implement proper Kubernetes resource definitions
- Design for appropriate custom resource usage
- Consider Helm chart integration
- Implement proper namespace organization
- Design for appropriate RBAC configuration
- Document Kubernetes integration patterns
- Consider appropriate use of operators
- Implement proper resource requests and limits
- Design for appropriate service meshes
- Consider appropriate cluster architecture

## Configuration Management

- Implement proper configuration templating
- Design for appropriate parameter substitution
- Consider configuration versioning
- Implement proper configuration validation
- Design for appropriate configuration hierarchy
- Document configuration management approach
- Consider appropriate seal secrets implementation
- Implement proper environment-specific configuration
- Design for configuration drift detection
- Consider configuration impact analysis

## Testing and Validation

- Implement proper manifest validation
- Design for appropriate pre-commit validation
- Consider integration testing for infrastructure
- Implement proper policy enforcement (OPA, Kyverno)
- Design for appropriate compliance validation
- Document testing approach and coverage
- Consider dry-run mechanisms before deployment
- Implement proper security scanning
- Design for appropriate linting rules
- Consider chaos engineering testing

## Monitoring and Observability

- Implement proper monitoring for GitOps components
- Design for appropriate alerting for reconciliation failures
- Consider observability for deployment processes
- Implement proper logging for GitOps operations
- Design for appropriate deployment metrics
- Document monitoring and observability approach
- Consider drift detection monitoring
- Implement proper health checking
- Design for appropriate dashboard creation
- Consider tracing for complex deployment flows

## Collaboration and Workflows

- Implement proper pull request workflows
- Design for appropriate code review processes
- Consider collaborative documentation
- Implement proper change management
- Design for appropriate approval workflows
- Document team collaboration approaches
- Consider appropriate deployment ownership
- Implement proper notification systems
- Design for appropriate knowledge sharing
- Consider ChatOps integration for GitOps workflows

## Disaster Recovery

- Implement proper backup of Git repositories
- Design for appropriate restoration procedures
- Consider disaster recovery testing
- Implement proper documentation of recovery procedures
- Design for appropriate point-in-time recovery
- Document disaster recovery approach
- Consider multi-region GitOps architecture
- Implement proper failover mechanisms
- Design for appropriate data protection
- Consider business continuity planning

## Scaling and Performance

- Implement proper GitOps controller scaling
- Design for appropriate repository scaling
- Consider performance optimization for large deployments
- Implement proper resource allocation
- Design for appropriate reconciliation performance
- Document performance considerations
- Consider sharding for large-scale GitOps
- Implement proper caching strategies
- Design for appropriate parallel processing
- Consider efficient diffing algorithms

## Progressive Delivery

- Implement proper canary deployment patterns
- Design for appropriate blue-green deployments
- Consider feature flag integration
- Implement proper rollout strategies
- Design for appropriate traffic shifting
- Document progressive delivery approach
- Consider automated promotion criteria
- Implement proper rollback triggers
- Design for appropriate testing in production
- Consider appropriate metric-based promotion

## Multi-Cluster Management

- Implement proper multi-cluster GitOps architecture
- Design for appropriate cluster segmentation
- Consider cluster-specific configuration
- Implement proper fleet management
- Design for appropriate multi-cluster secrets
- Document multi-cluster patterns
- Consider appropriate synchronization strategies
- Implement proper cluster bootstrapping
- Design for appropriate cluster upgrade strategies
- Consider appropriate cluster federation patterns

## Documentation and Standards

- Implement comprehensive repository documentation
- Design for self-documenting infrastructure code
- Consider automated documentation generation
- Implement proper standards enforcement
- Design for appropriate knowledge sharing
- Document best practices and patterns
- Consider appropriate runbooks creation
- Implement proper change documentation
- Design for appropriate architecture diagrams
- Consider appropriate onboarding documentation