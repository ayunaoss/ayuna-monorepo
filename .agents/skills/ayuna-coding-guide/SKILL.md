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

- Load only the references needed for the task; do not read all of them.
  - `references/project_scaffold.md`: scaffolding, code generation, workspace sync/purge.
  - `references/naming_convention.md`: adding, renaming, or reviewing identifiers.
  - `references/golang_project.md`: Go work (go.work + go vet).
  - `references/typescript_project.md`: TypeScript work (pnpm + biome).
  - `references/python_project.md`: Python work (uv + ruff).
- For polyglot changes, load the guide for each target language only.
- Always use conventional commits for commit messages.

## Monorepo Layout

Nx managed monorepo. Default top-level project folders:

- `bufgen/`: reusable protobuf definitions and generated code (`bufgen/go`, `bufgen/py`, `bufgen/ts`).
- `apps/`: services and applications.
- `libs/`: libraries.

`apps/` and `libs/` group language-specific projects under `go/`, `py/` and `ts/` (e.g. `libs/py/<name>`, `apps/go/<name>`).

Root-level workspace files define project membership per language:

| Language   | Workspace file                       | Check tooling |
| ---------- | ------------------------------------ | ------------- |
| Go         | `go.work`                            | `go vet`      |
| TypeScript | `pnpm-workspace.yaml`                | `pnpm` + `biome` |
| Python     | `pyproject.toml` `[tool.uv.workspace]` | `uv` + `ruff` |

- Synchronize all workspace entries: `pnpm nx workspace-sync`.
- Clean up stale entries of the whole monorepo (e.g. after deleting projects): `pnpm nx workspace-purge`.
- Never hand-edit workspace member lists when these commands can do it.

## Verification and Debugging

- Use local LSP evidence first (diagnostics, definitions, references, hover) for errors, symbols and types. Fall back to CLI checks only when LSP is unavailable or insufficient.
- Scope checks to the changed files or the owning project; avoid whole-monorepo runs unless asked.
- Use the language guide for exact check commands. Repository scripts, Nx targets, and CI take precedence.

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
