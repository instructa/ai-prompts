---
description: "Best practices for MongoDB database design, querying, and management"
globs: "*.js,*.ts,*.py,*.java,*.json,*.mongodb"
---

# MongoDB Best Practices

## Key Principles

- Design schemas appropriate for document-oriented data models
- Implement efficient indexing strategies to optimize query performance
- Apply proper security practices for MongoDB deployments
- Utilize appropriate data modeling patterns for different use cases
- Implement effective query optimization techniques
- Create robust backup and recovery procedures

## Schema Design

- Design schemas to match access patterns
- Embed related data when it's accessed together
- Use references for large, independent sub-documents
- Avoid deeply nested document structures
- Consider document growth when designing schemas
- Use appropriate data types for fields
- Follow consistent naming conventions
- Include appropriate metadata in documents
- Create versioning strategies for schema evolution
- Document schema design decisions

## Indexing Strategy

- Create indexes to support common queries
- Use compound indexes for multi-field queries
- Add indexes for sort operations
- Implement text indexes for full-text search
- Create appropriate geospatial indexes for location data
- Avoid creating unnecessary indexes
- Use background indexing for production environments
- Monitor index size and usage
- Consider covered queries when designing indexes
- Regularly review and optimize indexes

## Query Optimization

- Use projection to limit returned fields
- Implement pagination for large result sets
- Apply appropriate filters early in query chains
- Use aggregation framework efficiently
- Understand and utilize query execution plans
- Leverage the explain() method for query analysis
- Avoid in-memory sorting for large datasets
- Implement proper query timeout strategies
- Use appropriate read concerns and write concerns
- Utilize read preferences for replica sets

## Security Practices

- Implement proper authentication mechanisms
- Use role-based access control
- Encrypt data at rest and in transit
- Implement network security measures
- Configure appropriate IP binding
- Apply field-level encryption for sensitive data
- Implement secure configuration practices
- Regularly audit access and operations
- Follow principle of least privilege
- Keep MongoDB updated to latest stable version

## Operational Best Practices

- Implement proper monitoring and alerting
- Use replica sets for high availability
- Configure appropriate write concern levels
- Implement proper backup strategies
- Schedule regular database maintenance
- Monitor performance metrics
- Implement proper logging configuration
- Plan for capacity and scaling
- Create disaster recovery procedures
- Document operational procedures
