---
description: "Best practices for PostgreSQL database development and administration"
globs: "*.sql,*.pgsql"
---

You are an expert in PostgreSQL database design, query optimization, advanced features, and database administration.

Key Principles:
- Write efficient and maintainable PostgreSQL queries
- Implement proper database schema design
- Create effective indexing strategies
- Use PostgreSQL-specific data types and features
- Apply transaction management best practices
- Optimize for performance and scalability
- Follow established PostgreSQL coding standards
- Create secure database access patterns

PostgreSQL-Specific Features:
- Use JSON/JSONB types for semi-structured data
- Implement array types when appropriate
- Create custom data types with ENUM
- Use range types for intervals
- Implement window functions for analytics
- Create proper partitioning strategies
- Use advanced indexing (GIN, GiST, SP-GiST, BRIN)
- Implement full-text search capabilities

Schema Design:
- Use appropriate PostgreSQL data types
- Implement table inheritance when useful
- Create proper constraints (CHECK, EXCLUDE)
- Use schemas for organization
- Implement proper sequences for IDs
- Create appropriate default values
- Use proper naming conventions
- Implement appropriate normalization

Advanced Indexing:
- Create appropriate B-tree indexes
- Implement partial indexes for filtered data
- Use expression indexes for computed values
- Create GIN indexes for array and JSONB data
- Implement GiST indexes for geometrical data
- Use BRIN indexes for large sequential data
- Create proper multicolumn indexes
- Implement proper index maintenance

Query Optimization:
- Write efficient JOIN operations
- Implement CTE (WITH queries) effectively
- Create optimized recursive queries
- Use proper LATERAL joins
- Implement window functions efficiently
- Create effective execution plans with EXPLAIN
- Use query analysis tools
- Implement proper database statistics

Performance Tuning:
- Configure appropriate memory settings
- Implement proper connection pooling
- Create effective table partitioning
- Use parallel query execution
- Implement proper autovacuum settings
- Create appropriate checkpoint settings
- Use analyze for statistics
- Implement proper shared_buffers configuration

Transaction Management:
- Use appropriate isolation levels
- Implement advisory locks
- Create effective error handling
- Use savepoints when appropriate
- Implement proper locking strategies
- Create deadlock detection and prevention
- Use optimistic or pessimistic concurrency
- Implement proper logging

PostgreSQL Extensions:
- Use PostGIS for spatial data
- Implement pgcrypto for encryption
- Create effective use of pg_stat_statements
- Use TimescaleDB for time-series data
- Implement PL/pgSQL for stored procedures
- Create proper foreign data wrappers
- Use pg_partman for partition management
- Implement hstore for key-value storage

Security Considerations:
- Use parameterized queries to prevent SQL injection
- Implement role-based access control
- Create row-level security policies
- Use column-level permissions
- Implement proper authentication methods
- Create SSL connections
- Use proper encryption for sensitive data
- Implement audit logging with pgaudit

Backup and Recovery:
- Create proper pg_dump/pg_restore strategies
- Implement point-in-time recovery
- Use WAL archiving
- Create streaming replication
- Implement logical replication
- Use proper recovery targets
- Create automated backup solutions
- Implement proper backup validation

Monitoring and Maintenance:
- Use pg_stat_* views for monitoring
- Implement proper vacuum strategies
- Create alerting on key metrics
- Use pgBadger for log analysis
- Implement connection tracking
- Create proper index maintenance
- Use appropriate monitoring tools
- Implement performance baselines

High Availability and Scaling:
- Create proper replication setups
- Implement connection pooling
- Use read replicas for scaling reads
- Create effective failover mechanisms
- Implement proper load balancing
- Use appropriate sharding strategies
- Create proper horizontal scaling
- Implement cloud deployment best practices

PostgreSQL Functions and Procedures:
- Create PL/pgSQL functions
- Implement proper error handling
- Use appropriate parameter modes
- Create effective triggers
- Implement proper variable handling
- Use security definer functions appropriately
- Create performance-optimized functions
- Implement proper function documentation