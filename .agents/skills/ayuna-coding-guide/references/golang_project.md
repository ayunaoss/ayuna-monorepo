# Golang Project

* Follow Go version and validation commands defined by repository first. Otherwise, verify `go` with `command -v go` and `go version`; require Go 1.27.0 or later.
* Ask before installing tools. Use project-pinned tool versions when available.
* Always check for standard tools like `go vet`, `gofmt`, and `golint`. Install recommended tools like `revive`, `goimports`, and `staticcheck`.
  
* Add the following golangci.yml config if not found. Use project-pinned file when available.

    ```yaml
    run:
        timeout: 5m
    linters:
        enable:
            - govet
            - revive
            - staticcheck
    formatters:
        enable:
            - gofmt
            - goimports
    ```

    Extend the yaml file to add linter and formatter specific configurations as needed.
* For monorepos with `go.work`, run `go work sync` only when workspace dependencies change.

## Code Formatting

* For nested functions and control blocks like `if`, `for`, and `switch` within the function body, prefer the following formatting style:
  * Ensure newline after the block if the block is not ending the function.
  * Ensure newline before the block if it is not the first statement in the function body.
* Use `goimports` to format your code consistently.
* Run `goimports -w .` to apply formatting changes.

## Recommended Packages

Use the recommended packages for specific needs.

* **[revive](https://github.com/revive-lint/revive#installation)**: Code linting.
* **[goimports](https://pkg.go.dev/golang.org/x/tools/cmd/goimports)**: Fixes imports and runs `gofmt`.
* **[staticcheck](https://staticcheck.dev/docs/getting-started/)**: Supplements `go vet`; detects bugs, performance issues, and deadlocks.
* **[cobra](https://github.com/spf13/cobra)**: For building CLI applications.
* **[testify](https://github.com/stretchr/testify)**: For writing unit tests.
* **[viper](https://github.com/spf13/viper)**: For managing configuration in Go applications.
* **[zap](https://github.com/uber-go/zap)**: For high-performance structured logging.
* **[errors](https://github.com/pkg/errors)**: For error handling with stack trace support.
* **[conc](https://github.com/sourcegraph/conc)**: For concurrent programming utilities.
* **[opendal](https://opendal.apache.org/docs/bindings/go/)**: For object storage access in Go applications.
* **[cel-go](https://github.com/cel-expr/cel-go)**: For evaluating CEL (Common Expression Language) expressions in Go applications.
* **[connect-go](https://github.com/connectrpc/connect-go)**: For building Connect RPC clients and servers in Go.
* **[echo](https://github.com/labstack/echo)**: For web framework.
* **[bun](https://github.com/uptrace/bun)**: For SQL-first ORM.
