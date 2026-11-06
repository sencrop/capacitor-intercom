# Contributing

This guide provides instructions for contributing to this Capacitor plugin.

## Developing

### Local Setup

1. Clone the repo.
1. Install the dependencies from a devenv shell.

   ```shell
   devenv shell -- pnpm install
   ```

### Scripts

#### `pnpm run build`

Build the plugin web assets and generate plugin API documentation using [`@capacitor/docgen`](https://github.com/ionic-team/capacitor-docgen).

`vp pack` ([tsdown](https://tsdown.dev/), on Rolldown) compiles `src/` into ESM JavaScript in `dist/esm/`, with type declarations emitted by TypeScript 7. These files are used in apps with bundlers when your plugin is imported.

It also bundles the code into a single file at `dist/plugin.js` (IIFE, for apps without bundlers that include it as a script in `index.html`) and `dist/plugin.cjs.js` (CommonJS).

#### `pnpm run verify`

Build and validate the web and native projects.

This is useful to run in CI to verify that the plugin builds for all platforms.

#### `pnpm run check`

Check formatting, lint and types with [Vite+](https://viteplus.dev/). `pnpm run check --fix` applies the formatting and lint fixes. The pre-commit hook does the same on staged files.

#### `pnpm run check:ios` / `pnpm run check:android`

Lint the native code: swift-format (shipped with Xcode, configured in `.swift-format`) for Swift, google-java-format (AOSP style, provided by devenv) and Android Lint (JDK 21 provided by devenv, needs the Android SDK) for the Android library. `xcrun swift-format format --in-place --recursive ios/Plugin ios/PluginTests` fixes the Swift formatting. The pre-commit hook formats the staged Swift and Java files and lints the Swift ones; CI runs `check:android` only.

## Publishing

Releases are automated with [release-please](https://github.com/googleapis/release-please). Every push to `master` updates a `chore: release <version>` pull request that bumps the version and the changelog from the [Conventional Commits](https://www.conventionalcommits.org/) titles. Merging it tags the release, creates the GitHub release and stages the package on npm from the `Release` workflow (npm trusted publishing, no token). The version is not live yet: a maintainer approves it, with 2FA, in one of two ways:

- on npmjs.com, `https://www.npmjs.com/settings/<npm-username>/staged-packages` (your own account settings, not the package page), **Approve** button (enabled once npm has scanned the package);
- from a terminal, outside this repo (npm refuses to run here): `npm stage list @sencrop/capacitor-intercom`, then `npm stage approve <stage-id>`.

The summary of the `Release` workflow run recalls these steps.

To publish an existing tag again, run the `Release` workflow manually with that tag.

> **Note**: The [`files`](https://docs.npmjs.com/cli/v7/configuring-npm/package-json#files) array in `package.json` specifies which files get published. If you rename files/directories or add files elsewhere, you may need to update it.
