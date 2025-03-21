# AI-Prompts Repository Guide

## Build Commands
- `npm run test:structure` - Validate repository structure
- `npm run build-index` - Build the index JSON file
- `npm run all-scripts` - Run both commands above

## Code Style
- **File Organization**: Place prompts in `prompts/<category>/<files>` 
- **Metadata**: Create `aiprompt.json` in each prompt directory
- **Prompt Files**: Use `.md` or `.mdc` with YAML front-matter
- **Front-matter Format**: 
  ```
  ---
  description: "Short summary"
  globs: "*.ext,folder/**"
  ---
  ```
- **Naming**: `rule-*.md` for coding standards, `agent-*.md` for automation, `add-*.md` for features
- **Quality**: Ensure high-quality, concise prompts with clear descriptions
- **Validation**: All changes must pass validation with `npm run test:structure`