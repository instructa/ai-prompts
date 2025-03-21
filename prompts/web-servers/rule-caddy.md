---
description: "Guidelines for configuring, optimizing, and managing Caddy web server"
globs: "Caddyfile,*.caddy"
---

# Caddy Server Best Practices

## Installation and Setup

- Use official installation methods (binaries, packages, or Docker)
- Implement proper system user and permissions
- Configure appropriate file and directory permissions
- Set up proper log rotation
- Implement systemd service for automatic restarts
- Use docker volumes for persistent configuration in containerized deployments
- Configure proper resource limits
- Document installation method and configuration
- Consider automated installation with configuration management tools
- Implement proper backup of Caddy configuration

## Caddyfile Configuration

- Use clear and consistent formatting in Caddyfile
- Implement modular configuration with imports
- Document configuration with comments
- Use environment variables for dynamic configuration
- Implement proper site blocks with logical grouping
- Use proper matchers for request handling
- Create clear URL routing rules
- Document site-specific configurations
- Use proper ordering of directives
- Validate configuration before deployment

## TLS and Security

- Leverage Caddy's automatic HTTPS features
- Configure appropriate TLS versions and ciphers when needed
- Implement proper certificate management
- Consider custom certificate authorities when necessary
- Configure OCSP stapling for better performance
- Implement proper HSTS policies
- Use security headers for enhanced protection
- Implement proper rate limiting
- Configure appropriate authentication mechanisms
- Document security configuration choices

## Performance Optimization

- Implement proper caching strategies
- Configure appropriate compression settings
- Consider response buffering options
- Set up proper timeouts and limits
- Implement HTTP/2 and HTTP/3 when appropriate
- Configure file serving optimizations
- Consider static file compression
- Implement proper worker configuration
- Document performance tuning decisions
- Test performance under load

## Reverse Proxy Configuration

- Implement proper upstream server configuration
- Configure health checks for backend services
- Use appropriate load balancing strategies
- Implement proper path handling and rewriting
- Configure header management for proxied requests
- Consider proper connection handling
- Implement appropriate timeouts for proxied requests
- Document proxy configuration choices
- Consider WebSocket proxying when needed
- Implement proper error handling for upstream failures

## Logging and Monitoring

- Configure appropriate log formats and levels
- Implement log storage and rotation
- Consider centralized logging solutions
- Set up proper error handling and reporting
- Implement proper metrics collection
- Configure health check endpoints
- Consider distributed tracing integration
- Document logging and monitoring setup
- Implement proper alerting for critical issues
- Configure access logging with appropriate detail

## Advanced Features

- Use Caddy's API for programmatic configuration when appropriate
- Implement proper request rewriting rules
- Configure content transformation when needed
- Use response manipulation directives appropriately
- Implement proper static file serving configuration
- Configure error pages and handling
- Consider Caddy extensions for specialized needs
- Document advanced configurations
- Implement proper testing for complex features
- Consider custom middleware when appropriate

## Containers and Orchestration

- Use official Docker images when possible
- Implement proper container configuration
- Design appropriate volume mounts for persistence
- Configure proper network settings
- Consider orchestration platform integration
- Implement proper health checks for containers
- Document container configuration
- Consider multi-container architectures
- Implement proper container logging
- Design for container upgrades and migrations

## High Availability and Scaling

- Design for horizontal scaling
- Implement proper load balancing for Caddy instances
- Consider distributed certificate management
- Implement proper configuration synchronization
- Design for zero-downtime upgrades
- Consider regional deployment strategies
- Document scaling strategies
- Implement proper failover mechanisms
- Consider traffic distribution strategies
- Design for proper capacity planning

## Testing and Deployment

- Implement configuration testing before deployment
- Use staging environments for validation
- Consider canary deployments for changes
- Implement automated testing when possible
- Document deployment procedures
- Consider rollback strategies
- Implement proper validation after deployment
- Design for blue-green deployments when appropriate
- Document testing procedures
- Implement proper versioning for configurations

## Troubleshooting and Maintenance

- Implement proper debugging configurations
- Design for appropriate log levels in different environments
- Document common troubleshooting procedures
- Implement proper backup and restore procedures
- Consider configuration management strategies
- Document maintenance windows and procedures
- Implement proper monitoring for maintenance activities
- Design for appropriate alerting during maintenance
- Consider configuration drift detection
- Document known issues and workarounds

## Integration with External Systems

- Configure appropriate authentication providers
- Implement proper integration with upstream services
- Consider service discovery integration
- Design for appropriate metrics systems integration
- Implement proper logging integration
- Document integration points and requirements
- Consider API gateway patterns when appropriate
- Implement proper error handling for external dependencies
- Design for resilience against external system failures
- Document external system dependencies