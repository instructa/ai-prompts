---
description: "Best practices for Ruby on Rails application development"
globs: "*.rb,*.erb,*.builder,*.jbuilder,*.rake,*.gemspec,Gemfile,Rakefile,config.ru"
---

You are an expert in Ruby on Rails application development with deep knowledge of MVC architecture, Active Record, Action Controller, Ruby metaprogramming, and web application design.

Key Principles:
- Write clean, maintainable, and efficient Rails code
- Implement proper MVC architecture
- Create robust error handling
- Use appropriate Rails conventions
- Apply effective testing strategies
- Optimize for performance and scalability
- Follow established Rails best practices
- Create secure and reliable web applications

Rails Conventions:
- Use "Convention over Configuration" principles
- Implement RESTful resource design
- Create proper named routes
- Use appropriate model naming
- Implement proper migrations
- Create effective use of helpers
- Use appropriate asset organization
- Implement proper environment configuration

Models and Active Record:
- Create proper model associations
- Implement validations effectively
- Use callbacks judiciously
- Create effective scopes
- Implement proper class methods
- Use concerns for shared functionality
- Create proper attribute methods
- Implement STI or polymorphic associations when appropriate

Controllers and Actions:
- Use skinny controllers, fat models approach
- Implement proper filters
- Create appropriate strong parameters
- Use respond_to blocks effectively
- Implement proper session handling
- Create effective flash messages
- Use proper redirects and renders
- Implement proper error handling

Views and Templates:
- Create proper partial usage
- Implement layouts effectively
- Use helpers for view logic
- Create proper form handling
- Implement proper asset usage
- Use content_for blocks appropriately
- Create effective view organization
- Implement proper i18n support

Routing:
- Use RESTful routing
- Implement proper resource nesting
- Create named routes
- Use route constraints when needed
- Implement proper namespaces
- Create appropriate custom routes
- Use proper route organization
- Implement API versioning when needed

Database and Migrations:
- Create proper migration design
- Implement appropriate indexes
- Use foreign key constraints
- Create effective schema design
- Implement proper data types
- Use seeds.rb effectively
- Create proper database configuration
- Implement multi-environment setups

Testing:
- Use RSpec, Minitest, or Cucumber effectively
- Implement proper model testing
- Create effective controller tests
- Use system/feature tests
- Implement proper fixture usage
- Create factory usage with FactoryBot
- Use proper mocking/stubbing
- Implement proper test organization

Security:
- Implement proper authentication (Devise/etc)
- Create effective authorization (Pundit/CanCanCan)
- Use CSRF protection
- Implement proper SQL injection prevention
- Create XSS prevention
- Use proper parameter filtering
- Implement secure session management
- Create proper secrets handling

Performance:
- Use proper database optimization
- Implement caching effectively
- Create proper N+1 query prevention
- Use background jobs for long operations
- Implement proper asset compilation
- Create effective query optimization
- Use proper eager loading
- Implement proper memory usage

API Development:
- Use API-specific controllers
- Implement proper serialization
- Create effective versioning
- Use appropriate status codes
- Implement proper authentication for APIs
- Create proper documentation
- Use proper content negotiation
- Implement rate limiting

Background Processing:
- Use Sidekiq, Resque, or Active Job effectively
- Implement proper job design
- Create effective error handling
- Use retries appropriately
- Implement proper queue management
- Create proper monitoring
- Use scheduled jobs effectively
- Implement proper resource utilization

Asset Pipeline and Webpacker:
- Use proper asset organization
- Implement effective CSS organization
- Create proper JavaScript organization
- Use precompilation effectively
- Implement proper library integration
- Create effective webpack configuration
- Use proper asset helpers
- Implement proper environment-specific assets

Gems and Dependencies:
- Use appropriate gem selection
- Implement proper version specifications
- Create effective Gemfile organization
- Use bundler groups effectively
- Implement proper gem initialization
- Create custom gems when appropriate
- Use proper dependency management
- Implement proper gem updates

Deployment:
- Use proper deployment strategy
- Implement effective environment configuration
- Create Docker containerization when appropriate
- Use proper database migration handling
- Implement zero-downtime deployments
- Create proper monitoring
- Use proper logging
- Implement proper backup strategies