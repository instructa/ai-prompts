---
description: "Guidelines for building modern web applications using JavaScript, APIs, and Markup (JAMstack)"
globs: "*.js,*.ts,*.jsx,*.tsx,*.html,*.md,*.mdx,netlify.toml,vercel.json"
---

# JAMstack Best Practices

## Architecture and Philosophy

- Decouple the frontend from the backend
- Pre-render content when possible
- Use APIs for dynamic functionality
- Leverage the CDN for content delivery
- Implement proper separation of concerns
- Use atomic deployments
- Design for immutability
- Implement progressive enhancement
- Consider the entire site lifecycle
- Focus on performance and user experience

## Static Site Generators

- Choose the appropriate static site generator for your needs (Next.js, Gatsby, Astro, Hugo, 11ty, etc.)
- Optimize build times for large sites
- Implement incremental builds when available
- Use appropriate templating systems
- Implement proper content modeling
- Configure appropriate build settings
- Document build and deployment processes
- Use code splitting for improved performance
- Implement proper error handling during builds
- Configure proper SEO metadata generation

## Content Management

- Select appropriate headless CMS solutions (Contentful, Sanity, Strapi, etc.)
- Implement proper content modeling
- Use structured content for better reusability
- Set up appropriate editorial workflows
- Implement proper content versioning
- Configure appropriate webhooks for build triggers
- Document content creation processes
- Implement proper media handling
- Configure multi-language support when needed
- Set up appropriate content previews

## API Integration

- Use appropriate API integration patterns
- Implement proper authentication for API requests
- Use API abstraction layers
- Handle API rate limiting appropriately
- Implement proper error handling for API failures
- Use appropriate caching strategies
- Document API dependencies and requirements
- Consider API versioning in your integration
- Implement proper fallbacks for API unavailability
- Monitor API usage and performance

## Frontend Development

- Use modern JavaScript frameworks (React, Vue, Svelte, etc.)
- Implement proper component architecture
- Use CSS approaches that work well with the JAMstack (CSS Modules, CSS-in-JS, Tailwind)
- Optimize bundle sizes
- Implement proper code splitting
- Use appropriate state management
- Implement proper client-side routing
- Configure proper linting and formatting
- Document component usage and API
- Implement proper testing strategies

## Performance Optimization

- Optimize image delivery with modern formats and responsive images
- Implement proper lazy loading
- Configure appropriate caching strategies
- Minimize JavaScript bundle size
- Use appropriate font loading strategies
- Implement proper resource hints (preload, prefetch)
- Optimize critical rendering path
- Configure proper CDN settings
- Monitor performance metrics
- Use appropriate performance testing tools

## Deployment and Hosting

- Use specialized JAMstack hosting platforms (Netlify, Vercel, Cloudflare Pages, etc.)
- Implement proper CI/CD pipelines
- Configure appropriate build settings
- Use environment variables for configuration
- Implement proper preview deployments
- Configure custom domains and SSL
- Set up proper redirects and rewrites
- Configure appropriate cache invalidation
- Document deployment procedures
- Implement proper rollback strategies

## Authentication and Authorization

- Use appropriate authentication providers
- Implement authentication using services like Auth0, Clerk, or Supabase
- Configure proper JWT handling
- Implement appropriate role-based access control
- Secure API endpoints properly
- Use appropriate authentication UI components
- Implement proper session management
- Document authentication flow
- Configure proper OAuth integration
- Implement proper error handling for authentication failures

## Forms and User Input

- Use form handling services (Formspree, Netlify Forms, etc.)
- Implement proper form validation
- Configure appropriate form submission handling
- Implement proper spam protection
- Use appropriate form UI components
- Document form submission processes
- Implement proper error handling for form submissions
- Configure appropriate form success responses
- Implement proper file upload handling
- Set up form analytics when needed

## Testing and Quality Assurance

- Implement appropriate testing strategies
- Use automated testing (unit, integration, E2E)
- Configure proper linting and code quality tools
- Implement visual regression testing
- Use appropriate performance testing
- Configure proper accessibility testing
- Set up proper SEO testing
- Document testing procedures
- Implement proper test coverage reporting
- Use appropriate browser testing strategies

## SEO and Analytics

- Implement proper metadata for SEO
- Configure appropriate sitemap generation
- Use structured data for rich results
- Implement proper canonical URLs
- Configure appropriate robots.txt
- Implement proper analytics integration
- Set up conversion tracking
- Configure appropriate event tracking
- Document SEO strategy
- Monitor and improve site performance for better SEO