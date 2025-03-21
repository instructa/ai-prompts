---
description: "Guidelines for building robust, efficient, and secure GraphQL API architectures"
globs: "*.graphql,*.gql,*.js,*.ts,*.py"
---

# GraphQL API Stack Best Practices

## Schema Design

- Design schema from the client's perspective
- Use descriptive and consistent naming conventions
- Implement proper type definitions with clear fields
- Use interfaces and unions for polymorphic types
- Consider pagination patterns (cursor-based vs. offset)
- Implement proper nullability constraints
- Design mutations with appropriate input types
- Use enums for fixed value sets
- Document schema with descriptions
- Consider schema modularity for larger applications

## Resolvers and Data Fetching

- Implement efficient resolver patterns
- Use dataloader for batching and caching
- Consider resolver complexity and performance
- Implement proper error handling in resolvers
- Design for appropriate data source abstractions
- Consider parallel execution of resolvers
- Implement proper context management
- Use appropriate resolver composition patterns
- Document resolver behavior and dependencies
- Consider resolver-specific caching strategies

## Authentication and Authorization

- Implement proper authentication mechanisms
- Design field-level authorization when appropriate
- Consider directive-based permission controls
- Implement proper user context management
- Design for appropriate token validation
- Consider role-based access control
- Implement proper error messaging for auth failures
- Design for appropriate scope management
- Document authentication requirements
- Consider JWT or session-based authentication approaches

## Performance Optimization

- Implement query complexity analysis
- Use pagination for large result sets
- Consider field selection optimization
- Implement proper caching strategies
- Design for appropriate batching of operations
- Consider persisted queries for production
- Implement proper execution timeout handling
- Design for optimized nested resolution
- Document performance characteristics
- Consider query optimization tools and techniques

## Server Implementation

- Choose appropriate GraphQL server implementation
- Configure proper execution options
- Implement subscription support when needed
- Design for appropriate error formatting
- Consider request lifecycle hooks
- Implement proper logging and monitoring
- Design for scalability and high availability
- Document server configuration
- Consider containerization and deployment strategies
- Implement proper health checks

## Client Integration

- Use strongly typed client libraries
- Implement proper client-side caching
- Consider optimistic UI updates
- Design for appropriate error handling
- Implement proper loading states
- Consider query management patterns
- Design for offline support when appropriate
- Document client integration patterns
- Consider code generation for type safety
- Implement proper request retry strategies

## Testing

- Implement schema validation tests
- Design for proper resolver unit testing
- Implement integration tests for full queries
- Consider performance testing for complex queries
- Design for proper mocking of data sources
- Implement security testing for GraphQL endpoints
- Document testing methodologies
- Consider snapshot testing for schema
- Implement proper CI/CD integration
- Design for proper test coverage metrics

## Security

- Implement proper query depth limiting
- Design for appropriate complexity limits
- Consider rate limiting strategies
- Implement introspection control for production
- Design for proper input validation
- Consider injection prevention in resolvers
- Implement proper error masking in production
- Document security controls
- Consider authorization testing
- Implement proper audit logging

## Monitoring and Observability

- Implement proper query performance monitoring
- Design for appropriate logging
- Consider distributed tracing integration
- Implement error tracking and reporting
- Design for appropriate metrics collection
- Document monitoring setup
- Consider automated alerting for issues
- Implement proper request tracking
- Design for appropriate operational visibility
- Consider APM integration

## Versioning and Evolution

- Implement schema versioning strategy
- Design for backward compatibility
- Consider deprecation strategies
- Implement proper schema change management
- Design for schema evolution without breaking changes
- Document versioning approach
- Consider feature flagging for schema changes
- Implement proper communication of schema changes
- Design for appropriate schema documentation
- Consider schema registry integration

## Caching Strategies

- Implement appropriate HTTP caching
- Design for resolver-level caching
- Consider distributed caching solutions
- Implement proper cache invalidation strategies
- Design for appropriate cache TTL management
- Document caching approach
- Consider partial query caching
- Implement proper cache warming strategies
- Design for cache versioning
- Consider edge caching for global deployments

## Error Handling

- Design consistent error formatting
- Implement proper error classification
- Consider error codes and categories
- Design for appropriate error localization
- Implement proper error logging
- Document error handling approach
- Consider retry strategies for transient errors
- Implement proper user-facing error messages
- Design for graceful degradation
- Consider partial results with errors

## Subscriptions

- Implement appropriate transport protocols
- Design for scalable subscription architecture
- Consider proper connection management
- Implement appropriate filtering
- Design for subscription authorization
- Document subscription patterns
- Consider rate limiting for subscriptions
- Implement proper connection lifecycle management
- Design for appropriate reconnection strategies
- Consider serverless subscription challenges

## Federation and Microservices

- Design proper schema stitching or federation
- Implement clear service boundaries
- Consider type ownership and namespace management
- Design for appropriate service discovery
- Implement proper gateway configuration
- Document service dependencies
- Consider authentication handling across services
- Implement proper error propagation
- Design for appropriate service versioning
- Consider service health management

## Development Workflow

- Implement schema-first or code-first approach consistently
- Design for proper development environments
- Consider schema validation in CI/CD
- Implement proper documentation generation
- Design for appropriate IDE integration
- Document development workflow
- Consider schema change review process
- Implement proper local development experience
- Design for appropriate testing workflow
- Consider mocking tools for development