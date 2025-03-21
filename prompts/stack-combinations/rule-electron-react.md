---
description: "Guidelines for building robust, performant, and maintainable desktop applications with Electron and React"
globs: "*.js,*.jsx,*.ts,*.tsx"
---

# Electron + React Best Practices

## Project Structure

- Separate main and renderer processes clearly
- Implement proper module boundaries
- Design appropriate folder organization
- Consider monorepo structure for complex applications
- Implement clear separation between UI and business logic
- Document project architecture and organization
- Consider appropriate asset management strategy
- Implement proper build configuration
- Design for appropriate test organization
- Document file structure and conventions

## React Implementation

- Choose appropriate state management (Redux, MobX, Context API)
- Implement component hierarchy with proper composition
- Design for proper props management
- Consider appropriate hooks usage
- Implement proper component lifecycle management
- Document component responsibilities
- Consider React performance optimization techniques
- Implement proper error boundaries
- Design for appropriate component reusability
- Consider styling strategy (CSS-in-JS, CSS Modules, etc.)

## Electron Main Process

- Implement proper window management
- Design for appropriate IPC handling
- Consider security in main process implementation
- Implement proper app lifecycle management
- Document main process responsibilities
- Consider proper menu and tray implementation
- Implement system integration features appropriately
- Design for proper error handling in main process
- Consider proper protocol handling
- Implement appropriate auto-update management

## Inter-Process Communication (IPC)

- Design clear IPC channels and events
- Implement proper error handling for IPC
- Consider security in IPC implementation
- Document IPC contract between processes
- Consider typed IPC communication
- Implement proper response handling
- Design for appropriate synchronous vs. asynchronous IPC
- Consider performance implications of IPC patterns
- Implement proper validation for IPC messages
- Design for proper IPC channel organization

## File System Access

- Implement proper file system operations
- Design for appropriate permission handling
- Consider security in file operations
- Implement proper error handling for file operations
- Document file system interactions
- Consider appropriate file watching patterns
- Implement proper file locking where needed
- Design for appropriate temp file management
- Consider cross-platform file path handling
- Implement proper file cleanup procedures

## Native Integration

- Use native modules appropriately
- Design for proper native dependency management
- Consider rebuild strategies for native modules
- Implement proper error handling for native operations
- Document native integration points
- Consider cross-platform compatibility
- Implement proper fallbacks for unavailable native features
- Design for appropriate native performance optimization
- Consider security implications of native modules
- Document native module versioning requirements

## Security

- Implement proper Content Security Policy
- Design for appropriate contextIsolation settings
- Consider nodeIntegration security implications
- Implement proper input validation
- Document security controls and assumptions
- Consider proper permission handling
- Implement secure IPC communication
- Design for appropriate webSecurity settings
- Consider secure storage of sensitive data
- Implement proper HTTPS certificate validation

## Performance Optimization

- Implement proper memory management
- Design for appropriate garbage collection
- Consider renderer process optimization
- Implement proper caching strategies
- Document performance metrics and targets
- Consider proper resource utilization
- Implement process-appropriate operations
- Design for appropriate startup performance
- Consider lazy loading for performance
- Implement proper resource cleanup

## Testing

- Implement unit testing for React components
- Design for appropriate integration testing
- Consider Electron-specific testing strategies
- Implement end-to-end testing
- Document testing approach and coverage
- Consider proper test environment setup
- Implement continuous integration for testing
- Design for appropriate mocking strategies
- Consider performance testing
- Implement proper test data management

## Packaging and Distribution

- Implement proper build configuration
- Design for appropriate code signing
- Consider auto-update implementation
- Implement proper versioning strategy
- Document build and release procedures
- Consider platform-specific packaging requirements
- Implement proper asset bundling
- Design for appropriate installer configuration
- Consider license management in distribution
- Implement proper crash reporting

## State Management

- Choose appropriate state management library
- Implement proper state organization
- Design for appropriate persistence
- Consider state synchronization across windows
- Implement proper state migration for updates
- Document state management approach
- Consider performance implications of state architecture
- Implement proper error handling in state operations
- Design for appropriate state access patterns
- Consider state serialization strategies

## Offline Support

- Implement proper offline detection
- Design for appropriate offline functionality
- Consider data synchronization strategies
- Implement proper conflict resolution
- Document offline capabilities and limitations
- Consider appropriate caching strategies
- Implement proper error handling for offline state
- Design for appropriate offline UX
- Consider offline first development approach
- Implement proper recovery from offline state

## Cross-Platform Considerations

- Design for appropriate platform-specific features
- Implement proper path handling across platforms
- Consider platform-specific styling
- Document platform support and limitations
- Consider appropriate fallbacks for platform-specific features
- Implement proper platform detection
- Design for appropriate window management across platforms
- Consider platform-specific build configurations
- Implement proper keyboard shortcuts for all platforms
- Design for appropriate menu structure across platforms

## Monitoring and Error Reporting

- Implement proper crash reporting
- Design for appropriate telemetry collection
- Consider privacy in monitoring implementation
- Implement proper error logging
- Document monitoring approach
- Consider remote debugging capabilities
- Implement proper diagnostics collection
- Design for appropriate user consent for telemetry
- Consider automated issue reporting
- Implement proper environment information collection

## Updates and Versioning

- Implement proper auto-update mechanisms
- Design for appropriate update notification
- Consider delta updates for efficiency
- Implement proper update verification
- Document update procedures and policies
- Consider staged rollouts for updates
- Implement proper version checking
- Design for appropriate update UI
- Consider background updates vs. manual updates
- Implement proper update error handling