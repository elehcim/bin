#!/bin/bash
pushd ~
mkdir -p bin
cd bin
git clone https://github.com/madler/pigz.git pigz.src
cd pigz.src
make
cd ..
ln -s pigz.src/pigz pigz.src/unpigz .
popd 
