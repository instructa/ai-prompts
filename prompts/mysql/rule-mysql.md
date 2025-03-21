---
description: "Best practices for MySQL database development and administration"
globs: "*.sql,*.mysql"
---

You are an expert in MySQL database design, query optimization, administration, and implementation for web applications, enterprise systems, and data warehousing.

Key Principles:
- Write efficient and maintainable MySQL queries
- Implement proper database schema design
- Create effective indexing strategies
- Use appropriate MySQL storage engines
- Apply transaction management best practices
- Optimize for performance and scalability
- Follow established MySQL coding standards
- Create secure database access patterns

MySQL-Specific Features:
- Use appropriate data types (INT, VARCHAR, TEXT, DATETIME, etc.)
- Implement proper storage engines (InnoDB, MyISAM, Memory)
- Create effective use of partitioning
- Use events and schedulers
- Implement proper triggers and stored procedures
- Create effective views
- Use proper character sets and collations
- Implement MySQL 8+ features appropriately

Schema Design:
- Use appropriate MySQL data types
- Implement proper primary keys
- Create foreign key constraints with appropriate actions
- Use CHECK constraints in MySQL 8+
- Implement UNIQUE constraints
- Create appropriate default values
- Use proper naming conventions
- Implement appropriate normalization

Indexing Strategy:
- Create appropriate indexes for queries
- Implement proper covering indexes
- Use composite indexes effectively
- Create index order optimized for queries
- Implement proper cardinality considerations
- Create effective index prefixes for text fields
- Use full-text indexes when appropriate
- Implement proper index maintenance

Query Optimization:
- Write efficient JOIN operations
- Implement proper subquery optimization
- Create efficient aggregation queries
- Use EXPLAIN to analyze query execution plans
- Implement proper sorting and filtering
- Create pagination with LIMIT efficiently
- Use query profiling
- Implement proper query rewriting

Performance Tuning:
- Configure appropriate buffer pool size
- Implement proper thread and connection settings
- Create effective query cache configuration
- Use appropriate log settings
- Implement proper temporary table configuration
- Create efficient sort buffer settings
- Use proper join buffer size
- Implement slow query logging and analysis

Transaction Management:
- Use appropriate isolation levels
- Implement proper transaction boundaries
- Create effective locking strategies
- Use row-level locking effectively
- Implement deadlock prevention
- Create proper transaction monitoring
- Use optimistic or pessimistic concurrency
- Implement proper error handling

Replication and High Availability:
- Create proper master-slave replication
- Implement group replication when appropriate
- Use binary log configuration effectively
- Create proper failover procedures
- Implement read/write splitting
- Create effective replication monitoring
- Use proper replication filtering
- Implement semi-synchronous replication

Security Considerations:
- Use parameterized queries to prevent SQL injection
- Implement proper user management
- Create appropriate privileges
- Use TLS/SSL for encrypted connections
- Implement proper authentication methods
- Create secure configuration settings
- Use encryption for sensitive data
- Implement proper auditing

Backup and Recovery:
- Create proper backup strategies
- Implement mysqldump effectively
- Use binary log backup
- Create point-in-time recovery capabilities
- Implement proper backup verification
- Use appropriate backup compression
- Create automated backup solutions
- Implement proper restore testing

Monitoring and Maintenance:
- Use performance_schema for monitoring
- Implement proper table maintenance
- Create alerts for critical metrics
- Use appropriate monitoring tools
- Implement regular ANALYZE TABLE operations
- Create proper index statistics updates
- Use proactive server monitoring
- Implement performance baselines

Scaling Strategies:
- Create effective read replicas
- Implement proper connection pooling
- Use sharding when appropriate
- Create effective caching strategies
- Implement proper load balancing
- Use database proxies when needed
- Create vertical and horizontal scaling strategies
- Implement proper capacity planning

Stored Procedures and Functions:
- Create modular and reusable procedures
- Implement proper error handling
- Use appropriate parameter conventions
- Create effective cursors (sparingly)
- Implement proper variable handling
- Use security considerations
- Create appropriate transaction handling
- Implement proper logging

Working with Large Datasets:
- Use proper bulk insert techniques
- Implement effective partitioning strategies
- Create appropriate archiving solutions
- Use efficient data export/import methods
- Implement proper handling of temporary tables
- Create effective batch processing
- Use proper ETL processes
- Implement efficient data purging strategies