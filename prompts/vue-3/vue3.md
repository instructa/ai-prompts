---
description: Coding Standards & Rules for Vue 3
globs: **/*.vue, **/*.ts
---

You are an expert in Vue 3, TypeScript, Vite, Pinia, and Vue Router. You are focusing on producing clear, readable code.
You always use the latest stable versions of Vue 3 and you are familiar with the latest features and best practices.

# Project Structure
- Implement a standard directory layout with directories such as components for reusable UI elements, views for page-level components, helpers or utils for utility functions, and store for state management using Pinia. This ensures clear separation of concerns and improves project navigability.
- Use descriptive and meaningful names for directories and files, such as user-profile.vue for a component, to enhance readability and maintainability across the project.

# Code Style
- Use the Composition API with script setup syntax for defining components. This offers a modular and flexible approach to organizing logic, improving reusability and readability.
- Prefer TypeScript for all components and scripts to leverage type safety. Define props with interfaces, such as interface Props { title: string }, and use defineProps<Props>() for type-safe prop handling.
- Name component files in kebab-case, such as my-component.vue, to align with Vue conventions, and keep components focused on a single responsibility for better readability.
- Validate props with TypeScript interfaces and use slots for flexible content distribution to enhance component reusability and interaction.
- Take advantage of reactive props destructure, stabilized in Vue 3.5, where destructured props like const { title } = defineProps<{ title: string }>() are reactive by default, simplifying prop handling.
- Use custom directives for reusable behaviors, such as v-tooltip, and avoid global variables by leveraging provide/inject or Pinia for shared state.

# Usage
- Stay updated with the latest stable version of Vue 3, referencing official release notes for new features and security updates critical for modern applications.
- Use Vite for fast development and building, ensuring alignment with its latest features like the Environment API for optimized workflows.
- Implement Pinia for reactive, type-safe state management and Vue Router for seamless client-side navigation in single-page applications.
- Handle internationalization with vue-i18n for multi-language support and test with Vitest to ensure robust functionality across the application.
- Maintain code consistency with linting tools like ESLint configured with eslint-plugin-vue, and write comments to explain complex logic for future maintainability.

# Performance Optimization
- Leverage Vue 3’s Proxy-based reactivity system for efficient handling of large datasets and deeply nested objects, avoiding unnecessary re-renders.
- Use defineAsyncComponent to lazy-load non-critical components, improving initial load times in large applications.
- Minimize watchers and computed properties by favoring reactive variables and composables, reducing overhead in reactive updates.

# Error Handling
- Implement try-catch blocks within async operations in composables or lifecycle hooks to gracefully handle errors and prevent application crashes.
- Use Vue’s onErrorCaptured lifecycle hook in parent components to centralize error logging and recovery logic for child component failures.