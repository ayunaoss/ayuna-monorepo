# Project Scaffold

The recommended project scaffolding practice for monorepos using golang, python and typescript.
All the commands given below, should be run from the monorepo root, unless stated otherwise.

> **NOTE**: Recommendations for consistent monorepo structure.
>
> 1. Use the same `<repo-namespace>` value for all projects.
> 2. Use the same `<go-modules-prefix>` value for all projects.
> 3. Ensure to use quotes while providing `<project-summary>` values.
> 4. The `<license-type>` can be SPDX identifiers like `MIT`, `Apache-2.0`, or `Refer to LICENSE file` text.
> 5. Use one of `bufgen` or `typegen` to generate common types for polyglot projects.
> 6. Recommended option is to use `bufgen` to generate common types for polyglot projects.
> 7. Always use user approved parameters for all scaffold commands.

---

## Initialize bufgen structure

```bash
# Initialize the bufgen structure - buf.build configurations.
# This creates 'bufgen' folder in the monorepo root and adds
# buf.yaml, buf.gen.yaml and namespace folder to add .proto files.
pnpm nx g @ayunaio/scaffold:bufgen --repoNamespace <repo-namespace> --authorName <author-name> --authorEmail <author-email> --license <license-type> --goModPrefix <go-module-prefix>

# Generate code from .proto definitions (e.g., bufgen/<repo-namespace>/v1/greeting.proto)
# Ensure that you add the required .proto files before running this.
# This adds generated protobuf code for golang, python and typescript under
# bufgen/go, bufgen/py and bufgen/ts folders respectively.
pnpm nx run <repo-namespace>-bufgen:codegen

# Update the root-level go.work, pnpm-workspace.yaml and pyproject.toml
# to ensure bufgen/go, bufgen/py and bufgen/ts workspace entries are
# registered.
pnpm nx workspace-sync
pnpm nx sync
```

### Generate clean and up-to-date bufgen code

```bash
# First, purge the generated stale code
pnpm nx run <repo-namespace>-bufgen:codepurge

# Then, regenerate the updated code
pnpm nx run <repo-namespace>-bufgen:codegen
```

---

## Initialize typegen structure

```bash
# Initialize the typegen structure - TypeSpec configurations.
# This creates 'typegen' typescript project and provides a
# Makefile to generate golang, python and typescript code from
# TypeSpec definitions in src/main.tsp file. Update the file
# and add the required model definitions and generate the code.
pnpm nx g @ayunaio/scaffold:typegen --repoNamespace <repo-namespace> --authorName <author-name> --authorEmail <author-email> --goModPrefix <go-module-prefix>

# Synchronize the workspace
pnpm nx workspace-sync
pnpm nx sync

# Enter the typegen project directory and generate the code
cd typegen
make all

# Return to the monorepo root directory
cd ..

# Once again synchronize the workspace
pnpm nx workspace-sync
pnpm nx sync
```

> **NOTE**: The `make all` command scaffolds the following projects and populates the TypeSpec generated code appropriately.
>
> * Golang code under `libs/go/gotypes`
> * Python code under `libs/py/<repo-namespace>-pytypes`
> * TypeScript code under `libs/ts/<repo-namespace>-tstypes`

---

## Generate libraries or applications as needed

```bash
# To generate a Go library and register it
# in root-level go.work file
pnpm nx g @ayunaio/scaffold:go-lib --repoNamespace <repo-namespace> --name <project-name> --modulePrefix <go-module-prefix> --summary <project-summary>

# To generate a Go application and register it
# in the root-level go.work file
pnpm nx g @ayunaio/scaffold:go-app --repoNamespace <repo-namespace> --name <project-name> --modulePrefix <go-module-prefix> --summary <project-summary>

# To generate a Python library and register it
# in the root-level pyproject.toml file
pnpm nx g @ayunaio/scaffold:py-lib --repoNamespace <repo-namespace> --name <project-name> --authorName <author-name> --authorEmail <author-email> --summary <project-summary>

# To generate a Python application and register it
# in the root-level pyproject.toml file
pnpm nx g @ayunaio/scaffold:py-app --repoNamespace <repo-namespace> --name <project-name> --authorName <author-name> --authorEmail <author-email> --summary <project-summary>

# To generate a TypeScript library and register it
# in the root-level pnpm-workspace.yaml file
pnpm nx g @ayunaio/scaffold:ts-lib --repoNamespace <repo-namespace> --name <project-name> --authorName <author-name> --authorEmail <author-email> --summary <project-summary>

# To generate a TypeScript application and register it
# in the root-level pnpm-workspace.yaml file
pnpm nx g @ayunaio/scaffold:ts-app --repoNamespace <repo-namespace> --name <project-name> --authorName <author-name> --authorEmail <author-email> --summary <project-summary>
```

---

## Sync workspace entries

In order to ensure all generated (using *pnpm nx g @ayunaio/scaffold:...*), workspace projects have their entries updated in the root-level go.work, pyproject.toml or pnpm-workspace.yaml, you can run the following idempotent commands.

```bash
pnpm nx workspace-sync
pnpm nx sync
```

---

## Cleanup stale workspace entries

In case you have manually deleted any of the generated projects, run the following command to update the the root-level go.work, pnpm-workspace.yaml and pyproject.toml files. These commands are idempotent.

```bash
pnpm nx workspace-purge
pnpm nx sync
```
