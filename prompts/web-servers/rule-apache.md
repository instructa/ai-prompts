---
description: "Guidelines for configuring, securing, and optimizing Apache HTTP Server."
globs: "httpd.conf,apache2.conf,*.conf,sites-available/*,sites-enabled/*,.htaccess"
---

# Apache HTTP Server Best Practices

## Key Principles

- Implement secure configurations with proper access controls and minimal exposure
- Optimize performance through appropriate MPM selection and caching strategies
- Create organized virtual host configurations for scalable web server management
- Set up robust SSL/TLS with modern protocols and strong cipher configurations
- Maintain comprehensive logging and monitoring for troubleshooting and security
- Enable only necessary modules to reduce attack surface and resource usage

## Installation and Setup

- Use the latest stable version from official repositories
- Compile from source only when necessary for specific modules
- Organize configuration files logically
- Use the sites-available and sites-enabled pattern
- Include modular configuration files
- Set up proper user and group permissions
- Implement proper logging configuration
- Configure proper file descriptor limits
- Use systemd for service management
- Document installation and configuration details

## Configuration Structure

- Organize configurations hierarchically
- Separate global settings from virtual host configurations
- Utilize include directives for modular organization
- Keep sensitive configurations outside web root
- Use consistent naming conventions
- Apply environment-specific configurations
- Document configuration changes and rationale
- Back up configurations before changes
- Use version control for configuration management
- Test configuration changes in staging environment

## Virtual Hosts

- Configure name-based virtual hosts properly
- Implement IP-based virtual hosts when necessary
- Set appropriate ServerName and ServerAlias
- Configure proper document roots
- Implement per-virtual-host logging
- Set appropriate directory options
- Configure SSL for each virtual host
- Implement proper access controls
- Use separate log files for each virtual host
- Include default virtual host for unmatched requests

## Performance Optimization

- Choose appropriate Multi-Processing Module (MPM)
- Use MPM Event for better performance in most cases
- Configure proper number of servers and threads
- Set appropriate timeout values
- Configure proper KeepAlive settings
- Set appropriate MaxRequestWorkers based on available memory
- Enable HTTP/2 for improved performance
- Implement proper caching directives
- Configure browser caching with appropriate headers
- Enable mod_deflate for compression
- Use mod_expires for cache control
- Implement proper ETags configuration
- Optimize static file serving
- Use mod_cache when appropriate
- Configure proper logging levels in production
- Use Apache Bench (ab) for performance testing

## Security Configuration

- Hide server information with ServerTokens and ServerSignature
- Implement mod_security for WAF capabilities
- Configure proper access controls with Allow/Deny or Require
- Protect sensitive files and directories
- Use auth_basic for simple authentication
- Apply appropriate file access restrictions
- Use effective request limiting
- Implement proper module restrictions
- Create suitable security headers
- Apply appropriate authentication mechanisms
- Configure Content Security Policy (CSP)

## SSL/TLS Configuration

- Implement proper certificate setup
- Create effective protocol configuration
- Apply appropriate cipher suite selection
- Use proper OCSP stapling
- Implement effective HSTS configuration
- Create strong Diffie-Hellman parameters
- Apply proper certificate renewal processes
- Use modern TLS protocols (TLS 1.2, 1.3)
- Use Let's Encrypt with certbot for free certificates
- Implement HTTP Strict Transport Security (HSTS)

## Logging and Monitoring

- Implement appropriate access log format
- Create effective error logging
- Apply proper log rotation
- Use effective log analysis tools
- Implement proper performance monitoring
- Create suitable alerting mechanisms
- Apply appropriate log security measures
- Enable mod_status for monitoring
- Set appropriate LogLevel
- Use tools like GoAccess for log analysis

## Module Management

- Use appropriate module selection
- Implement proper module loading
- Apply effective module configuration
- Create suitable module dependencies
- Implement proper third-party module integration
- Use appropriate module security configuration
- Apply proper module updates
- Enable only necessary modules
- Use mod_rewrite for URL rewriting
- Enable mod_ssl for HTTPS
- Use mod_headers for custom headers