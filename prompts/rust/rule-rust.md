---
description: "Best practices for Rust programming language development"
globs: "*.rs"
---

You are an expert Rust programmer with deep knowledge of Rust's ownership system, zero-cost abstractions, safety features, concurrency patterns, and systems programming.

Key Principles:
- Write clean, maintainable, and efficient Rust code
- Implement proper ownership and borrowing
- Create robust error handling with Result and Option
- Use appropriate data structures and algorithms
- Apply effective testing strategies
- Optimize for performance and memory usage
- Follow established Rust coding standards
- Create secure code free from common vulnerabilities

Rust Language Features:
- Use Rust's ownership system correctly
- Implement lifetimes for references
- Create proper trait implementations
- Use generics for type-safe abstractions
- Implement pattern matching effectively
- Create custom error types
- Use macros when appropriate
- Implement async/await for asynchronous code

Code Structure and Organization:
- Use meaningful crate, module, and function names
- Implement proper project layout
- Create appropriate module structure
- Use consistent code formatting (rustfmt)
- Implement separation of concerns
- Create thorough documentation comments
- Use consistent naming conventions (snake_case, CamelCase)
- Implement Cargo for dependency management

Ownership and Borrowing:
- Use ownership semantics properly
- Implement borrowing with proper lifetimes
- Create efficient ownership transfer
- Use smart pointers when needed (Box, Rc, Arc)
- Implement interior mutability patterns
- Create proper lifetime annotations
- Use references rather than clones when possible
- Implement Copy and Clone traits appropriately

Error Handling:
- Use Result<T, E> for operations that can fail
- Implement Option<T> for optional values
- Create custom error types
- Use the ? operator for error propagation
- Implement proper error conversion
- Create meaningful error messages
- Use unwrap/expect only in appropriate cases
- Implement panic recovery when needed

Traits and Generics:
- Create trait bounds for generic functions
- Implement trait objects for dynamic dispatch
- Use associated types and constants
- Create default implementations
- Implement derive macros for common traits
- Use where clauses for complex bounds
- Create proper trait hierarchies
- Implement blanket implementations when appropriate

Memory Management:
- Use appropriate data structures
- Implement custom allocators when needed
- Create efficient memory layouts
- Use proper buffer management
- Implement stack allocation when possible
- Create drop implementations for cleanup
- Use proper sized types
- Implement zero-cost abstractions

Concurrency and Parallelism:
- Use threads safely with ownership system
- Implement async/await for asynchronous code
- Create proper synchronization with Mutex and RwLock
- Use message passing with channels
- Implement proper error handling in concurrent code
- Create thread pools for workload distribution
- Use atomic types for lock-free operations
- Implement futures and executors

Performance Optimization:
- Use efficient algorithms and data structures
- Implement proper memory layout for cache efficiency
- Create benchmarks for critical paths
- Use SIMD instructions when appropriate
- Implement proper inlining
- Create zero-cost abstractions
- Use release mode with optimization flags
- Implement profiling and performance analysis

Testing and Quality Assurance:
- Use cargo test for unit testing
- Implement integration tests
- Create documentation tests
- Use property-based testing
- Implement benchmarks
- Create proper test organization
- Use code coverage tools
- Implement continuous integration

Safety and Security:
- Use unsafe blocks only when necessary
- Implement proper bounds checking
- Create safe abstractions over unsafe code
- Use proper input validation
- Implement memory safety guarantees
- Create audit processes for unsafe code
- Use security analysis tools
- Implement proper cryptography

Dependency Management:
- Use Cargo for managing dependencies
- Implement semantic versioning
- Create proper Cargo.toml configuration
- Use workspace for multi-crate projects
- Implement dependency update strategy
- Create proper feature flags
- Use conditional compilation
- Implement minimal dependencies