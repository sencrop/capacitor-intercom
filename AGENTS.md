# Agent instructions

Run every command from a devenv shell (`devenv shell -- <command>`): Node.js and pnpm come from devenv, not from the global PATH.

- Install: `pnpm install`
- Format, lint and type check: `pnpm run check`, and `pnpm run check --fix` to apply the fixes
- Build: `pnpm run build` (it also regenerates the API section of `README.md`)

Native code is outside `pnpm run check`:

- `pnpm run check:ios` lints the Swift code with swift-format (shipped with Xcode); `xcrun swift-format format --in-place --recursive ios/Plugin ios/PluginTests` fixes the formatting. The pre-commit hook formats and lints the staged Swift files; CI does not check them
- `pnpm run check:android` checks the Java formatting with google-java-format (AOSP style, from devenv) and runs Android Lint (needs JDK 21 and the Android SDK); `google-java-format --aosp --replace <files>` fixes the formatting. The pre-commit hook formats the staged Java files
