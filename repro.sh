#!/bin/sh
# Runs `pnpm dedupe` three times and prints the lockfile hash after each run.
# Expected: all three hashes are equal. Actual on pnpm 12.8.0: 1st == 3rd != 2nd.
set -e
for i in 1 2 3; do
  pnpm dedupe --lockfile-only >/dev/null 2>&1
  echo "after dedupe #$i: $(shasum pnpm-lock.yaml | cut -c1-12)"
done
pnpm dedupe --check --lockfile-only >/dev/null 2>&1 && echo "dedupe --check: clean" || echo "dedupe --check: FAILS"
