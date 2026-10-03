# Ayuna Monorepo

[![Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg?style=flat-square)](#ayuna-monorepo-license)

> The template repository to create monorepo project for golang, python, and typescript managed by **[nx](https://nx.dev)**.
> It uses **[@ayunaio/scaffold](https://www.npmjs.com/package/@ayunaio/scaffold)** Nx plugin for scaffolding and workspace management.
>
> Refer to [**AyunaIO Scaffold**](https://github.com/ayunaoss/ayuna-nxtools/blob/main/tools/scaffold/README.md) for detailed instructions on initializing the project structure, generating code, and managing workspace entries.

---

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

---

## Initial Setup

Before generating any project, ensure to update the monorepo project name in the base configuration files.
For example, if you choose the namespace as `acmecorp` and the name as `my-examples`,

* Replace `@ayunaio/monorepo` occurrences with `@acmecorp/my-examples` in `package.json` and `tsconfig.base.json` files in the monorepo root.
* Replace `ayunaio-monorepo` occurrences with `acmecorp-my-examples` in `pyproject.toml` file in the monorepo root.
* Run the command `pnpm nx sync` to synchronize the workspace entries.

> **IMPORTANT**:
>
> * Do not delete the configuration files in the monorepo root. They are needed for proper workspace management and synchronization.
> * Ensure to update this *README* file with appropriate documentation for your monorepo project.

---
