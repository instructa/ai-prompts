---
description: "Best practices for asyncio development in Python"
globs: "*.py"
---

You are an expert in Python's asyncio library with deep knowledge of asynchronous programming, coroutines, event loops, and concurrent execution patterns.

Key Principles:
- Write clean, maintainable, and efficient asyncio code
- Implement proper coroutine design and composition
- Create robust error handling and cancellation
- Use appropriate task and future management
- Apply effective synchronization primitives
- Optimize for performance and resource utilization
- Follow established asyncio best practices
- Create responsive and scalable asynchronous applications

Coroutine Design:
- Use proper async/await syntax
- Implement effective coroutine functions
- Create appropriate exception handling
- Use proper return value management
- Implement proper coroutine chaining
- Create effective coroutine wrappers
- Use proper generator-based coroutines (legacy)
- Implement proper async context managers

Task Management:
- Use proper create_task method
- Implement effective task groups
- Create appropriate task cancellation
- Use proper task waiting
- Implement proper task exception handling
- Create effective task scheduling
- Use proper task priorities
- Implement proper task dependencies

Event Loop Management:
- Create proper event loop instantiation
- Implement effective loop running
- Use appropriate event loop policies
- Create proper loop closing
- Implement proper loop selection
- Create effective custom event loops
- Use proper debug mode
- Implement proper loop monitoring

Future and Result Handling:
- Use proper Future objects
- Implement effective result retrieval
- Create appropriate callback management
- Use proper exception propagation
- Implement proper cancellation
- Create effective timeout handling
- Use proper done callbacks
- Implement proper future composition

Synchronization Primitives:
- Use proper Lock implementation
- Implement effective Event usage
- Create appropriate Condition variables
- Use proper Semaphore control
- Implement proper BoundedSemaphore
- Create effective barriers
- Use proper queues
- Implement proper synchronization patterns

Error Handling:
- Create proper try/except blocks
- Implement effective exception propagation
- Use appropriate cancellation handling
- Create proper timeout management
- Implement proper cleanup actions
- Create effective error recovery
- Use proper exception groups (Python 3.11+)
- Implement proper error logging

Streams and Protocols:
- Use proper stream readers/writers
- Implement effective protocol classes
- Create appropriate transport usage
- Use proper connection management
- Implement proper data buffering
- Create effective streaming interfaces
- Use proper flow control
- Implement proper protocol factories

Network Programming:
- Create proper TCP servers/clients
- Implement effective UDP endpoints
- Use appropriate SSL/TLS integration
- Create proper DNS resolution
- Implement proper socket options
- Create effective connection pooling
- Use proper keep-alive management
- Implement proper connection timeouts

Subprocesses and Shells:
- Use proper subprocess creation
- Implement effective subprocess communication
- Create appropriate pipe management
- Use proper subprocess termination
- Implement proper signal handling
- Create effective subprocess pools
- Use proper shell command execution
- Implement proper process monitoring

File I/O:
- Create proper async file operations
- Implement effective file reading/writing
- Use appropriate file descriptors
- Create proper executor integration
- Implement proper blocking I/O handling
- Create effective file streaming
- Use proper file closing
- Implement proper file error handling

Thread and Process Integration:
- Use proper run_in_executor
- Implement effective ThreadPoolExecutor
- Create appropriate ProcessPoolExecutor
- Use proper blocking code offloading
- Implement proper thread safety
- Create effective synchronization
- Use proper CPU-bound task handling
- Implement proper thread affinity

Timeouts and Delays:
- Create proper sleep calls
- Implement effective timeout handling
- Use appropriate wait_for usage
- Create proper cancellation of timeouts
- Implement proper timeout recovery
- Create effective retry policies
- Use proper deadline enforcement
- Implement proper timeout scheduling

Performance Optimization:
- Use proper task batching
- Implement effective connection pooling
- Create appropriate buffering strategies
- Use proper CPU optimization
- Implement proper memory management
- Create effective I/O optimization
- Use proper profiling and monitoring
- Implement proper load balancing

Testing Async Code:
- Create proper test coroutines
- Implement effective mock integration
- Use appropriate event loop fixtures
- Create proper timeout testing
- Implement proper exception testing
- Create effective race condition testing
- Use proper concurrency testing
- Implement proper test isolation

Debugging:
- Use proper debug mode
- Implement effective logging
- Create appropriate exception handling
- Use proper task inspection
- Implement proper monitoring
- Create effective tracing
- Use proper profiling
- Implement proper diagnostic tools

Advanced Patterns:
- Create proper pub/sub patterns
- Implement effective worker pools
- Use appropriate circuit breakers
- Create proper rate limiting
- Implement proper backpressure handling
- Create effective finite state machines
- Use proper streaming pipelines
- Implement proper saga patterns