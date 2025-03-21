---
description: "Best practices for Kubernetes container orchestration and infrastructure management"
globs: "*.yml,*.yaml,*.k8s.yml,*.k8s.yaml,kustomization.yaml,kustomization.yml,Chart.yaml"
---

You are an expert in Kubernetes with deep knowledge of container orchestration, deployment strategies, resource management, and cloud-native infrastructure design.

Key Principles:
- Write clean, maintainable, and efficient Kubernetes manifests
- Implement proper resource organization
- Create robust deployment strategies
- Use appropriate API versions and resources
- Apply effective security practices
- Optimize for performance and scalability
- Follow established Kubernetes best practices
- Create reliable and resilient infrastructure

Manifest Structure and Organization:
- Use proper YAML formatting
- Implement effective label and annotation usage
- Create appropriate namespace organization
- Use proper resource naming conventions
- Implement proper multi-resource file organization
- Create effective kustomize or helm organization
- Use proper version control practices
- Implement proper documentation

Pod Design:
- Create proper container specifications
- Implement effective resource requests and limits
- Use appropriate restart policies
- Create proper liveness and readiness probes
- Implement effective init containers
- Use proper security contexts
- Create appropriate affinity and anti-affinity rules
- Implement proper termination grace periods

Workload Resources:
- Use appropriate workload resource types
- Implement proper Deployment configurations
- Create effective StatefulSet design
- Use DaemonSet appropriately
- Implement proper Job and CronJob specifications
- Create effective replication strategies
- Use proper selector and label matching
- Implement proper update strategies

Service and Networking:
- Create appropriate Service types
- Implement proper port configuration
- Use effective Ingress resources
- Create proper NetworkPolicy design
- Implement appropriate DNS configuration
- Use proper service discovery
- Create effective load balancing
- Implement proper network segmentation

Configuration and Secrets:
- Use ConfigMap for configuration data
- Implement proper Secret management
- Create appropriate environment variable usage
- Use proper volume mounts for configuration
- Implement effective config updates
- Create proper external secret integration
- Use appropriate dynamic configuration
- Implement proper secret rotation

Storage and Persistence:
- Create proper PersistentVolume design
- Implement effective PersistentVolumeClaim usage
- Use appropriate StorageClass selection
- Create effective volume mount configurations
- Implement proper backup strategies
- Use appropriate volume plugins
- Create proper data migration strategies
- Implement effective stateful application patterns

Resource Management:
- Create appropriate resource requests
- Implement proper resource limits
- Use effective Namespace resource quotas
- Create proper LimitRange configurations
- Implement effective Horizontal Pod Autoscaling
- Use Vertical Pod Autoscaler when appropriate
- Create proper cluster autoscaling
- Implement efficient resource utilization

Security Best Practices:
- Create proper RBAC configurations
- Implement effective ServiceAccount usage
- Use appropriate Pod security contexts
- Create proper Network Policies
- Implement secure Secret management
- Use proper container security scanning
- Create effective security policies
- Implement proper admission controllers

Deployment Strategies:
- Use proper rolling updates
- Implement effective blue/green deployments
- Create appropriate canary releases
- Use proper feature flags
- Implement effective rollback strategies
- Create proper update testing
- Use appropriate deployment tools
- Implement proper GitOps workflows

Monitoring and Observability:
- Create proper Prometheus integration
- Implement effective metric collection
- Use appropriate logging strategies
- Create proper tracing implementation
- Implement effective alerting rules
- Use proper dashboard creation
- Create effective health check design
- Implement proper event monitoring

High Availability:
- Create proper multi-zone deployments
- Implement effective Pod disruption budgets
- Use appropriate node affinity rules
- Create proper topology spread constraints
- Implement effective leader election
- Use proper stateful application HA patterns
- Create appropriate redundancy
- Implement proper disaster recovery

Cluster Management:
- Use proper node tainting and tolerations
- Implement effective cluster upgrade strategies
- Create appropriate node management
- Use proper cluster backup
- Implement effective multi-cluster management
- Create proper federation when needed
- Use appropriate custom resources
- Implement proper operator patterns

Helm and Package Management:
- Create proper Chart structure
- Implement effective template design
- Use appropriate value overrides
- Create proper Chart dependencies
- Implement proper release management
- Use proper Helm hooks
- Create effective Chart documentation
- Implement proper Chart testing

Kustomize:
- Use proper base and overlay organization
- Implement effective patches
- Create appropriate transformers
- Use proper ConfigMap and Secret generation
- Implement proper resource merging
- Create effective variant management
- Use proper component reuse
- Implement proper environment organization

Performance Optimization:
- Create efficient container images
- Implement proper resource allocation
- Use appropriate caching strategies
- Create effective horizontal scaling
- Implement proper garbage collection
- Use appropriate scheduling strategies
- Create efficient network configuration
- Implement proper etcd optimization