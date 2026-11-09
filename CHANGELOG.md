# Changelog

## [11.0.1](https://github.com/sencrop/capacitor-intercom/compare/v11.0.0...v11.0.1) (2026-11-09)


### Bug fixes

* **android:** initialize Intercom from the Application, before Android opens an Intercom activity ([#57](https://github.com/sencrop/capacitor-intercom/issues/57)) ([2d56867](https://github.com/sencrop/capacitor-intercom/commit/2d56867a4e7aa99d48e8b6e63dc929129172ea75))


### Documentation

* point to Menu &gt; Staged Packages on npmjs.com ([#56](https://github.com/sencrop/capacitor-intercom/issues/56)) ([93328f1](https://github.com/sencrop/capacitor-intercom/commit/93328f1a0acc44b8f8c4f794202753a6506962f2))


### CI configuration

* build, test and lint the iOS plugin ([#54](https://github.com/sencrop/capacitor-intercom/issues/54)) ([01b6e22](https://github.com/sencrop/capacitor-intercom/commit/01b6e224a40ae0e2837f77eea174514f64aa966d))

## [11.0.0](https://github.com/sencrop/capacitor-intercom/compare/v10.0.2...v11.0.0) (2026-11-09)


### ⚠ BREAKING CHANGES

* **android:** the Android plugin exposes Intercom Android 18 (`api` dependency); apps remove their own Intercom artifact. Intercom 18 migrates its local storage one way (DataStore, going back to 17 loses the local Intercom state) and requires minSdk 23. Intercom iOS is bounded to ~> 19.5. handlePushMessage() is no longer called.

### Bug fixes

* align the iOS, Android and web behaviors ([#46](https://github.com/sencrop/capacitor-intercom/issues/46)) ([2e10d8d](https://github.com/sencrop/capacitor-intercom/commit/2e10d8dc03d99c292b4070b3a2c0aead7305b373))
* **android:** expose the Intercom SDK so the app runs a single Intercom version ([#50](https://github.com/sencrop/capacitor-intercom/issues/50)) ([71f5f17](https://github.com/sencrop/capacitor-intercom/commit/71f5f17d7d710a07f6ae82163ac5d0e9e704d35d))
* **ios:** only pass Intercom the values the app sends ([#51](https://github.com/sencrop/capacitor-intercom/issues/51)) ([30552c9](https://github.com/sencrop/capacitor-intercom/commit/30552c96be701af859dc8c00bcfaa4aa53391023))
* **ios:** put the Intercom error in the rejection message ([#45](https://github.com/sencrop/capacitor-intercom/issues/45)) ([017096e](https://github.com/sencrop/capacitor-intercom/commit/017096e83dbbf904294ae5363be859dcbe9ac625))
* **ios:** support Swift Package Manager ([#52](https://github.com/sencrop/capacitor-intercom/issues/52)) ([c77bae8](https://github.com/sencrop/capacitor-intercom/commit/c77bae8ce1ebe819a839bcddb98de4bdbd643379))
* pin the iOS Intercom SDK and update the Android one to 18 ([#47](https://github.com/sencrop/capacitor-intercom/issues/47)) ([850ef1e](https://github.com/sencrop/capacitor-intercom/commit/850ef1ef7b1df85c235be8851655db3a8e3f888c))


### Documentation

* explain how the app wires Intercom push notifications ([#49](https://github.com/sencrop/capacitor-intercom/issues/49)) ([cee39d5](https://github.com/sencrop/capacitor-intercom/commit/cee39d582fc3aef440b8d48795b732c716da1e17))
* link the npm staged packages page ([#42](https://github.com/sencrop/capacitor-intercom/issues/42)) ([94e9708](https://github.com/sencrop/capacitor-intercom/commit/94e970865f26df0c3cb62c6768e494d9c8ea1b13))


### CI configuration

* post releases to #deployment-updates-prod ([#44](https://github.com/sencrop/capacitor-intercom/issues/44)) ([1e97556](https://github.com/sencrop/capacitor-intercom/commit/1e975560e42b9b785e24e78b3f0df752c2c76dc2))

## [10.0.2](https://github.com/sencrop/capacitor-intercom/compare/v10.0.1...v10.0.2) (2026-11-06)


### Miscellaneous Chores

* **devenv:** move to node 24 ([#37](https://github.com/sencrop/capacitor-intercom/issues/37)) ([fc795f2](https://github.com/sencrop/capacitor-intercom/commit/fc795f2d0eaef73c149bf394cf0db3cf8efb15e1))
* **devenv:** update ([#36](https://github.com/sencrop/capacitor-intercom/issues/36)) ([401966d](https://github.com/sencrop/capacitor-intercom/commit/401966ddb460807cafe7b63763547b110c34c359))
* **lint:** make npm run lint pass ([#38](https://github.com/sencrop/capacitor-intercom/issues/38)) ([0c94c02](https://github.com/sencrop/capacitor-intercom/commit/0c94c025920039d35b7b3daf8e3730faccb3cf97))


### Build system

* migrate to pnpm, Vite+ and Rolldown, add CI and automated releases ([#39](https://github.com/sencrop/capacitor-intercom/issues/39)) ([263b096](https://github.com/sencrop/capacitor-intercom/commit/263b096aba6ecf6285c3ee30234d590f005d3a6c))
* unblock the release check, restrict manual releases to tags, JDK 21 in devenv ([#41](https://github.com/sencrop/capacitor-intercom/issues/41)) ([ecb5a3e](https://github.com/sencrop/capacitor-intercom/commit/ecb5a3ec82b7d0d6abc5d96e5b3b0412062ffa45))
