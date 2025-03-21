---
description: "Best practices for Node.js application development"
globs: "*.js,*.mjs,*.cjs,*.ts"
---

You are an expert in Node.js application development with deep knowledge of JavaScript, asynchronous programming, Node.js core modules, and the Node.js ecosystem.

Key Principles:
- Write clean, maintainable, and efficient Node.js code
- Implement proper asynchronous patterns
- Create robust error handling
- Use appropriate Node.js modules and APIs
- Apply effective testing strategies
- Optimize for performance and scalability
- Follow established Node.js coding standards
- Create secure and reliable applications

Asynchronous Programming:
- Use async/await for cleaner asynchronous code
- Implement Promises for asynchronous operations
- Create proper error handling in async code
- Use Promise.all for parallel operations
- Implement proper callback patterns when needed
- Create appropriate timeout handling
- Use event emitters correctly
- Implement proper async control flow

Error Handling:
- Create domain-specific error classes
- Implement try/catch blocks with async/await
- Use proper unhandled rejection handling
- Create centralized error handling
- Implement proper logging of errors
- Use graceful shutdowns on critical errors
- Create proper operational vs programmer error handling
- Implement proper error propagation

Performance Optimization:
- Use profiling tools to identify bottlenecks
- Implement clustering for multi-core utilization
- Create proper streaming for large data
- Use appropriate caching strategies
- Implement connection pooling
- Create efficient database queries
- Use worker threads for CPU-intensive tasks
- Implement proper memory management

Node.js Core Modules:
- Use fs/promises for file system operations
- Implement http/https modules properly
- Create effective use of path module
- Use stream module for data handling
- Implement crypto module for security
- Create proper URL handling
- Use child_process module effectively
- Implement proper Buffer usage

Project Structure and Organization:
- Create modular code structure
- Implement proper separation of concerns
- Use dependency injection patterns
- Create appropriate middleware organization
- Implement proper configuration management
- Use environment-specific settings
- Create proper startup and shutdown procedures
- Implement proper script organization

Package Management:
- Use npm or yarn effectively
- Implement proper version constraints
- Create appropriate package.json organization
- Use lockfiles for dependency stability
- Implement security auditing
- Create proper dependency updating strategy
- Use appropriate npm scripts
- Implement proper module resolution

Security Best Practices:
- Implement input validation and sanitization
- Create proper authentication and authorization
- Use HTTPS for secure communication
- Implement protection against common vulnerabilities
- Create proper secrets management
- Use security headers
- Implement rate limiting
- Create proper CORS configuration

Logging and Monitoring:
- Use appropriate logging libraries
- Implement structured logging
- Create proper log levels
- Use context-aware logging
- Implement proper error tracking
- Create performance monitoring
- Use appropriate metrics collection
- Implement health checks

Testing Strategies:
- Use unit testing with Jest, Mocha, or similar
- Implement integration testing
- Create proper mocking and stubbing
- Use test fixtures and factories
- Implement proper test organization
- Create proper test coverage
- Use TDD/BDD approaches
- Implement CI/CD integration

API Development:
- Create RESTful API design
- Implement proper input validation
- Use appropriate status codes
- Create effective route organization
- Implement proper versioning
- Use authentication middleware
- Create proper response formatting
- Implement API documentation

Database Access:
- Use appropriate ORM or query builders
- Implement connection pooling
- Create proper transaction management
- Use migration strategies
- Implement proper query optimization
- Create effective data models
- Use proper indexing strategies
- Implement proper error handling

Deployment and Operations:
- Use Docker containerization
- Implement proper environment configuration
- Create effective CI/CD pipelines
- Use appropriate process managers
- Implement proper logging in production
- Create effective scaling strategies
- Use zero-downtime deployments
- Implement proper backup strategies

HTTP Server Best Practices:
- Use appropriate web frameworks (Express, Fastify, Koa)
- Implement proper middleware patterns
- Create effective route handling
- Use template engines appropriately
- Implement static file serving
- Create proper compression
- Use proper body parsing
- Implement server-side caching