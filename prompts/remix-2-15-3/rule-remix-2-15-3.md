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

Code Style
- Always write route files in TypeScript with .tsx extensions to ensure type safety and enhance tooling support.
- Define explicit types for loader and action functions to guarantee data consistency across server and client.
- Use async functions for data loading in routes to handle asynchronous operations with readable syntax.
- Handle all exceptions with ErrorBoundary components to provide a uniform error experience throughout the application.
- Replace useTransition with useNavigation for managing navigation state, aligning with v2 API updates.
- Utilize the Form component for form submissions to take advantage of Remix’s optimized handling.
- Ensure link attributes in route links use camelCase (e.g., imageSrcSet) to maintain consistency with v2 standards.

Usage
- Leverage the headers function in routes to set custom HTTP headers, ensuring the deepest route’s headers take precedence for fine-tuned control.
- Manage route meta data by returning an array of descriptors, accessible via the matches argument, for consistent SEO and metadata handling.
- Configure polyfills explicitly in remix.config.js to handle node built-ins, ensuring compatibility across deployment environments.
- Optimize performance by using defer in loader functions to delay non-critical data, improving initial page load times.
- Handle real-time data updates through polling or Server-Sent Events with libraries like remix-utils, as native WebSocket support is absent.
- Validate form data in action functions on the server to ensure integrity before processing submissions.
- Ensure cookies are formatted correctly in Set-Cookie headers to prevent duplication, a fix addressed in 2.15.3.
- Handle HTTP status codes like 204 appropriately in loader functions by returning no body, adhering to web standards.