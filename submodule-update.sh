#!/bin/bash -ev

set -ev

. ./setenv.sh

rm -rf libsodium

git submodule init
git submodule sync
#git submodule update --remote --merge
git submodule update

pushd libsodium

git fetch && git checkout 1.0.13

NEW_TEXT="export LDFLAGS=\"-Wl,-z,max-page-size=16384\""
FILES=("dist-build/android-armv7-a.sh" "dist-build/android-armv8-a.sh" "dist-build/android-x86.sh" "dist-build/android-x86_64.sh")

for file in "${FILES[@]}"; do
  # Use -i.bak for systems like macOS to create a backup, or -i '' to avoid backup
  sed -i "4i $NEW_TEXT" "$file"
  echo "Inserted text into $file"
done

git commit -am "add support for Android 16KB page size (port change from https://github.com/jedisct1/libsodium/pull/1407)"

popd
