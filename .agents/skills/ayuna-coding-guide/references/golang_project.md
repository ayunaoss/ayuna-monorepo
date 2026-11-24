# Golang Project

* Follow Go version and validation commands defined by repository first. Otherwise, verify `go` with `command -v go` and `go version`; require Go 1.27.0 or later.
* Ask before installing tools. Use project-pinned tool versions when available.
* Always check for standard tools like `go vet`, `gofmt`, and `golint`. Install recommended tools like `revive`, `goimports`, and `staticcheck`.
  
* Add the following `.golangci.yml` (golangci-lint v2 format) to each Go project if not found. Use project-pinned file when available.

    ```yaml
    version: "2"
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

    golangci-lint 2.x requires `version: "2"` and only auto-detects dot-prefixed names (`.golangci.yml`); a v1-style file or a plain `golangci.yml` is rejected or ignored. Verify with `golangci-lint config verify`, and replace any v1 `golangci.yml` that a scaffold generator wrote.
    Extend the yaml file to add linter and formatter specific configurations as needed.
* For monorepos with `go.work`, run `go work sync` only when workspace dependencies change.

## Checking and Debugging

* Use root-level `go.work` as the workspace source; run commands from the repo root so all `use` modules resolve together. A new project missing from `go.work` needs `pnpm nx workspace-sync`.
* Prefer local LSP (gopls) diagnostics first; confirm with `go vet`.
* Check changed files by their packages, not the whole workspace:
  * `go vet ./<module-dir>/<pkg>/...` (e.g. `go vet ./libs/go/<name>/...`)
  * Whole module only when needed: `cd <module-dir> && go vet ./...`
* For debugging, reproduce with `go vet` and `go test -run <Test> ./<pkg>`; add `-v` or `-race` only when required.

## Code Formatting

* For nested functions and control blocks like `if`, `for`, and `switch` within the function body, prefer the following formatting style:
  * Ensure newline after the block if the block is not ending the function.
  * Ensure newline before the block if it is not the first statement in the function body.
* Use `goimports` to format your code consistently.
* Run `goimports -w .` to apply formatting changes.

## Data Structures and Lookups

* Choose the structure by the operation, not by habit:
  * `map[K]V` for lookup by key, for example providers keyed by provider name, fields keyed by canonical field name, and claims keyed by claim name. A map makes the key unique and the lookup direct.
  * Slices for ordered data, for example ordered claim fallback lists, claim values and route order. Never replace an ordered list with a set.
  * `map[T]struct{}` only for membership tests and deduplication, for example allowed mapping keys or already-seen group names. Return an ordered slice when order is part of the contract.
* Keep independent collections separate when their keys have different semantics. A provider configuration map is not a claim map, and an ordered fallback list is not a set.

    ```go
    type Providers map[Name]Provider // dictionary: lookup by provider name
    type List []Claim                // ordered: fallback precedence
    type FieldSet map[Field]struct{} // set: membership or deduplication only
    ```

* Do not use a set for anything whose order is read back. If order matters, store a slice and use a set only as a temporary membership index.
* Before hashing, storing or comparing a collection whose order is not semantic, canonicalise it: remove duplicates, sort, and then hash/store/compare the canonical form. Keep ordered collections such as claim fallbacks in their declared order.
* Prefer `maps.Copy`, `maps.Clone`, `slices.Clone`, `slices.Contains` and `slices.ContainsFunc` over hand-written loops. Copy maps and slices at API boundaries so callers cannot mutate shared state.
* When walking a slice backwards, use `slices.Backward` instead of an index loop.

## Goroutines and Concurrency

* Use `github.com/sourcegraph/conc` for goroutine management in new code, including tests. Do not add `sync.WaitGroup` or `errgroup` for a new goroutine group.
* Use `conc.WaitGroup` for a fixed group of goroutines whose errors are handled independently or passed over a channel:

    ```go
    var wg conc.WaitGroup

    wg.Go(func() { /* work */ })
    wg.Go(func() { /* work */ })

    wg.Wait()
    ```

* Use `conc/pool` for fan-out, bounded concurrency, context cancellation and error collection:

    ```go
    p := pool.New().WithContext(ctx).WithCancelOnError()

    p.Go(func(ctx context.Context) error {
        return doWork(ctx)
    })

    return p.Wait()
    ```

* Prefer `WithMaxGoroutines` for bounded work; use `WithFirstError` when the remaining tasks are expected to return `context.Canceled` after the first failure. `pool.Wait` propagates panics and joins errors.
* A single long-lived goroutine that is part of a start/stop protocol (for example `http.Server.Serve` or a ticker loop tied to a context) may use a bare `go` when waiting before shutdown would block the lifecycle. It must have an explicit context/channel lifecycle and a comment explaining why `conc` does not fit. This is the only exception; never use bare `go` for a group or for fire-and-forget work.
* Tests follow the same rule: groups of test goroutines use `conc`; a test that starts one blocking server or function in the background is the same lifecycle exception, not a reason to skip `conc` for real fan-out.
* Keep `sync.Mutex`/`sync.RWMutex` for protecting state; `conc` is for goroutine lifecycle, not mutual exclusion.
* Never let a goroutine own an error that is not returned or logged; check the `conc` wait result.
* This skill packages the guard at `assets/tools/go_guard/guard.py`. Run it from the target repository root with `python <skill-root>/assets/tools/go_guard/guard.py --root .` (or the equivalent `uv run python` command); run its tests with `pytest <skill-root>/assets/tools/go_guard`. It enforces these rules in CI.

## Loops and Early Exit

* Break or return as soon as the answer is determined, when the remaining iterations cannot change the result. Typical cases: one boolean flag (`found`, `seen`, `admin`), the first matching key or error, an existence check, or a search. Prefer `slices.Contains`, `slices.ContainsFunc` or `slices.Index` over a hand-written search loop when no other work is needed.
* Do not break when the loop has work to do on every element:
  * writing or updating all matching entries, including duplicate provider or sign-in entries;
  * validating every element or collecting every error;
  * draining a channel, consuming all pending messages, or preserving ordering/backpressure;
  * accumulating counts, sums, merged sets, or last-wins state;
  * releasing resources or running cleanup that must happen for every iteration.
* When a loop intentionally scans every element, add a short comment saying why the full scan is required.
* `break` inside a `switch` only leaves the `switch`, not the enclosing loop. Use a label, or set a flag and break after the `switch`, when the whole loop must stop.
* Prefer returning directly over setting a found flag and continuing to the end of the function. Tests follow the same rule.

## Modern Go and Lint Baseline

* Use the repository Go toolchain (1.27 or later) and prefer the standard library's modern APIs. Preview safe rewrites with `go fix -diff ./...`, then apply with `go fix ./...`; the final diff must be empty.
* Apply the modernize rewrites consistently, including in `_test.go` files:
  * `errors.As(err, &target)` becomes `errors.AsType[T](err)`.
  * loops over `strings.Split`/`strings.Fields` become `strings.SplitSeq`/`strings.FieldsSeq` when only iteration is needed.
  * `strings.Index`/`HasPrefix`/`HasSuffix` pairs become `strings.Cut`/`CutPrefix`/`CutSuffix`.
  * explicit map copy loops become `maps.Copy`; membership loops become `slices.Contains`; backward index loops become `slices.Backward`.
  * `ptr(x)` helpers become `new(expr)`; remove helpers that become unused.
  * `WaitGroup.Add(1)` plus `go` plus `Done` becomes `WaitGroup.Go`.
  * `reflect.TypeOf(x)` becomes `reflect.TypeFor[T]()` where applicable.
  * redundant embedded-field names in composite literals are removed.
  * unnecessary loop-variable copies such as `f := f` are removed.
* Do not silence a diagnostic; fix it. If a suggested rewrite changes behavior, keep the original and add a short comment explaining why it is not equivalent.
* Do not build strings by concatenation inside `WriteString`/`Write`. Write the parts separately, or use `strings.Builder`/`fmt.Fprintf` with a format string.
* In `database/sql` loops, always check `rows.Err()` after the final `rows.Next()`, and close the rows before using the accumulated result.
* Do not hand-edit generated code (`bufgen/go/*.pb.go`, files with `// Code generated ... DO NOT EDIT.`). Regenerate it with the pinned generator; keep generated files out of manual lint rewrites.

## Database and API Boundaries

* Validate external input at the edge: proto validation and the service layer must reject unknown fields, empty lists, duplicate names and identity fields that the layer does not own.
* Keep wire and storage shapes explicit: a map keyed by name is a dictionary, not a list with a uniqueness check; an ordered fallback list stays a slice.
* Copy mutable data before storing or returning it. A caller must not be able to mutate tenant mappings, provider configuration or claim lists through a shared map or slice.

## Logging

* Application code uses `go.uber.org/zap`; do not add `log/slog` to `apps/go/*`.
* Shared libraries that must stay standard-library-only (for example `libs/go/secrets` and `libs/go/store`) may use `log/slog` at their boundary under the C7a2 decision. Keep it out of application code and document the boundary.
* Credential and secret types must redact themselves for every logger: implement `String()`/`GoString()` and, where practical, `zapcore.ObjectMarshaler`; cover both zap and slog redaction in tests.
* Never log passwords, tokens, provider client secrets or raw credential payloads.

## Verification Before Commit

Run these for every touched module and fix every diagnostic:

* `gopls check <changed files>` and `gopls check -severity=hint <changed files>`; the hint pass catches `modernize` diagnostics.
* `go mod tidy -diff` in every touched module; it must print nothing. Use `GOWORK=off` when checking a module against its own `go.mod` rather than the workspace.
* `go fix -diff ./...`; after fixes it must print nothing.
* `golangci-lint run ./...`; zero issues.
* `go test ./...` (with `-race` where the project target uses it).
* `gofmt -l` / `goimports`, and `git diff --check`.

## Recommended Packages

These are the project's first-choice packages, not optional suggestions. When a need matches one, use it; do not add a parallel library or hand-roll an equivalent. If an existing area uses another package, migrate it when you touch it or record a written exception in the change/ADR. Adding or replacing a package requires updating the approved dependency list and the licence inventory.

* **[revive](https://github.com/revive-lint/revive#installation)**: Code linting.
* **[goimports](https://pkg.go.dev/golang.org/x/tools/cmd/goimports)**: Fixes imports and runs `gofmt`.
* **[staticcheck](https://staticcheck.dev/docs/getting-started/)**: Supplements `go vet`; detects bugs, performance issues, and deadlocks.
* **[cobra](https://github.com/spf13/cobra)**: For building CLI applications.
* **[testify](https://github.com/stretchr/testify)**: For writing unit tests.
* **[viper](https://github.com/spf13/viper)**: For managing configuration in Go applications.
* **[zap](https://github.com/uber-go/zap)**: For high-performance structured logging.
* **[errors](https://github.com/pkg/errors)**: For error handling with stack trace support.
* **[conc](https://github.com/sourcegraph/conc)**: For concurrent programming utilities. Mandatory for goroutine groups; see “Goroutines and Concurrency”. The skill's `assets/tools/go_guard` CI guard rejects `sync.WaitGroup`, `errgroup` and non-test bare `go` statements.
* **[opendal](https://opendal.apache.org/docs/bindings/go/)**: For object storage access in Go applications.
* **[cel-go](https://github.com/cel-expr/cel-go)**: For evaluating CEL (Common Expression Language) expressions in Go applications.
* **[connect-go](https://github.com/connectrpc/connect-go)**: For building Connect RPC clients and servers in Go.
* **[echo](https://github.com/labstack/echo)**: For web framework.
* **[bun](https://github.com/uptrace/bun)**: For SQL-first ORM.
