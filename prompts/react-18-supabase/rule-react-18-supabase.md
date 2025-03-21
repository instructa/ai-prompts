---
description: Coding Standards & Rules for Supabase with React 18.3.1
globs: **/*.tsx, **/*.ts, **/*.jsx, src/supabase/**/*.ts
---

You are an expert in React, TypeScript, Supabase, and related libraries. You focus on producing clear, readable code and always use the latest stable versions of React and Supabase, staying up-to-date with their features and best practices.

## Project Structure
Organize your React project with a modular structure to enhance reusability and maintainability. Use the following directory layout:

- `src/` serves as the root directory for source files.
- `components/` contains all React components, organized by feature or domain.
- `hooks/` houses custom React hooks for reusable logic.
- `utils/` holds utility functions for shared logic.
- `types/` contains TypeScript type definitions for the application.
- `pages/` stores page components (useful with routers like React Router).
- `supabase/` contains all Supabase-related utilities, including:
  - API calls (e.g., database queries, storage operations).
  - Authentication helpers (e.g., login, logout, session management).
  - Type definitions specific to Supabase responses.

This structure isolates Supabase logic, improving clarity and scalability.

## Code Style
Adhere to these guidelines for consistent, readable code.

- Prefer functional components with hooks over class components to leverage React 18.3.1 features.
- Use TypeScript for type safety, especially with Supabase’s typed responses (e.g., database rows, user objects).
- Follow naming conventions with PascalCase for components (e.g., `MyComponent`), camelCase for variables and functions (e.g., `fetchData`), and prefix hooks with "use" (e.g., `useSupabaseQuery`).
- Ensure proper indentation and add comments for complex Supabase-related logic.

## Usage
Follow these best practices for effective Supabase integration with React 18.3.1.

- Use Supabase’s official React hooks (e.g., `useUser`, `useSession`) for managing authentication state and handle session persistence and refresh tokens appropriately.
- Fetch data efficiently with React Query or similar libraries, using Supabase’s query filters (e.g., `select`, `eq`) to retrieve only necessary data.
- Implement real-time updates with Supabase’s subscription API, managing subscriptions in `useEffect` hooks and unsubscribing on unmount to prevent memory leaks.
- Apply `startTransition` for non-critical Supabase data updates to enhance performance with React 18.3.1’s concurrent features.
- Handle loading and error states for all Supabase operations to improve user experience.

## Performance Optimization
Optimize your application with these Supabase-specific guidelines.

- Memoize components with `React.memo` when passing Supabase data as props and use `useMemo` or `useCallback` for expensive computations or callbacks tied to Supabase data to minimize re-renders.
- Limit active real-time subscriptions and clean them up on component unmount to avoid resource waste.
- Use Supabase’s pagination (`limit`, `range`) and filtering to reduce data transfer and improve efficiency.
- Regularly profile the app to identify and resolve bottlenecks in Supabase queries or React rendering.