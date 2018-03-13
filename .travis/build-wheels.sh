#!/usr/bin/env bash

set -e -x

PYTHON_VERSION=py37

curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

# Compile wheel
PYBIN="/opt/python/cp37-cp37m/bin"
"${PYBIN}/pip" wheel /io/ -w wheels/
rm -rf /io/build /io/*.egg-info

# Bundle external shared libraries into the wheels
for whl in wheels/sourmash*.whl; do
    auditwheel show "$whl"
    auditwheel repair "$whl" -w /io/dist/
done
