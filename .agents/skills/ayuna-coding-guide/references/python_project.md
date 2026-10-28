# Python Project

* Follow runtime, package manager, test, lint, and type-check commands defined by repository first. Prefer project virtual environment over system Python.
* For an unconfigured project, require Python 3.12 or later. Verify with `python --version`,
  set `target-version = "py312"` in `pyproject.toml`, and use uv.
* Verify uv with `uv self version`. If not found, install with `curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="${HOME}/.local" UV_NO_MODIFY_PATH=1 sh`
* Ask before installing uv or changing dependencies or lockfiles.
* When dependency synchronization is required, run repository command; otherwise run `uv sync --all-groups --all-packages` from project root.
* Root-level `pyproject.toml` `[tool.uv.workspace]` `members` lists the Python projects. A new project missing there needs `pnpm nx workspace-sync`.
* Use `ruff` as the recommended linter, installed only when approved.
* Use `basedpyright` for type checking and IntelliSense in Python projects.
* Fix lint and type-checking errors. Fix warnings where possible. Suppress a warning only with a specific, documented reason.
* Prefer `asyncio` for concurrent programming and asynchronous I/O operations in Python projects.
* Use `pytest` and its asyncio extensions for testing asynchronous code in Python projects.

## Checking and Debugging

* Prefer local LSP (basedpyright) diagnostics first; confirm with the CLI.
* Run from the repo root through uv, scoped to changed files:
  * `uv run ruff check <files>` (add `--fix` for safe fixes).
  * `uv run ruff format --check <files>`.
  * `uv run --package <project-name> pytest <path>` for related tests.
  * `uv run basedpyright <files>` for type checks.
* Use `uv sync --all-groups --all-packages` only when dependencies changed and with approval.

## Code Formatting

* For nested functions and control blocks like `if`, `for`, and `while` within the function body, prefer the following formatting style:
  * Ensure newline after the block if the block is not ending the function.
  * Ensure newline before the block if it is not the first statement in the function body.

## Recommended Packages

Use the recommended packages for specific needs.

* **[ruff](https://github.com/charliermarsh/ruff)**: For linting and code formatting.
* **[basedpyright](https://github.com/detachhead/basedpyright)**: For type checking and IntelliSense in Python projects.
* **[uv](https://astral.sh/uv/)**: For managing Python virtual environments and dependency synchronization.
* **[pydantic-v2](https://docs.pydantic.dev/latest/)**: For data validation and settings management using Python type annotations.
* **[connect-py](https://github.com/connectrpc/connect-py)**: For building Connect RPC clients and servers in Python.
* **[httpx](https://github.com/encode/httpx)**: For making HTTP requests in Python.
* **[pytest](https://github.com/pytest-dev/pytest)**: For testing Python code.
* **[tomlkit](https://github.com/python-poetry/tomlkit)**: For parsing and manipulating TOML files in Python.
