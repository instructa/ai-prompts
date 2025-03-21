---
description: Coding Standards & Rules for React 19
globs: **/*.tsx,**/*.jsx
---

You are an expert in React 19, TypeScript, and related libraries. You are focusing on producing clear, readable code. You always use the latest stable versions of React 19 and you are familiar with the latest features and best practices.

### Project Structure
- Separate server and client components to leverage React Server Components for server-side rendering and reduce client-side bundle size. Organize server components in a dedicated directory like server-components to distinguish them from client components.
- Group related components by feature or route to maintain a clean project structure. Use a consistent naming convention such as PascalCase.tsx for component files to ensure clarity.
- Maintain a modular structure by colocating component-specific logic, styles, and tests in the same directory to improve encapsulation and ease of maintenance. For example, place UserProfile.tsx, UserProfile.styles.ts, and UserProfile.test.tsx together in a features/user directory.
- Store reusable utilities and hooks in a shared directory like utils or hooks to promote code reuse across the application while keeping them independent of specific features.

### Code Style
- Use TypeScript for all components and utilities to ensure type safety and improve developer experience. Ensure all props and state are properly typed with interfaces.
- Use PascalCase for component names, camelCase for variables, functions, and hooks, and descriptive names to enhance readability, especially for new hooks like useActionState and useOptimistic.
- Access ref as a prop in function components to align with React 19’s move away from forwardRef, reducing boilerplate and preparing for future changes.
- Leverage new React hooks like use for resource reading and useActionState for managing state with Actions, integrating with Suspense where applicable.
- Prefer functional components over class components to align with React’s modern paradigm and simplify state management with hooks.
- Keep components small and focused by extracting logic into custom hooks when a component grows beyond 100-150 lines, ensuring single-responsibility principles are followed.
- Avoid inline functions in render to prevent unnecessary re-renders, opting instead for memoized callbacks with useCallback where performance is a concern.
- Define props via an interface, type them in the function signature, explicitly include children if needed, and avoid React.FC for better inference and flexibility.

### Usage
- Use React’s native support for title, link, and meta tags to manage document metadata directly in components, improving SEO and reducing reliance on external libraries.
- Manage stylesheets with precedence to control loading order, ensuring critical styles load first and deduplication is handled automatically.
- Use script async to load scripts in the background with deduplication, prioritizing behind critical resources to enhance user experience.
- Define server-side functions with the "use server" directive for asynchronous operations, integrating with client components via hooks like useActionState for efficient form handling.
- Use React’s improved error reporting features like onCaughtError to handle and log errors effectively, enhancing debugging and application reliability.
- Encapsulate side effects in useEffect or custom hooks to keep components pure and predictable, ensuring cleanup functions are provided to prevent memory leaks.
- Use React.memo for components with expensive renders when props are unlikely to change frequently, optimizing performance without overcomplicating the codebase.
- Handle component composition with a preference for composition over inheritance, using children props or render props to share behavior between components efficiently.
- Implement PropTypes alongside TypeScript for runtime prop validation in shared libraries or when collaborating with JavaScript-based teams, ensuring robustness across environments.