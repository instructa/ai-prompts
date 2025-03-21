---
description: "Guidelines for developing maintainable and performant web applications using Bubble.io no-code platform"
globs: "*.js,*.json"
---

# Bubble.io Best Practices

## Application Structure

- Design a clear page hierarchy and navigation flow
- Organize reusable elements with proper naming conventions
- Implement a modular approach with reusable components
- Design for scalability from the beginning
- Create clear separation between data and presentation layers
- Implement proper responsive design principles
- Document application architecture and design decisions
- Consider user flow and experience in the structure
- Design for appropriate page access controls
- Create consistent UI patterns across the application

## Data Design

- Implement a well-structured data model with clear relationships
- Use consistent naming conventions for data types and fields
- Design for appropriate data privacy and access controls
- Implement data validation at the field level
- Create proper indexing for frequently queried fields
- Consider data migration strategy for future changes
- Document data model and relationships
- Design for appropriate data constraints
- Implement archiving strategy for historical data
- Consider performance implications of data structure

## Workflow Design

- Create modular and reusable workflows
- Implement proper error handling in all workflows
- Design for appropriate transaction management
- Use clear naming conventions for workflow steps
- Document workflow purpose and behavior
- Consider performance optimization for complex workflows
- Implement logging for critical workflow steps
- Design for appropriate workflow triggers
- Create conditional paths for different scenarios
- Consider workflow dependencies and ordering

## API Integration

- Use API Connector for external integrations
- Implement proper authentication handling
- Design for appropriate error handling
- Consider rate limiting strategies
- Document API dependencies and versions
- Create reusable API workflows
- Implement proper retry handling
- Design for API versioning compatibility
- Consider caching strategies for API responses
- Document API authentication requirements

## Performance Optimization

- Limit the use of recursive workflows
- Optimize database queries with proper constraints
- Use "Only when needed" for conditional elements
- Implement pagination for large data sets
- Consider server-side operations for complex calculations
- Optimize page load with proper initialization
- Design for efficient data loading patterns
- Implement appropriate caching strategies
- Document performance requirements and constraints
- Consider asynchronous operations when appropriate

## Security

- Implement proper privacy rules for all data types
- Design for appropriate user role permissions
- Use proper authentication mechanisms
- Consider data filtering based on user context
- Implement sensitive data handling best practices
- Design for proper input validation
- Document security controls and assumptions
- Consider audit logging for sensitive operations
- Implement secure API authentication
- Design for security testing

## Testing and QA

- Create comprehensive test plans
- Implement testing across different devices and browsers
- Design for testability with clear states
- Consider edge case testing
- Document testing procedures and results
- Implement user acceptance testing
- Design for regression testing
- Create automated testing where possible
- Consider load testing for critical features
- Document known limitations

## Version Control and Deployment

- Use version control with clear versioning strategy
- Implement proper staging and production environments
- Design for appropriate release management
- Create deployment checklists
- Document deployment procedures
- Implement proper backup strategies
- Design for rollback procedures
- Consider continuous integration approaches
- Implement proper testing before deployment
- Document versioning strategy

## Plugins and Third-Party Integration

- Evaluate plugins for stability and performance
- Document plugin dependencies and versions
- Consider plugin update strategies
- Implement proper plugin configuration
- Design for plugin fallback options
- Document plugin licensing requirements
- Consider plugin security implications
- Implement proper testing for plugin integration
- Design for plugin replacement strategy
- Document plugin support channels

## Frontend Design

- Use consistent design system and components
- Implement proper responsive breakpoints
- Design for accessibility compliance
- Consider mobile-first approach
- Implement proper loading states
- Design for appropriate form validation
- Create consistent error messaging
- Consider internationalization when needed
- Implement proper focus management
- Document design patterns and components

## Backend Optimization

- Design efficient database queries
- Implement appropriate indexing strategies
- Consider data denormalization for performance
- Design for appropriate caching
- Implement scheduled workflows for maintenance
- Consider database size management
- Document backend architecture
- Implement proper data backup strategies
- Design for database scaling
- Consider serverless function integration when appropriate

## User Management

- Implement proper user onboarding flows
- Design for appropriate authentication methods
- Consider social login integration when appropriate
- Implement proper password policies
- Design for user profile management
- Consider user roles and permissions
- Implement proper session management
- Design for account recovery
- Document user management procedures
- Consider compliance requirements

## Monitoring and Analytics

- Implement proper error tracking
- Design for performance monitoring
- Consider user analytics integration
- Document monitoring requirements
- Implement proper logging
- Design for observability
- Consider alerting for critical issues
- Implement usage tracking
- Design for diagnostics
- Document troubleshooting procedures

## Collaboration and Documentation

- Create comprehensive application documentation
- Implement proper naming conventions for all elements
- Design for team collaboration
- Consider access controls for team members
- Document development standards
- Implement change management procedures
- Design for knowledge transfer
- Consider code comments and documentation
- Implement proper version history
- Document team responsibilities

## Scalability and Growth

- Design for user growth from the beginning
- Implement proper database scaling strategy
- Consider performance at scale
- Design for feature expansion
- Implement appropriate architecture for scaling
- Document scaling considerations
- Consider infrastructure requirements for growth
- Design for appropriate capacity planning
- Implement monitoring for scale indicators
- Document growth strategy and milestones