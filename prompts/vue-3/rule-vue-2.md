---
description: Coding Standards & Rules for Vue 3
globs: **/*.vue, **/*.ts, **/*.js
---

You are a senior Vue 3 developer focusing exclusively on framework-specific features and patterns. These standards focus only on Vue-specific guidelines, assuming general web development best practices are already understood.

Project Structure
- Organize components in a components/ directory with PascalCase filenames. For example, use components/MyComponent.vue for a reusable component.
- Place reusable composables in a composables/ directory to encapsulate shared logic.
- Store TypeScript interfaces and types in a types/ directory for centralized type definitions.
- Keep utility functions in a utils/ directory to maintain modularity.

Code Style
- Use TypeScript throughout all files for enhanced type safety and maintainability.
- Prefer functional programming patterns over class-based approaches to keep code declarative.
- Name components with PascalCase. For example, use MyComponent.vue for a component file.
- Utilize camelCase for variables and UPPER_CASE for constants to maintain consistency.
- Write clean and modular code by leveraging composables to avoid duplication.

Usage

Composition API
- Use `<script setup>` syntax with TypeScript for enhanced type safety in all components.
- Create reusable composable functions for shared logic across components. For example, use `function useCounter() { const count = ref(0); return { count }; }`.

Component Architecture
- Define component props using TypeScript interfaces with runtime validation. For example, use `const props = defineProps<{ message: string }>()`.
- Implement two-way binding with defineModel. For example, use `const model = defineModel<string>('value', { default: '' })`.

State Management
- Use Pinia for large-scale state management in applications with complex state.
- Create custom stores with composables for shared state. For example, use `const useUserStore = defineStore('user', () => { const user = ref<User | null>(null); return { user }; })`.

Performance Optimization
- Use shallowRef for large objects that do not require deep reactivity. For example, use `const largeData = shallowRef<DataType>(initialValue)`.
- Implement v-memo in templates to skip unnecessary re-renders of static content.
- Enable Vapor Mode where possible to improve runtime performance by bypassing the Virtual DOM.

Reactivity System
- Use ref for primitive values and reactive for objects to manage state. For example, use `const count = ref(0)` and `const state = reactive({ key: 'value' })`.
- Implement computed properties for derived state. For example, use `const fullName = computed(() => `${firstName.value} ${lastName.value}`)`.

Template Patterns
- Use v-bind with dynamic props to create flexible component interfaces.
- Implement slots with fallback content for reusable templates. For example, use `<template #default="{ item }">{{ item.name }}</template>`.

Component Features
- Use defineProps and defineEmits for clear component communication. For example, use `const emit = defineEmits<(e: 'update', value: string) => void>()`.
- Handle async components with Suspense. For example, use `const AsyncComponent = defineAsyncComponent(() => import('./Component.vue'))`.

Template Features
- Use v-model with defineModel for form inputs to simplify two-way binding. For example, use `v-model="searchQuery"`.
- Implement custom directives for reusable DOM manipulations. For example, create a directive to focus an input with `app.directive('focus', { mounted(el) { el.focus(); } })`.