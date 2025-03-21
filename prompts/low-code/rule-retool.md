---
description: "Guidelines for building effective and maintainable internal tools with Retool"
globs: "*.js,*.sql,*.json"
---

# Retool Best Practices

## Application Architecture

- Organize applications by business domain or function
- Design clear navigation flows between related tools
- Implement proper page organization within applications
- Consider modular design with reusable components
- Design for appropriate permissions and access controls
- Document application architecture and dependencies
- Implement consistent design patterns across applications
- Consider user workflow optimization
- Design for appropriate data refresh patterns
- Document integration points with other systems

## Component Design

- Use consistent naming conventions for components
- Group related components using containers
- Implement proper layout techniques for responsive design
- Consider component visibility rules for dynamic interfaces
- Design for appropriate loading states
- Implement error handling at the component level
- Use consistent styling across components
- Document component purpose and behavior
- Consider accessibility requirements
- Design for appropriate component interactions

## Query Management

- Use clear naming conventions for queries
- Organize queries by function or resource
- Implement proper error handling for all queries
- Design for appropriate caching strategies
- Use parameterized queries for security
- Document query purpose and expected results
- Consider query performance optimization
- Implement appropriate trigger conditions
- Design for proper query dependencies
- Consider pagination for large result sets

## Data Transformations

- Use transformer functions for complex data manipulation
- Implement proper error handling in transformers
- Design for reusable transformation functions
- Document transformation logic clearly
- Consider performance implications of complex transformations
- Use appropriate JavaScript practices in transformers
- Implement input validation in transformers
- Design for testable transformation functions
- Consider data type handling in transformations
- Document edge cases and special handling

## State Management

- Use app-level state for shared data
- Implement component-level state for local interactions
- Design for proper state synchronization
- Consider temporary state management
- Document state dependencies between components
- Implement appropriate state initialization
- Design for state persistence when needed
- Consider URL parameters for shareable state
- Implement proper state reset mechanisms
- Document state flow and lifecycle

## Security and Access Control

- Implement proper resource-level permissions
- Design for appropriate role-based access control
- Consider data filtering based on user permissions
- Implement sensitive data handling best practices
- Design for proper authentication requirements
- Document security controls and assumptions
- Consider audit logging for sensitive operations
- Implement proper query parameterization
- Design for least privilege access
- Consider security testing methodologies

## Database Integration

- Use connection pooling for database resources
- Implement proper query parameterization
- Design for appropriate transaction management
- Consider database performance optimization
- Document database schema dependencies
- Implement proper error handling for database operations
- Design for appropriate database credentials management
- Consider database connection timeouts
- Implement proper connection release
- Document database version requirements

## API Integration

- Use resource creation for reusable API connections
- Implement proper authentication handling
- Design for appropriate error handling
- Consider rate limiting strategies
- Document API dependencies and versions
- Implement proper retry handling
- Design for API versioning
- Consider API response caching
- Implement proper header management
- Document API integration patterns

## Performance Optimization

- Implement appropriate query caching
- Design for efficient data loading patterns
- Consider pagination for large data sets
- Implement proper component loading optimization
- Design for network efficiency
- Consider browser performance optimization
- Document performance requirements and constraints
- Implement proper loading states
- Design for appropriate refresh strategies
- Consider query parallelization when appropriate

## Testing and Validation

- Implement manual testing procedures
- Design for testability
- Consider automated testing where possible
- Implement proper input validation
- Design for edge case handling
- Document testing procedures
- Consider user acceptance testing
- Implement proper error validation
- Design for regression testing
- Document known limitations

## Version Control and Deployment

- Use Git for version control
- Implement proper branching strategies
- Design for appropriate release management
- Consider environment-specific configurations
- Document deployment procedures
- Implement proper backup strategies
- Design for rollback procedures
- Consider continuous integration
- Implement proper testing before deployment
- Document versioning strategy

## Documentation

- Create clear user documentation
- Implement inline documentation for complex logic
- Design for self-documenting interfaces where possible
- Consider video tutorials for complex workflows
- Document admin procedures
- Implement proper change documentation
- Design for knowledge transfer
- Consider automated documentation generation
- Implement proper component and query naming
- Document integration points and dependencies

## Collaboration

- Implement proper team access controls
- Design for collaborative development
- Consider code review processes
- Document team responsibilities
- Implement proper communication channels
- Design for knowledge sharing
- Consider pair programming for complex features
- Implement proper version history
- Design for conflict resolution
- Document collaboration guidelines

## Monitoring and Observability

- Implement proper error tracking
- Design for performance monitoring
- Consider user analytics
- Document monitoring requirements
- Implement proper logging
- Design for observability
- Consider alerting for critical issues
- Implement usage tracking
- Design for diagnostics
- Document troubleshooting procedures

## Mobile and Responsive Design

- Design interfaces for multiple screen sizes
- Implement proper mobile interaction patterns
- Consider touch interfaces
- Document responsive behavior
- Implement proper component layout for mobile
- Design for appropriate loading strategies on mobile
- Consider offline capabilities when needed
- Implement proper testing across devices
- Design for consistent user experience
- Document mobile-specific features and limitations