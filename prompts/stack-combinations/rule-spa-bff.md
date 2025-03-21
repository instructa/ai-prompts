---
description: "Guidelines for implementing the Single Page Application (SPA) with Backend-For-Frontend (BFF) architecture pattern"
globs: "*.js,*.ts,*.jsx,*.tsx,*.vue,*.svelte"
---

# SPA + BFF Pattern Best Practices

## Architecture Design

- Design clear separation between SPA and BFF components
- Implement proper API contract between frontend and BFF
- Design BFF specific to frontend requirements
- Consider proper domain modeling across layers
- Implement appropriate caching strategies
- Design for proper error handling propagation
- Document architecture decisions and patterns
- Consider multiple BFFs for different client types when appropriate
- Implement proper service discovery when needed
- Design for appropriate scaling characteristics

## SPA Implementation

- Choose appropriate frontend framework (React, Vue, Angular, etc.)
- Implement proper state management
- Design for appropriate routing strategy
- Consider code splitting for performance
- Implement proper error boundaries
- Design for accessibility compliance
- Document component architecture
- Consider internationalization requirements
- Implement proper loading states
- Design for appropriate client-side validation

## BFF Implementation

- Implement focused API tailored to frontend needs
- Design for appropriate data aggregation
- Consider proper authorization handling
- Implement request validation
- Design for appropriate error mapping
- Document API contracts
- Consider performance optimization at the BFF layer
- Implement logging and monitoring
- Design for appropriate dependency management
- Consider rate limiting and throttling

## API Design

- Implement consistent API design patterns
- Design for appropriate versioning strategy
- Consider proper resource naming
- Implement appropriate HTTP methods
- Design for proper status code usage
- Document API endpoints thoroughly
- Consider appropriate pagination patterns
- Implement proper filtering and sorting
- Design for appropriate content negotiation
- Consider GraphQL for complex data requirements

## Authentication and Authorization

- Implement proper authentication mechanisms
- Design for token-based authentication
- Consider appropriate token storage
- Implement proper authorization at BFF layer
- Design for appropriate role-based access control
- Document authentication flows
- Consider refresh token strategies
- Implement proper session management
- Design for cross-domain authentication if needed
- Consider authentication provider integration

## Performance Optimization

- Implement proper caching at multiple layers
- Design for appropriate bundling and minification
- Consider server-side rendering when appropriate
- Implement resource hints for faster loading
- Design for appropriate data prefetching
- Document performance requirements and metrics
- Consider lazy loading for components and routes
- Implement proper image optimization
- Design for appropriate client-side caching
- Consider performance monitoring

## Testing Strategy

- Implement proper unit testing for all components
- Design for integration testing across boundaries
- Consider end-to-end testing for critical flows
- Implement proper API contract testing
- Design for appropriate mocking strategies
- Document testing approach and coverage
- Consider performance testing for critical endpoints
- Implement security testing
- Design for appropriate test data management
- Consider automated testing in CI/CD

## Security

- Implement proper CSRF protection
- Design for appropriate CORS configuration
- Consider Content Security Policy implementation
- Implement proper input validation at all layers
- Design for appropriate output encoding
- Document security controls
- Consider security headers configuration
- Implement proper sensitive data handling
- Design for secure communication (HTTPS)
- Consider regular security assessments

## Deployment and DevOps

- Implement proper CI/CD pipelines
- Design for containerization when appropriate
- Consider infrastructure as code
- Implement proper environment configuration
- Design for zero-downtime deployments
- Document deployment procedures
- Consider feature flagging for controlled rollouts
- Implement proper monitoring and alerts
- Design for appropriate scaling strategies
- Consider blue-green or canary deployments

## Error Handling and Logging

- Implement consistent error handling across layers
- Design for appropriate error propagation
- Consider user-friendly error messaging
- Implement proper error logging
- Design for appropriate error aggregation
- Document error handling patterns
- Consider centralized error monitoring
- Implement proper retry strategies
- Design for graceful degradation
- Consider fallback mechanisms

## Monitoring and Observability

- Implement proper health checks
- Design for appropriate metrics collection
- Consider distributed tracing
- Implement proper logging strategy
- Design for appropriate alerting
- Document monitoring setup
- Consider user behavior analytics
- Implement proper performance tracking
- Design for appropriate operational visibility
- Consider real user monitoring

## State Management

- Choose appropriate state management patterns
- Implement clear data flow architecture
- Design for appropriate local vs. server state
- Consider optimistic updates when appropriate
- Implement proper state persistence
- Document state management approach
- Consider state synchronization strategies
- Implement proper form state management
- Design for appropriate shared state patterns
- Consider immutability patterns

## Data Fetching and Caching

- Implement proper data fetching strategies
- Design for appropriate loading states
- Consider declarative data fetching
- Implement proper request deduplication
- Design for appropriate invalidation strategies
- Document caching policies
- Consider background data refreshing
- Implement proper pagination handling
- Design for appropriate retry logic
- Consider prefetching strategies

## Code Organization

- Implement clear module boundaries
- Design for appropriate separation of concerns
- Consider proper dependency management
- Implement consistent coding conventions
- Design for appropriate reusability
- Document code organization principles
- Consider monorepo vs. multiple repositories
- Implement proper shared code strategies
- Design for appropriate package organization
- Consider code generation when appropriate

## Backend Integration

- Design clear service boundaries
- Implement proper service integration patterns
- Consider appropriate communication protocols
- Design for appropriate service discovery
- Implement proper error handling for service integration
- Document service dependencies
- Consider service versioning strategy
- Implement proper timeout handling
- Design for resilience against service failures
- Consider circuit breaker patterns