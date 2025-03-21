---
description: "Best practices for Amazon DynamoDB design, querying, and management"
globs: "*.js,*.ts,*.py,*.java,*.json,*.yaml,*.yml"
---

# Amazon DynamoDB Best Practices

## Key Principles

- Design for single-table patterns whenever possible
- Implement efficient access patterns with proper key design
- Apply proper capacity management and provisioning
- Utilize appropriate DynamoDB features for different use cases
- Implement cost-effective data storage and retrieval strategies
- Create robust backup and disaster recovery procedures

## Data Modeling

- Design tables to support access patterns
- Use single-table design for related entities
- Implement sparse indexes for selective queries
- Use composite sort keys for hierarchical data
- Create GSIs and LSIs for flexible querying
- Minimize table count to reduce management overhead
- Implement proper partition key selection to avoid hot partitions
- Use item collections for related data
- Apply appropriate normalization/denormalization strategies
- Document data model design decisions

## Key Design

- Choose high-cardinality partition keys
- Implement composite sort keys for data hierarchy
- Use uniform partition key distribution
- Design for efficient query patterns
- Implement effective filtering strategies
- Create secondary indexes for alternative access patterns
- Use overloaded indexes for multi-entity tables
- Implement version attributes for optimistic locking
- Add TTL attributes for automatic item expiration
- Document key design rationale

## Query Optimization

- Minimize API calls with BatchGetItem and BatchWriteItem
- Use query operations instead of scans
- Apply filtering at the database level
- Implement pagination for large result sets
- Use projection expressions to limit attributes returned
- Leverage parallel scans for large tables
- Implement efficient conditional operations
- Use transactional operations when appropriate
- Optimize for read/write capacity consumption
- Monitor and analyze query performance

## Capacity Management

- Choose appropriate capacity mode (on-demand vs. provisioned)
- Implement auto-scaling for provisioned capacity
- Monitor and optimize capacity consumption
- Use reserved capacity for predictable workloads
- Implement proper retry with exponential backoff
- Apply adaptive capacity strategies
- Implement effective burst capacity management
- Monitor throttling events and adjust capacity
- Create capacity forecasting processes
- Document capacity management strategies

## Security Practices

- Implement fine-grained access control with IAM
- Use VPC endpoints for enhanced security
- Encrypt data at rest and in transit
- Implement proper conditional expressions for data integrity
- Apply attribute-based access control when needed
- Use temporary credentials for application access
- Implement secure API access patterns
- Regularly audit access and operations
- Follow principle of least privilege
- Document security configurations

## Operational Excellence

- Implement proper monitoring with CloudWatch
- Create appropriate alarms for critical metrics
- Use DynamoDB Streams for event-driven architectures
- Implement proper backup and restore procedures
- Apply point-in-time recovery for critical data
- Create effective disaster recovery processes
- Monitor costs and optimize resource usage
- Implement proper error handling and resilience
- Use global tables for multi-region availability
- Document operational procedures
