---
description: "Guidelines for configuring, optimizing, and managing HAProxy load balancer and reverse proxy"
globs: "*.cfg,haproxy.cfg"
---

# HAProxy Best Practices

## Installation and Setup

- Use official packages from trusted repositories
- Implement proper system user and permissions
- Configure appropriate file and directory permissions
- Set up proper log rotation
- Implement systemd service for automatic restarts
- Use containerization for consistent deployments
- Configure proper resource limits and ulimits
- Document installation method and configuration
- Consider automated installation with configuration management tools
- Implement proper backup of HAProxy configuration

## Configuration Structure

- Organize configuration into logical sections
- Use clear and consistent naming conventions
- Implement modular configuration with includes
- Document configuration with comments
- Use variables and templating for dynamic configuration
- Separate frontend, backend, and global configurations
- Create clear mapping between frontends and backends
- Document configuration structure
- Implement version control for configurations
- Validate configuration before deployment

## Frontend Configuration

- Implement proper binding to addresses and ports
- Configure appropriate protocol settings
- Use proper ACLs for request routing
- Implement appropriate header processing
- Configure proper logging for frontend traffic
- Design for appropriate connection handling
- Implement proper SSL/TLS termination when needed
- Document frontend configuration decisions
- Consider performance implications of frontend settings
- Implement proper request routing rules

## Backend Configuration

- Configure appropriate server definitions
- Implement proper health checks
- Use appropriate load balancing algorithms
- Configure connection settings and limits
- Implement proper server timeouts
- Design for backend server failure handling
- Document backend configuration decisions
- Consider sticky sessions when appropriate
- Implement proper error handling
- Configure proper logging for backend traffic

## TLS and Security

- Implement proper certificate management
- Configure appropriate TLS versions and ciphers
- Use proper certificate validation
- Consider SNI configuration for multi-domain setups
- Implement proper TLS session caching
- Configure OCSP stapling when possible
- Use HTTP security headers
- Implement proper authentication mechanisms
- Consider TLS termination strategies
- Document security configuration choices

## Performance Optimization

- Implement proper connection pooling
- Configure appropriate buffer sizes
- Use HTTP/2 when appropriate
- Implement proper compression settings
- Configure TCP optimizations
- Consider kernel tuning for high performance
- Implement proper timeout settings
- Design for appropriate concurrency models
- Document performance tuning decisions
- Test performance under load

## High Availability

- Implement active-passive or active-active setups
- Configure proper failover mechanisms
- Use keepalived for high availability
- Implement proper health checking for HA
- Design for zero-downtime reloads
- Consider split brain prevention
- Document HA configuration and procedures
- Implement proper synchronization between nodes
- Consider floating IP strategies
- Design for proper failure detection and recovery

## Logging and Monitoring

- Configure appropriate log formats and destinations
- Implement centralized logging
- Use proper log levels for different environments
- Configure HTTP access logging
- Implement metrics collection via stats socket
- Design for proper alerting based on logs and metrics
- Consider integration with monitoring systems
- Document logging configuration
- Implement proper log analysis strategies
- Configure health check endpoints

## Advanced Features

- Use stick tables for advanced persistence
- Implement content-based routing when needed
- Configure HTTP rewriting rules appropriately
- Use TCP mode for non-HTTP protocols
- Implement dynamic server management
- Consider Lua scripting for complex logic
- Use maps for dynamic configuration
- Document advanced configurations
- Implement proper testing for complex features
- Consider using runtime API for dynamic configuration

## Docker and Containerization

- Use official HAProxy images
- Implement proper container configuration
- Design appropriate volume mounts for configuration
- Configure proper network settings for containers
- Consider Docker Compose for multi-container setups
- Implement proper health checks for containers
- Document container configuration
- Consider orchestration platform integration
- Implement proper container logging
- Design for container upgrades and migrations

## Rate Limiting and DDoS Protection

- Implement proper connection rate limiting
- Configure request rate limiting
- Use stick tables for tracking abusive clients
- Implement appropriate denial rules
- Design for bot protection when needed
- Consider whitelisting for trusted sources
- Document rate limiting strategies
- Implement proper logging for security events
- Consider geographic restrictions when appropriate
- Design for resilience against different attack vectors

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

## Troubleshooting and Maintenance

- Implement proper debugging configurations
- Use appropriate log levels for troubleshooting
- Document common troubleshooting procedures
- Implement proper backup and restore procedures
- Consider configuration management strategies
- Document maintenance windows and procedures
- Implement proper monitoring during maintenance
- Design for appropriate alerting during maintenance
- Consider configuration validation tools
- Document known issues and workarounds

## Specialized Use Cases

- Configure appropriate settings for WebSocket support
- Implement gRPC support when needed
- Configure for microservices architectures
- Design for API gateway patterns
- Consider service mesh integration
- Implement proper configuration for database load balancing
- Document specialized configurations
- Consider TCP/UDP load balancing configuration
- Implement proper session persistence for stateful applications
- Design for appropriate health checking in specialized scenarios