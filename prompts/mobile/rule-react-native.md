---
description: "Guidelines for building performant, maintainable, and user-friendly mobile applications with React Native"
globs: "*.{js,jsx,ts,tsx}"
---

# React Native Best Practices

## Project Structure

- Organize code by feature or domain
- Use clear and consistent naming conventions
- Separate business logic from UI components
- Implement proper navigation structure
- Use proper directory organization for assets
- Separate API calls into services
- Keep configuration in dedicated files
- Organize styles consistently
- Use proper file naming conventions
- Document project structure for new team members

## Architecture and State Management

- Choose appropriate state management (Redux, Context API, MobX)
- Implement proper data flow architecture
- Use selectors for accessing state
- Keep components stateless when possible
- Separate business logic into hooks or dedicated files
- Implement proper error handling
- Use immutable state patterns
- Follow unidirectional data flow principles
- Implement proper side effect management
- Document your architecture choices

## Component Design

- Build small, reusable components
- Use functional components with hooks
- Implement proper prop validation
- Use PureComponent or React.memo for performance
- Keep components focused on a single responsibility
- Implement consistent styling patterns
- Use composition over inheritance
- Create proper component documentation
- Create a component library or storybook
- Implement proper component testing

## Performance Optimization

- Use FlatList instead of ScrollView for long lists
- Implement proper list item rendering optimizations
- Use proper image optimization techniques
- Avoid unnecessary re-renders
- Use useCallback and useMemo appropriately
- Implement proper loading states and skeletons
- Optimize JavaScript bundle size
- Use proper memory management techniques
- Implement performance monitoring
- Test performance on actual devices, not just simulators

## Styling

- Use a consistent styling approach (StyleSheet, styled-components, etc.)
- Implement proper responsive designs
- Use proper theming for consistency
- Consider design systems for larger projects
- Implement proper dark mode support
- Create reusable style components
- Use proper typography system
- Implement proper spacing system
- Handle different screen sizes and orientations
- Test styling on multiple devices

## Navigation

- Use React Navigation or a similar robust solution
- Implement proper navigation patterns
- Handle deep linking appropriately
- Implement proper navigation guards
- Use consistent transition animations
- Handle navigation state persistence if needed
- Implement proper tab and drawer navigation
- Handle navigation history properly
- Document navigation structure
- Test navigation flows thoroughly

## API Integration

- Implement proper API service layer
- Use axios or fetch with proper error handling
- Implement proper loading and error states
- Use proper caching strategies
- Implement retry mechanisms for failed requests
- Handle API versioning properly
- Implement proper authentication token management
- Use proper data transformation layers
- Document API integration
- Test API integration with mocks

## Offline Support

- Implement proper offline detection
- Use appropriate local storage solutions
- Implement proper data synchronization
- Handle offline user actions appropriately
- Provide clear feedback about offline status
- Implement proper error recovery when back online
- Test offline scenarios thoroughly
- Document offline behavior
- Consider using Redux Persist or similar for state persistence
- Implement proper conflict resolution strategies

## Testing

- Implement unit tests for business logic
- Use Jest for testing
- Implement component testing with React Native Testing Library
- Create end-to-end tests with Detox or similar
- Implement proper mocking strategies
- Test on multiple devices and OS versions
- Implement proper test coverage
- Document testing procedures
- Implement continuous integration for testing
- Consider snapshot testing for UI components

## Native Modules

- Use native modules judiciously
- Document native module usage and installation
- Keep native code well-organized
- Handle platform differences properly
- Test native modules on all supported platforms
- Consider alternatives before writing custom native modules
- Maintain proper version compatibility
- Document build requirements for native modules
- Follow platform-specific best practices
- Keep native dependencies updated

## Security

- Implement proper authentication and authorization
- Secure sensitive data using proper storage
- Implement proper certificate pinning for API calls
- Handle app permissions properly
- Sanitize user inputs
- Implement proper session management
- Consider obfuscation for sensitive code
- Follow platform security best practices
- Implement proper error handling without leaking information
- Conduct security testing

## Accessibility

- Use proper accessibility labels
- Implement proper focus management
- Support screen readers (VoiceOver, TalkBack)
- Use proper color contrast
- Implement proper text scaling
- Test with accessibility tools
- Support reduced motion preferences
- Implement proper keyboard navigation
- Document accessibility features
- Follow platform-specific accessibility guidelines

## Internationalization (i18n)

- Use proper i18n libraries (i18next, react-i18next)
- Extract all strings for translation
- Handle proper date and number formatting
- Consider RTL language support
- Implement proper pluralization handling
- Test with different languages
- Consider cultural differences in design
- Document localization process
- Implement proper fallback mechanisms
- Consider dynamic language switching

## Code Quality and Patterns

- Use ESLint and Prettier for code quality
- Implement proper TypeScript typing
- Follow React and React Native best practices
- Use consistent coding patterns
- Document complex logic
- Implement proper error boundaries
- Use proper design patterns
- Conduct regular code reviews
- Refactor code when necessary
- Keep dependencies updated

## Development Workflow

- Use proper versioning and branching strategy
- Implement continuous integration
- Use proper environment configurations
- Document build and release procedures
- Implement proper debugging tools
- Use React Native Flipper for debugging
- Implement proper logging
- Document common issues and solutions
- Use proper dependency management
- Implement proper error reporting

## App Store Optimization

- Optimize app size
- Implement proper app icons and splash screens
- Create compelling screenshots and previews
- Write clear and concise app descriptions
- Implement proper app indexing for search
- Consider implementing app review requests
- Follow platform guidelines for submission
- Implement proper versioning strategy
- Document submission process
- Track and analyze user feedback

## CI/CD and DevOps

- Implement automated builds
- Use proper signing and provisioning
- Implement proper testing in CI pipeline
- Use proper deployment strategies
- Implement proper crash reporting
- Use proper analytics integration
- Document CI/CD process
- Implement proper versioning
- Consider using Fastlane for automation
- Implement proper environment management

## Deep Linking and App Links

- Implement proper deep linking support
- Handle universal links (iOS) and app links (Android)
- Test deep linking scenarios
- Document deep link structure
- Implement proper deep link handling in navigation
- Consider deep links for marketing campaigns
- Implement proper deep link analytics
- Test deep links across different entry points
- Document deep link testing procedures
- Consider deep link security implications

## Push Notifications

- Implement proper push notification handling
- Handle notification permissions properly
- Implement proper notification channels (Android)
- Handle notification interactions
- Implement proper notification payload handling
- Test notifications in different app states
- Document notification structure
- Implement proper notification analytics
- Consider using a notification service
- Implement proper notification grouping