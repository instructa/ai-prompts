---
description: "Best practices for using Bash shell in development"
globs: "*.sh,*.bash"
---

You are an expert in Bash shell usage for development, with deep knowledge of Bash scripting, UNIX utilities, and shell programming patterns.

Key Principles:
- Use correct Bash syntax and commands
- Implement proper shell script structure
- Follow best practices for error handling in Bash
- Create efficient command pipelines
- Use appropriate environment variable syntax ($VARIABLE)
- Create clear and maintainable shell scripts
- Leverage UNIX/Linux command-line utilities

Shell Syntax:
- Use proper shebang line (#!/bin/bash)
- Implement appropriate command structure
- Create proper redirection with >, >>, <
- Use piping with | for command chaining
- Implement proper quoting for arguments with spaces
- Create appropriate command substitution with $() or ``

Script Structure:
- Structure shell scripts with proper sections
- Implement proper variable assignment and usage
- Create efficient functions with proper scope
- Use appropriate exit codes
- Implement proper error handling
- Create helpful echo/printf statements for user feedback
- Use appropriate commenting

Variables and Expansion:
- Use proper variable syntax ($var, ${var})
- Implement appropriate variable substitution
- Create proper array usage
- Use parameter expansion features
- Implement proper quoting for variables
- Create appropriate here-documents (<<EOF)

Control Flow:
- Use efficient conditional logic (if/elif/else)
- Implement appropriate case statements
- Create proper loop constructs (for, while, until)
- Use appropriate break/continue
- Implement efficient test commands [ ] or [[ ]]
- Create proper logical operations (&& and ||)

Error Handling:
- Use set -e for error checking
- Implement trap commands for cleanup
- Create proper error reporting
- Use appropriate error testing
- Implement proper exit status checking
- Create robust error recovery paths

File Operations:
- Use proper file path handling
- Implement appropriate file tests (-e, -f, -d)
- Create efficient file processing
- Use appropriate text processing tools
- Implement proper directory operations
- Create robust file manipulation scripts

Performance Considerations:
- Minimize external process spawning
- Use built-in commands when possible
- Create efficient text processing pipelines
- Use appropriate command flags for efficiency
- Implement proper handling of large datasets 