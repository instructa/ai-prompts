# AI-Prompts Repository Guide

## Build Commands
- `npm run test:structure` - Validate repository structure and file formats
- `npm run build-index` - Generate index.json from prompt files
- `npm run all-scripts` - Run both validation and build commands

## Repository Structure
- Place prompts in `prompts/<category>/<files>` with each category having its own directory
- Each category must contain an `aiprompt.json` file defining metadata and available rules
- Use `.md` (Markdown) or `.mdc` (Markdown with frontmatter) for prompt content files

## File Format Standards
- **Frontmatter**: All rule files require YAML frontmatter with `title`, `author`, `description`, `tags`, and `globs`
- **Author Format**: Use object format with `name`, `url`, and `avatar` properties
- **File Naming**: Use `rule-*.mdc` for coding standards, `agent-*.md` for automation, `add-*.md` for features
- **Content Structure**: Organize content with clear hierarchical headings (# for title, ## for sections)
- **Globbing**: Specify applicable file types in frontmatter using glob patterns (e.g., `*.{js,jsx,ts,tsx}`)

## Contribution Workflow
- Validate changes with `npm run test:structure` before submitting
- Ensure author information is complete in all aiprompt.json files
- Maintain consistent formatting and organization across all rule files
- Add new categories to the index by creating appropriate directory structure