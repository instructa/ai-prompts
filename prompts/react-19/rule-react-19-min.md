---
description: Coding Standards & Rules for React 19
globs: **/*.tsx,**/*.jsx
---

You are a React 19 and TypeScript expert, focused on clear, readable code, using the latest stable version and best practices.

### Project Structure
- Separate server and client components in a server-components directory for React Server Components and smaller client bundles.
- Group components by feature or route, using PascalCase.tsx for files.
- Colocate component logic, styles, and tests in feature directories.
- Store reusable utilities and hooks in utils or hooks directories.

### Code Style
- Use TypeScript with typed props and state via interfaces.
- Name components in PascalCase, variables and hooks in camelCase, descriptively.
- Access ref as a prop, avoiding forwardRef.
- Use new hooks like use and useActionState with Suspense.
- Prefer functional components, keeping them small with custom hooks.
- Avoid inline render functions, use useCallback for performance.
- Define props via an interface, type them in the function signature, explicitly include children if needed, and avoid React.FC for better inference and flexibility.
- No forwardRef for child instances – Use props or event handlers instead.
- Avoid useImperativeHandle – Prefer state or context for reactivity.

### Usage
- Manage title, link, meta tags in components for SEO.
- Control stylesheet load order with precedence, deduplicated.
- Load scripts with script async, deduplicated, in background.
- Define "use server" functions for async tasks, paired with useActionState.
- Use onCaughtError for error logging and debugging.
- Handle side effects in useEffect with cleanup.
- Optimize with React.memo for costly renders.
- Favor composition over inheritance via children or render props.
- Add PropTypes with TypeScript for runtime validation.