---
description: "Guidelines for configuring, optimizing, and managing the Apache, PHP-FPM, and MySQL stack for web applications"
globs: "*.php,*.conf,*.htaccess,*.sql"
---

# Apache + PHP-FPM + MySQL Best Practices

## Architecture Design

- Implement proper separation between web server, application, and database tiers
- Design for appropriate connection pooling
- Consider horizontal scaling requirements
- Implement proper load balancing when needed
- Design for appropriate caching strategy
- Document architecture decisions
- Consider containerization approach
- Implement proper service isolation
- Design for appropriate network security
- Consider high availability requirements

## Apache Configuration

- Implement proper MPM (Multi-Processing Module) selection
- Design for appropriate worker/thread configuration
- Consider request handling optimization
- Implement proper virtual host configuration
- Design for appropriate SSL/TLS setup
- Document Apache configuration
- Consider proper logging configuration
- Implement appropriate security headers
- Design for proper URL rewriting
- Consider performance monitoring integration

## PHP-FPM Setup

- Implement proper pool configuration
- Design for appropriate process management
- Consider memory limits and optimization
- Implement proper error handling
- Design for appropriate logging
- Document PHP-FPM configuration
- Consider opcode caching
- Implement proper session handling
- Design for appropriate request timeout handling
- Consider PHP extension optimization

## MySQL Optimization

- Implement proper storage engine selection
- Design for appropriate indexing strategy
- Consider query optimization
- Implement proper connection handling
- Design for appropriate buffer configuration
- Document database optimization
- Consider data partitioning when appropriate
- Implement proper backup strategy
- Design for appropriate replication
- Consider query caching strategy

## Performance Tuning

- Implement proper caching at multiple levels
- Design for appropriate static file handling
- Consider content delivery optimization
- Implement proper database query optimization
- Design for appropriate PHP execution optimization
- Document performance bottlenecks and solutions
- Consider proper compression settings
- Implement resource usage monitoring
- Design for appropriate connection pooling
- Consider proper timeout configurations

## Security Implementation

- Implement proper network segmentation
- Design for appropriate access controls
- Consider input validation at all layers
- Implement proper authentication security
- Design for appropriate SSL/TLS configuration
- Document security controls
- Consider regular security updates
- Implement proper firewall rules
- Design for appropriate database security
- Consider web application firewall integration

## Monitoring and Logging

- Implement proper application logging
- Design for appropriate server monitoring
- Consider centralized log management
- Implement proper performance monitoring
- Design for appropriate alerting
- Document monitoring approach
- Consider log rotation and retention
- Implement proper error tracking
- Design for appropriate transaction monitoring
- Consider user experience monitoring

## Backup and Recovery

- Implement proper database backup strategy
- Design for appropriate file system backups
- Consider point-in-time recovery
- Implement proper disaster recovery procedures
- Design for appropriate backup verification
- Document backup and recovery procedures
- Consider automated backup testing
- Implement proper data retention policies
- Design for appropriate database replication
- Consider offsite backup storage

## Scaling Strategy

- Implement proper horizontal scaling
- Design for appropriate vertical scaling
- Consider read/write splitting for databases
- Implement proper load balancing
- Design for appropriate session handling in scaled environment
- Document scaling architecture
- Consider database sharding when appropriate
- Implement proper cache synchronization
- Design for appropriate deployment in scaled environment
- Consider containerization for scaling

## PHP Application Optimization

- Implement proper autoloading
- Design for appropriate dependency management
- Consider framework optimization
- Implement proper database interaction
- Design for appropriate error handling
- Document application architecture
- Consider code profiling and optimization
- Implement proper session management
- Design for appropriate file handling
- Consider asynchronous processing when appropriate

## Database Schema Design

- Implement proper normalization
- Design for appropriate indexing
- Consider data types optimization
- Implement proper constraints
- Design for appropriate relationships
- Document database schema
- Consider schema migration strategy
- Implement proper query optimization
- Design for appropriate partitioning
- Consider data archiving strategy

## Deployment Workflow

- Implement proper CI/CD pipelines
- Design for appropriate environment management
- Consider zero-downtime deployments
- Implement proper rollback mechanisms
- Design for appropriate database migrations
- Document deployment procedures
- Consider configuration management
- Implement proper build optimization
- Design for appropriate artifact management
- Consider blue-green deployments

## Cache Management

- Implement proper opcode caching
- Design for appropriate application caching
- Consider HTTP caching headers
- Implement proper page caching
- Design for appropriate object caching
- Document caching strategy
- Consider distributed caching when needed
- Implement proper cache invalidation
- Design for appropriate cache warming
- Consider CDN integration

## Configuration Management

- Implement proper configuration version control
- Design for appropriate environment-specific configuration
- Consider configuration automation
- Implement proper secret management
- Design for appropriate configuration validation
- Document configuration approach
- Consider configuration templating
- Implement proper configuration deployment
- Design for appropriate configuration backups
- Consider infrastructure as code for configuration

## High Availability Setup

- Implement proper redundancy at all levels
- Design for appropriate failover mechanisms
- Consider data replication
- Implement proper load balancing
- Design for appropriate health checking
- Document HA architecture
- Consider geographic distribution
- Implement proper backup and restore
- Design for appropriate disaster recovery
- Consider degraded mode operation