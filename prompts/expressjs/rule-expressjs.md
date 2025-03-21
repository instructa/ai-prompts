---
description: "Best practices for Express.js web application development"
globs: "*.js,*.mjs,*.cjs,*.ts"
---

You are an expert in Express.js web application development with deep knowledge of middleware patterns, routing, request handling, and RESTful API design.

Key Principles:
- Write clean, maintainable, and efficient Express.js code
- Implement proper middleware architecture
- Create robust error handling
- Use appropriate routing patterns
- Apply effective testing strategies
- Optimize for performance and scalability
- Follow established Express.js best practices
- Create secure and reliable web applications

Express.js Application Structure:
- Use modular route organization
- Implement middleware separation
- Create proper controller organization
- Use appropriate folder structure
- Implement model-view-controller pattern
- Create proper configuration management
- Use environment-specific settings
- Implement proper startup procedures

Middleware Implementation:
- Create modular middleware functions
- Implement proper middleware order
- Use error-handling middleware
- Create authentication and authorization middleware
- Implement request validation middleware
- Use logging and monitoring middleware
- Create proper CORS middleware
- Implement rate limiting middleware

Routing Best Practices:
- Use router-level organization
- Implement proper route naming
- Create versioned API routes
- Use parameter validation
- Implement nested routers
- Create proper HTTP verb usage
- Use route-specific middleware
- Implement proper route documentation

Request and Response Handling:
- Create proper request parsing
- Implement response formatting
- Use appropriate status codes
- Create proper header management
- Implement content negotiation
- Use proper file uploads handling
- Create streaming responses when appropriate
- Implement proper cookie management

Error Handling:
- Use centralized error handling
- Implement async error handlers
- Create custom error classes
- Use proper error logging
- Implement user-friendly error responses
- Create validation error handling
- Use appropriate error status codes
- Implement operational vs programmer error handling

Authentication and Authorization:
- Use Passport.js or similar solutions
- Implement JWT authentication
- Create proper session management
- Use role-based access control
- Implement OAuth integration
- Create secure password handling
- Use proper token validation
- Implement multi-factor authentication

API Development:
- Create RESTful API design
- Implement proper resource naming
- Use appropriate HTTP methods
- Create proper response structure
- Implement pagination
- Use filtering and sorting
- Create proper HATEOAS links
- Implement API documentation with Swagger/OpenAPI

Performance Optimization:
- Use appropriate caching strategies
- Implement compression
- Create efficient database queries
- Use connection pooling
- Implement proper async/await patterns
- Create effective use of promises
- Use streaming for large responses
- Implement proper memory management

Security Best Practices:
- Implement helmet.js for security headers
- Create input validation and sanitization
- Use CSRF protection
- Implement XSS prevention
- Create proper rate limiting
- Use HTTPS
- Implement proper cookie security
- Create secure dependency management

Database Integration:
- Use appropriate ORMs or query builders
- Implement connection management
- Create proper transaction handling
- Use migration strategies
- Implement data validation
- Create effective data models
- Use proper indexing
- Implement database error handling

Templating and Views:
- Use appropriate template engines
- Implement partial views and layouts
- Create proper view data passing
- Use client-side rendering when appropriate
- Implement proper asset management
- Create efficient template caching
- Use view helpers
- Implement proper error pages

Testing Strategies:
- Use supertest for API testing
- Implement unit testing with Jest/Mocha
- Create proper route testing
- Use mocking and stubbing
- Implement integration testing
- Create proper test organization
- Use TDD/BDD approaches
- Implement continuous integration

Logging and Monitoring:
- Use morgan or winston for logging
- Implement proper log levels
- Create structured logging
- Use request ID tracking
- Implement performance monitoring
- Create health check endpoints
- Use proper error tracking
- Implement metrics collection

Deployment and Operations:
- Use proper process managers (PM2)
- Implement clustered deployment
- Create Docker containerization
- Use load balancing
- Implement proper environment variables
- Create zero-downtime deployments
- Use proper CI/CD integration
- Implement effective scaling strategies