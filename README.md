# pnpm 12: `pnpm dedupe` never converges

Every `pnpm dedupe` rewrites the key of the same peer variant of
`@react-native-firebase/app@23.8.2`: one run writes it as a hashed peer suffix
(`@react-native-firebase/app@23.8.2(c10232d09b241daf3df3a0112ad34b9c)`), the next as the
full expanded suffix (`@react-native-firebase/app@23.8.2(@react-native-async-storage/async-storage@2.2.0(…))(expo@57.0.9(…))(react-native@0.86.2(…))(react@19.2.3)`).
The snapshot body is identical in both runs; only the key changes. `pnpm dedupe --check`
therefore always fails.

```sh
pnpm install --lockfile-only
./repro.sh
```

pnpm 12.8.0:

```
after dedupe #1: 9c9eb77d92c6
after dedupe #2: 9afeadaac535
after dedupe #3: 9c9eb77d92c6
dedupe --check: FAILS
```

pnpm 11.24.0 / 11.28.1 (change `packageManager` in `package.json`): all three hashes are equal.

Notes:
- The committed `pnpm-lock.yaml` is required: starting from no lockfile, pnpm 12.8.0 produces
  a lockfile that is stable under `dedupe`.
- Removing any remaining piece makes the lockfile stable: `autoInstallPeers: false`, the
  `typescript` override, the patch of `@react-native-async-storage/async-storage` (it only
  edits the README), any dependency of `packages/b`, or either `npm:` alias in `packages/c`.
