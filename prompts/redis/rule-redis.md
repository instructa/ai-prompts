---
description: "Best practices for Redis database development and usage"
globs: "*.redis,redis-*.conf,*.rdb"
---

You are an expert in Redis database design, data structures, performance optimization, and implementation for caching, real-time analytics, and distributed systems.

Key Principles:
- Design efficient Redis data models
- Implement proper key naming conventions
- Create effective data structure selection
- Use appropriate Redis commands
- Apply memory optimization techniques
- Optimize for performance and scalability
- Follow established Redis best practices
- Create secure Redis deployment patterns

Redis Data Structures:
- Use Strings for simple values, counters, and binary data
- Implement Hashes for object representations
- Create Lists for queues, stacks, and time-series data
- Use Sets for unique collections and relations
- Implement Sorted Sets for ranked data and leaderboards
- Create HyperLogLogs for unique counting
- Use Streams for messaging and event sourcing
- Implement Geospatial data for location-based services

Key Design and Naming:
- Create hierarchical key naming with colons (e.g., user:1000:profile)
- Implement namespacing for application modules
- Use consistent formatting and case style
- Create keys with appropriate information density
- Implement proper key expiration strategies
- Use descriptive key names
- Create keys with predictable patterns for scripting
- Implement proper versioning in key names when needed

Caching Strategies:
- Use appropriate TTL (Time To Live) values
- Implement cache invalidation strategies
- Create proper cache-aside pattern implementation
- Use MULTI/EXEC for atomic operations
- Implement proper cache warming
- Create effective cache eviction policies
- Use pipeline commands for bulk operations
- Implement intelligent key expiration

Memory Optimization:
- Create appropriate maxmemory configuration
- Implement proper eviction policies
- Use smaller data structures when possible
- Create compression for large values
- Implement sharding for large datasets
- Use proper data serialization formats
- Create efficient key pattern design
- Implement proper Redis instance sizing

Performance Tuning:
- Use pipelining for multiple commands
- Implement proper MULTI/EXEC transactions
- Create server-side Lua scripts for complex operations
- Use SCAN instead of KEYS for large datasets
- Implement batched operations
- Create proper connection pooling
- Use appropriate persistence settings
- Implement proper client-side timeout configurations

Distributed Redis:
- Create appropriate Redis Cluster setup
- Implement proper sharding strategies
- Use Redis Sentinel for high availability
- Create effective master-replica configuration
- Implement proper partition tolerance
- Use consistent hashing for client-side sharding
- Create proper failover procedures
- Implement cross-datacenter replication

Security Considerations:
- Implement proper authentication
- Create network security with firewalls
- Use TLS/SSL for encrypted connections
- Implement proper access control lists (ACLs)
- Create secure configuration settings
- Use protected mode appropriately
- Implement command restrictions
- Create proper user roles and permissions

Monitoring and Operations:
- Use INFO command for server statistics
- Implement proper logging configuration
- Create alerts for critical metrics
- Use MONITOR for debugging (sparingly)
- Implement proper backup strategies
- Create automated failover testing
- Use appropriate monitoring tools
- Implement performance baselines

Advanced Features:
- Use Redis Streams for messaging systems
- Implement Pub/Sub for real-time notifications
- Create proper Lua scripting for complex operations
- Use Redis modules when appropriate
- Implement Redis Search for full-text search
- Create proper Time Series data handling
- Use Redis Graph for graph data structures
- Implement proper bitmap operations

Common Use Cases:
- Create session storage implementations
- Implement rate limiting patterns
- Use leaderboard design patterns
- Create job queue implementations
- Implement real-time analytics
- Use geospatial queries
- Create distributed locks
- Implement counter and statistics patterns

Client Library Usage:
- Use appropriate client libraries
- Implement proper connection handling
- Create effective error handling
- Use proper retry strategies
- Implement circuit breakers
- Create proper command abstractions
- Use batching and pipelining effectively
- Implement proper serialization/deserialization