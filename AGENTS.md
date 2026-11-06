# Agent instructions

Run every command from a devenv shell (`devenv shell -- <command>`): Node.js and pnpm come from devenv, not from the global PATH.

- Install: `pnpm install`
- Format, lint and type check: `pnpm run check`, and `pnpm run check --fix` to apply the fixes
- Build: `pnpm run build` (it also regenerates the API section of `README.md`)

Native code (`android/`, `ios/`) is neither formatted nor linted by `pnpm run check`.
