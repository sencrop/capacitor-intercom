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

Lint the native code: swift-format (shipped with Xcode, configured in `.swift-format`) for Swift, Android Lint for the Android library (needs JDK 21 and the Android SDK). `xcrun swift-format format --in-place --recursive ios/Plugin ios/PluginTests` fixes the Swift formatting. The pre-commit hook formats and lints the staged Swift files; CI only runs Android Lint.

## Publishing

There is a `prepublishOnly` hook in `package.json` which prepares the plugin before publishing, so all you need to do is run:

```shell
pnpm publish
```

> **Note**: The [`files`](https://docs.npmjs.com/cli/v7/configuring-npm/package-json#files) array in `package.json` specifies which files get published. If you rename files/directories or add files elsewhere, you may need to update it.
