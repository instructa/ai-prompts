---
description: "Best practices for Ansible infrastructure automation and configuration management"
globs: "*.yml,*.yaml,inventory.ini,ansible.cfg,hosts"
alwaysApply: false
---

# Ansible Best Practices

## Key Principles

- Create modular, reusable Ansible infrastructure
- Implement proper role-based organization
- Write idempotent and predictable playbooks
- Apply effective inventory management
- Utilize secure variable and secret management
- Implement structured testing for Ansible code
- Follow clear naming conventions and documentation

## Playbook Organization

- Create well-structured playbook organization
- Implement proper task separation
- Apply appropriate play organization
- Use meaningful names for plays and tasks
- Implement proper task tagging
- Create effective playbook composition
- Apply appropriate default variables
- Use proper conditionals for task execution
- Implement effective role dependencies
- Create standardized project structure

## Role Development

- Create properly scoped roles
- Implement consistent role structure
- Apply appropriate role variables
- Use effective defaults for roles
- Implement proper role metadata
- Create comprehensive role documentation
- Apply appropriate dependency management
- Use reusable role patterns
- Implement version control for roles
- Create proper role testing

## Variable Management

- Implement proper variable precedence
- Create effective variable scoping
- Apply appropriate encryption with ansible-vault
- Use separate variable files
- Implement consistent variable naming
- Create proper variable hierarchy
- Apply appropriate group and host variables
- Use effective inventory variables
- Implement proper environment-specific variables
- Create secure handling of sensitive data

## Task Design

- Write idempotent tasks
- Implement proper error handling
- Apply appropriate retry logic
- Use effective task delegation
- Implement proper privilege escalation
- Create effective module usage
- Apply appropriate task control flow
- Use proper handler implementations
- Implement effective notification chains
- Create appropriate task timeouts

## Inventory Management

- Implement dynamic inventory where appropriate
- Create proper inventory grouping
- Apply appropriate group hierarchy
- Use effective host patterns
- Implement proper inventory plugins
- Create inventory documentation
- Apply appropriate inventory variables
- Use consistent inventory naming conventions
- Implement effective inventory testing
- Create proper inventory security

## Testing and Validation

- Implement syntax checking
- Create effective linting with ansible-lint
- Apply appropriate molecule testing
- Use effective integration testing
- Implement proper CI/CD integration
- Create playbook dry-run with --check
- Apply appropriate diff checking with --diff
- Use effective testing for idempotence
- Implement proper test isolation
- Create comprehensive test documentation

## Security Practices

- Implement proper privilege management
- Create effective secret management
- Apply appropriate vault usage
- Use secure connection methods
- Implement proper SSH hardening
- Create minimal-access automation users
- Apply appropriate network security
- Use effective credential management
- Implement proper inventory security
- Create secure task execution
