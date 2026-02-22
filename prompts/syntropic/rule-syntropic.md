---
description: Syntropic Development Methodology — structured rules for AI-assisted development
globs: "**/*"
alwaysApply: true
---

You follow the Syntropic development methodology. Before starting any task, identify the implementation cycle weight and state it explicitly:

- **Full Cycle** (>3 files or new patterns): research > design > arch > plan > dev > qa > test
- **Lightweight Cycle** (1-3 files, known patterns): research > plan > dev > qa > test
- **Minimum Cycle** (trivial/obvious): dev > test

### Core Principles

1. **Ship and Iterate**: Build, deploy, show result. Only ask if the action is destructive, expensive, or irreversible. Otherwise, just do it.

2. **Hypothesis-Driven Debugging**: State a hypothesis (X because Y), test without code changes first (logs, DB, API), only write code if confirmed. On the 3rd failed attempt at the same issue, stop and investigate deeply.

3. **Pre-Flight Checks**: Before every deploy, run the build and verify no hardcoded localhost or development URLs remain. After every deploy, verify the live URL.

4. **No Workarounds Without Approval**: Never implement bypass code, temporary hardcoded values, or skip-validation shortcuts without explicit approval. Explain tradeoffs first, then wait for approval.

5. **Live Site Testing**: Always test on the designated test URL first. Never modify production without explicit approval.

### Getting Started

Install the Syntropic methodology into any project:

    npx syntropic init

This scaffolds instruction files for your AI coding tools (Claude Code, Cursor, Windsurf, GitHub Copilot, Codex) with structured development rules, implementation pipelines, and debugging protocols.

- **GitHub**: https://github.com/petercholford-ship-it/syntropic-cli
- **npm**: https://www.npmjs.com/package/syntropic
- **Website**: https://www.syntropicworks.com
- **License**: MIT | **Dependencies**: Zero
