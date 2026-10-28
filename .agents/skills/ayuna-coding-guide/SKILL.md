---
name: ayuna-coding-guide
description: Apply Ayuna coding, naming, and tooling guidance for Go, Python, and TypeScript changes and reviews. Use when writing, debugging, reviewing, or configuring projects in these languages.
license: MIT
metadata:
  version: "0.1"
  author: Ayuna OSS
  repository: https://github.com/ayunaoss/ayuna-monorepo
  keywords: golang, python, typescript, best practices, naming conventions, software tools, libraries
---

# Instructions

Project instructions, configuration, scripts, lockfiles, and CI take precedence. Do not replace established project tooling unless user requests it. Ask before installing software or changing dependencies or lockfiles.

- Always follow `references/project_scaffold.md` for project scaffolding and code generation practices.
- Use `references/naming_convention.md` when adding, renaming, or reviewing identifiers.
- Use `references/python_project.md` for Python project preferences.
- Use `references/golang_project.md` for Golang project preferences.
- Use `references/typescript_project.md` for TypeScript project preferences.
- For polyglot projects, use each guide based on the target language.
- Always use conventional commits for commit messages.

## Containerfile Samples

- Use `assets/oci/go.Containerfile` for Golang apps.
- Use `assets/oci/py.Containerfile` for Python apps.
- Use `assets/oci/nextjs.Containerfile` for Next.js apps.
- Replace `my-service` with the actual project name in the Containerfile.

## License Samples

- Use `assets/license/MIT` for MIT licensed projects.
- Use `assets/license/Apache-v2.0` for Apache v2.0 licensed projects.
- Use `assets/license/EPL-v2.0` for Eclipse-Public-License v2.0 projects.
- Replace <year-or-year-range> and <license-owner-or-group-name> with appropriate values in the license files post approval.
