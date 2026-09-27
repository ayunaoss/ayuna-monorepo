# Ayuna Monorepo

[![Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg?style=flat-square)](#ayuna-monorepo-license)

> The template repository to create monorepo project for golang, python, and typescript managed by **[nx](https://nx.dev)**.
> It uses **[@ayunaio/scaffold](https://www.npmjs.com/package/@ayunaio/scaffold)** Nx plugin for scaffolding and workspace management.
>

## Ayuna Monorepo License

The `ayuna-monorepo` template project itself is released under the **Unlicense** (*license text below*).
You can add appropriate license file(s) to your derived monorepo as needed.

```md
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>
```

---

## Supported Stacks

`@ayunaio/scaffold` provides opinionated **[nx](https://nx.dev)** project generators for:

* **Buf:** Protobuf based code generation using **[buf](https://buf.build)**
* **Golang:** `go.mod` based setup targeting Go 1.27+
* **Python:** `uv` based dependency and environment management targeting Python 3.12+
* **TypeScript:** `pnpm` based configuration targeting Node.js 24+ (LTS)

The provided generators are;

* **bufgen**: Codegen using **[buf](https://buf.build)** and protobuf definitions
* **go-lib**: Golang library project using `go 1.27`
* **go-app**: Golang application project using `go 1.27`
* **py-lib**: Python library project using `uv` with `python 3.12`
* **py-app**: Python application project using `uv` with `python 3.12`
* **ts-lib**: TypeScript library project using `pnpm` with `nodejs 24.x`
* **ts-app**: TypeScript application project using `pnpm` with `nodejs 24.x`

The provided executors are;

* **workspace-sync**: Synchronize the workspace state
* **workspace-purge**: Purge the workspace state

## Initial Setup

Before generating any project, ensure to update the monorepo project name in the base configuration files.
For example, if you choose the namespace as `acmecorp` and the name as `my-examples`,

* Replace `@ayunaio/monorepo` occurrences with `@acmecorp/my-examples` in `package.json` and `tsconfig.base.json` files in the monorepo root.
* Replace `ayuna-monorepo` occurrences with `acmecorp-my-examples` in `pyproject.toml` file in the monorepo root.
* Run the command `pnpm nx sync` to synchronize the workspace entries.

> **IMPORTANT**:
>
> * Do not delete the configuration files in the monorepo root. They are needed for proper workspace management and synchronization.
> * Ensure to update this *README* file with appropriate documentation for your monorepo project.

## Manage Projects

All the commands given below, should be run from the monorepo root, unless stated otherwise.

### Initialize the protobuf and codegen folder structures

```bash
# Initialize the bufgen structure - buf.build configurations.
# This creates 'bufgen' folder in the monorepo root and adds
# buf.yaml, buf.gen.yaml and namespace folder to add .proto files.
pnpm nx g @ayunaio/scaffold:bufgen

# Generate code from .proto definitions (For e.g., bufgen/ayuna/v1/greeting.proto)
# Ensure that you add the required .proto files before running this.
# This adds generated protobuf code for golang, python and typescript under
# bufgen/go, bufgen/py and bufgen/ts folders respectively.
pnpm nx run ayuna-bufgen:codegen

# Update the root-level go.work, pnpm-workspace.yaml and pyproject.toml
# to ensure bufgen/go, bufgen/py and bufgen/ts workspace entries are
# registered.
pnpm nx workspace-sync
```

### Generate libraries or applications as needed

```bash
# To generate a Go library and register it
# in root-level go.work file
pnpm nx g @ayunaio/scaffold:go-lib

# To generate a Go application and register it
# in the root-level go.work file
pnpm nx g @ayunaio/scaffold:go-app

# To generate a Python library and register it
# in the root-level pyproject.toml file
pnpm nx g @ayunaio/scaffold:py-lib

# To generate a Python application and register it
# in the root-level pyproject.toml file
pnpm nx g @ayunaio/scaffold:py-app

# To generate a TypeScript library and register it
# in the root-level pnpm-workspace.yaml file
pnpm nx g @ayunaio/scaffold:ts-lib

# To generate a TypeScript application and register it
# in the root-level pnpm-workspace.yaml file
pnpm nx g @ayunaio/scaffold:ts-app
```

### Sync workspace entries

In order to ensure all generated (using *pnpm nx g @ayunaio/scaffold:...*), workspace projects have their entries updated in the root-level go.work, pyproject.toml or pnpm-workspace.yaml, you can run the following idempotent command.

```bash
pnpm nx workspace-sync
```

### Cleanup generated stale code

Run the following commands to clean the code generated by stale .proto definitions which might have been removed or renamed and regenerate the updated code again. The commands are idempotent.

```bash
# First, purge the generated stale code
pnpm nx run ayuna-bufgen:codepurge

# Then, regenerate the updated code
pnpm nx run ayuna-bufgen:codegen
```

### Cleanup stale workspace entries

In case you have manually deleted any of the generated projects, run the following command to update the the root-level go.work, pnpm-workspace.yaml and pyproject.toml files. This command is idempotent.

```bash
pnpm nx workspace-purge
```
