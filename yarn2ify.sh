#!/usr/bin/env bash

if [[ ! -f ./package.json ]]; then
  echo "package.json not found"
  exit 1
fi

git create-branch GL-2096

export NVM_DIR=$HOME/.nvm;
source $NVM_DIR/nvm.sh;
echo "16" > ./.nvmrc
nvm use

yarn set version stable

cat <<EOF >> ./.yarnrc.yml
nodeLinker: node-modules
npmScopes:
  speareducation:
    npmRegistryServer: https://npm.pkg.github.com
    npmAlwaysAuth: true
EOF

if [[ $(fgrep -c "npm.fontawesome.com" .npmrc) -gt 0 ]]; then
cat <<EOF >> ./.yarnrc.yml
  fortawesome:
    npmRegistryServer: https://npm.fontawesome.com
    npmAlwaysAuth: true
    npmAuthToken: lolno
EOF
fi

cat <<EOF >> ./.gitignore

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
EOF

rimraf ./node_modules
rm ./yarn.lock
rm ./.npmrc

yarn install
yarn plugin import interactive-tools

git add --all
git commit -m "[GL-2096] Node 16 & Yarn 2"
