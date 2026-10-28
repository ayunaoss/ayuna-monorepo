# TypeScript Project

* Follow runtime, package manager, test, lint, and type-check commands defined by repository first. Detect them from `package.json`, lockfiles, runtime files, and CI.
* For an unconfigured project, use active Node.js LTS version 24 or later and `pnpm`. Verify with `node --version` and `pnpm --version`.
* Install pnpm only when approved using `wget -qO- https://get.pnpm.io/install.sh | env ENV="${HOME}/.bashrc" SHELL="$(which bash)" bash -`
* For new projects, set `packageManager` to pnpm in `package.json`.
* Run `pnpm install` from project root when dependency installation is required.
* Use `jest` for testing, `biome` for formatting and linting. Install on approval as dev dependencies using pnpm.
* Fix lint and type-checking errors. Fix warnings where possible. Suppress a warning only with a specific, documented reason.

## Code Formatting

* For nested functions and control blocks like `if`, `for`, and `while` within the function body, prefer the following formatting style:
  * Ensure newline after the block if the block is not ending the function.
  * Ensure newline before the block if it is not the first statement in the function body.

## Recommended Packages

* **[jest](https://github.com/jestjs/jest)**: For testing TypeScript code.
* **[biome](https://github.com/biomejs/biome)**: For code formatting and linting TypeScript code.
* **[typescript](https://www.typescriptlang.org/)**: For type-checking TypeScript code.
* **[ts-node](https://typestrong.org/ts-node/)**: For running TypeScript code directly.
* **[swc/jest](https://github.com/swc-project/swc)**: For using SWC as a fast TypeScript compiler with Jest.
* **[yaml](https://github.com/eemeli/yaml)**: For parsing and stringifying YAML in TypeScript projects.
* **[toml](https://github.com/sunnyadn/js-toml)**: For parsing and stringifying TOML in TypeScript projects.
* **[connect-es](https://github.com/connectrpc/connect-es)**: For building Connect RPC clients and servers in TypeScript.
