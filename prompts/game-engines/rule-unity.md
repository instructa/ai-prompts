---
description: "Best practices for game development with Unity Engine"
globs: "*.cs,*.unity,*.prefab,*.asset,*.meta,Assets/**"
---

# Unity Engine Best Practices

Unity is a cross-platform game engine developed by Unity Technologies, widely used for creating 2D and 3D games, simulations, and interactive experiences.

## Project Organization

### Directory Structure
- Organize project with a clear folder hierarchy
- Use descriptive folder names
- Group assets by type and/or functionality
- Keep scenes organized in dedicated folders

```
Assets/
├── _Project/           # Project-specific folders start with underscore
│   ├── Scripts/        # All scripts
│   ├── Scenes/         # All scenes
│   ├── Prefabs/        # All prefabs
│   ├── Materials/      # All materials
│   ├── Animations/     # All animations
│   ├── Audio/          # All audio files
│   ├── Sprites/        # All sprites (2D)
│   ├── Models/         # All 3D models
│   ├── Textures/       # All textures
│   └── UI/             # All UI elements
├── Plugins/            # Third-party plugins
├── Resources/          # Assets loaded via Resources.Load()
└── StreamingAssets/    # Files accessed via absolute path
```

### Asset Naming
- Use descriptive names for all assets
- Apply consistent naming conventions
- Include asset type in the name as a suffix
- Use PascalCase for all asset names

```
Character_Player_Prefab
Enemy_Zombie_Model
Weapon_Sword_Material
Level_01_Scene
Button_Start_Sprite
```

### Prefab Structure
- Create modular, reusable prefabs
- Use nested prefabs for complex objects
- Implement prefab variants for variations
- Keep prefabs organized by functionality

```
Prefabs/
├── Characters/
│   ├── Player.prefab
│   └── Enemies/
│       ├── Enemy_Base.prefab
│       ├── Enemy_Zombie.prefab
│       └── Enemy_Boss.prefab
├── Environment/
│   ├── Props/
│   └── Structures/
└── UI/
    ├── HUD.prefab
    └── Menus/
```

## C# Scripting

### Code Style
- Follow C# conventions for naming:
  - PascalCase for class names, public methods, and properties
  - camelCase for private fields and local variables
  - Use `_underscore` prefix for private fields
- Use explicit access modifiers (public, private, protected)
- Group related fields and methods together
- Add XML documentation for public APIs

```csharp
using UnityEngine;

/// <summary>
/// Controls player movement and actions.
/// </summary>
public class PlayerController : MonoBehaviour
{
    [Header("Movement Settings")]
    [Tooltip("Maximum movement speed in units per second")]
    public float moveSpeed = 5f;
    
    [SerializeField] private float _jumpForce = 10f;
    
    private Rigidbody _rigidbody;
    private bool _isGrounded;
    
    private void Awake()
    {
        _rigidbody = GetComponent<Rigidbody>();
    }
    
    private void Update()
    {
        HandleInput();
    }
    
    private void FixedUpdate()
    {
        HandleMovement();
    }
    
    /// <summary>
    /// Applies damage to the player.
    /// </summary>
    /// <param name="amount">Amount of damage to apply</param>
    /// <returns>Current health after damage</returns>
    public float TakeDamage(float amount)
    {
        // Implementation
        return 0f;
    }
    
    private void HandleInput()
    {
        // Implementation
    }
    
    private void HandleMovement()
    {
        // Implementation
    }
}
```

### MonoBehaviour Practices
- Follow Unity's execution order understanding
- Keep `Update()` and `FixedUpdate()` methods lean
- Implement proper initialization in `Awake()` and `Start()`
- Use `OnEnable()` and `OnDisable()` for event subscriptions

```csharp
// MonoBehaviour execution order
private void Awake()
{
    // Component references and initialization
    // Called before Start, not affected by enabled state
}

private void OnEnable()
{
    // Subscribe to events
    EventManager.OnGamePaused += HandleGamePaused;
}

private void Start()
{
    // Setup that requires other objects to be initialized
    // Called after Awake and OnEnable, before first Update
}

private void Update()
{
    // Per-frame logic, input handling
}

private void FixedUpdate()
{
    // Physics calculations, movement
}

private void LateUpdate()
{
    // Camera follow, post-movement adjustments
}

private void OnDisable()
{
    // Unsubscribe from events
    EventManager.OnGamePaused -= HandleGamePaused;
}

private void OnDestroy()
{
    // Final cleanup
}
```

### Component References
- Cache component references in `Awake()`
- Use `[SerializeField]` for inspector-assigned references
- Implement null checks for optional references
- Consider using dependency injection for loosely coupled systems

```csharp
[SerializeField] private Animator _animator;
[SerializeField] private Transform _groundCheck;

private Rigidbody _rigidbody;
private PlayerInput _input;

private void Awake()
{
    // Cache component references
    _rigidbody = GetComponent<Rigidbody>();
    _input = GetComponent<PlayerInput>();
    
    // Validate required references
    if (_animator == null)
        Debug.LogError($"Animator reference missing on {gameObject.name}");
}
```

### Script Communication
- Use events for loosely coupled communication
- Implement interfaces for type-agnostic interactions
- Consider ScriptableObjects for shared data
- Avoid direct references to singletons when possible

```csharp
// Event-based communication
public class GameEvents : MonoBehaviour
{
    public static event Action<int> OnScoreChanged;
    public static event Action OnGameOver;
    
    public static void ScoreChanged(int newScore)
    {
        OnScoreChanged?.Invoke(newScore);
    }
    
    public static void GameOver()
    {
        OnGameOver?.Invoke();
    }
}

// Interface-based communication
public interface IDamageable
{
    void TakeDamage(float amount);
}

public class Enemy : MonoBehaviour, IDamageable
{
    public void TakeDamage(float amount)
    {
        // Implementation
    }
}
```

## Unity-Specific Patterns

### Singleton Pattern
- Use singletons sparingly for true global managers
- Implement thread-safe singleton initialization
- Include `DontDestroyOnLoad` for cross-scene persistence
- Consider alternative patterns for most use cases

```csharp
public class GameManager : MonoBehaviour
{
    private static GameManager _instance;
    
    public static GameManager Instance
    {
        get
        {
            if (_instance == null)
                Debug.LogError("GameManager is null!");
                
            return _instance;
        }
    }
    
    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(gameObject);
            return;
        }
        
        _instance = this;
        DontDestroyOnLoad(gameObject);
    }
}
```

### Object Pooling
- Implement object pooling for frequently instantiated objects
- Pre-allocate pools at initialization
- Include expandable pools when appropriate
- Return objects to pool instead of destroying

```csharp
public class ObjectPool : MonoBehaviour
{
    [SerializeField] private GameObject _prefab;
    [SerializeField] private int _initialSize = 10;
    
    private Queue<GameObject> _pool = new Queue<GameObject>();
    
    private void Awake()
    {
        InitializePool();
    }
    
    private void InitializePool()
    {
        for (int i = 0; i < _initialSize; i++)
        {
            GameObject obj = Instantiate(_prefab);
            obj.SetActive(false);
            _pool.Enqueue(obj);
            obj.transform.SetParent(transform);
        }
    }
    
    public GameObject GetFromPool()
    {
        if (_pool.Count == 0)
        {
            GameObject newObj = Instantiate(_prefab);
            return newObj;
        }
        
        GameObject obj = _pool.Dequeue();
        obj.SetActive(true);
        return obj;
    }
    
    public void ReturnToPool(GameObject obj)
    {
        obj.SetActive(false);
        _pool.Enqueue(obj);
    }
}
```

### ScriptableObjects
- Use ScriptableObjects for shared data assets
- Implement ScriptableObject-based event systems
- Create ScriptableObject configurations for game settings
- Define systems with ScriptableObject-based architectures

```csharp
[CreateAssetMenu(fileName = "NewWeaponData", menuName = "Game/Weapon Data")]
public class WeaponData : ScriptableObject
{
    public string weaponName;
    public float damage;
    public float fireRate;
    public GameObject weaponPrefab;
    public AudioClip fireSound;
}

// Usage
public class Weapon : MonoBehaviour
{
    [SerializeField] private WeaponData _weaponData;
    
    private void Start()
    {
        Initialize(_weaponData);
    }
}
```

## Performance Optimization

### General Optimization
- Use the Profiler to identify bottlenecks
- Implement object pooling for frequent instantiation
- Cache component references and computation results
- Avoid string operations in performance-critical code

```csharp
// Bad: GetComponent in Update
private void Update()
{
    GetComponent<Rigidbody>().AddForce(Vector3.up);
}

// Good: Cache component reference
private Rigidbody _rigidbody;

private void Awake()
{
    _rigidbody = GetComponent<Rigidbody>();
}

private void Update()
{
    _rigidbody.AddForce(Vector3.up);
}
```

### Physics Optimization
- Use simplified collision meshes
- Implement physics layers for selective collisions
- Adjust fixed timestep for performance vs. accuracy
- Use Rigidbody.Sleep() for inactive objects

### Rendering Optimization
- Implement proper LOD (Level of Detail) systems
- Use texture atlases to reduce draw calls
- Implement occlusion culling for complex scenes
- Batch static objects when possible

## UI Implementation

### UI Architecture
- Use the Canvas system for all UI elements
- Implement proper anchoring for responsive layouts
- Use TextMeshPro for high-quality text
- Separate UI logic from game logic

```csharp
// UI Controller pattern
public class HealthUI : MonoBehaviour
{
    [SerializeField] private Slider _healthSlider;
    [SerializeField] private TextMeshProUGUI _healthText;
    
    public void UpdateHealth(float currentHealth, float maxHealth)
    {
        float percentage = currentHealth / maxHealth;
        _healthSlider.value = percentage;
        _healthText.text = $"{Mathf.RoundToInt(currentHealth)}/{Mathf.RoundToInt(maxHealth)}";
    }
}
```

### UI Optimization
- Disable raycast targets on non-interactive elements
- Use the CanvasGroup component for UI block transitions
- Implement UI object pooling for repeated elements
- Consider disabling Canvas when UI is not visible

## Animation

### Animation Setup
- Use Mecanim for character animations
- Implement Animation Controllers for state management
- Use Animation Events for gameplay synchronization
- Consider Timeline for cutscenes and sequences

### Animation Transitions
- Implement smooth blending between animations
- Use layers for partial body animations
- Set appropriate transition durations
- Implement root motion selectively

```csharp
// Animation parameter setting
private void HandleMovementAnimation()
{
    _animator.SetFloat("Speed", _movementSpeed);
    _animator.SetBool("IsGrounded", _isGrounded);
    
    if (_isJumping)
        _animator.SetTrigger("Jump");
}
```

## Testing and Debugging

### Error Handling
- Implement descriptive error messages
- Use try-catch blocks judiciously
- Add validation checks for critical operations
- Log appropriate information for debugging

```csharp
public void ApplyDamage(float amount, GameObject source)
{
    if (amount < 0)
    {
        Debug.LogWarning($"Negative damage value ({amount}) from {source.name}");
        return;
    }
    
    // Process damage
}
```

### Testing
- Write unit tests for game logic
- Implement integration tests for systems
- Create test scenes for isolated feature testing
- Use the Unity Test Framework for automated testing

## Asset Optimization

### Texture Optimization
- Set appropriate texture compression formats
- Implement mipmaps for distant objects
- Use texture atlases for UI and similar elements
- Adjust texture import settings based on usage

### Model Optimization
- Optimize polygon count for target platforms
- Implement LOD (Level of Detail) for complex models
- Reuse materials when possible
- Set appropriate import settings for models

## Platform-Specific Considerations

### Mobile Optimization
- Minimize draw calls and batch where possible
- Implement aggressive LOD strategies
- Use lower-resolution textures and simplified shaders
- Monitor memory usage and implement memory budgets

### Cross-Platform Development
- Use Input System package for unified input handling
- Abstract platform-specific features
- Test on all target platforms regularly
- Implement conditional compilation for platform-specific code

```csharp
#if UNITY_ANDROID || UNITY_IOS
    // Mobile-specific code
#elif UNITY_WEBGL
    // WebGL-specific code
#else
    // Desktop-specific code
#endif
```

## Version Control

### Unity and Git
- Use Git LFS for large binary files
- Configure appropriate `.gitignore` file
- Consider using Unity Teams for larger projects
- Coordinate scene editing to avoid merge conflicts

### Project Versioning
- Use semantic versioning for builds
- Document version changes
- Consider using Unity Cloud Build for CI/CD
- Implement version checking for networked games