---
description: Coding Standards & Rules for Remix 2.15.3
globs: **/*.tsx, **/*.jsx
---

You are an expert in Remix, TypeScript, and related libraries. You are focusing on producing clear, readable code. You always use the latest stable versions of Remix 2.15.3 and you are familiar with the latest features and best practices.

Project Structure
- Use the v2 file system route convention with dot notation for nested routes (e.g., components.users.index.tsx for /users) to reflect URL hierarchy clearly.
- Prefix layout route files with an underscore (e.g., _layout.tsx) to differentiate them from regular route files.
- Use _index.tsx for index routes within a directory to define default routes intuitively.
- Avoid the v1 route convention unless maintaining compatibility with older Remix projects is necessary.
- Organize utility functions and shared logic in an app/utils directory to keep routes focused on rendering and data handling.
- Place server-only code in an app/server directory to separate it from client-side logic and enhance security.

Code Style
- Always write route files in TypeScript with .tsx extensions to ensure type safety and enhance tooling support.
- Define explicit types for loader and action functions to guarantee data consistency across server and client.
- Use async functions for data loading in routes to handle asynchronous operations with readable syntax.
- Handle all exceptions with ErrorBoundary components to provide a uniform error experience throughout the application.
- Replace useTransition with useNavigation for managing navigation state, aligning with v2 API updates.
- Utilize the Form component for form submissions to take advantage of Remix’s optimized handling.
- Ensure link attributes in route links use camelCase (e.g., imageSrcSet) to maintain consistency with v2 standards.
- Keep components small and focused by extracting reusable logic into custom hooks or composables within the app directory.
- Prefer functional components over class-based ones to align with Remix’s React foundations and simplify state management.

Usage
- Leverage the headers function in routes to set custom HTTP headers, ensuring the deepest route’s headers take precedence for fine-tuned control.
- Manage route meta data by returning an array of descriptors, accessible via the matches argument, for consistent SEO and metadata handling.
- Configure polyfills explicitly in remix.config.js to handle node built-ins, ensuring compatibility across deployment environments.
- Optimize performance by using defer in loader functions to delay non-critical data, improving initial page load times.
- Handle real-time data updates through polling or Server-Sent Events with libraries like remix-utils, as native WebSocket support is absent.
- Validate form data in action functions on the server to ensure integrity before processing submissions.
- Ensure cookies are formatted correctly in Set-Cookie headers to prevent duplication, a fix addressed in 2.15.3.
- Handle HTTP status codes like 204 appropriately in loader functions by returning no body, adhering to web standards.
- Use loader functions to fetch data server-side whenever possible to leverage Remix’s edge-first rendering capabilities.
- Implement client-side data fetching with useFetcher only when server-side rendering is impractical or unnecessary.

General Remix Coding Standards
- Design routes to handle both server-side and client-side rendering seamlessly, taking full advantage of Remix’s hybrid approach.
- Minimize client-side JavaScript by relying on server-side logic and HTML responses to reduce bundle size and improve performance.
- Use Remix’s built-in resource routes (e.g., files under app/routes/api) to serve non-HTML resources like JSON or files efficiently.
- Write loader and action functions to be idempotent where possible, ensuring consistent behavior across repeated requests.
- Avoid global state management libraries unless absolutely necessary, as Remix’s loader and action system often suffices for data flow.
- Ensure all external API calls in loaders include proper error handling to prevent uncaught exceptions from breaking the app.
- Use the json helper to return typed JSON responses from loaders and actions, improving readability and type safety.
- Structure CSS in Remix by scoping styles to routes or components, leveraging tools like Tailwind CSS or CSS modules for maintainability.
- Test loader and action functions independently with tools like Vitest to verify server-side logic without running the full app.
- Document route-specific behavior (e.g., loader dependencies, action side effects) in comments or a separate README to aid team collaboration.