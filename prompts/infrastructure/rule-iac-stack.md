---
description: "Guidelines for implementing effective, maintainable, and secure infrastructure as code using modern tools and methodologies"
globs: "*.tf,*.yml,*.yaml,*.json,*.ts,*.py"
---

# Infrastructure as Code Stack Best Practices

## Tool Selection

- Choose appropriate IaC tools based on requirements (Terraform, Pulumi, CloudFormation, etc.)
- Implement proper tool versioning
- Design for appropriate tool integration
- Consider declarative vs. imperative approaches
- Implement proper provider and plugin management
- Document tool selection rationale
- Consider multi-tool approaches when appropriate
- Implement proper tool security
- Design for appropriate learning curve
- Consider ecosystem maturity and community support

## Code Organization

- Implement modular code structure
- Design for appropriate repository organization
- Consider monorepo vs. multi-repo strategies
- Implement proper code layering
- Design for appropriate code reuse
- Document code organization principles
- Consider proper naming conventions
- Implement proper documentation inline
- Design for appropriate abstraction levels
- Consider domain-based organization

## State Management

- Implement proper state storage
- Design for appropriate state locking
- Consider state backup strategies
- Implement proper state encryption
- Design for collaborative state management
- Document state management approach
- Consider appropriate state granularity
- Implement proper state import/export capabilities
- Design for appropriate state migration
- Consider state management security

## Security Implementation

- Implement proper secrets management
- Design for appropriate access controls
- Consider least privilege principles
- Implement security scan integration
- Design for appropriate compliance requirements
- Document security controls
- Consider security testing automation
- Implement proper key management
- Design for appropriate network security
- Consider security audit capabilities

## Testing Strategy

- Implement proper unit testing for infrastructure code
- Design for appropriate integration testing
- Consider policy-as-code testing
- Implement proper validation testing
- Design for appropriate security testing
- Document testing approach
- Consider test-driven infrastructure development
- Implement proper cost estimation testing
- Design for appropriate compliance testing
- Consider chaos engineering testing

## CI/CD Integration

- Implement proper CI/CD pipelines for infrastructure
- Design for appropriate environment promotion
- Consider automated validation
- Implement proper plan and apply separation
- Design for appropriate approval workflows
- Document CI/CD integration
- Consider automated drift detection
- Implement proper notification systems
- Design for appropriate rollback mechanisms
- Consider parallel execution for large infrastructures

## Environment Management

- Implement proper environment isolation
- Design for appropriate environment configuration
- Consider environment promotion workflows
- Implement proper environment consistency
- Design for appropriate environment cleanup
- Document environment management approach
- Consider ephemeral environments
- Implement proper environment dependencies
- Design for appropriate environment variables
- Consider cost management across environments

## Versioning and Change Management

- Implement proper version control integration
- Design for appropriate tagging and versioning
- Consider change documentation automation
- Implement proper change approval processes
- Design for appropriate change visualization
- Document versioning strategy
- Consider change impact analysis
- Implement proper release management
- Design for appropriate rollback strategies
- Consider automated changelog generation

## Module Management

- Implement proper module versioning
- Design for appropriate module interfaces
- Consider module testing strategies
- Implement proper module documentation
- Design for appropriate module composition
- Document module development standards
- Consider module discoverability
- Implement proper module dependency management
- Design for appropriate module granularity
- Consider private vs. public module repositories

## Documentation

- Implement proper code documentation
- Design for appropriate architecture diagrams
- Consider automated documentation generation
- Implement proper README files
- Design for appropriate variable documentation
- Document best practices and standards
- Consider documentation testing
- Implement proper change documentation
- Design for appropriate onboarding documentation
- Consider infrastructure visualization

## Cost Management

- Implement proper cost estimation
- Design for appropriate resource tagging
- Consider cost optimization reviews
- Implement proper resource constraints
- Design for appropriate scheduling of resources
- Document cost management approach
- Consider automated cost reporting
- Implement proper cost anomaly detection
- Design for appropriate budget controls
- Consider FinOps integration

## Compliance and Governance

- Implement proper policy as code
- Design for appropriate compliance frameworks
- Consider automated compliance checking
- Implement proper audit logging
- Design for appropriate approval workflows
- Document compliance requirements
- Consider regulatory requirements
- Implement proper drift detection
- Design for appropriate remediation workflows
- Consider compliance reporting

## Scaling and Performance

- Implement proper code organization for scale
- Design for appropriate resource grouping
- Consider parallelization strategies
- Implement proper code optimization
- Design for appropriate provider rate limiting
- Document scaling best practices
- Consider large-scale refactoring approaches
- Implement proper module composition for scale
- Design for appropriate execution strategies
- Consider performance testing for large infrastructures

## Multi-Cloud Strategy

- Implement proper abstraction for multi-cloud
- Design for appropriate provider-specific features
- Consider cloud-agnostic approaches where appropriate
- Implement proper multi-cloud testing
- Design for appropriate resource mapping
- Document multi-cloud strategy
- Consider cost optimization across clouds
- Implement proper cloud-specific optimizations
- Design for appropriate failover strategies
- Consider multi-cloud compliance requirements

## Collaboration and Workflow

- Implement proper code review processes
- Design for appropriate knowledge sharing
- Consider pair programming for complex changes
- Implement proper communication channels
- Design for appropriate feedback loops
- Document collaboration patterns
- Consider cross-team dependencies
- Implement proper onboarding processes
- Design for appropriate expertise development
- Consider collaborative troubleshooting processes