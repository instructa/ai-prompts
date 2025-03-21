---
description: "Best practices for designing and implementing event-driven architectures and systems"
globs: "*.js,*.ts,*.java,*.cs,*.py,*.go,*.yaml,*.yml,*.json"
alwaysApply: false
---

# Event-Driven Architecture Best Practices

## Key Principles

- Design loosely coupled components connected through events
- Implement proper event schema and versioning
- Create effective event routing and delivery mechanisms
- Apply appropriate event storage and replay capabilities
- Utilize effective event processing patterns
- Implement proper error handling and resilience
- Design for scalability and elasticity in event processing

## Event Design

- Create clear event naming conventions
- Implement proper event schema design
- Apply appropriate event versioning
- Use effective event metadata
- Implement proper event payload structure
- Create immutable event records
- Apply appropriate event categorization
- Use proper event timestamps
- Implement effective correlation IDs
- Create comprehensive event documentation

## Event Production

- Implement proper event validation
- Create effective idempotent event publishing
- Apply appropriate event serialization
- Use effective retry mechanisms
- Implement proper event ordering when needed
- Create effective batching strategies
- Apply appropriate backpressure handling
- Use proper producer acknowledgment modes
- Implement effective event source pattern
- Create proper event routing strategies

## Event Consumption

- Implement effective consumer patterns
- Create proper consumer groups
- Apply appropriate parallel processing
- Use effective message filtering
- Implement proper offset management
- Create event replay capabilities
- Apply appropriate dead letter queues
- Use proper consumer acknowledgments
- Implement effective consumer scaling
- Create proper consumer monitoring

## Messaging Infrastructure

- Choose appropriate message broker technologies
- Implement proper queue/topic design
- Apply appropriate durability settings
- Use effective partitioning strategies
- Implement proper message retention policies
- Create effective delivery guarantees
- Apply appropriate high availability configurations
- Use proper security for messaging
- Implement effective monitoring for message brokers
- Create appropriate scaling strategies

## Event Processing Patterns

- Implement effective event stream processing
- Create proper command-query responsibility segregation (CQRS)
- Apply appropriate event sourcing
- Use effective saga patterns for transactions
- Implement proper complex event processing
- Create effective event-driven services
- Apply appropriate event handlers
- Use reactive programming models
- Implement proper materialized views
- Create effective state management

## Error Handling

- Implement proper dead letter queues
- Create effective retry policies
- Apply appropriate circuit breaker patterns
- Use proper error events
- Implement effective monitoring for failures
- Create proper fallback mechanisms
- Apply appropriate compensation strategies
- Use effective error logging
- Implement proper alerting for failures
- Create comprehensive troubleshooting guides

## Testing and Monitoring

- Implement proper event contract testing
- Create effective event simulation
- Apply appropriate integration testing
- Use proper event tracing
- Implement effective monitoring for event flows
- Create proper event visualization
- Apply appropriate event analytics
- Use proper performance testing
- Implement effective chaos testing
- Create comprehensive documentation
