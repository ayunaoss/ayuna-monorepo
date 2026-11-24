"""Go concurrency guard for Ayuna projects.

Rules (see ``references/golang_project.md`` in this skill):

* non-test Go code must not start a bare ``go`` statement; use conc.WaitGroup
  or conc/pool. A single start/stop lifecycle goroutine may opt out with a
  ``//go:allow-bare-go`` comment and a reason.
* no Go code (including tests) may use ``sync.WaitGroup`` or ``errgroup``;
  use the conc equivalents.
* generated files are skipped.

Run it from the target repository root, or pass ``--root``. The default scan
roots are the Ayuna monorepo layout; pass ``--roots`` for another layout.
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path

ROOTS = ("apps", "libs", "bufgen")
SKIP_DIRS = {"node_modules", ".venv", "vendor"}

BARE_GO = re.compile(r"^\s*go\s+(?:func\b|[A-Za-z_][A-Za-z0-9_.]*\s*\()")
WAITGROUP = re.compile(r"\bsync\.WaitGroup\b")
ERRGROUP = re.compile(r"\berrgroup\.")
ALLOW_BARE_GO = "//go:allow-bare-go"

BARE_GO_MESSAGE = (
    "bare go statement: use conc.WaitGroup or conc/pool; add "
    "//go:allow-bare-go only for a single start/stop lifecycle goroutine"
)
WAITGROUP_MESSAGE = "sync.WaitGroup: use conc.WaitGroup"
ERRGROUP_MESSAGE = "errgroup: use conc/pool with errors"


@dataclass(frozen=True)
class Problem:
    path: Path
    line: int
    message: str


def _code(line: str, in_block: bool) -> tuple[str, bool]:
    """Drop comments from one line and return the remaining code and block state."""
    while True:
        if in_block:
            end = line.find("*/")
            if end == -1:
                return "", True
            line = line[end + 2 :]
            in_block = False

        start = line.find("/*")
        if start == -1:
            break

        end = line.find("*/", start + 2)
        if end == -1:
            line = line[:start]
            in_block = True
            break
        line = line[:start] + line[end + 2 :]

    return line.split("//", 1)[0], in_block


def _is_generated(text: str) -> bool:
    header = "\n".join(text.splitlines()[:10])
    return "Code generated" in header and "DO NOT EDIT" in header


def scan_file(path: Path) -> list[Problem]:
    text = path.read_text(encoding="utf-8")
    if _is_generated(text):
        return []

    allow_bare_go = ALLOW_BARE_GO in text
    is_test = path.name.endswith("_test.go")
    problems: list[Problem] = []
    in_block = False

    for number, line in enumerate(text.splitlines(), start=1):
        code, in_block = _code(line, in_block)
        if not is_test and not allow_bare_go and BARE_GO.search(code):
            problems.append(Problem(path, number, BARE_GO_MESSAGE))
        if WAITGROUP.search(code):
            problems.append(Problem(path, number, WAITGROUP_MESSAGE))
        if ERRGROUP.search(code):
            problems.append(Problem(path, number, ERRGROUP_MESSAGE))

    return problems


def scan_root(root: Path, roots: tuple[str, ...] = ROOTS) -> list[Problem]:
    problems: list[Problem] = []
    for name in roots:
        base = root / name
        if not base.is_dir():
            continue
        for path in sorted(base.rglob("*.go")):
            if any(part in SKIP_DIRS for part in path.parts):
                continue
            problems.extend(scan_file(path))
    return problems


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--root",
        type=Path,
        default=Path.cwd(),
        help="repository root (defaults to the current directory)",
    )
    parser.add_argument(
        "--roots",
        default=",".join(ROOTS),
        help="comma-separated roots to scan (default: apps,libs,bufgen)",
    )
    args = parser.parse_args(argv)

    roots = tuple(root.strip() for root in args.roots.split(",") if root.strip())
    problems = scan_root(args.root, roots)
    for problem in problems:
        try:
            shown = problem.path.relative_to(args.root)
        except ValueError:
            shown = problem.path
        print(f"{shown}:{problem.line}: {problem.message}")

    if problems:
        print(f"go guard: {len(problems)} violation(s)", file=sys.stderr)
        return 1

    print("go guard: ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
