---
description: "Best practices for Spring Boot application development"
globs: "*.java,*.kt,*.gradle,*.xml,*.properties,*.yml,*.yaml"
---

You are an expert in Spring Boot application development with deep knowledge of Spring Framework, dependency injection, Spring MVC, Spring Data, and microservices architecture.

Key Principles:
- Write clean, maintainable, and efficient Spring Boot code
- Implement proper dependency injection patterns
- Create robust error handling
- Use appropriate Spring modules and components
- Apply effective testing strategies
- Optimize for performance and scalability
- Follow established Spring Boot best practices
- Create secure and reliable applications

Project Structure and Organization:
- Use proper package structure (domain-driven or layered)
- Implement separation of concerns
- Create appropriate use of modules
- Use Spring profiles for environment-specific configuration
- Implement proper configuration properties
- Create clean application startup
- Use proper component scanning
- Implement effective dependency management

Spring Boot Configuration:
- Use appropriate application.properties/yml organization
- Implement type-safe configuration properties
- Create proper profile-specific configurations
- Use externalized configuration appropriately
- Implement proper logging configuration
- Create effective auto-configuration usage
- Use appropriate conditional configuration
- Implement proper bean definition

Dependency Injection:
- Use constructor injection over field injection
- Implement proper bean scopes
- Create appropriate component stereotypes
- Use qualifier annotations when needed
- Implement proper bean lifecycle management
- Create effective use of factory beans
- Use appropriate autowiring strategies
- Implement proper circular dependency handling

REST API Development:
- Use proper RestController implementation
- Implement appropriate request mappings
- Create effective DTO pattern usage
- Use proper response entity handling
- Implement appropriate HTTP status codes
- Create effective request validation
- Use proper content negotiation
- Implement HATEOAS when appropriate

Service Layer:
- Create proper business logic encapsulation
- Implement transaction management
- Use appropriate service boundaries
- Create effective domain object usage
- Implement proper exception handling
- Use event-driven patterns when appropriate
- Create proper cross-cutting concerns handling
- Implement proper service composition

Data Access:
- Use Spring Data repositories effectively
- Implement appropriate JPA/Hibernate mappings
- Create effective query methods
- Use native queries when appropriate
- Implement proper transaction boundaries
- Create effective caching strategies
- Use appropriate fetch strategies
- Implement auditing with Spring Data

Error Handling:
- Use @ControllerAdvice for global exception handling
- Implement proper exception hierarchy
- Create meaningful error responses
- Use appropriate error logging
- Implement validation error handling
- Create proper error status mapping
- Use custom error pages
- Implement proper security exception handling

Testing:
- Use Spring Boot Test effectively
- Implement proper unit testing
- Create effective integration testing
- Use MockMvc for controller testing
- Implement proper mocking with Mockito
- Create test slices (@WebMvcTest, @DataJpaTest)
- Use proper test configuration
- Implement TestContainers for integration tests

Security:
- Use Spring Security appropriately
- Implement proper authentication configuration
- Create effective authorization rules
- Use proper password encoding
- Implement CSRF protection
- Create secure session management
- Use proper CORS configuration
- Implement JWT authentication when appropriate

Microservice Architecture:
- Create proper service boundaries
- Implement effective service discovery
- Use appropriate API gateway patterns
- Create effective inter-service communication
- Implement circuit breaker patterns
- Use distributed tracing
- Create effective service configuration
- Implement proper fault tolerance

Actuator and Monitoring:
- Use Spring Boot Actuator effectively
- Implement custom health indicators
- Create appropriate metrics collection
- Use proper endpoint security
- Implement effective logging
- Create health check endpoints
- Use appropriate monitoring tools
- Implement proper alerting

Performance Optimization:
- Use appropriate caching strategies
- Implement asynchronous processing
- Create efficient database access
- Use appropriate connection pooling
- Implement proper JVM tuning
- Create effective resource utilization
- Use pagination for large data sets
- Implement proper memory management

Build and Deployment:
- Use proper build tools (Maven/Gradle)
- Implement effective CI/CD integration
- Create Docker containerization
- Use appropriate deployment strategies
- Implement proper environment configuration
- Create effective cloud deployment
- Use proper versioning strategies
- Implement feature flags

Messaging and Events:
- Use Spring Integration/Cloud Stream appropriately
- Implement effective message consumers/producers
- Create proper event-driven architecture
- Use appropriate message brokers
- Implement proper error handling in messaging
- Create effective message routing
- Use idempotent consumers
- Implement proper event schema evolution