---
description: "Guidelines for building effective web applications using headless CMS systems with modern frontend frameworks"
globs: "*.js,*.jsx,*.ts,*.tsx,*.vue,*.svelte,*.astro"
---

# Headless CMS + Frontend Best Practices

## Architecture Design

- Implement clear separation between content and presentation
- Design appropriate content models for your domain
- Consider proper API design for content delivery
- Implement appropriate caching strategies
- Design for content localization when needed
- Document architecture decisions and patterns
- Consider multiple frontend applications sharing content
- Implement proper content versioning strategy
- Design for appropriate environment separation
- Consider headless CMS selection based on requirements

## Content Modeling

- Design content types with reusability in mind
- Implement proper content relationships
- Consider appropriate field types for different content
- Design for content modularity and composition
- Implement proper validation rules
- Document content model structure and relationships
- Consider content governance requirements
- Design for appropriate content localization
- Implement proper asset management
- Consider SEO requirements in content modeling

## Headless CMS Implementation

- Choose appropriate headless CMS (Contentful, Strapi, Sanity, etc.)
- Implement proper content type definitions
- Design for appropriate user roles and permissions
- Consider webhook configuration for content changes
- Implement proper content validation
- Document CMS configuration and customization
- Consider appropriate backup strategies
- Design for proper content workflow
- Implement appropriate publishing mechanisms
- Consider migration strategy between environments

## Frontend Implementation

- Choose appropriate frontend framework (React, Vue, Svelte, etc.)
- Implement proper content fetching patterns
- Design for appropriate state management
- Consider static site generation vs. client-side fetching
- Implement proper loading states for content
- Document component architecture
- Consider code splitting for performance
- Implement proper error handling for content fetching
- Design for appropriate image handling
- Consider accessibility in frontend implementation

## API and Integration

- Design proper API integration with headless CMS
- Implement appropriate authentication for API access
- Consider rate limiting and API quotas
- Design for proper error handling in API calls
- Implement appropriate caching for API responses
- Document API integration patterns
- Consider GraphQL vs. REST for content API
- Implement proper retry mechanisms
- Design for appropriate API versioning
- Consider batching strategies for API requests

## Content Delivery

- Implement appropriate Content Delivery Network (CDN)
- Design for proper cache invalidation
- Consider edge caching strategies
- Implement preview environments for content
- Design for appropriate publishing workflows
- Document content delivery architecture
- Consider incremental static regeneration
- Implement proper cache headers
- Design for appropriate content refresh strategies
- Consider multi-region content delivery

## Authentication and Authorization

- Implement proper authentication for CMS users
- Design for appropriate role-based access control
- Consider authentication for frontend users when needed
- Implement proper API token management
- Design for appropriate content permissions
- Document authentication flows
- Consider single sign-on integration
- Implement proper session management
- Design for appropriate access audit logging
- Consider API key rotation strategies

## Performance Optimization

- Implement proper image optimization
- Design for appropriate lazy loading
- Consider asset optimization pipelines
- Implement proper bundling and minification
- Design for appropriate code splitting
- Document performance metrics and targets
- Consider performance monitoring
- Implement proper font loading strategies
- Design for Core Web Vitals optimization
- Consider performance budgets

## Testing

- Implement proper unit testing for frontend components
- Design for appropriate integration testing
- Consider content preview testing
- Implement visual regression testing
- Document testing approach and coverage
- Consider automated content validation
- Implement proper CI/CD for testing
- Design for appropriate test data management
- Consider performance testing
- Implement proper end-to-end testing

## Deployment and DevOps

- Implement proper CI/CD pipelines
- Design for appropriate environment configuration
- Consider infrastructure as code
- Implement proper build optimization
- Design for zero-downtime deployments
- Document deployment procedures
- Consider feature flagging for content features
- Implement proper monitoring and alerts
- Design for appropriate scaling strategies
- Consider automated deployment triggers on content changes

## SEO and Analytics

- Implement proper metadata management
- Design for appropriate structured data
- Consider sitemap generation
- Implement proper canonical URLs
- Design for appropriate social sharing metadata
- Document SEO strategy
- Consider analytics integration
- Implement proper event tracking
- Design for appropriate conversion tracking
- Consider SEO performance monitoring

## Multilingual and Localization

- Implement proper content localization strategy
- Design for appropriate locale selection
- Consider translation workflows
- Implement proper URL structure for locales
- Design for appropriate fallback locales
- Document localization approach
- Consider right-to-left language support
- Implement proper locale-specific formatting
- Design for appropriate content synchronization across locales
- Consider automatic translation tools integration

## Rich Media Handling

- Implement proper image optimization pipeline
- Design for responsive images
- Consider video content delivery
- Implement proper asset transformation
- Design for appropriate media organization
- Document media handling patterns
- Consider Digital Asset Management integration
- Implement proper media accessibility
- Design for appropriate media caching
- Consider media delivery optimization

## Content Migration

- Implement proper content migration tools
- Design for appropriate content transformation
- Consider incremental migration strategies
- Implement proper validation during migration
- Design for appropriate rollback mechanisms
- Document migration procedures
- Consider automated testing for migrated content
- Implement proper content mapping
- Design for appropriate URL handling during migration
- Consider content audit before and after migration

## Monitoring and Maintenance

- Implement proper uptime monitoring
- Design for appropriate error tracking
- Consider content health monitoring
- Implement proper performance monitoring
- Design for appropriate alerting
- Document maintenance procedures
- Consider automated content auditing
- Implement proper backup strategies
- Design for appropriate disaster recovery
- Consider content archiving strategies