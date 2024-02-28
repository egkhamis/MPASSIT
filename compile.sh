#!/bin/bash

rm -fr ./build
mkdir ./build && cd ./build

cmake .. ${CMAKE_FLAGS}

make -j 8 VERBOSE=1

cp mpassit ../run/

cd ..

