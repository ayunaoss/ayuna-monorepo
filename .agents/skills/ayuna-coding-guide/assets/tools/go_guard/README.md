# Go concurrency guard

This asset enforces the Go concurrency rules in
`references/golang_project.md`:

- non-test Go code must not use a bare `go` statement; use `conc.WaitGroup` or
  `conc/pool`. A single start/stop lifecycle goroutine may opt out with
  `//go:allow-bare-go` and a reason;
- no Go code, including `_test.go`, may use `sync.WaitGroup` or `errgroup`;
- generated files are skipped.

From the skill root, run it against the target repository root:

```sh
python assets/tools/go_guard/guard.py --root /path/to/target
```

Or pass any root and scan roots:

```sh
python assets/tools/go_guard/guard.py --root /path/to/repo --roots services,pkg
```

Run the guard's own tests with:

```sh
pytest assets/tools/go_guard
```

The default scan roots are the Ayuna monorepo layout (`apps`, `libs`, `bufgen`).
Override them with `--roots` for another layout.
