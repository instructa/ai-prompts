---
description: "Guidelines for efficient, maintainable, and secure Infrastructure as Code with Terraform"
globs: "*.{tf,tfvars,tfstate}"
---

# Terraform Best Practices

## Code Organization

- Structure repositories with modules, environments, and configurations
- Use a consistent directory structure across projects
- Separate environments with different state files
- Organize resources by logical components or services
- Use modules for reusable components
- Keep modules focused on specific functionality
- Place shared modules in a separate repository
- Group related resources together
- Use consistent naming conventions
- Document your code structure

## Module Design

- Create small, reusable, and focused modules
- Design modules with clear interfaces using variables and outputs
- Use semantic versioning for modules
- Document module inputs, outputs, and usage
- Provide sensible defaults for variables
- Validate inputs with variable validation blocks
- Design modules to be idempotent
- Follow the principle of least privilege for module permissions
- Test modules thoroughly
- Publish reusable modules to a module registry

## State Management

- Store state files remotely (S3, Azure Storage, GCS, etc.)
- Enable state locking to prevent concurrent modifications
- Enable state file encryption
- Restrict access to state backends
- Use separate state files for different environments
- Use workspaces for environment variations with similar configs
- Implement state file backup procedures
- Be careful with sensitive data in state files
- Use `terraform_remote_state` data sources for cross-state references
- Document your state management approach

## Variables and Outputs

- Use descriptive variable and output names
- Set appropriate variable types and constraints
- Group related variables together
- Document all variables with descriptions
- Use variable validation to enforce rules
- Provide default values when appropriate
- Make all assumptions explicit in variable descriptions
- Output useful resource attributes
- Use locals for computing values
- Set sensitive = true for sensitive variables and outputs

## Resource Configuration

- Use resource for managed resources and data for read-only
- Implement Terraform lifecycle blocks appropriately
- Use meta-arguments (count, for_each) for resource iteration
- Use the depends_on attribute for explicit dependencies
- Use the provider attribute for multi-provider configurations
- Tag all resources with common tags (environment, owner, etc.)
- Use provisioners only when absolutely necessary
- Implement proper error handling for provisioners
- Configure timeouts for slow-creating resources
- Use dynamic blocks for repeated nested blocks

## Provider Configuration

- Pin provider versions using version constraints
- Configure providers in a separate file
- Use provider aliases for multiple provider configurations
- Use provider configurations consistently
- Define provider requirements in modules
- Document provider requirements
- Test against the minimum required provider version
- Consider regional constraints in provider configurations
- Use the minimum required provider permissions
- Implement proper error handling for provider failures

## Security

- Never commit secrets to version control
- Use variable files or environment variables for secrets
- Implement a secrets management solution (HashiCorp Vault, AWS Secrets Manager, etc.)
- Apply the principle of least privilege for IAM roles
- Enable encryption for data at rest
- Implement network security best practices
- Audit security configurations regularly
- Use security groups and ACLs effectively
- Plan for key rotation
- Use sensitive = true for sensitive outputs

## Version Control

- Use a git-based workflow
- Commit .tfvars files only for non-sensitive values
- Include proper .gitignore file for Terraform
- Use branches for feature development
- Use pull/merge requests for code review
- Tag releases with semantic versioning
- Document changes in commit messages
- Lock dependency versions
- Use pre-commit hooks for validation
- Review infrastructure changes before merging

## Workflow

- Use terraform init, plan, apply workflow
- Automate with CI/CD pipelines
- Implement automated testing
- Use consistent formatting with terraform fmt
- Validate configurations with terraform validate
- Use proper error handling in scripts
- Document the workflow process
- Implement approval gates for sensitive changes
- Use Terraform workspaces appropriately
- Implement proper error handling and logging

## CI/CD Integration

- Automate the Terraform workflow in CI/CD pipelines
- Run terraform validate and terraform plan in CI
- Implement approval gates before terraform apply
- Store Terraform outputs in CI/CD artifacts
- Integrate with notification systems
- Implement proper error handling
- Use dedicated service accounts for CI/CD
- Secure CI/CD secrets and credentials
- Document the CI/CD integration
- Implement smoke tests after apply

## Testing

- Implement unit tests for modules
- Use terraform-module-testing libraries
- Implement integration tests for infrastructure
- Test modules against multiple provider versions
- Create test fixtures for complex scenarios
- Document test procedures
- Test both success and failure conditions
- Automate tests in CI/CD pipelines
- Create test environments that mirror production
- Clean up test resources after testing

## Documentation

- Document your Terraform code and architecture
- Generate module documentation automatically
- Document variables, outputs, and dependencies
- Maintain a README for each module
- Document prerequisites and setup instructions
- Create architecture diagrams
- Document operation procedures
- Keep documentation up to date
- Use consistent documentation standards
- Document known issues and limitations

## Cost Management

- Be aware of resource costs
- Use cost-effective resource types
- Implement resource scheduling for non-production
- Use auto-scaling for variable workloads
- Tag resources for cost allocation
- Implement budget alerts
- Consider spot/preemptible instances where appropriate
- Clean up unused resources
- Use cost estimation tools
- Document cost optimization strategies

## Team Collaboration

- Establish team standards and conventions
- Implement code reviews
- Use pull requests for changes
- Document design decisions
- Share knowledge among team members
- Conduct infrastructure reviews
- Use pair programming for complex changes
- Implement onboarding procedures
- Define roles and responsibilities
- Maintain a knowledge base

## Monitoring and Operations

- Output monitoring endpoints
- Implement logging for infrastructure
- Configure alerts for critical resources
- Create dashboards for infrastructure visibility
- Document operational procedures
- Implement backup and recovery procedures
- Plan for disaster recovery
- Document troubleshooting steps
- Create runbooks for common tasks
- Train operations teams

## Scaling and Performance

- Design for horizontal scaling
- Implement auto-scaling
- Consider regional distribution
- Design for high availability
- Plan for disaster recovery
- Optimize for performance
- Test scalability
- Document scaling procedures
- Plan for capacity growth
- Implement performance monitoring

## Maintenance

- Regularly update Terraform and providers
- Apply security patches promptly
- Review and refactor code regularly
- Clean up unused resources
- Document maintenance procedures
- Plan for major version upgrades
- Maintain a deprecation plan
- Test upgrades before applying
- Document known issues
- Maintain change logs