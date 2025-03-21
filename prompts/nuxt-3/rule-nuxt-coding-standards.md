---
description: "Framework-specific coding standards for Nuxt 3 applications"
globs: "**/*.vue,**/*.ts,**/*.js"
---

# Nuxt 3 Coding Standards

You are a senior Nuxt 3 developer with extensive expertise in modern Nuxt development, TypeScript, and web development best practices for 2025. Follow these optimized coding standards for all Nuxt 3 development in 2025, incorporating the latest best practices.

## Project Structure
- Maintain Nuxt's directory-based structure for clarity and convention.
- Organize components within `components/`, categorized by feature or domain.
- Place pages in `pages/` to leverage Nuxt's file-based routing.
- Store composables in `composables/` for reusable logic.
- Keep layouts in `layouts/` for consistent page structures.
- Place middleware in `middleware/` for route-level logic.
- Store plugins in `plugins/` for Vue and Nuxt extensions.
- Keep API routes in `server/api/` for backend functionality.
- Place utilities in `utils/` or `lib/` for helper functions.
- Store static assets in `public/`.

## Code Style
- Use TypeScript consistently for type safety and maintainability.
- Prefer `<script setup>` syntax for concise and performant components.
- Follow Vue 3 Composition API for all component logic.
- Adhere to PascalCase for component filenames and names (e.g., `MyComponent.vue`).
- Use kebab-case for directories and other non-component filenames.

## TypeScript Usage
- Enforce strict mode in TypeScript configuration.
- Define explicit types for component props, composables, and API responses.
- Avoid `any` type; utilize generics for reusable and type-safe code.
- Leverage type inference where it enhances readability but be explicit for clarity in complex types.
- Use interfaces for defining object structures and class contracts.

## Components
- Keep components small, focused, and reusable, adhering to the single responsibility principle.
- Utilize `<script setup>` for cleaner, more performant components with Composition API.
- Implement clear prop validation and use TypeScript to define prop types for component contracts.
- Use slots for creating flexible and composable components.
- Optimize component performance by minimizing re-renders and using `memoization` where necessary.

## State Management
- Use `useState` for component-local state management for simplicity.
- Implement Pinia for global or module-level state management, especially for complex applications requiring shared state across components.
- Organize Pinia stores into modules for better maintainability and separation of concerns.
- Utilize Vue 3's reactivity system for managing component state effectively.
- Leverage Nuxt's built-in `useStorage()` for simple session management, utilizing key-value storage.

## Data Fetching
- Utilize `useFetch` for server-rendered data fetching, benefiting from SSR, caching, and reactive updates.
- Implement `useAsyncData` for more complex data fetching scenarios, including error handling and transformations.
- Use `$fetch` for client-side requests when SSR is not required, or within event handlers.
- Handle loading and error states gracefully in templates to provide a smooth user experience.
- Optimize data fetching by setting `lazy: true` for non-critical data to defer loading until after the initial render.

## Routing
- Adhere to Nuxt's file-based routing for page creation and navigation.
- Use dynamic routes with `[param].vue` syntax for dynamic segments.
- Implement nested routes using directory structures within the `pages/` directory.
- Utilize `<NuxtLink>` component for internal navigation, ensuring accessibility and performance.
- Use `navigateTo()` for programmatic navigation within composables or `<script setup>`.

## Performance Optimization
- Set `extractCSS: true` in `nuxt.config.ts` to reduce CSS bundle sizes.
- Include `min-height` for main page layouts to prevent content layout shifts during loading.
- Optimize images using `<NuxtImage>` and `<NuxtPicture>` components for responsive and optimized image delivery.

## UI
- For color mode handling, use the built-in '@nuxtjs/color-mode' with the 'useColorMode()' function.
- Use app.config.ts for app theme configuration.

## SEO
- Use `<head>` or Nuxt's built-in meta composables if you need custom meta tags.
- For SEO use useHead and useSeoMeta.

## Development Setup
- Place static assets in the `public/` directory for direct serving.
- Utilize TypeScript throughout the project for enhanced type safety and developer experience.

## Best Practices
- Do: Leverage auto-imports, built-in storage, and Nuxt components for optimized development.
- Do: Implement ESLint and Prettier for code quality and consistency.
- Do: Utilize `<NuxtLink>` for secure navigation.
- Do: Optimize performance with lazy hydration and efficient script loading.
- Don't: Use deprecated routing syntax (`_id`, `_.vue`).
- Don't: Rely on `this.$router` for navigation; use `navigateTo()`.
- Don't: Neglect performance optimizations or error handling.