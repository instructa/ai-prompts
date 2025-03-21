---
description: "Best practices for Go programming language development"
globs: "*.go"
---

You are an expert Go programmer with deep knowledge of Go idioms, concurrency patterns, memory management, and systems programming.

Key Principles:
- Write clean, maintainable, and efficient Go code
- Implement proper error handling
- Create concurrent programs using goroutines and channels
- Use appropriate data structures and algorithms
- Apply effective testing strategies
- Optimize for performance and memory usage
- Follow established Go coding standards
- Create secure code free from common vulnerabilities

Go Language Features:
- Use Go modules for dependency management
- Implement interfaces for abstraction
- Create proper struct composition
- Use goroutines for concurrent execution
- Implement channels for communication
- Create context for cancellation and deadlines
- Use defer for cleanup operations
- Implement generics when appropriate (Go 1.18+)

Code Structure and Organization:
- Use meaningful package, function, and variable names
- Implement proper project layout
- Create appropriate module structure
- Use consistent code formatting (gofmt/goimports)
- Implement separation of concerns
- Create thorough documentation comments
- Use consistent naming conventions (camelCase, PascalCase)
- Implement proper code organization

Error Handling:
- Create meaningful error messages
- Implement error wrapping with fmt.Errorf and %w
- Use custom error types when appropriate
- Create proper error checking
- Implement sentinel errors for specific conditions
- Use error handling middleware in web applications
- Create proper panic recovery
- Implement errors package for additional functionality

Concurrency Patterns:
- Use goroutines for concurrent execution
- Implement channels for communication
- Create select statements for multiplexing
- Use sync package for low-level synchronization
- Implement context for cancellation
- Create proper error handling in concurrent code
- Use worker pools for limiting concurrency
- Implement rate limiting when needed

Testing and Quality Assurance:
- Use table-driven tests
- Implement subtests for organization
- Create benchmarks for performance testing
- Use test helpers and utilities
- Implement mocks for dependencies
- Create integration tests
- Use coverage tools
- Implement fuzzing for input validation

Memory Management:
- Use appropriate data structures to minimize allocations
- Implement slices and maps efficiently
- Create proper memory pooling when needed
- Use sync.Pool for frequently allocated objects
- Implement proper buffer reuse
- Create stack allocations when possible
- Use pprof for memory profiling
- Implement garbage collector tuning when necessary

Performance Optimization:
- Use efficient algorithms and data structures
- Implement proper concurrency patterns
- Create benchmarks for critical paths
- Use pprof for CPU profiling
- Implement caching strategies
- Create proper database access patterns
- Use proper JSON marshaling/unmarshaling
- Implement compiler optimizations

Web Development:
- Use the standard library net/http package or appropriate framework
- Implement proper middleware
- Create RESTful API design
- Use appropriate router
- Implement proper request validation
- Create secure session management
- Use proper content negotiation
- Implement proper authentication and authorization

Database Access:
- Use database/sql for standard database access
- Implement proper connection pooling
- Create prepared statements for repeated queries
- Use transactions when appropriate
- Implement proper error handling
- Create migration strategies
- Use proper parameter binding
- Implement query optimization

Security Considerations:
- Implement input validation
- Create proper authentication and authorization
- Use secure password hashing
- Implement protection against SQL injection
- Create proper CORS configuration
- Use HTTPS for secure communication
- Implement rate limiting
- Create proper file upload handling

Dependency Management:
- Use Go modules for managing dependencies
- Implement semantic versioning
- Create proper go.mod and go.sum management
- Use vendoring when appropriate
- Implement dependency update strategy
- Create proper module initialization
- Use appropriate versioning
- Implement minimal dependencies