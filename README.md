[![Instructa AI Prompts Banner](/public/image.png)](https://www.instructa.ai/ai-prompts)

# AI Prompts & Rules

<p>
  <a href="https://github.com/instructa/ai-prompts"><img src="https://img.shields.io/github/repo-size/instructa/ai-prompts?style=flat&colorA=18181B&colorB=28CF8D" alt="Repo Size"></a>
  <a href="https://github.com/instructa/ai-prompts/actions"><img src="https://img.shields.io/github/actions/workflow/status/instructa/ai-prompts/ci.yml?branch=main&style=flat&colorA=18181B&colorB=28CF8D" alt="Build Status"></a>
  <a href="https://github.com/instructa/ai-prompts/blob/main/LICENSE"><img src="https://img.shields.io/github/license/instructa/ai-prompts.svg?style=flat&colorA=18181B&colorB=28CF8D" alt="License"></a>
  <a href="https://github.com/instructa/ai-prompts/stargazers"><img src="https://img.shields.io/github/stars/instructa/ai-prompts.svg?style=flat&colorA=18181B&colorB=28CF8D" alt="Stars"></a>
</p>

**Instructa AI Prompts** is an open-source repository dedicated to collecting and sharing AI prompts, best practices, and curated rules for developers. From project scaffolding to coding standards, our goal is to help you quickly set up and refine your workflow with ready-to-use prompts. 

Try it out [here](https://www.instructa.ai/ai-prompts) or use these prompts directly in your favorite AI coding environment.

## Table of Contents

- [📖 Usage](#usage)
- [🤝 Contributing](#contributing)
- [🛟 Community & Support](#community--support)
- [🔗 Related Projects](#related-projects)
- [⚖️ License](#license)

---

## Usage

To dynamically include prompts in AI-assisted coding tools like Cursor, GitHub Copilot, Zed, Windsurf, and Cline, you can utilize their respective configuration features. This approach ensures that your AI assistant adheres to project-specific coding standards, best practices, and automation workflows.


Need a Guide? Read the blog post: [How to use Cursor Rules](https://www.instructa.ai/en/blog/how-to-use-cursor-rules-in-version-0-45) | [X Post](https://x.com/kregenrek/status/1887574770474229802)

**How to Use AI Prompts in Different Tools**

| AI Tool           | How to Include Prompts                                                                                                                                                                                                                 |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Cursor**        | Add prompts as project rules inside the `.cursor/rules/` directory (e.g., `.cursor/rules/cursorrules.mdc`). Cursor will automatically detect and apply them. For detailed guidance, refer to the [official Cursor rule guide](https://docs.cursor.com/context/rules-for-ai#project-rules-recommended). |
| **GitHub Copilot**| Create a `.github/copilot-instructions.md` file in your repository's root directory and add natural language instructions in Markdown format. These instructions will guide Copilot's behavior across your project. More information is available in the [GitHub Copilot documentation](https://docs.github.com/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot). |
| **Zed**           | Store prompts in the `.zed/` directory within your project. You can configure project-specific settings by creating a `.zed/settings.json` file, allowing Zed to apply these configurations accordingly. Consult the [Zed documentation](https://zed.dev/docs/configuring-zed) for further details. |
| **Windsurf**      | Add a .windsurfrules file into the project root. [Windsurf Getting Started Guide](https://docs.codeium.com/windsurf/getting-started). |
| **Cline**         | 1. Click Cline extension settings 2. Find "Custom Instructions" field 3. Add your instructions  [Cline GitHub repository](https://cline.bot/faq). |

By configuring these settings, you can ensure that your AI tools operate in alignment with your project's specific requirements and standards. 


## 🤝 Contributing Prompts

We welcome all contributions! Whether you're adding new prompts, improving existing ones, or fixing typos - every bit helps. 

**Quick Start**:
1. Create a folder under `prompts/<your-prompt-name>`
2. Add metadata in `aiprompt.json` (see [example](./prompt-template/aiprompt.json))
3. Include `.mdc` files with YAML front-matter for rules
4. Submit a Pull Request

For full details, please see our [Contribution Guidelines](./CONTRIBUTING.md). 


## Community & Support


- **Discussions**: Share ideas, get help, or suggest improvements on our [GitHub Discussions](https://github.com/instructa/ai-prompts/discussions).  
- **Issues**: Report bugs or request new prompt categories through [GitHub Issues](https://github.com/instructa/ai-prompts/issues).  

## Social

- X/Twitter: [@kregenrek](https://x.com/kregenrek)
- Bluesky: [@kevinkern.dev](https://bsky.app/profile/kevinkern.dev)


## 🔗 Related Projects

- [DevScratchpad AI Skill Studio](https://www.devscratchpad.tech/ai-skill-studio) - Free, 100% client-side privacy-first web scratchpad for generating, validating, and previewing Cursor `.mdc` rules, Claude Code skills, and `AGENTS.md` directives with 36+ battle-tested framework presets.

## License

[MIT License](https://github.com/instructa/ai-prompts/blob/main/LICENSE)

This repository is open-source under the MIT license. You’re free to use, modify, and distribute it under those terms. Enjoy building!
