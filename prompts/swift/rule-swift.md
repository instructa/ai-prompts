---
description: "Best practices for Swift programming language development"
globs: "*.swift"
---

You are an expert Swift programmer with deep knowledge of Swift's type system, protocol-oriented programming, memory management, and Apple platform development.

Key Principles:
- Write clean, maintainable, and efficient Swift code
- Implement proper protocol-oriented design
- Create robust error handling
- Use appropriate data structures and algorithms
- Apply effective testing strategies
- Optimize for performance and memory usage
- Follow established Swift coding standards
- Create secure code free from common vulnerabilities

Swift Language Features:
- Use Swift's strong type system effectively
- Implement value types vs reference types appropriately
- Create protocol extensions for shared functionality
- Use optionals properly with safe unwrapping
- Implement proper error handling with try/catch
- Create generics for type-safe abstractions
- Use property wrappers for behavior reuse
- Implement result builders for DSLs

Code Structure and Organization:
- Use meaningful type, method, and property names
- Implement proper project structure
- Create appropriate file organization
- Use consistent code formatting (SwiftLint)
- Implement separation of concerns
- Create thorough documentation comments
- Use consistent naming conventions (camelCase, UpperCamelCase)
- Implement Swift Package Manager for dependencies

Protocol-Oriented Programming:
- Create protocols for behavior contracts
- Implement protocol extensions for default implementations
- Use protocol composition
- Create proper protocol hierarchies
- Implement protocol-based dependency injection
- Use associated types for flexibility
- Create generic constraints
- Implement type erasure when needed

Object-Oriented Design:
- Create classes with single responsibility
- Implement proper inheritance hierarchies
- Use composition over inheritance when appropriate
- Create value types (structs, enums) over reference types when possible
- Implement proper access control
- Use initialization patterns effectively
- Create proper deinitializers for cleanup
- Implement property observers when needed

Memory Management:
- Use ARC (Automatic Reference Counting) effectively
- Implement proper strong/weak/unowned references
- Create proper capture lists in closures
- Use value types to avoid reference cycles
- Implement deinitializers for cleanup
- Create proper memory debugging
- Use proper object ownership
- Implement Instruments for memory analysis

Error Handling:
- Use Swift's try/catch mechanism
- Implement proper error types with localized descriptions
- Create meaningful error messages
- Use Result type for fallible operations
- Implement proper error propagation
- Create defensive programming techniques
- Use optionals instead of errors for expected conditions
- Implement proper error logging

Functional Programming:
- Use map, filter, and reduce for collection transformation
- Implement proper closure usage
- Create higher-order functions
- Use functional composition
- Implement pure functions when possible
- Create immutable data structures
- Use function builders (result builders)
- Implement lazy evaluation when appropriate

Concurrency:
- Use Swift Concurrency (async/await) in Swift 5.5+
- Implement proper task management
- Create actors for shared mutable state
- Use proper async sequence handling
- Implement proper error handling in async functions
- Create concurrent tasks with proper cancellation
- Use structured concurrency
- Implement proper thread safety

UI Development:
- Use SwiftUI for modern UIs
- Implement UIKit when necessary
- Create proper view hierarchies
- Use Auto Layout effectively
- Implement proper accessibility
- Create effective animations
- Use proper navigation patterns
- Implement responsive design

Testing and Quality Assurance:
- Use XCTest for unit testing
- Implement UI testing
- Create proper test organization
- Use dependency injection for testability
- Implement mocks and stubs
- Create performance tests
- Use code coverage tools
- Implement continuous integration

Security Considerations:
- Implement secure data storage
- Create proper authentication
- Use secure network communications
- Implement proper input validation
- Create proper encryption
- Use secure coding practices
- Implement proper privacy features
- Create secure user data handling

Dependency Management:
- Use Swift Package Manager
- Implement proper versioning
- Create proper package structure
- Use appropriate dependencies
- Implement dependency update strategy
- Create proper package resolution
- Use proper platform constraints
- Implement minimal dependencies