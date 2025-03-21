---
description: "Guidelines for configuring, optimizing, and securing Nginx web server"
globs: "*.conf,*.nginx"
---

# Nginx Best Practices

## Installation and Setup

- Use the official package repositories when possible
- Compile from source for maximum customization and latest features
- Keep Nginx updated for security patches and new features
- Select appropriate modules during installation
- Organize configuration files in a modular way
- Use separate configuration files for different domains/applications
- Place SSL certificates in secure locations
- Run Nginx with proper user permissions
- Consider using Docker containers for deployment
- Document your installation and configuration choices

## Basic Configuration

- Configure worker processes based on CPU cores (`worker_processes auto;`)
- Set appropriate worker connections (`worker_connections 1024;`)
- Configure proper keepalive settings
- Set appropriate buffer sizes for your workload
- Use sensible client body and header buffer sizes
- Configure proper timeouts (client, keep-alive, send, read)
- Enable gzip compression for appropriate content types
- Set proper MIME types and defaults
- Configure proper log formats and locations
- Use meaningful and consistent server names

## Performance Optimization

- Enable HTTP/2 for improved performance
- Configure proper caching directives
- Use microcaching for dynamic content
- Implement browser caching with appropriate headers
- Enable gzip or Brotli compression
- Optimize buffer sizes for your workload
- Use sendfile for static content delivery
- Configure TCP settings for optimal performance
- Enable TCP_NODELAY and TCP_NOPUSH when appropriate
- Optimize open file cache for busy servers
- Use appropriate connection processing methods

## Security

- Keep Nginx updated with security patches
- Disable unnecessary modules
- Hide server tokens and version information
- Implement proper access controls with `allow` and `deny`
- Configure appropriate request limits
- Implement rate limiting to prevent abuse
- Set up proper SSL/TLS configuration
- Enable HTTPS and redirect HTTP to HTTPS
- Configure strong cipher suites
- Implement HSTS (HTTP Strict Transport Security)
- Use modern TLS versions (disable old versions)
- Add security headers (X-Content-Type-Options, X-XSS-Protection, etc.)
- Implement Content Security Policy
- Protect against clickjacking with X-Frame-Options
- Use access restrictions for sensitive areas

## SSL/TLS Configuration

- Use strong cipher suites and protocols
- Disable old protocols (SSLv2, SSLv3, TLSv1.0, TLSv1.1)
- Enable OCSP stapling
- Configure proper SSL session cache
- Use proper certificate chains
- Implement automatic certificate renewal (e.g., with Certbot)
- Set appropriate SSL buffer size
- Use strong Diffie-Hellman parameters
- Implement HSTS with appropriate max-age
- Consider implementing Certificate Transparency
- Configure proper SSL session timeout

## Proxy Configuration

- Configure proper proxy headers
- Set appropriate proxy timeouts
- Configure proxy buffers based on response sizes
- Implement upstream health checks
- Configure proper connection pooling
- Use consistent hashing for session persistence
- Configure proper upstream connection limits
- Handle WebSocket connections properly
- Implement proper upstream error handling
- Configure proper SSL for upstream connections
- Use caching for backend responses when appropriate

## Load Balancing

- Choose appropriate load balancing algorithms
- Implement proper health checks for backends
- Configure backup servers for failover
- Use persistent connections to upstream servers
- Implement session persistence when needed
- Configure proper weights for servers
- Monitor backend performance
- Use slow start for new backends
- Implement proper error handling for failed backends
- Consider using active health checks

## Logging and Monitoring

- Configure proper log formats with relevant information
- Implement log rotation to manage disk space
- Consider using JSON logging for easier parsing
- Log to syslog for centralized logging
- Implement access logging with appropriate information
- Configure error logging with proper verbosity
- Monitor Nginx status with stub_status module
- Use monitoring tools compatible with Nginx
- Set up alerts for critical errors
- Analyze logs for performance and security issues

## Caching

- Configure proxy caching for appropriate content
- Use appropriate cache keys
- Set proper cache expiry times
- Configure cache bypass conditions
- Use stale cache when refreshing or on errors
- Implement microcaching for dynamic content
- Configure cache purging mechanisms
- Use cache locking for popular resources
- Organize cache directories effectively
- Monitor cache performance and hit rates

## HTTP/2 and HTTP/3

- Enable HTTP/2 for improved performance
- Configure appropriate HTTP/2 settings
- Consider enabling HTTP/3 (QUIC) when available
- Implement proper ALPN configuration
- Configure appropriate priority settings
- Set server push directives when beneficial
- Optimize number of concurrent streams
- Consider HTTP/2 specific optimizations
- Test HTTP/2 performance with proper tools
- Monitor HTTP/2 connection performance

## Content and Response Optimization

- Enable compression for appropriate content types
- Configure proper gzip compression levels
- Consider using Brotli compression when available
- Remove unnecessary headers
- Optimize ETags configuration
- Implement browser caching with Cache-Control
- Optimize image delivery (consider WebP format)
- Use appropriate Content-Type headers
- Consider implementing response filtering
- Configure proper character sets and encoding

## Dynamic Modules

- Use dynamic modules for specialized functionality
- Load only necessary modules
- Configure modules with appropriate settings
- Keep dynamic modules updated
- Document module usage and configuration
- Test performance impact of modules
- Use proper error handling for module failures
- Consider security implications of modules
- Monitor module performance
- Ensure proper compatibility between modules

## Containerization

- Use official Nginx Docker images when possible
- Create slim, purpose-built containers
- Use multi-stage builds for custom builds
- Mount configuration files as volumes
- Handle logs appropriately in containers
- Implement proper health checks
- Use proper signals for graceful shutdown
- Configure appropriate resource limits
- Run containers with proper user permissions
- Implement proper secrets management

## Testing and Deployment

- Test configuration changes in staging environment
- Use `nginx -t` to test configurations before applying
- Implement blue/green deployments for zero downtime
- Use configuration management tools (Ansible, Chef, etc.)
- Implement automated testing for configurations
- Use graceful reloads for configuration changes
- Document deployment procedures
- Implement backup procedures for configurations
- Test performance after significant changes
- Implement rollback procedures