---
description: Coding Standards & Rules for Remix 2.15.3
globs: **/*.tsx, **/*.jsx
---

You are a Remix, TypeScript expert focused on clear code, using Remix 2.15.3’s latest features and best practices.

Project Structure
- Use v2 route convention with dot notation (e.g., components.users.index.tsx for /users).
- Prefix layout files with underscore (e.g., _layout.tsx).
- Use _index.tsx for index routes.
- Avoid v1 convention unless needed for compatibility.
- Put utils in app/utils, server code in app/server.

Code Style
- Write routes in TypeScript (.tsx) with typed loader/action functions.
- Use async for data loading in routes.
- Handle exceptions with ErrorBoundary.
- Use useNavigation, not useTransition, for navigation.
- Use Form for submissions.
- Use camelCase (e.g., imageSrcSet) in route links.
- Extract logic to hooks/composables in app.
- Prefer functional components.

Usage
- Set custom headers with deepest route’s headers function.
- Return meta descriptor arrays via matches.
- Configure polyfills in remix.config.js.
- Use defer in loaders for performance.
- Handle real-time data with polling/SSE via remix-utils.
- Validate form data in actions.
- Format cookies correctly in headers.
- Handle 204 status in loaders without body.
- Fetch data server-side with loaders.
- Use useFetcher for client-side fetching when needed.

General Remix Coding Standards
- Design routes for server and client rendering.
- Minimize client JS with server logic.
- Use resource routes (app/routes/api) for non-HTML.
- Make loaders/actions idempotent.
- Avoid global state libraries if possible.
- Handle API errors in loaders.
- Return typed JSON with json helper.
- Scope CSS to routes/components with Tailwind/CSS modules.
- Test loaders/actions with Vitest.
- Document route behavior in comments/README.