---
name: ayuna-coding-guide
description: Apply Ayuna coding, naming, and tooling guidance for Go, Python, and TypeScript changes and reviews. Use when writing, debugging, reviewing, or configuring projects in these languages.
license: MIT
metadata:
  version: "0.3"
  author: Ayuna OSS
  repository: https://github.com/ayunaoss/ayuna-monorepo
  keywords: golang, python, typescript, best practices, naming conventions, software tools, libraries
---

# Instructions

Project instructions, configuration, scripts, lockfiles, and CI take precedence. Do not replace established project tooling unless user requests it. Ask before installing software or changing dependencies or lockfiles.

- Load only the references needed for the task; do not read all of them.
  - `references/project_scaffold.md`: scaffolding, code generation, workspace sync/purge.
  - `references/naming_convention.md`: adding, renaming, or reviewing identifiers.
  - `references/golang_project.md`: Go work (go.work, go vet, gopls/modernize, golangci-lint, conc guard).
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

## Configuration and Deployment Values

Applies to every language and to templates, scripts and Compose files.

- Do not hardcode deployment-specific values in source: service hostnames and ports, URLs, database or broker addresses, TLS and secret file paths, cloud endpoints, or environment names. Examples of what not to write: `ayuna-checkpoint:8091`, `http://ayuna-casdoor:8380`, `/run/secrets/egress-keys`.
- Put each value in an environment variable or a configuration file, with a local-development default only when the default is safe and clearly local. Resolve it once at the boundary (process startup, config loader, or template renderer) and pass the resolved value down. Do not scatter `os.Getenv`/`process.env`/`os.environ` reads through business logic.
- Keep code, templates, and deployment manifests on the same names so one override updates all of them. Prefer a small, documented set of scalars (`CHECKPOINT_JWKS_URL`, `MODEL_STUB_URL`, `CASDOOR_URL`, `EGRESS_KEY_DIR`, `TLS_CERT_FILE`) plus a structured config file for lists and maps.
- Local defaults may match the checked-in Compose stack, but Kubernetes and production must be able to replace every endpoint without editing code. A default must never point at a production host or contain a real credential.
- Validate required configuration at startup and fail with a clear message naming the missing key. Do not silently fall back to a hardcoded address. Never log secret values.
- Tests and local verification harnesses may use fixed loopback fixtures; production code paths, reusable libraries, rendered configs, and deployment scripts may not.
- When adding a new external dependency, add its endpoint to the configuration surface in the same change, document the variable or key, and update the local default and the deployment example together.

## Verification and Debugging

- Use local LSP evidence first (diagnostics, definitions, references, hover) for errors, symbols and types. Fall back to CLI checks only when LSP is unavailable or insufficient.
- Scope checks to the changed files or the owning project; avoid whole-monorepo runs unless asked.
- Use the language guide for exact check commands. Repository scripts, Nx targets, and CI take precedence.
- The optional Go concurrency guard is packaged at `assets/tools/go_guard/guard.py`; run it against the target repository root and run its tests from the skill package. See `references/golang_project.md`.

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
