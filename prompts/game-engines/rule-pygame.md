---
description: "Guidelines for developing games with the Pygame library in Python"
globs: "*.py"
---

# Pygame Best Practices

## Project Structure and Organization

- Organize code into logical modules (game, sprites, scenes, ui, etc.)
- Separate game logic from rendering
- Use object-oriented design for game entities
- Create a main game loop in a dedicated file
- Use asset management systems for images, sounds, and other resources
- Implement proper error handling and logging
- Organize assets in dedicated directories
- Create utility modules for common functions
- Use configuration files for game settings
- Implement proper state management

## Game Loop and Timing

- Implement a consistent game loop (process events, update game state, render)
- Use pygame.time.Clock for consistent frame rate
- Calculate delta time for frame-rate independent movement
- Cap frame rate to prevent excessive CPU usage
- Handle timing for animations properly
- Implement proper game pausing
- Use consistent time units (milliseconds vs seconds)
- Consider fixed time step updates for physics
- Profile game loop performance
- Handle frame rate drops gracefully

## Input Handling

- Process all events in each frame
- Implement proper keyboard input handling
- Support gamepad/joystick input when appropriate
- Create abstractions for input actions
- Support key remapping and configuration
- Implement proper mouse input handling
- Consider using event-driven architecture for input
- Handle multiple input methods
- Implement proper input buffering for action games
- Support accessibility features

## Rendering

- Use layered rendering for proper z-order
- Implement proper sprite handling
- Create surface caching for static elements
- Use appropriate color formats for surfaces
- Implement dirty rectangle optimization when applicable
- Consider using pygame.SCALED flag for window scaling
- Implement camera systems for larger game worlds
- Use proper blending modes for transparency
- Implement proper sprite animation
- Consider using pygame.Surface.convert() for performance

## Sprites and Collisions

- Use pygame.sprite.Sprite as base class for game objects
- Organize sprites in pygame.sprite.Group for updates and rendering
- Implement proper collision detection
- Use appropriate collision shapes (rect, circle, mask)
- Optimize collision detection for large numbers of sprites
- Implement proper collision response
- Create sprite sheets for animations
- Use sprite animations effectively
- Implement proper sprite rotation and scaling
- Consider using spatial partitioning for collision optimization

## Sound and Music

- Initialize pygame.mixer with appropriate parameters
- Load sound effects and music efficiently
- Implement proper volume control
- Use channels for sound management
- Implement proper music looping and transitions
- Create sound manager for audio control
- Handle sound loading errors gracefully
- Implement proper audio feedback for game events
- Consider memory usage when loading audio
- Support muting and audio settings

## Performance Optimization

- Profile game performance regularly
- Use sprite groups for efficient updates and rendering
- Implement object pooling for frequently created/destroyed objects
- Avoid creating new objects in the game loop
- Use appropriate data structures for game state
- Optimize collision detection
- Use surface conversion for faster blitting
- Implement proper rendering optimizations
- Consider using pygame.HWSURFACE when appropriate
- Minimize surface locking operations

## UI and Text Rendering

- Create reusable UI components
- Implement proper text rendering with pygame.font
- Cache rendered text for static elements
- Create proper menu systems
- Implement UI scaling for different resolutions
- Use appropriate font sizes and colors for readability
- Implement proper UI navigation
- Create consistent UI feedback
- Support different languages and text localization
- Implement proper UI layouts

## State Management

- Implement proper game state management
- Create scene/screen management system
- Implement proper transitions between game states
- Handle loading and unloading resources between states
- Create proper pause and resume functionality
- Implement save/load game state
- Handle game state persistence
- Create proper game over and restart functionality
- Implement proper menu navigation
- Handle application exit properly

## Asset Management

- Create centralized asset loading system
- Implement proper error handling for missing assets
- Use appropriate asset formats for different resources
- Implement proper resource cleanup
- Consider memory usage when loading assets
- Implement asynchronous asset loading for large games
- Use appropriate compression for assets
- Create proper asset organization
- Document asset requirements and formats
- Implement proper asset versioning

## Testing and Debugging

- Implement debug rendering options
- Create proper logging for debugging
- Use assertions for critical game state
- Implement proper error handling
- Create testing framework for game mechanics
- Implement cheat codes for testing
- Use proper version control
- Document known issues and workarounds
- Create proper bug reporting system
- Test on different platforms and configurations