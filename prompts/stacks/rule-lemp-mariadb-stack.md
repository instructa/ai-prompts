---
description: "Guidelines for developing and deploying applications using the Linux, Nginx, MariaDB, PHP stack"
globs: "*.php,nginx.conf,nginx/*.conf,.my.cnf"
---

# LEMP Stack with MariaDB Best Practices

## Architecture and Setup

- Use the latest stable versions of Linux, Nginx, MariaDB, and PHP
- Implement proper separation of concerns (presentation, business logic, data access)
- Configure server blocks (virtual hosts) for multiple websites
- Use try_files for clean URLs instead of rewrite rules
- Implement proper file/directory permissions
- Utilize environment variables for configuration
- Follow the MVC (Model-View-Controller) pattern
- Separate development, staging, and production environments
- Use Docker for consistent development environments
- Configure proper log rotation

## Linux Configuration

- Keep the Linux kernel and packages updated
- Use a security-focused distribution (Ubuntu Server, CentOS, Debian)
- Implement proper user and group management
- Configure firewall rules with iptables or ufw
- Disable root SSH login
- Use SSH key authentication instead of passwords
- Implement proper logging and monitoring
- Configure automatic security updates
- Optimize kernel parameters for web server workloads
- Use systemd for service management

## Nginx Configuration

- Implement proper worker_processes and worker_connections based on CPU cores
- Enable HTTP/2 for improved performance
- Configure proper SSL/TLS with strong ciphers
- Use the fastcgi_cache for PHP caching
- Implement proper proxy_cache for reverse proxy scenarios
- Configure proper gzip compression
- Use microcaching for dynamic content when appropriate
- Implement proper access and error logging
- Use rate limiting for API endpoints and login attempts
- Configure browser caching with Cache-Control headers

## MariaDB Configuration

- Implement proper database design and normalization
- Use InnoDB as the default storage engine
- Configure proper buffer sizes based on available memory
- Implement query caching appropriately
- Use prepared statements to prevent SQL injection
- Create proper indexes for frequently used queries
- Implement regular database backups
- Utilize database replication for high availability
- Monitor slow queries and optimize them
- Implement proper user privileges following least privilege principle
- Configure proper character set and collation (utf8mb4)
- Use MariaDB-specific optimizations when appropriate

## PHP Configuration

- Use PHP-FPM for improved performance
- Configure opcache for bytecode caching
- Set appropriate memory limits and execution times
- Disable dangerous functions and expose_php
- Use modern PHP frameworks (Laravel, Symfony) or CMS (WordPress, Drupal)
- Implement proper error logging but disable error display in production
- Use composer for dependency management
- Follow PSR standards for code quality
- Implement proper input validation and output escaping
- Keep PHP extensions updated

## Security

- Implement proper authentication and authorization
- Use HTTPS with proper SSL/TLS configuration
- Validate and sanitize all user inputs
- Implement proper session management
- Use password hashing with bcrypt or Argon2
- Protect against common web vulnerabilities (XSS, CSRF, SQLi)
- Implement Content Security Policy (CSP)
- Use HTTPS Strict Transport Security (HSTS)
- Regularly update all components
- Implement proper file permissions

## Performance Optimization

- Implement caching at multiple levels (opcode, application, database, HTTP)
- Use a CDN for static assets
- Optimize images and assets
- Minify and combine CSS and JavaScript files
- Implement proper database indexing
- Use query optimization techniques
- Configure proper connection pooling
- Implement HTTP caching headers
- Use asynchronous processing for long-running tasks
- Implement proper load balancing for high-traffic sites

## Monitoring and Maintenance

- Set up performance monitoring
- Implement proper logging for all components
- Set up alerting for critical issues
- Regularly check for security updates
- Implement automated backup solutions
- Use tools like New Relic, Datadog, or Prometheus for monitoring
- Implement health checks
- Monitor disk usage and database growth
- Set up log aggregation and analysis
- Document the infrastructure and maintenance procedures

## Deployment

- Implement CI/CD pipelines
- Use version control (Git) for code management
- Implement blue-green deployments or canary releases
- Automate deployment processes
- Implement proper rollback procedures
- Use environment-specific configuration
- Implement database migration strategies
- Use containers or configuration management tools
- Test deployments in staging environment before production
- Use deployment tools like Capistrano or Deployer

## MariaDB-Specific Features

- Use MariaDB Galera Cluster for multi-master replication
- Implement MariaDB Columnstore for analytical workloads
- Use MariaDB's parallel replication capabilities
- Implement proper GTID (Global Transaction ID) configuration
- Use MariaDB's enhanced security features
- Implement MariaDB audit plugin for compliance
- Configure proper MariaDB backups with Mariabackup
- Use MariaDB's performance schema effectively
- Implement MariaDB-specific optimizations and features
- Keep updated with MariaDB's release cycle and features