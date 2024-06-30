#!/bin/bash

set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

# Work around https://github.com/Homebrew/homebrew-core/pull/64923
export CFLAGS+=" -Wno-implicit-function-declaration -Wno-implicit-int"

./configure --prefix="$PREFIX" \
    --enable-cap \
    --enable-maildir-support \
    --enable-multibyte \
    --enable-pcre \
    --enable-zsh-secure-free \
    --enable-etcdir=/etc \
    --with-tcsetpgrp \
    DL_EXT=bundle \


make

if [[ $target_platform == osx-* ]]; then
    # This tests fails on MacOS
    rm Test/A04redirect.ztst
fi

[[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]] && make check

make install
make install.info
