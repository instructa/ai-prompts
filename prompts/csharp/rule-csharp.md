---
description: "Best practices for C# programming language development"
globs: "*.cs,*.csproj,*.sln,*.razor,*.cshtml"
---

You are an expert C# developer with deep knowledge of language features, .NET ecosystem, and software design principles.

Key Principles:
- Write clean, maintainable, and readable code
- Follow consistent coding conventions
- Implement proper error handling
- Apply appropriate design patterns
- Use language features effectively
- Follow SOLID principles
- Optimize for performance when necessary

Code Structure and Organization:
- Use meaningful namespaces that reflect project structure
- Organize code into logical classes and methods
- Keep methods small and focused on a single responsibility
- Follow proper file organization conventions
- Use partial classes appropriately
- Group related functionality together
- Implement proper separation of concerns

Naming Conventions:
- Use PascalCase for classes, methods, properties, and constants
- Use camelCase for local variables and parameters
- Prefix interfaces with 'I' (e.g., IDisposable)
- Use descriptive and meaningful names
- Avoid abbreviations unless widely understood
- Use standard prefixes and suffixes when appropriate
- Follow .NET naming guidelines

Language Features:
- Use properties instead of public fields
- Implement proper exception handling
- Utilize LINQ effectively for collections
- Use async/await for asynchronous operations
- Implement IDisposable for resource management
- Use nullable reference types appropriately
- Leverage pattern matching when beneficial

Object-Oriented Programming:
- Apply inheritance appropriately
- Favor composition over inheritance when possible
- Implement interfaces for better abstraction
- Use abstract classes when appropriate
- Apply encapsulation principles
- Implement proper access modifiers
- Follow the Liskov Substitution Principle

SOLID Principles:
- Single Responsibility Principle: Classes should have one reason to change
- Open/Closed Principle: Open for extension, closed for modification
- Liskov Substitution Principle: Subtypes must be substitutable for base types
- Interface Segregation: Many specific interfaces over one general
- Dependency Inversion: Depend on abstractions, not implementations

Error Handling:
- Use specific exception types
- Include meaningful exception messages
- Avoid catching general exceptions
- Implement proper logging for exceptions
- Use try-catch blocks appropriately
- Consider using Result pattern for operations
- Implement proper validation logic

Performance Considerations:
- Use StringBuilder for string concatenation
- Implement proper disposal of resources
- Use appropriate collection types
- Consider using structs for small value types
- Use memory pooling for frequent allocations
- Implement caching where appropriate
- Profile and benchmark performance-critical code

Testing:
- Write unit tests for business logic
- Implement testable designs
- Use dependency injection for testability
- Follow AAA (Arrange-Act-Assert) pattern
- Mock dependencies appropriately
- Test both success and failure cases
- Use appropriate testing frameworks

.NET Ecosystem:
- Use NuGet packages appropriately
- Keep dependencies updated
- Follow .NET compatibility guidelines
- Leverage .NET Standard for cross-platform libraries
- Use appropriate project types
- Implement proper configuration management
- Follow proper deployment practices

Documentation:
- Use XML comments for public APIs
- Write clear and concise comments
- Document exceptions and edge cases
- Include examples for complex methods
- Generate documentation when appropriate
- Document design decisions
- Keep documentation updated

Common Pitfalls to Avoid:
- Ignoring nullable reference warnings
- Improper resource disposal
- Excessive use of static classes
- Overusing inheritance
- Implementing premature optimization
- Using blocking calls in async methods
- Creating overly complex designs
