---
description: "Guidelines for building efficient, secure, and scalable web applications with Linux, Apache, MariaDB, and PHP"
globs: "*.{php,sql,htaccess,conf}"
---

# LAMP Stack with MariaDB Best Practices

## Architecture Overview

- Understand the components of LAMP stack (Linux, Apache, MariaDB, PHP)
- Design a clear separation of concerns between tiers
- Consider scalability needs from the beginning
- Plan for security at each layer
- Document the architecture
- Consider containerization for consistent deployments
- Plan for backup and disaster recovery
- Implement monitoring for all components
- Consider caching strategies at appropriate layers
- Document deployment and update procedures

## Linux Configuration

- Keep the system updated with security patches
- Use a firewall (iptables, ufw, firewalld)
- Implement proper user management and permissions
- Configure secure SSH access
- Disable unnecessary services
- Implement proper logging and log rotation
- Configure proper time synchronization (NTP)
- Consider SELinux or AppArmor for enhanced security
- Optimize kernel parameters for web server workloads
- Implement proper resource monitoring

## Apache Configuration

- Use the latest stable Apache version
- Configure proper MPM (Event, Worker, or Prefork) based on workload
- Enable only necessary modules
- Implement virtual hosts for multiple websites
- Configure proper access and error logging
- Set up SSL/TLS with strong ciphers
- Implement security headers
- Configure proper file permissions for web directories
- Optimize Apache for performance (KeepAlive, timeouts, etc.)
- Use .htaccess files strategically or disable them for performance

## MariaDB Configuration

- Use the latest stable MariaDB version
- Secure the initial installation (mysql_secure_installation)
- Create proper database users with limited privileges
- Configure proper authentication mechanisms
- Optimize buffer sizes based on available memory
- Configure proper innodb settings
- Implement a regular backup strategy
- Set up binary logging for point-in-time recovery
- Configure proper character sets and collations (UTF-8)
- Monitor query performance and optimize slow queries

## PHP Configuration

- Use the latest stable PHP version
- Configure PHP-FPM for better performance
- Set appropriate memory limits
- Configure proper error reporting and logging
- Set secure session handling
- Disable dangerous functions (exec, system, etc.)
- Set proper file upload limits and handling
- Configure OPcache for performance
- Set appropriate timeouts
- Implement proper error handling

## Security

- Implement proper network segmentation
- Use HTTPS for all traffic
- Implement proper input validation
- Use prepared statements for database queries
- Implement proper authentication and authorization
- Keep all components updated with security patches
- Implement proper file permissions
- Use a Web Application Firewall (ModSecurity)
- Implement rate limiting for APIs
- Regularly scan for vulnerabilities

## Performance Optimization

- Implement proper caching strategies (Memcached, Redis)
- Use PHP OPcache for bytecode caching
- Optimize database queries and indexes
- Implement HTTP caching headers
- Use a CDN for static assets
- Optimize images and other static assets
- Implement proper database connection pooling
- Consider query caching at appropriate levels
- Monitor and optimize slow queries
- Implement proper load balancing for scalability

## Database Design

- Design proper database schemas
- Use appropriate data types
- Implement proper indexes
- Consider normalization vs. denormalization tradeoffs
- Use foreign keys for referential integrity
- Implement proper transactions
- Design for scalability (sharding if necessary)
- Use appropriate storage engines for different tables
- Implement proper backup and restore procedures
- Document the database schema

## PHP Development

- Follow a consistent coding standard (PSR)
- Use a modern PHP framework (Laravel, Symfony, etc.)
- Implement proper error handling
- Use dependency injection
- Implement proper logging
- Use composer for dependency management
- Write unit and integration tests
- Document your code
- Use proper version control
- Implement continuous integration

## Deployment and CI/CD

- Automate deployment processes
- Implement proper staging environments
- Use version control for all code
- Implement proper database migration strategies
- Use deployment tools (Deployer, Capistrano, etc.)
- Test deployments before applying to production
- Implement rollback procedures
- Document deployment processes
- Implement continuous integration
- Use proper environment-specific configurations

## Monitoring and Maintenance

- Implement server monitoring (CPU, memory, disk, etc.)
- Monitor application performance
- Set up error alerting
- Implement proper logging and log analysis
- Regularly check for security updates
- Implement automated backups
- Schedule regular maintenance windows
- Document maintenance procedures
- Monitor database performance
- Use APM (Application Performance Monitoring) tools

## Scaling Strategies

- Implement horizontal scaling for web servers
- Use proper load balancing
- Implement database replication
- Consider database clustering for high availability
- Use caching layers effectively
- Implement proper session handling for multiple servers
- Consider microservices architecture for specific components
- Implement proper health checks
- Document scaling procedures
- Test scaling under load

## Backup and Recovery

- Implement regular database backups
- Use binary logging for point-in-time recovery
- Back up web server configurations
- Implement proper data retention policies
- Test restore procedures regularly
- Document backup and restore procedures
- Consider off-site backups
- Implement proper access controls for backups
- Monitor backup success and failures
- Implement disaster recovery procedures

## Documentation

- Document architecture and design decisions
- Create proper API documentation
- Document database schema
- Create deployment and maintenance procedures
- Document security procedures
- Create user manuals where appropriate
- Document environment configurations
- Create proper code documentation
- Document backup and recovery procedures
- Keep documentation updated with changes

## MariaDB-Specific Considerations

- Understand differences between MariaDB and MySQL
- Leverage MariaDB-specific features (better replication, etc.)
- Use specific MariaDB storage engines when appropriate
- Configure Galera Cluster for high availability
- Understand MariaDB-specific query optimizations
- Leverage virtual columns and dynamic columns
- Use MariaDB's enhanced security features
- Configure the thread pool for better performance
- Understand MariaDB's specific JSON handling
- Keep up with MariaDB-specific updates and features

## Integration with Other Services

- Implement proper email service integration
- Consider integration with caching services (Redis, Memcached)
- Implement proper search functionality (Elasticsearch, Sphinx)
- Consider integration with CDNs
- Implement proper logging services
- Consider integration with monitoring services
- Implement proper authentication services
- Consider integration with payment gateways
- Implement proper file storage solutions
- Consider integration with external APIs