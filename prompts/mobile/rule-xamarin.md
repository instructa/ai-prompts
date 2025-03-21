---
description: "Guidelines for building efficient, maintainable, and cross-platform mobile applications with Xamarin"
globs: "*.cs,*.xaml,*.csproj,*.json"
---

# Xamarin Best Practices

## Architecture Design

- Implement MVVM (Model-View-ViewModel) pattern
- Design for appropriate separation of concerns
- Consider dependency injection
- Implement proper service abstraction
- Design for testability
- Document architecture decisions
- Consider repository pattern for data access
- Implement proper cross-platform abstractions
- Design for appropriate code sharing
- Consider appropriate architecture for platform-specific features

## Code Organization

- Implement proper project structure
- Design for appropriate use of shared code
- Consider partial classes where appropriate
- Implement proper namespace organization
- Design for appropriate resource management
- Document code organization principles
- Consider modular development approach
- Implement proper interface-based design
- Design for appropriate extension methods
- Consider appropriate use of generators and analyzers

## Cross-Platform Development

- Implement shared business logic
- Design for appropriate platform abstraction
- Consider Custom Renderers for platform-specific UI
- Implement proper Effects for UI customization
- Design for appropriate resource sharing
- Document cross-platform strategy
- Consider DependencyService for platform-specific implementations
- Implement proper platform conditionals
- Design for appropriate feature parity
- Consider performance implications of abstractions

## UI Implementation

- Implement proper XAML organization
- Design for appropriate styles and themes
- Consider proper resource dictionaries
- Implement proper control templating
- Design for appropriate layout performance
- Document UI architecture
- Consider XAML compilation for performance
- Implement proper data binding
- Design for appropriate animation implementation
- Consider accessibility requirements

## Performance Optimization

- Implement proper list virtualization
- Design for appropriate image optimization
- Consider memory management best practices
- Implement proper layout optimization
- Design for appropriate startup performance
- Document performance bottlenecks and solutions
- Consider background threading for intensive operations
- Implement proper app size optimization
- Design for appropriate resource cleanup
- Consider profiling and monitoring tools

## Testing Strategy

- Implement proper unit testing for shared code
- Design for appropriate UI testing
- Consider test-driven development
- Implement proper mocking strategies
- Design for appropriate test organization
- Document testing approach
- Consider platform-specific testing
- Implement proper integration testing
- Design for appropriate test coverage metrics
- Consider automated UI testing tools

## Native Integration

- Implement proper platform-specific code
- Design for appropriate platform feature access
- Consider dependency management for native libraries
- Implement proper permissions handling
- Design for appropriate device feature detection
- Document native integration patterns
- Consider platform version compatibility
- Implement proper native UI integration
- Design for appropriate native performance optimization
- Consider security implications of native access

## Data Management

- Implement proper local storage strategies
- Design for appropriate offline capabilities
- Consider data synchronization approaches
- Implement proper caching strategies
- Design for appropriate data serialization
- Document data architecture
- Consider secure storage for sensitive data
- Implement proper data validation
- Design for appropriate data compression
- Consider database performance optimization

## Dependency Management

- Implement proper NuGet package management
- Design for appropriate version constraints
- Consider dependency conflicts resolution
- Implement proper third-party library evaluation
- Design for appropriate build configuration
- Document dependency management approach
- Consider dependency update strategy
- Implement proper license compliance
- Design for appropriate dependency isolation
- Consider security implications of dependencies

## Resource Management

- Implement proper image asset management
- Design for appropriate localization strategy
- Consider right-to-left language support
- Implement proper font management
- Design for appropriate theme resources
- Document resource organization
- Consider scalable asset strategies for different densities
- Implement proper resource cleanup
- Design for appropriate resource access patterns
- Consider build-time resource optimization

## Error Handling

- Implement proper exception handling
- Design for appropriate error logging
- Consider crash reporting integration
- Implement proper user feedback for errors
- Design for appropriate retry mechanisms
- Document error handling strategy
- Consider graceful degradation
- Implement proper validation to prevent errors
- Design for appropriate debugging support
- Consider remote error monitoring

## Navigation

- Implement proper navigation patterns
- Design for appropriate deep linking support
- Consider navigation state preservation
- Implement proper back button handling
- Design for appropriate modal presentations
- Document navigation architecture
- Consider nested navigation scenarios
- Implement proper navigation parameters
- Design for appropriate navigation animations
- Consider accessibility in navigation flow

## Security

- Implement proper data encryption
- Design for appropriate authentication patterns
- Consider secure communication
- Implement proper certificate pinning
- Design for appropriate permission handling
- Document security controls
- Consider secure storage for sensitive data
- Implement proper input validation
- Design for appropriate session management
- Consider security testing integration

## Deployment and DevOps

- Implement proper build pipeline
- Design for appropriate environment configuration
- Consider CI/CD integration
- Implement proper app signing
- Design for appropriate versioning strategy
- Document release procedures
- Consider beta testing distribution
- Implement proper build optimization
- Design for appropriate app store compliance
- Consider automated deployment

## Monitoring and Analytics

- Implement proper application monitoring
- Design for appropriate analytics collection
- Consider performance monitoring
- Implement proper crash reporting
- Design for appropriate user behavior tracking
- Document monitoring approach
- Consider A/B testing integration
- Implement proper feature usage tracking
- Design for appropriate consent management
- Consider privacy implications of tracking

## Accessibility

- Implement proper screen reader support
- Design for appropriate color contrast
- Consider keyboard navigation
- Implement proper focus management
- Design for appropriate text scaling
- Document accessibility features
- Consider voice control support
- Implement proper semantic structure
- Design for appropriate touch targets
- Consider accessibility testing