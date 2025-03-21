---
description: "Guidelines for building modern, performant iOS, macOS, watchOS, and tvOS applications with SwiftUI"
globs: "*.swift"
---

# SwiftUI Best Practices

## Architecture

- Use MVVM (Model-View-ViewModel) architecture
- Separate business logic from UI components
- Use ObservableObject for view models
- Implement dependency injection for better testability
- Use environment objects for dependency injection across the view hierarchy
- Create reusable, composable views
- Apply the single responsibility principle to views
- Use proper state management techniques
- Organize code into modules or packages for larger applications
- Leverage Swift Concurrency for asynchronous operations

## View Structure and Composition

- Keep views small and focused on a single responsibility
- Extract complex view logic into subviews
- Use view builders for creating dynamic views
- Prefer composition over inheritance
- Use view modifiers to customize views
- Create custom view modifiers for reusable styling
- Use Group for logical grouping without visual impact
- Apply consistent padding and spacing
- Implement proper layout structures with stacks
- Use GeometryReader judiciously

## State Management

- Choose the right property wrapper for each use case (@State, @Binding, @StateObject, @ObservedObject, @EnvironmentObject)
- Use @State for simple view-local state
- Use @StateObject for view-owned observable objects
- Use @ObservedObject for observable objects passed to the view
- Use @EnvironmentObject for objects shared across the view hierarchy
- Use @Binding for state passed from parent views
- Implement proper source of truth for state
- Avoid state duplication
- Consider using state reduction patterns for complex state
- Use Combine for complex state transformations

## Performance Optimization

- Minimize view body recalculations
- Use lazy stacks (LazyVStack, LazyHStack) for large collections
- Implement proper ID for List and ForEach
- Use opaque return types with `some View`
- Avoid expensive operations in view body
- Use @StateObject instead of @ObservedObject for view-created objects
- Optimize images with resizable and aspectRatio
- Use drawingGroup() for complex views
- Measure and optimize performance with Instruments
- Cache expensive computations

## Navigation and Data Flow

- Use NavigationStack and NavigationLink properly
- Implement deep linking and state restoration
- Pass minimal data between views
- Use proper state management for navigation state
- Consider using coordinators for complex navigation
- Implement proper error handling and presentation
- Use sheets, popovers, and alerts appropriately
- Handle back navigation and dismissal properly
- Consider using path-based navigation for complex flows
- Implement proper state persistence across navigation

## UI/UX Design

- Follow Apple's Human Interface Guidelines
- Support dynamic type for accessibility
- Implement proper dark mode support
- Use SF Symbols for consistent iconography
- Implement proper accessibility labels and hints
- Support VoiceOver and other accessibility features
- Use semantic colors for proper adaptability
- Implement proper feedback for user interactions
- Design for all device sizes and orientations
- Use proper animations and transitions

## Testing

- Implement unit tests for business logic and view models
- Use preview providers for visual testing
- Create preview macros for different device configurations
- Use ViewInspector for testing SwiftUI views
- Implement UI tests for critical flows
- Test edge cases and error states
- Mock dependencies for isolated testing
- Test across different device sizes and orientations
- Implement snapshot testing for visual regression
- Implement proper CI/CD for automated testing

## Data Persistence

- Use SwiftData for persistent storage when available
- Consider CoreData for complex data models
- Implement proper data migration strategies
- Use FileManager for file-based storage
- Implement proper error handling for data operations
- Consider using Realm or other third-party databases
- Use UserDefaults for simple preferences
- Implement proper caching strategies
- Handle data conflicts appropriately
- Consider using CloudKit for sync capabilities

## Networking

- Use URLSession for network requests
- Implement proper error handling for network operations
- Use Combine or async/await for asynchronous operations
- Implement proper loading and error states
- Handle offline capabilities gracefully
- Implement proper caching of network responses
- Use proper authentication and authorization
- Follow RESTful or GraphQL best practices
- Implement proper retry logic
- Monitor network performance

## Advanced Techniques

- Use custom layout containers for complex layouts
- Implement custom animations and transitions
- Use matchedGeometryEffect for smooth transitions
- Create custom shapes and paths
- Implement Canvas for custom drawing
- Use PreferenceKey for child-to-parent communication
- Implement proper keyboard handling
- Use UIViewRepresentable and NSViewRepresentable for platform-specific functionality
- Implement proper lifecycle management
- Use SwiftUI previews effectively