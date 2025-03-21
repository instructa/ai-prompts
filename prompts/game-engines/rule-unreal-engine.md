---
description: "Best practices for game development with Unreal Engine"
globs: "*.uasset,*.uproject,*.cpp,*.h,*.ini,Source/**"
---

# Unreal Engine Best Practices

Unreal Engine is a powerful real-time 3D creation tool for photorealistic visuals and immersive experiences, widely used in game development, film, and other industries.

## Project Structure

### Directory Organization
- Follow Unreal's standard folder structure
- Create content folders by category or feature
- Use clear naming conventions for all assets
- Separate blueprints from other content types

```
ProjectName/
├── Config/
├── Content/
│   ├── Characters/
│   │   ├── Player/
│   │   └── NPCs/
│   ├── Environment/
│   │   ├── Landscape/
│   │   ├── Props/
│   │   └── Architecture/
│   ├── UI/
│   ├── VFX/
│   ├── Audio/
│   └── Blueprints/
├── Source/
│   ├── ProjectName/
│   └── ProjectNameEditor/
└── Plugins/
```

### Asset Organization
- Prefix assets by type (BP_, M_, T_, etc.)
- Group related assets with folders
- Use numbered suffixes for variations (_01, _02)
- Keep material instances near their parent materials

```
SM_Chair_01         // Static Mesh Chair variant 1
T_Wood_Diffuse      // Wood texture (diffuse/albedo)
M_Wood              // Wood master material
MI_Wood_Mahogany    // Wood material instance (mahogany)
BP_InteractiveDoor  // Door blueprint
```

### Content Naming
- Use PascalCase for asset names
- Apply consistent prefixes for asset types
- Include descriptive suffixes when needed
- Avoid spaces and special characters

| Asset Type          | Prefix | Example               |
|---------------------|--------|------------------------|
| Blueprint           | BP_    | BP_PlayerCharacter     |
| Material            | M_     | M_Metal_Gold           |
| Material Instance   | MI_    | MI_Metal_Copper        |
| Texture             | T_     | T_Brick_Diffuse        |
| Static Mesh         | SM_    | SM_Chair               |
| Skeletal Mesh       | SK_    | SK_HumanMale           |
| Animation Blueprint | ABP_   | ABP_PlayerCharacter    |
| Animation Sequence  | A_     | A_PlayerRun            |
| Particle System     | PS_    | PS_Fire                |
| Sound Cue           | SC_    | SC_Explosion           |
| Sound Wave          | SW_    | SW_Footstep            |

## C++ Code Practices

### Code Structure
- Follow Unreal's coding standard
- Use `U` prefix for UObject-derived classes
- Use `A` prefix for AActor-derived classes
- Use `I` prefix for interfaces

```cpp
// MyCharacter.h
#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Character.h"
#include "MyCharacter.generated.h"

UCLASS()
class MYGAME_API AMyCharacter : public ACharacter
{
    GENERATED_BODY()
    
public:
    AMyCharacter();
    
    // Public properties
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Movement")
    float MaxSpeed;
    
protected:
    virtual void BeginPlay() override;
    
    // Protected properties
    UPROPERTY(EditDefaultsOnly, Category = "Animation")
    UAnimMontage* AttackMontage;
    
private:
    // Private methods
    void InitializeComponents();
    
    // Private properties
    UPROPERTY()
    bool bIsAttacking;
};
```

### Property Specifiers
- Use appropriate property specifiers
  - `EditAnywhere`: Can be edited by property windows for all instances
  - `EditDefaultsOnly`: Can only be edited on archetypes/defaults
  - `EditInstanceOnly`: Can only be edited on instances, not archetypes
  - `BlueprintReadWrite`: Property can be read or written from Blueprints
  - `BlueprintReadOnly`: Property can only be read from Blueprints
- Group properties into categories
- Add tooltip descriptions for complex properties

```cpp
// Property with full specifiers
UPROPERTY(
    EditAnywhere,              // Edit in editor
    BlueprintReadOnly,         // Blueprints can read but not modify
    Category = "Combat",       // Property category in editor
    meta = (
        ClampMin = "0.0",      // Minimum allowed value
        ToolTip = "Maximum damage dealt by this weapon"
    )
)
float MaxDamage;
```

### Garbage Collection
- Use proper UPROPERTY() to prevent garbage collection
- Avoid raw pointers to UObject-derived classes
- Implement proper object cleanup
- Use TWeakObjectPtr for optional references

```cpp
// Strong reference (prevents garbage collection)
UPROPERTY()
UStaticMeshComponent* MeshComponent;

// Weak reference (doesn't prevent garbage collection)
TWeakObjectPtr<AActor> TargetActor;
```

## Blueprint Best Practices

### Blueprint Types
- Use appropriate blueprint types for different purposes:
  - Blueprint Class: For interactive objects and gameplay elements
  - Blueprint Interface: For shared functionality across different classes
  - Blueprint Function Library: For global utility functions
  - Blueprint Macro Library: For reusable graph node sequences
- Don't overuse inheritance; prefer composition

### Blueprint Organization
- Use functions to encapsulate repeatable logic
- Create event dispatchers for loose coupling
- Organize execution flow from left to right
- Use descriptive comment boxes for complex sections

### Blueprint Communication
- Implement Blueprint interfaces for type-agnostic communication
- Use event dispatchers for one-to-many communication
- Consider direct references for frequently accessed objects
- Use game subsystems for global state

```
// Communication patterns
1. Blueprint Interface: Called Object provides interface, Caller casts and calls function
2. Event Dispatcher: Object with event binds to it, Owner broadcasts event
3. Direct Reference: Direct call through object reference
4. Game Instance: Store global data accessible anywhere
5. Game State: Network-replicated global information
```

### Blueprint Performance
- Minimize "Event Tick" usage; use timers instead
- Batch related operations in a single function
- Avoid excessive casting operations
- Use variables to cache results of expensive operations

## Materials

### Material Structure
- Build modular material functions
- Create master materials with parameters
- Use material instances for variations
- Implement material LODs (Levels of Detail)

```
Master Material Hierarchy:
M_Master_Surface          // Base master with shared properties
├── M_Master_Opaque       // Master for opaque surfaces
│   ├── MI_Metal_Gold     // Instance for gold metal
│   └── MI_Wood_Oak       // Instance for oak wood
└── M_Master_Transparent  // Master for transparent surfaces
    └── MI_Glass_Clear    // Instance for clear glass
```

### Material Performance
- Limit instruction count for mobile platforms
- Implement texture streaming for large textures
- Use material quality switches for different platforms
- Avoid expensive operations (noise, raymarching)

## Level Design

### World Composition
- Use World Composition for large landscapes
- Implement level streaming for performance
- Create modular environment pieces
- Set proper level boundaries

### Level Organization
- Use sublevels for logical content separation
- Group similar actors with folders
- Use actor tags for filtering
- Implement proper lighting scenarios

```
MainLevel                  // Persistent level
├── Lighting_Daytime       // Sublevel for day lighting
├── Lighting_Nighttime     // Sublevel for night lighting
├── Environment_Static     // Static environment meshes
├── Environment_Dynamic    // Dynamic environment elements
├── Gameplay_Triggers      // Gameplay trigger volumes
└── Audio_Ambient          // Ambient audio sources
```

## Animation

### Animation Structure
- Create base locomotion state machines
- Use animation blueprints for logic
- Implement animation notifies for events
- Use montages for interruptible sequences

### Animation Performance
- Limit bone count for skeletal meshes
- Use animation LODs for distant characters
- Implement animation compression settings
- Consider vertex animation for background characters

## Networking

### Replication
- Define replication rules in GetLifetimeReplicatedProps
- Use RPC functions (Run on Server/Client) appropriately
- Implement network relevancy for large worlds
- Minimize bandwidth usage with property conditions

```cpp
// Server RPC (runs on server when called from client)
UFUNCTION(Server, Reliable, WithValidation)
void ServerFireWeapon();

// Multicast RPC (runs on all clients when called from server)
UFUNCTION(NetMulticast, Reliable)
void MulticastPlayEffects();
```

### Network Optimization
- Prioritize important network updates
- Implement client-side prediction
- Use lag compensation techniques
- Test under various network conditions

## Performance Optimization

### Profiling
- Use built-in profiling tools regularly
- Establish performance budgets by feature
- Test on lowest target hardware
- Monitor memory usage and leaks

### Rendering Optimization
- Implement proper LOD (Level of Detail) systems
- Use instanced static meshes for repeating objects
- Optimize material instruction count
- Implement occlusion and culling strategies

```
Performance Optimization Checklist:
- Texture sizes and compression
- Material complexity
- Draw call count
- Shadow methods
- Post-process effects cost
- Animation performance
- Physics performance
- Blueprint performance
- Garbage collection
- Memory usage
```

## UI Design

### UI Structure
- Use UMG (Unreal Motion Graphics) for UI
- Implement responsive anchors for different resolutions
- Create reusable widget components
- Separate UI logic from game logic

### UI Performance
- Avoid animating many UI elements simultaneously
- Use widget caching when appropriate
- Minimize widget hierarchy depth
- Consider disabling tick on static widgets

## Audio Implementation

### Audio Structure
- Implement sound classes for mixing
- Create sound cues for complex audio
- Use attenuation settings for 3D audio
- Implement sound concurrency for performance

### Audio Optimization
- Implement audio streaming for large files
- Use appropriate compression settings
- Limit simultaneous sounds with concurrency
- Create sound occlusion systems

## Version Control

### Source Control
- Use Git or Perforce for version control
- Configure proper ignore files (.gitignore)
- Commit regularly with descriptive messages
- Coordinate large asset changes with team members

### Project Branching
- Establish branching strategy (feature branches, release branches)
- Create proper merge processes
- Consider using Unreal Engine's collaborative editing
- Document dependency changes