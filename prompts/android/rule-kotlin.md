---
description: "Best practices for Android application development using Kotlin"
globs: "*.kt,*.kts,*.xml,AndroidManifest.xml,build.gradle,build.gradle.kts"
alwaysApply: false
---

# Kotlin Android Development Best Practices

## Key Principles

- Apply modern Android architecture patterns (MVVM, MVI)
- Implement clean separation of concerns in app components
- Utilize Kotlin language features effectively
- Create responsive and efficient UI implementations
- Implement proper asynchronous programming patterns
- Apply effective testing strategies for Android components
- Follow best practices for app security and performance

## Architecture and Structure

- Implement proper architectural patterns (MVVM, Clean Architecture)
- Create clear separation between UI, business logic, and data
- Apply appropriate dependency injection
- Use proper repository pattern for data access
- Implement effective navigation patterns
- Create modular app structure
- Apply appropriate feature modularization
- Use proper state management
- Implement effective error handling
- Create proper configuration change handling

## Kotlin Language Features

- Use data classes for model objects
- Implement extension functions appropriately
- Apply scope functions (let, run, with, apply, also)
- Utilize property delegates effectively
- Implement proper null safety patterns
- Create effective higher-order functions
- Apply appropriate use of sealed classes
- Use coroutines for asynchronous code
- Implement flow for reactive programming
- Apply proper functional programming techniques

## UI Implementation

- Follow Material Design guidelines
- Implement proper view binding
- Apply appropriate theme and style hierarchy
- Use ConstraintLayout effectively
- Implement efficient RecyclerView patterns
- Create responsive layouts for different screen sizes
- Apply proper animation patterns
- Implement effective custom views
- Use Jetpack Compose for modern UI (if applicable)
- Create accessible UI components

## Asynchronous Programming

- Use coroutines for asynchronous operations
- Implement proper coroutine scopes
- Apply appropriate dispatchers
- Create effective error handling in coroutines
- Use flows for reactive streams
- Implement proper lifecycle-aware coroutines
- Apply effective cancellation patterns
- Create proper background work with WorkManager
- Implement efficient network operations
- Use proper state management with coroutines

## Data Management

- Implement Room for local database
- Apply proper data caching strategies
- Use appropriate network libraries (Retrofit, Ktor)
- Implement effective data serialization
- Create proper offline support
- Apply effective data synchronization patterns
- Use appropriate data store for preferences
- Implement proper database migration strategies
- Create effective content provider implementations
- Apply proper data security practices

## Testing

- Implement comprehensive unit tests
- Create effective instrumentation tests
- Apply proper UI testing with Espresso
- Use appropriate mocking strategies
- Implement proper test architecture
- Create testable components
- Apply effective test-driven development
- Use proper testing libraries (JUnit, Mockito, etc.)
- Implement proper test coverage
- Create effective CI/CD for testing

## Performance and Optimization

- Apply proper view recycling
- Implement efficient image loading
- Create appropriate background processing
- Use proper memory management
- Apply effective battery optimization
- Implement appropriate lazy loading
- Create efficient startup performance
- Apply proper resource optimization
- Use ProGuard/R8 for code shrinking
- Implement effective app size reduction techniques
