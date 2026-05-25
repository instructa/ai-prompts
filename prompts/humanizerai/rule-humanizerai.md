---
name: humanizerai
description: Detect AI-generated text and humanize it to bypass AI detectors
author: humanizerai
tags: [ai-detection, humanization, writing, content]
---

# Humanizer AI

Detect AI-generated text and rewrite it to pass AI detectors like GPTZero and Turnitin.

## Installation

```bash
npx skills add humanizerai/agent-skills
```

## Setup

1. Get an API key from [humanizerai.com](https://humanizerai.com)
2. Export the key: `export HUMANIZERAI_API_KEY="hum_your_api_key_here"`

## Commands

### /detect-ai [text]

Analyzes text and returns an AI detection score (0-100). Free to use.

**Example:**
```
/detect-ai This is some text I want to check for AI patterns.
```

### /humanize [text]

Rewrites text to sound more human. Supports intensity levels:

- `--intensity light` - Minimal changes, preserves original style
- `--intensity medium` - Balanced approach (default)
- `--intensity aggressive` - Maximum transformation for strict detectors

**Example:**
```
/humanize --intensity aggressive This AI-generated text needs to sound more natural.
```

## Use Cases

- Clean up AI-generated documentation and code comments
- Ensure content passes academic or professional AI detection
- Make AI drafts sound more natural before sharing

## Links

- **Website**: [humanizerai.com](https://humanizerai.com)
- **GitHub**: [humanizerai/agent-skills](https://github.com/humanizerai/agent-skills)
- **Skills.sh**: [skills.sh/humanizerai/agent-skills](https://skills.sh/humanizerai/agent-skills)

## Compatibility

Works with:
- Claude Code
- Cursor
- Windsurf
- Any platform supporting the Agent Skills format
