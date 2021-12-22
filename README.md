# npm-pnpm-yarn

Demo of various package managers (semi private). All demos use a simplified, Node 16
compatible version of nuxt dependencies.

Starting with NPM 7, both Yarn 2 and pnpm can be installed in a project using corepack, which only
needs to be set up once:

```bash
nvm use 16
corepack enable
```

## Summary

- All 3 package managers produce pacakage directories of about the same size (yarn pnp not tested) and layout
- Install times are negligibly similar (pnpm is faster iff packages are cached)
- PNPM operates pretty much identically to NPM, only conveying overall disk usage benefits for multiple projects IFF using the exact same versions (meh)
- Yarn allows for the use of PnP and zero-install later if the tooling improves
- Yarn setup is much more complicated and uses non-standard config; once you yarn, you are kind of locked in
- Yarn has a slight syntactic benefit in being easy to say and does not require "run" to run scripts, just `yarn whatever`

## Project Setup

Only done once in a new project or when switching package managers

### NPM

- Included with node, no additional setup
- Private repository scopes set in `.npmrc`, and optionally tokens set in `~/.npmrc`
  ```
  @speareducation:registry=https://npm.pkg.github.com/
  ```

### Yarn 2+

- Installed via corepack
- Additional project setup required:
  - Install yarn binary: `yarn set version stable`
  - Add the following to `.yarnrc.yml`
    ```
    nodeLinker: node-modules
    npmScopes:
      speareducation:
        npmRegistryServer: https://npm.pkg.github.com
    ```
  - Add the following to `.gitignore`
    ```
    # Yarn
    .yarn/*
    !.yarn/patches
    !.yarn/plugins
    !.yarn/releases
    !.yarn/sdks
    !.yarn/versions
    # disable pnp
    .pnp.*
    # !.yarn/cache
    ```
  - Add upgrade interactive: `yarn plugin import interactive-tools`

### PNPM

- Installed via corepack
- Update to most recent version: `corepack prepare pnpm@6.24.2 --activate`
- Private repository scopes set in `.npmrc`, and optionally tokens set in `~/.npmrc`
  ```
  @speareducation:registry=https://npm.pkg.github.com/
  ```

## Installing & Managing Packages

### NPM

_Note_: Previous versions of npm would update package.json when running `npm install`, while `npm ci` was the preferred method for locked installs. This is no longer the case (thankfully). Likewise, the install commands for packages now operate much more like their yarn counterparts.

_Important_: Unlike the other managers, NPM will install peer dependencies by default. If this causes a conflict, it can look like the install failed, use `--legacy-peer-deps` to not install peer dependencies.

- Install: `npm install`
- Install from lockfile: `npm ci`
- Add a package:
  - `npm install consola` (prod)
  - or `npm install --save-dev consola`
  - or aliased to `npm add`
- Remove a package: `npm uninstall consola`
- Update packages: `npm update`

Check in `package-lock.json`

#### Performance

- Cold install (no lockfile): `36.40s user 27.36s system 167% cpu 38.029 total`
- Warm install (\w lockfile): `27.86s user 24.88s system 184% cpu 28.524 total`
- Size: 1.1G

### Yarn

- Install: `yarn` or `yarn install`
- Install from lockfile: `yarn install --immutable`
- Add a package: `yarn add consola`
- Remove a package: `yarn remove consola`
- Update packages: `yarn upgrade`

Check in `yarn.lock`

#### Performance

- Cold install (no lockfile): `43.02s user 26.20s system 185% cpu 37.409 total`
- Warm install (\w lockfile): `28.67s user 23.35s system 208% cpu 24.908 total`
- Size: 1.1G

### PNPM

- Install: `pnpm install`
- Install from lockfile: `pnpm install --frozen-lockfile`
- Add a package: `yarn add consola`
- Remove a package: `yarn remove consola`
- Update packages: `pnpm update`

Check in `pnpm-lock.yaml`

#### Performance

_Note_: Remember to delete `~/.pnpm-store` for cold install

- Cold install (no lockfile): `42.22s user 26.64s system 180% cpu 38.063 total`
- Warm install (\w lockfile): `16.76s user 15.89s system 192% cpu 16.941 total`
- Size: 1.1G

## Operations

```
npm outdated
npx npm-check
yarn upgrade-interactive
pnpm update --interactive
```

```
npm explain uuid
yarn why uuid
pnpm why uuid
```

```
npm run build
npx jest
npm exec -- jest
yarn build
yarn dlx jest
pnpm run build
pnpm dlx jest
```

## Example Output

### NPM

Boooooring

Install:
```
npm WARN deprecated core-js@2.6.12: core-js@<3.3 is no longer maintained and not recommended for usage due to the number of issues. Because of the V8 engine whims, feature detection in old core-js versions could cause a slowdown up to 100x even if nothing is polyfilled. Please, upgrade your dependencies to the actual version of core-js.

added 2072 packages, and audited 2073 packages in 1m

138 packages are looking for funding
  run `npm fund` for details

21 vulnerabilities (13 moderate, 8 high)

To address issues that do not require attention, run:
  npm audit fix

To address all issues possible (including breaking changes), run:
  npm audit fix --force

Some issues need review, and may require choosing
a different dependency.

Run `npm audit` for details.
```

### Yarn

Looks much better in console.

```
➤ YN0000: ┌ Resolution step
➤ YN0061: │ popper.js@npm:1.16.1 is deprecated: You can find the new Popper v2 at @popperjs/core, this package is dedicated to the legacy v1
➤ YN0032: │ fsevents@npm:2.3.2: Implicit dependencies on node-gyp are discouraged
➤ YN0061: │ debug@npm:4.1.1 is deprecated: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)
➤ YN0061: │ core-js@npm:2.6.12 is deprecated: core-js@<3.3 is no longer maintained and not recommended for usage due to the number of issues. Because of the V8 engine whims, feature detection in old core-js versions could cause a slowdown up to 100x even if nothing is polyfilled. Please, upgrade your dependencies to the actual version of core-js.
➤ YN0032: │ node-addon-api@npm:1.7.2: Implicit dependencies on node-gyp are discouraged
➤ YN0061: │ urix@npm:0.1.0 is deprecated: Please see https://github.com/lydell/urix#deprecated
➤ YN0061: │ resolve-url@npm:0.2.1 is deprecated: https://github.com/lydell/resolve-url#deprecated
➤ YN0061: │ querystring@npm:0.2.1 is deprecated: The querystring API is considered Legacy. new code should use the URLSearchParams API instead.
➤ YN0061: │ flatten@npm:1.0.3 is deprecated: flatten is deprecated in favor of utility frameworks such as lodash.
➤ YN0061: │ svgo@npm:1.3.2 is deprecated: This SVGO version is no longer supported. Upgrade to v2.x.x.
➤ YN0061: │ querystring@npm:0.2.0 is deprecated: The querystring API is considered Legacy. new code should use the URLSearchParams API instead.
➤ YN0061: │ chokidar@npm:2.1.8 is deprecated: Chokidar 2 will break on node v14+. Upgrade to chokidar 3 with 15x less dependencies.
➤ YN0061: │ fsevents@npm:1.2.13 is deprecated: fsevents 1 will break on node v14+ and could be using insecure binaries. Upgrade to fsevents 2.
➤ YN0032: │ nan@npm:2.15.0: Implicit dependencies on node-gyp are discouraged
➤ YN0032: │ evp_bytestokey@npm:1.0.3: Implicit dependencies on node-gyp are discouraged
➤ YN0061: │ uuid@npm:3.3.2 is deprecated: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
➤ YN0061: │ intl-messageformat-parser@npm:1.8.1 is deprecated: We've written a new parser that's 6x faster and is backwards compatible. Please use @formatjs/icu-messageformat-parser
➤ YN0002: │ @nuxt/webpack@npm:2.15.8 doesn't provide @vue/compiler-sfc (p606e8), requested by vue-loader
➤ YN0002: │ @nuxtjs/eslint-module@npm:3.0.2 [1254e] doesn't provide webpack (p8844b), requested by eslint-webpack-plugin
➤ YN0002: │ @speareducation/components@npm:1.6.4::__archiveUrl=https%3A%2F%2Fnpm.pkg.github.com%2Fdownload%2F%40speareducation%2Fcomponents%2F1.6.4%2Ff162a2cfc5295be4e72cec0583953d4d7de4543d8945db3d7ea9a4cf291d61fa doesn't provide jquery (p1d5fc), requested by bootstrap
➤ YN0002: │ @speareducation/components@npm:1.6.4::__archiveUrl=https%3A%2F%2Fnpm.pkg.github.com%2Fdownload%2F%40speareducation%2Fcomponents%2F1.6.4%2Ff162a2cfc5295be4e72cec0583953d4d7de4543d8945db3d7ea9a4cf291d61fa doesn't provide popper.js (p0216d), requested by bootstrap
➤ YN0002: │ bootstrap-vue@npm:2.21.2 doesn't provide jquery (pf1ff3), requested by bootstrap
➤ YN0002: │ bootstrap-vue@npm:2.21.2 doesn't provide vue (p679d5), requested by portal-vue
➤ YN0002: │ nuxt@npm:2.15.8 doesn't provide consola (p2d844), requested by @nuxt/components
➤ YN0002: │ patient-mock@workspace:. doesn't provide @vue/compiler-sfc (p1dbe2), requested by vue-loader
➤ YN0002: │ patient-mock@workspace:. doesn't provide jquery (p3b3f4), requested by bootstrap
➤ YN0002: │ patient-mock@workspace:. doesn't provide vue (p533c1), requested by @vue/test-utils
➤ YN0002: │ patient-mock@workspace:. doesn't provide vue (p367fb), requested by vue-instantsearch
➤ YN0002: │ patient-mock@workspace:. doesn't provide vue (pff3cd), requested by vue-jest
➤ YN0002: │ patient-mock@workspace:. doesn't provide vue (pe9d5b), requested by vue-js-modal
➤ YN0002: │ patient-mock@workspace:. doesn't provide vue (p32378), requested by vue-notification
➤ YN0002: │ patient-mock@workspace:. doesn't provide vue-template-compiler (pdaa94), requested by @vue/test-utils
➤ YN0002: │ patient-mock@workspace:. doesn't provide vue-template-compiler (p81205), requested by vue-jest
➤ YN0002: │ vue-browser-detect-plugin@npm:0.1.18 doesn't provide eslint (pf88af), requested by vue-eslint-parser
➤ YN0002: │ vue-slider-component@npm:3.2.15 doesn't provide vue (pfb52d), requested by vue-property-decorator
➤ YN0000: │ Some peer dependencies are incorrectly met; run yarn explain peer-requirements <hash> for details, where <hash> is the six-letter p-prefixed code
➤ YN0000: └ Completed in 9s 790ms
➤ YN0000: ┌ Fetch step
➤ YN0013: │ yargs@npm:15.4.1 can't be found in the cache and will be fetched from the remo
➤ YN0013: │ yargs@npm:16.2.0 can't be found in the cache and will be fetched from the remo
➤ YN0013: │ yauzl@npm:2.10.0 can't be found in the cache and will be fetched from the remo
➤ YN0013: │ yeast@npm:0.1.2 can't be found in the cache and will be fetched from the remot
➤ YN0013: │ yocto-queue@npm:0.1.0 can't be found in the cache and will be fetched from the
➤ YN0000: └ Completed in 2s 993ms
➤ YN0000: ┌ Link step
➤ YN0076: │ fsevents@patch:fsevents@npm%3A2.3.2#~builtin<compat/fsevents>::version=2.3.2&hash=18f3a7 The linux-x64 architecture is incompatible with this module, link skipped.
➤ YN0076: │ fsevents@patch:fsevents@npm%3A1.2.13#~builtin<compat/fsevents>::version=1.2.13&hash=18f3a7 The linux-x64 architecture is incompatible with this module, link skipped.
➤ YN0007: │ bootstrap-vue@npm:2.21.2 must be built because it never has been before or the last one failed
➤ YN0007: │ core-js@npm:3.20.0 must be built because it never has been before or the last one failed
➤ YN0007: │ nuxt@npm:2.15.8 must be built because it never has been before or the last one failed
➤ YN0007: │ puppeteer@npm:10.4.0 must be built because it never has been before or the last one failed
➤ YN0007: │ electron@npm:7.3.3 must be built because it never has been before or the last one failed
➤ YN0007: │ core-js@npm:2.6.12 must be built because it never has been before or the last one failed
➤ YN0007: │ deasync@npm:0.1.24 must be built because it never has been before or the last one failed
➤ YN0000: └ Completed in 25s 207ms
➤ YN0000: Done with warnings in 38s 222ms
```

### PNPM

Nice summary

```
 WARN  deprecated popper.js@1.16.1: You can find the new Popper v2 at @popperjs/core, this package is dedicated to the legacy v1rap-vue/2.21.2: 752 kB/8.09 MB
Downloading npm.pkg.github.com/@speareducation/header/3.1.0: 7.49 MB/7.49 MB, done
Downloading registry.npmjs.org/bootstrap-vue/2.21.2: 8.09 MB/8.09 MB, done
Downloading registry.npmjs.org/typescript/4.5.4: 11.3 MB/11.3 MB, done
Packages: +1577
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Packages are hard linked from the content-addressable store to the virtual store.
  Content-addressable store is at: /home/user/.pnpm-store/v3
  Virtual store is at:             node_modules/.pnpm
Progress: resolved 1577, reused 0, downloaded 1575, added 1577, done
node_modules/.pnpm/core-js@2.6.12/node_modules/core-js: Running postinstall script, done in 72msmodules/.pnpm/core-js@3.20.0/node_modules/core-js: Running postinstall script...
node_modules/.pnpm/deasync@0.1.24/node_modules/deasync: Running install script...
node_modules/.pnpm/core-js@3.20.0/node_modules/core-js: Running postinstall script, done innode_modules/.pnpm/deasync@0.1.24/node_modules/deasync: Running install script, done in 202node_modules/.pnpm/bootstrap-vue@2.21.2_vue@2.6.14/node_modules/bootstrap-vue: Running postnode_modules/.pnpm/bootstrap-vue@2.21.2/node_modules/bootstrap-vue: Running postinstall script, done in 267ms
node_modules/.pnpm/puppeteer@10.4.0/node_modules/puppeteer: Running install script...
node_modules/.pnpm/puppeteer@10.4.0/node_modules/puppeteer: Running install script, done in 7.9s
node_modules/.pnpm/nuxt@2.15.8/node_modules/nuxt: Running postinstall script, done in 235ms

dependencies:
+ @nuxtjs/axios 5.13.6
+ @speareducation/footer 2.3.5
+ @speareducation/header 3.1.0
+ @speareducation/util 2.10.2
+ autosize 4.0.4 (5.0.1 is available)
+ bootstrap 4.6.1 (5.1.3 is available)
+ bootstrap-vue 2.21.2
+ core-js 3.20.0
+ fuse.js 3.6.1 (6.5.0 is available)
+ jpeg-autorotate 5.0.3 (8.0.0 is available)
+ js-cookie 3.0.1
+ jwt-decode 3.1.2
+ moment-timezone 0.5.34
+ nuxt 2.15.8
+ popper.js 1.16.1 deprecated
+ vue-browser-detect-plugin 0.1.18
+ vue-draggable-resizable 2.3.0
+ vue-instantsearch 1.7.0 (4.3.0 is available)
+ vue-js-modal 1.3.35 (2.0.1 is available)
+ vue-notification 1.3.20
+ vue-slider-component 3.2.15
+ vue-swatches 1.0.4 (2.1.1 is available)
+ vuedraggable 2.24.3

devDependencies:
+ @babel/core 7.16.5
+ @babel/eslint-parser 7.16.5
+ @nuxtjs/eslint-module 3.0.2
+ @nuxtjs/style-resources 1.2.1
+ @speareducation/eslint-config 2.1.0
+ @vue/devtools 5.3.4
+ @vue/test-utils 1.3.0
+ babel-core 7.0.0-bridge.0
+ babel-jest 27.4.5
+ babel-loader 8.2.3
+ css-loader 4.3.0 (6.5.1 is available)
+ eslint 7.32.0 (8.5.0 is available)
+ jest 27.4.5
+ prettier 2.5.1
+ sass 1.45.1
+ sass-loader 10.2.0 (12.4.0 is available)
+ vue-jest 3.0.7
+ vue-loader 15.9.8
+ webpack 4.46.0 (5.65.0 is available)

 WARN  Issues with peer dependencies found
.
├─┬ @vue/test-utils
│ ├── ✕ missing peer vue@2.x
│ └── ✕ missing peer vue-template-compiler@^2.x
├─┬ vue-jest
│ ├── ✕ missing peer vue@^2.x
│ └── ✕ missing peer vue-template-compiler@^2.x
├─┬ bootstrap-vue
│ └─┬ portal-vue
│   └── ✕ missing peer vue@^2.5.18
├─┬ vue-instantsearch
│ └── ✕ missing peer vue@^2.2.2
├─┬ vue-js-modal
│ └── ✕ missing peer vue@^2.2.6
├─┬ vue-notification
│ └── ✕ missing peer vue@^2.0.0
├─┬ vue-slider-component
│ └─┬ vue-property-decorator
│   ├── ✕ missing peer vue@"*"
│   └─┬ vue-class-component
│     └── ✕ missing peer vue@^2.0.0
├─┬ vue-loader
│ └── ✕ missing peer vue-template-compiler@"*"
├─┬ @speareducation/footer
│ └─┬ bootstrap-vue
│   └─┬ bootstrap
│     └── ✕ missing peer jquery@"1.9.1 - 3"
└─┬ nuxt
  └─┬ @nuxt/components
    └── ✕ missing peer consola@"*"
Peer dependencies that should be installed:
  consola@"*"                             vue-template-compiler@">=2.0.0 <3.0.0"
  jquery@"1.9.1 - 3"                      vue@">=2.5.18 <3.0.0"
```

