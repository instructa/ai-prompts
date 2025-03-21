---
description: "Guidelines for configuring and deploying secure web services using Nginx, Let's Encrypt, and Docker"
globs: "*.conf,docker-compose.yml,Dockerfile,*.sh"
---

# Nginx, Let's Encrypt, and Docker Integration Best Practices

## Architecture and Design

- Use Docker Compose for service orchestration
- Implement proper container networking
- Use Docker volumes for persistent data
- Separate configuration from code
- Implement proper service dependencies
- Use environment variables for configuration
- Create modular and reusable configurations
- Document architecture and design decisions
- Implement proper restart policies
- Design for zero-downtime certificate renewal

## Docker Configuration

- Use official Nginx and Certbot (Let's Encrypt) images
- Pin image versions for stability
- Implement proper health checks
- Configure appropriate resource limits
- Use multi-stage builds for custom images
- Implement proper logging configuration
- Use Docker networks for service isolation
- Configure proper user permissions
- Document Docker-specific configurations
- Use Docker secrets for sensitive information

## Nginx Configuration

- Use modular configuration with include directives
- Implement proper virtual hosts configuration
- Configure appropriate SSL/TLS settings
- Use HTTP/2 for improved performance
- Implement proper proxy configuration for backend services
- Configure appropriate caching headers
- Implement proper logging
- Use environment variables in templates
- Configure proper security headers
- Document Nginx configuration details

## SSL/TLS with Let's Encrypt

- Use the ACME protocol for certificate issuance
- Implement proper domain validation methods
- Configure automatic certificate renewal
- Use staging environment for testing
- Implement proper certificate storage
- Configure appropriate certificate issuance rate limits
- Document certificate management procedures
- Implement proper error handling for certificate issuance
- Configure appropriate security settings
- Use wildcard certificates when appropriate

## Security

- Implement proper HTTPS redirection
- Configure HTTP Strict Transport Security (HSTS)
- Use proper SSL/TLS protocols and ciphers
- Implement Content Security Policy (CSP)
- Configure appropriate access controls
- Disable server tokens
- Implement rate limiting for sensitive endpoints
- Configure proper backoff for failed authentication attempts
- Document security measures
- Regularly update base images

## Performance Optimization

- Configure appropriate worker processes and connections
- Implement proper caching strategies
- Use compression for appropriate content types
- Configure proper buffer sizes
- Implement HTTP/2 for improved performance
- Use efficient SSL/TLS configuration
- Configure proper keepalive settings
- Implement proper load balancing for multiple backends
- Document performance configurations
- Monitor and optimize performance regularly

## Deployment

- Implement proper CI/CD pipelines
- Use automated deployment procedures
- Configure proper staging and production environments
- Implement blue-green deployments
- Use proper deployment validation
- Document deployment procedures
- Implement proper rollback strategies
- Configure appropriate monitoring
- Use proper release management
- Implement proper backup procedures

## Certificate Management

- Implement automated certificate renewal
- Configure proper certificate storage
- Set up notifications for certificate expiration
- Implement proper error handling for renewal failures
- Document certificate management procedures
- Configure appropriate renewal schedules
- Implement proper certificate deployment
- Use staging environment for testing
- Configure appropriate backup procedures
- Document recovery procedures for certificate failures

## Monitoring and Logging

- Configure appropriate logging for Nginx
- Implement proper log rotation
- Use centralized logging when appropriate
- Configure monitoring for certificate expiration
- Implement proper alerting for failures
- Document monitoring procedures
- Use structured logging when possible
- Implement proper error tracking
- Configure appropriate metrics collection
- Set up dashboards for system health

## Scaling and High Availability

- Design for horizontal scaling
- Implement proper load balancing
- Configure shared certificate storage for multiple instances
- Use proper container orchestration
- Implement proper health checks
- Configure appropriate failover mechanisms
- Document scaling procedures
- Implement proper resource management
- Test scaling and failover scenarios
- Configure appropriate auto-scaling rules