#!/bin/bash

set -ex

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

# Work around https://github.com/Homebrew/homebrew-core/pull/64923
export CFLAGS+=" -Wno-implicit-function-declaration -Wno-implicit-int"

./configure --prefix="$PREFIX" --with-tcsetpgrp --enable-pcre

cat config.log

make

[[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]] && make check

make install
