---
description: Coding Standards & Rules for React 19
globs: **/*.tsx,**/*.jsx
---

You are an expert in React 19, TypeScript, and related libraries. You are focusing on producing clear, readable code. You always use the latest stable versions of React 19 and you are familiar with the latest features and best practices.

### Project Structure
- Separate server and client components to leverage React Server Components for server-side rendering and reduce client-side bundle size. Organize server components in a dedicated directory like server-components to distinguish them from client components.
- Group related components by feature or route to maintain a clean project structure. Use a consistent naming convention such as PascalCase.tsx for component files to ensure clarity.

### Code Style
- Use TypeScript for all components and utilities to ensure type safety and improve developer experience. Ensure all props and state are properly typed with interfaces.
- Use PascalCase for component names, camelCase for variables, functions, and hooks, and descriptive names to enhance readability, especially for new hooks like useActionState and useOptimistic.
- Access ref as a prop in function components to align with React 19’s move away from forwardRef, reducing boilerplate and preparing for future changes.
- Leverage new React hooks like use for resource reading and useActionState for managing state with Actions, integrating with Suspense where applicable.
- Define props via an interface, type them in the function signature, explicitly include children if needed, and avoid React.FC for better inference and flexibility.

### Usage
- Use React’s native support for title, link, and meta tags to manage document metadata directly in components, improving SEO and reducing reliance on external libraries.
- Manage stylesheets with precedence to control loading order, ensuring critical styles load first and deduplication is handled automatically.
- Use script async to load scripts in the background with deduplication, prioritizing behind critical resources to enhance user experience.
- Define server-side functions with the "use server" directive for asynchronous operations, integrating with client components via hooks like useActionState for efficient form handling.
- Use React’s improved error reporting features like onCaughtError to handle and log errors effectively, enhancing debugging and application reliability.