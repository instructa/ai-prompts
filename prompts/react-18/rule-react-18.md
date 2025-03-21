---
description: Coding Standards & Rules for React 18.3.1
globs: **/*.tsx, **/*.jsx, **/*.ts
---

You are an expert in React, TypeScript, and related libraries. You are focusing on producing clear, readable code. You always use the latest stable versions of React and you are familiar with the latest features and best practices.

## Project Structure
Organize your React project with a modular structure to enhance reusability and maintainability. Use the following directory layout.

- `src/` contains the root directory for source files.
- `components/` includes all React components, organized by feature or domain.
- `hooks/` houses custom React hooks for reusable logic.
- `utils/` holds utility functions for shared logic.
- `context/` manages context providers for global state.
- `types/` contains TypeScript type definitions for the application.
- `pages/` stores page components, especially useful when using a router like React Router.

This structure ensures clarity and scalability, making it easier to manage large applications.

## Code Style
Adhere to the following code style guidelines to maintain consistency and readability.

- Prefer functional components with hooks over class components to leverage React 18.3.1 features effectively.
- Use TypeScript for type safety and improved maintainability across the codebase.
- Follow naming conventions with PascalCase for component names (e.g., `MyComponent`), camelCase for variables and functions (e.g., `myFunction`), and prefix hooks with "use" (e.g., `useCustomHook`).
- Apply `startTransition` for non-critical state updates to take advantage of concurrent rendering and enhance performance.
- Ensure proper indentation and add comments to clarify complex logic where necessary.

## Usage
Follow these best practices to utilize React 18.3.1 effectively.

- Use Suspense for lazy loading components to optimize initial load times.
- Fetch data with `useEffect` when components mount, ensuring proper handling of loading and error states.
- Leverage automatic batching to minimize re-renders and avoid manual batching unless absolutely required.
- Implement the context API to manage global state efficiently, reducing prop drilling.
- Differentiate between `useEffect` and `useLayoutEffect` to time effects appropriately, particularly with concurrent rendering.

## Performance Optimization
Optimize performance with these critical guidelines specific to React 18.3.1.

- Employ `startTransition` for state updates that do not need to block the UI, such as search inputs or filters, to maintain a responsive interface.
- Reduce reliance on `useEffect` for data fetching by integrating Suspense with compatible libraries like React Query or SWR, aligning with React 18’s concurrent features.
- Prevent unnecessary re-renders by memoizing components with `React.memo` where performance gains are significant.
- Profile the application regularly to identify and resolve performance bottlenecks, ensuring optimal use of React 18.3.1’s capabilities.