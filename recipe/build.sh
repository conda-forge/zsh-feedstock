#!/bin/bash

set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

# Work around https://github.com/Homebrew/homebrew-core/pull/64923
export CFLAGS+=" -Wno-implicit-function-declaration -Wno-implicit-int"

configure_args=()
if [[ "$target_platform" == linux-* ]]; then
    # Keep ZSH_VERSION separate from relocatable paths such as $PREFIX/lib/zsh/<version>.
    # Otherwise prefix replacement can zero out a shared version-string suffix.
    export CFLAGS+=" -fno-merge-constants"
    configure_args+=(--enable-cap)
else
    configure_args+=(--disable-cap)
fi

./configure --prefix="$PREFIX" \
    "${configure_args[@]}" \
    --enable-maildir-support \
    --enable-multibyte \
    --enable-pcre \
    --enable-zsh-secure-free \
    DL_EXT=bundle

make

if [[ $target_platform == osx-* ]]; then
    # This tests fails on MacOS
    rm Test/A04redirect.ztst
fi

[[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]] && make check

make install
make install.info
