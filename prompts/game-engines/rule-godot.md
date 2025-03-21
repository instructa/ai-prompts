---
description: "Best practices for game development with Godot Engine"
globs: "*.gd,*.gdshader,*.tscn,*.tres,*.godot,project.godot"
---

# Godot Engine Best Practices

Godot Engine is a free and open-source game engine that provides a comprehensive set of tools for 2D and 3D game development.

## Project Organization

### Directory Structure
- Organize project with clear directory hierarchy
- Use consistent naming conventions for folders
- Separate assets by type (sprites, models, sounds, etc.)
- Group scene components logically

```
project/
├── assets/
│   ├── sprites/
│   ├── models/
│   ├── sounds/
│   └── fonts/
├── scenes/
│   ├── ui/
│   ├── levels/
│   └── characters/
├── scripts/
│   ├── autoload/
│   ├── components/
│   └── resources/
└── addons/
```

### Scene Organization
- Break complex scenes into smaller, reusable subscenes
- Use scene inheritance for variations of similar objects
- Keep UI elements in separate scenes
- Implement consistent scene structure for similar objects

### Resource Management
- Create resource files (.tres) for reusable configurations
- Use resource preloading for frequently used assets
- Implement resource caching for runtime optimization
- Name resources descriptively and consistently

```gdscript
# Preload resources
const PlayerScene = preload("res://scenes/characters/player.tscn")
const EnemyResource = preload("res://resources/enemies/slime.tres")
```

## GDScript Best Practices

### Code Style
- Follow PEP 8 style conventions when applicable
- Use snake_case for variables, functions, and files
- Use PascalCase for classes, enums, and constants
- Add descriptive comments for complex logic

```gdscript
# Constants at the top in SCREAMING_SNAKE_CASE
const MAX_SPEED = 300.0
const JUMP_FORCE = 500.0

# Member variables with descriptive names
var current_health: int = 100
var is_attacking: bool = false

# Clear, descriptive function names
func take_damage(amount: int) -> void:
    current_health -= amount
    if current_health <= 0:
        die()
```

### Script Structure
- Order script elements consistently:
  1. Class docstring
  2. Signals
  3. Enums and constants
  4. Exported variables
  5. Private variables
  6. Onready variables
  7. Built-in functions
  8. Public methods
  9. Private methods
- Use `class_name` for reusable scripts
- Group related functionality into separate scripts

```gdscript
class_name Player
extends CharacterBody2D

## Player controller script handling movement and actions

# Signals
signal health_changed(new_health)
signal died

# Enums and Constants
enum States {IDLE, RUNNING, JUMPING, FALLING}
const MAX_SPEED = 300.0

# Exported variables
@export var jump_force: float = 500.0
@export var acceleration: float = 20.0

# Member variables
var _current_state: int = States.IDLE
var _current_health: int = 100

# Built-in Godot functions
func _ready() -> void:
    _initialize()

func _process(delta: float) -> void:
    _update_animation()

func _physics_process(delta: float) -> void:
    _handle_movement(delta)

# Public methods
func take_damage(amount: int) -> void:
    _current_health -= amount
    emit_signal("health_changed", _current_health)
    if _current_health <= 0:
        die()

# Private methods
func _initialize() -> void:
    # Setup code
    pass
```

### Node References
- Use `@onready` for node references
- Validate node references in `_ready()`
- Prefer dependency injection for external references
- Use signals for loose coupling between nodes

```gdscript
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
    # Validate references
    assert(animation_player != null, "AnimationPlayer node not found")
    assert(sprite != null, "Sprite node not found")
```

## Nodes and Scenes

### Node Usage
- Choose appropriate nodes for their intended purpose
- Keep the node tree as flat as possible
- Name nodes descriptively
- Use groups for organizing related nodes

```gdscript
# Adding a node to a group
func _ready() -> void:
    add_to_group("enemies")

# Using groups to call multiple nodes
func _on_player_detected() -> void:
    get_tree().call_group("enemies", "alert")
```

### Scene Design
- Implement composition over inheritance where possible
- Create reusable scene components
- Design scenes for single responsibility
- Use inheritance for variations of similar objects

### Instancing
- Use `.instance()` for runtime instantiation
- Prefer `add_child()` with the correct ownership setting
- Set necessary properties before adding to the scene tree
- Clean up instances when no longer needed

```gdscript
func spawn_enemy(position: Vector2) -> void:
    var enemy = EnemyScene.instantiate()
    enemy.position = position
    enemy.connect("died", _on_enemy_died)
    add_child(enemy)
```

## Physics and Collision

### Physics Bodies
- Choose the appropriate physics body (RigidBody2D, CharacterBody2D, etc.)
- Set collision layers and masks intentionally
- Use Area2D/3D for detection zones
- Implement collision handling in `_physics_process`

```gdscript
# Setting up collision layers
func _ready() -> void:
    collision_layer = 0b00000010  # Layer 2
    collision_mask = 0b00000001   # Only collide with layer 1
```

### Physics Optimization
- Disable physics processing when not needed
- Use simplified collision shapes for complex objects
- Implement spatial partitioning for large scenes
- Avoid physics for purely visual elements

## UI Design

### Control Nodes
- Use anchors and margins for responsive layouts
- Implement proper focus navigation
- Use theme resources for consistent styling
- Separate UI logic from game logic

```gdscript
func _ready() -> void:
    # Set up button connections
    $StartButton.connect("pressed", _on_start_button_pressed)
    
    # Set initial focus
    $StartButton.grab_focus()
```

### UI Animation
- Use AnimationPlayer for UI transitions
- Implement accessibility features (text scaling, contrast)
- Create a consistent UI feedback system
- Use tweens for simple UI animations

```gdscript
func show_menu() -> void:
    $UI.visible = true
    var tween = create_tween()
    tween.tween_property($UI, "modulate:a", 1.0, 0.3)
```

## Performance Optimization

### General Optimization
- Profile your game to identify bottlenecks
- Use object pooling for frequently instantiated objects
- Implement level streaming for large worlds
- Consider visibility notifiers for offscreen objects

```gdscript
# Object pooling example
var bullet_pool = []
const POOL_SIZE = 20

func _ready() -> void:
    _initialize_pool()

func _initialize_pool() -> void:
    for i in range(POOL_SIZE):
        var bullet = BulletScene.instantiate()
        bullet.set_process(false)
        bullet.visible = false
        bullet_pool.append(bullet)
        add_child(bullet)
```

### Shader Optimization
- Keep shaders as simple as possible
- Use shader LOD (Level of Detail) techniques
- Cache computed values in shaders
- Consider mobile performance constraints

## Input Handling

### Input Actions
- Use Input Map for abstracting input controls
- Implement input buffering for responsive controls
- Handle multiple input methods (keyboard, gamepad, touch)
- Allow remapping of controls

```gdscript
func _physics_process(delta: float) -> void:
    var direction = Vector2.ZERO
    
    if Input.is_action_pressed("move_right"):
        direction.x += 1
    if Input.is_action_pressed("move_left"):
        direction.x -= 1
    
    # Normalize and apply movement
    if direction != Vector2.ZERO:
        direction = direction.normalized()
        velocity = direction * speed
    else:
        velocity = Vector2.ZERO
        
    move_and_slide()
```

## Audio Implementation

### Sound Organization
- Organize audio by type (music, SFX, voice)
- Use buses for audio mixing
- Implement 3D audio positioning for immersion
- Consider dynamic audio based on game state

```gdscript
func play_footstep_sound() -> void:
    var audio_player = $FootstepAudioPlayer
    
    # Randomize pitch slightly for variety
    audio_player.pitch_scale = randf_range(0.9, 1.1)
    audio_player.play()
```

## Exporting and Deployment

### Export Configuration
- Configure export presets for target platforms
- Set appropriate icons and splash screens
- Optimize build size for distribution
- Test exports thoroughly on target devices

### Version Management
- Implement a version tracking system
- Consider update mechanisms for released games
- Document changes between versions
- Create a rollback strategy for critical issues

## Multiplayer Considerations

### Network Structure
- Choose appropriate network architecture (client-server, P2P)
- Implement state synchronization strategies
- Consider bandwidth and latency constraints
- Use RPCs (Remote Procedure Calls) appropriately

```gdscript
# Server RPC function
@rpc("any_peer")
func register_player(id: int, player_name: String) -> void:
    if multiplayer.is_server():
        players[id] = player_name
        # Notify other clients
        rpc("update_player_list", players)
```

### Security
- Validate all client inputs on the server
- Implement anti-cheat measures for competitive games
- Secure sensitive data in multiplayer games
- Consider fallback mechanisms for connection issues