---
description: "Guidelines for implementing comprehensive observability with metrics, logging, and tracing for modern applications and infrastructure"
globs: "*.yaml,*.yml,*.json,*.js,*.ts,*.py"
---

# Observability Stack Best Practices

## Architecture Design

- Implement the three pillars of observability: metrics, logs, and traces
- Design for appropriate data collection strategies
- Consider appropriate storage solutions for different data types
- Implement proper data retention policies
- Design for appropriate scaling of observability components
- Document observability architecture
- Consider appropriate integration between observability systems
- Implement proper security controls for observability data
- Design for appropriate data correlation
- Consider appropriate alerting architecture

## Metrics Collection

- Implement proper instrumentation for applications
- Design for appropriate metric naming conventions
- Consider cardinality management
- Implement appropriate metric types (counter, gauge, histogram)
- Design for proper tagging and labeling
- Document metrics collection approach
- Consider appropriate collection intervals
- Implement proper aggregation methods
- Design for appropriate metric metadata
- Consider cost optimization for metric storage

## Logging Implementation

- Implement structured logging patterns
- Design for appropriate log levels
- Consider proper log sampling strategies
- Implement standardized logging formats (JSON, etc.)
- Design for appropriate log transportation
- Document logging standards
- Consider log enrichment approaches
- Implement proper log correlation
- Design for appropriate log parsing
- Consider log retention and archiving strategies

## Distributed Tracing

- Implement proper trace context propagation
- Design for appropriate sampling strategies
- Consider proper service naming conventions
- Implement standardized span attributes
- Design for appropriate trace visualization
- Document tracing implementation
- Consider appropriate trace exporters
- Implement proper error and exception tracking
- Design for appropriate trace filtering
- Consider trace analytics capabilities

## Tool Selection

- Choose appropriate observability tools (Prometheus, Grafana, OpenTelemetry, etc.)
- Implement proper tool integration
- Design for appropriate tool redundancy
- Consider vendor lock-in mitigation strategies
- Implement proper tool version management
- Document tool selection rationale
- Consider open source vs. commercial solutions
- Implement proper tool backup strategies
- Design for appropriate tool security
- Consider total cost of ownership

## Alerting and Notification

- Implement proper alerting rules
- Design for appropriate alerting thresholds
- Consider alert fatigue mitigation
- Implement proper alert routing
- Design for appropriate escalation policies
- Document alerting strategy
- Consider on-call rotation management
- Implement proper alert aggregation
- Design for appropriate alert severity levels
- Consider automated incident response

## Dashboard Design

- Implement proper dashboard organization
- Design for appropriate visualization types
- Consider dashboard performance
- Implement proper dashboard templating
- Design for appropriate user targeting (operators, developers, business)
- Document dashboard usage
- Consider appropriate refresh rates
- Implement proper dashboard permissions
- Design for appropriate drill-down capabilities
- Consider user experience in dashboard design

## Service Level Objectives (SLOs)

- Implement proper SLO definitions
- Design for appropriate SLI selection
- Consider error budget policies
- Implement proper SLO tracking
- Design for appropriate SLO visualization
- Document SLO approach
- Consider appropriate timeframes for SLOs
- Implement proper stakeholder communication
- Design for appropriate SLO alerting
- Consider SLO-driven development practices

## Application Instrumentation

- Implement standardized instrumentation libraries
- Design for appropriate auto-instrumentation
- Consider proper instrumentation testing
- Implement appropriate performance overhead management
- Design for appropriate context propagation
- Document instrumentation patterns
- Consider custom instrumentation needs
- Implement proper instrumentation versioning
- Design for appropriate sampling strategies
- Consider instrumentation observability

## Infrastructure Monitoring

- Implement proper infrastructure metrics collection
- Design for appropriate resource utilization monitoring
- Consider capacity planning metrics
- Implement proper network monitoring
- Design for appropriate platform-specific monitoring
- Document infrastructure monitoring approach
- Consider infrastructure health checking
- Implement proper dependency monitoring
- Design for appropriate cloud service monitoring
- Consider container and orchestration platform monitoring

## Anomaly Detection

- Implement appropriate anomaly detection algorithms
- Design for proper baseline establishment
- Consider seasonal patterns in detection
- Implement proper anomaly classification
- Design for appropriate false positive management
- Document anomaly detection approach
- Consider machine learning for complex patterns
- Implement proper anomaly prioritization
- Design for appropriate anomaly correlation
- Consider automated remediation for known anomalies

## Cost Management

- Implement proper resource allocation for observability
- Design for appropriate data sampling
- Consider data compression strategies
- Implement proper data retention policies
- Design for appropriate cardinality limits
- Document cost optimization strategies
- Consider multi-tier storage approaches
- Implement proper usage monitoring
- Design for appropriate cost attribution
- Consider observability ROI measurement

## Security and Compliance

- Implement proper access controls for observability data
- Design for appropriate data encryption
- Consider sensitive data handling
- Implement proper audit logging
- Design for appropriate compliance requirements
- Document security controls
- Consider privacy regulations
- Implement proper data masking and anonymization
- Design for appropriate retention policies
- Consider security observability

## Scaling and Performance

- Implement proper horizontal scaling for observability components
- Design for appropriate resource allocation
- Consider high-availability configurations
- Implement proper performance testing
- Design for appropriate data partitioning
- Document scaling patterns
- Consider performance impact of observability
- Implement proper caching strategies
- Design for appropriate query optimization
- Consider distributed deployment models

## Integration and Correlation

- Implement proper correlation between metrics, logs, and traces
- Design for appropriate data enrichment
- Consider unified querying capabilities
- Implement proper contextual linking
- Design for appropriate root cause analysis
- Document correlation patterns
- Consider causal relationship visualization
- Implement proper service dependency mapping
- Design for appropriate business context integration
- Consider user session tracking