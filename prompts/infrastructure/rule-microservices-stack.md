---
description: "Guidelines for designing, implementing, and managing microservices architectures"
globs: "*.yaml,*.yml,*.json,Dockerfile,docker-compose.yml"
---

# Microservices Architecture Stack Best Practices

## Architecture Design

- Design services around business capabilities
- Implement proper domain-driven design principles
- Define clear service boundaries and responsibilities
- Design for failure and resilience
- Implement proper service discovery mechanisms
- Use API gateways for client access
- Design for independent deployability
- Implement proper data ownership and consistency models
- Document architecture decisions and rationales
- Consider eventual consistency patterns for data

## Service Communication

- Choose appropriate communication patterns (REST, gRPC, messaging)
- Implement proper API versioning strategies
- Use asynchronous communication for decoupling
- Implement proper retry and circuit breaker patterns
- Design for backward compatibility
- Use message brokers for event-driven architectures
- Implement proper error handling in service communication
- Define clear API contracts
- Document communication patterns
- Consider using API management platforms

## Data Management

- Implement database-per-service when appropriate
- Choose appropriate data storage for each service
- Design for data consistency across services
- Implement event sourcing when appropriate
- Use CQRS pattern for complex domains
- Implement proper data migration strategies
- Design for data resilience and recovery
- Document data models and flows
- Implement proper data backup strategies
- Consider polyglot persistence based on service needs

## Containerization and Orchestration

- Use Docker for containerization
- Implement Kubernetes for orchestration
- Design for horizontal scaling
- Use appropriate resource allocation
- Implement proper health checks and probes
- Use stateless services when possible
- Configure appropriate auto-scaling
- Implement proper container security
- Document container and orchestration configurations
- Use Helm charts for deployment management

## Service Mesh

- Consider service mesh implementations (Istio, Linkerd, Consul)
- Implement traffic management capabilities
- Use service mesh for observability
- Implement proper security through service mesh
- Configure appropriate retry and timeout policies
- Design for proper traffic splitting for testing
- Document service mesh configuration
- Implement proper mesh deployment strategies
- Consider performance implications of service mesh
- Use mesh for cross-cutting concerns

## CI/CD and DevOps

- Implement automated CI/CD pipelines
- Use infrastructure as code
- Implement proper testing strategies
- Design for continuous deployment
- Use feature flags for safe releases
- Implement proper rollback strategies
- Use blue-green or canary deployments
- Document deployment procedures
- Implement proper release management
- Consider GitOps workflows

## Monitoring and Observability

- Implement distributed tracing
- Use proper logging strategies
- Implement metrics collection and visualization
- Design for proper alerting
- Use health checks for service status
- Implement proper error tracking
- Design for root cause analysis
- Document monitoring procedures
- Implement proper SLOs and SLIs
- Consider using observability platforms

## Security

- Implement proper authentication and authorization
- Use API security best practices
- Implement network security policies
- Design for proper secret management
- Use secure communication (TLS/mTLS)
- Implement proper role-based access control
- Design for security in depth
- Document security measures
- Implement proper security monitoring
- Consider using security scanning tools

## Resilience and Reliability

- Implement circuit breakers
- Design for graceful degradation
- Use bulkheads to isolate failures
- Implement proper timeout handling
- Design for retry with exponential backoff
- Use chaos engineering to test resilience
- Implement proper fallback mechanisms
- Document failure modes and recovery procedures
- Design for self-healing
- Consider implementing the Saga pattern for distributed transactions

## Scaling and Performance

- Design for horizontal scaling
- Implement proper caching strategies
- Use appropriate load balancing
- Design for performance testing
- Implement proper resource allocation
- Use asynchronous processing for long-running tasks
- Design for proper database scaling
- Document scaling procedures
- Implement proper performance monitoring
- Consider using CDNs for content delivery