---
description: "Guidelines for writing clean, efficient, and idiomatic Kotlin code"
globs: "*.kt"
---

# Kotlin Best Practices

## Language Features

- Use `val` over `var` whenever possible to create immutable variables
- Take advantage of type inference rather than explicit type declarations
- Use string templates (`"Hello, $name!"`) instead of string concatenation
- Leverage extension functions to extend functionality of existing classes
- Use data classes for model/POJO classes to get equals(), hashCode(), toString(), and copy() for free
- Utilize object expressions and declarations for singletons
- Use sealed classes for representing restricted class hierarchies
- Make use of higher-order functions and lambdas for cleaner code
- Use named arguments for better readability, especially with multiple parameters
- Use default parameters instead of overloaded functions when appropriate
- Leverage inline functions for performance-critical code with lambdas
- Use the scope functions (let, apply, run, with, also) appropriately
- Use property delegates like lazy for efficient lazy initialization
- Use operator overloading judiciously and intuitively

## Null Safety

- Leverage the type system to prevent null pointer exceptions
- Prefer non-nullable types (`String`) over nullable types (`String?`)
- Use the safe call operator (`?.`) instead of null checks
- Use the Elvis operator (`?:`) for providing default values
- Use the not-null assertion operator (`!!`) only when you're absolutely sure a value isn't null
- Use the `lateinit` modifier for non-null properties initialized after construction
- Make sure to handle nullability properly in Java interop
- Use smart casts after null checks
- Utilize `requireNotNull()` or `checkNotNull()` for early validation
- Consider the `let` scope function with safe call for executing code only for non-null values

## Functional Programming

- Use functions as first-class citizens
- Take advantage of higher-order functions in the standard library (map, filter, fold, etc.)
- Use function references (::functionName) when passing functions
- Utilize the functional collection operations
- Make use of sequence for lazy evaluation of collection operations
- Use tail-recursive functions with the `tailrec` modifier for recursive operations
- Use immutable collections where appropriate
- Leverage the Pipeline pattern with extension functions
- Use function composition where appropriate
- Consider using Arrow or other functional libraries for more advanced functional programming features

## Coroutines

- Use coroutines for asynchronous programming
- Properly structure coroutines with CoroutineScope
- Use appropriate dispatchers (IO, Default, Main)
- Implement proper exception handling in coroutines
- Use supervisorScope for independent failure of children
- Properly cancel coroutines to avoid leaks
- Use structured concurrency principles
- Make use of flow for reactive streams
- Leverage channels for communication between coroutines
- Use withContext for changing context without creating new coroutines

## Collections

- Prefer immutable collections for thread safety and predictability
- Use the right collection for the job (List, Set, Map)
- Use the standard library's collection extension functions
- Chain collection operations for readability
- Use sequences for large collections to avoid intermediate collection creation
- Be mindful of performance implications when chaining many operations
- Use `mapOf()`, `listOf()`, `setOf()` for creating immutable collections
- Use `mutableMapOf()`, `mutableListOf()`, `mutableSetOf()` for creating mutable collections
- Leverage specialized collections for better performance when needed
- Use collection builders for complex collection construction

## Android Specific

- Use view binding or data binding instead of findViewById()
- Leverage Kotlin Android Extensions for synthetic properties
- Use the Android KTX extensions for cleaner code
- Implement lifecycle-aware components with LifecycleObserver
- Use coroutines for asynchronous operations instead of callbacks
- Leverage viewModelScope and lifecycleScope for coroutines
- Use Flow instead of LiveData when appropriate
- Use property delegates for shared preferences
- Follow the MVVM or MVI architecture pattern
- Implement proper dependency injection (Dagger, Hilt, Koin, etc.)

## Testing

- Write unit tests with JUnit and Mockito/MockK
- Use assertk or other Kotlin-friendly assertion libraries
- Leverage coroutine testing libraries for testing asynchronous code
- Write readable and maintainable tests
- Use data classes for test fixtures
- Use proper test naming conventions
- Implement integration tests where appropriate
- Use test doubles (mocks, stubs, fakes) effectively
- Test corner cases and edge conditions
- Aim for high test coverage but prioritize critical paths

## Interoperability

- Use `@JvmStatic` and `@JvmField` for better Java interoperability
- Handle Java's nullable types carefully in Kotlin
- Use `@JvmOverloads` for exposing functions with default parameters to Java
- Be mindful of name mangling when calling Kotlin code from Java
- Use `@Throws` to specify checked exceptions for Java callers
- Be aware of platform types coming from Java libraries
- Leverage Kotlin's SAM conversions for Java interfaces
- Use companion objects effectively with Java interop
- Be careful with extension functions in Java interop
- Consider Java consumers when designing Kotlin APIs

## Performance

- Use `inline` for small functions with lambdas to reduce overhead
- Be mindful of boxing/unboxing when using primitive types
- Use `const val` for compile-time constants
- Minimize object allocations in performance-critical code
- Use sequences for large collections to avoid intermediate allocations
- Be cautious about autoboxing in generic collection types
- Profile your code to identify bottlenecks
- Consider using value classes for wrappers over primitive types
- Use `@OptIn` with experimental APIs carefully
- Take advantage of inline classes for type safety without runtime overhead

## Code Style

- Follow the official Kotlin style guide
- Use meaningful and consistent naming conventions
- Write descriptive comments for complex logic
- Keep functions small and focused
- Use whitespace and indentation consistently
- Group related code together
- Limit line length for better readability
- Use code formatting tools like ktlint or detekt
- Document public APIs with KDoc
- Organize imports and package structure logically