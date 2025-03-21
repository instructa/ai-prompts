---
description: "Guidelines for configuring, optimizing, and managing Traefik edge router and reverse proxy"
globs: "*.yaml,*.yml,*.toml"
---

# Traefik Best Practices

## Installation and Setup

- Use official installation methods (binaries, Helm charts, or Docker)
- Implement proper system user and permissions
- Configure appropriate file and directory permissions
- Set up proper log rotation
- Implement systemd service for automatic restarts
- Use docker volumes for persistent configuration in containerized deployments
- Configure proper resource limits
- Document installation method and configuration
- Consider automated installation with configuration management tools
- Implement proper backup of Traefik configuration

## Configuration Structure

- Choose appropriate configuration format (YAML, TOML, or environment variables)
- Implement modular configuration files
- Document configuration with comments
- Use variables and environment substitution
- Create clear separation between static and dynamic configuration
- Implement proper versioning for configurations
- Document configuration structure and organization
- Consider templating for dynamic environments
- Use proper naming conventions
- Validate configuration before deployment

## Provider Configuration

- Configure appropriate providers for your environment
- Implement proper Docker/Kubernetes integration
- Configure file provider for static rules
- Use proper authentication for provider APIs
- Implement appropriate polling intervals
- Document provider-specific configurations
- Consider multiple providers when appropriate
- Design for proper isolation between providers
- Implement proper error handling for provider failures
- Configure appropriate watches and updates

## Routing Configuration

- Implement clear routing rules with proper priorities
- Use host-based routing appropriately
- Configure path-based routing when needed
- Implement proper middleware chains
- Design for appropriate request matching
- Use proper HTTP methods and constraints
- Document routing decisions and logic
- Consider service weighting and load balancing
- Implement proper error routing
- Design for proper rule evaluation order

## TLS and Security

- Implement proper certificate management
- Configure ACME (Let's Encrypt) integration
- Use appropriate certificate resolvers
- Implement proper TLS options and configurations
- Configure appropriate TLS versions and ciphers
- Consider certificate rotation and renewal
- Implement proper HTTPS redirection
- Use security headers middleware
- Document TLS configuration choices
- Consider mTLS when appropriate

## Middleware Configuration

- Use appropriate built-in middlewares
- Implement clear middleware chains
- Configure proper request manipulation
- Use appropriate authentication middlewares
- Implement proper compression settings
- Configure rate limiting when needed
- Use circuit breaker patterns appropriately
- Document middleware configurations
- Consider middleware ordering and priority
- Implement proper error handling in middlewares

## Service Discovery

- Configure appropriate service discovery mechanisms
- Implement proper health checks
- Design for service resilience
- Consider service tagging and metadata
- Implement proper load balancing strategies
- Document service discovery configuration
- Consider service versioning strategies
- Design for zero-downtime deployments
- Implement proper failover mechanisms
- Configure appropriate service timeouts

## Docker Integration

- Use proper Docker labels for configuration
- Implement network isolation where appropriate
- Configure proper port exposure
- Consider Docker Compose for multi-container setups
- Implement proper health checks for containers
- Document container integration patterns
- Consider multi-network configurations
- Design for proper container lifecycle integration
- Implement proper logging for Docker services
- Consider Docker Swarm mode when appropriate

## Kubernetes Integration

- Use proper Ingress resources and CRDs
- Implement IngressRoute resources for Traefik CRDs
- Configure appropriate namespace handling
- Use proper annotations for configuration
- Implement appropriate ServiceType configurations
- Consider Helm for deployment management
- Document Kubernetes-specific configurations
- Design for proper integration with Kubernetes services
- Implement proper RBAC configurations
- Consider cluster-wide vs. namespaced installations

## Observability and Metrics

- Configure appropriate logging formats and levels
- Implement metrics collection (Prometheus)
- Configure access logs appropriately
- Design dashboards for monitoring (Grafana)
- Implement distributed tracing when appropriate
- Configure health check endpoints
- Document monitoring setup and dashboards
- Implement proper alerting for critical issues
- Consider log aggregation solutions
- Design for appropriate operational visibility

## High Availability and Scaling

- Implement proper clustering configuration
- Configure appropriate leader election
- Design for horizontal scaling
- Implement proper load distribution
- Consider regional and zonal deployment strategies
- Document scaling strategies and procedures
- Implement proper configuration synchronization
- Design for zero-downtime updates
- Consider traffic distribution strategies
- Implement proper capacity planning

## Performance Optimization

- Configure appropriate buffer sizes
- Implement proper connection limits
- Use HTTP/2 and HTTP/3 when appropriate
- Configure proper timeouts for different services
- Consider caching strategies
- Implement proper compression settings
- Document performance tuning decisions
- Test performance under load
- Consider resource allocation strategies
- Implement proper connection pooling

## Testing and Deployment

- Implement configuration validation before deployment
- Use staging environments for testing
- Consider canary deployments for changes
- Implement automated testing when possible
- Document deployment procedures
- Consider graceful reload strategies
- Implement proper validation after deployment
- Design for blue-green deployments when appropriate
- Document testing procedures
- Implement proper versioning for configurations

## API and Dashboard

- Configure API access controls
- Implement proper authentication for API and dashboard
- Design for appropriate API usage
- Consider API rate limiting
- Document API endpoints and usage
- Configure dashboard access appropriately
- Implement proper CORS settings
- Consider API versioning strategies
- Document dashboard features and limitations
- Implement proper auditing for API usage

## Security Considerations

- Apply principle of least privilege
- Implement proper network isolation
- Configure appropriate firewall rules
- Consider running Traefik with non-root user
- Implement proper secret management
- Configure appropriate authentication for protected resources
- Document security configuration
- Consider security scanning for configurations
- Implement proper access controls
- Design for defense in depth