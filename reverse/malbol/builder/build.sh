#!/bin/bash

cp ../malbol.cob ./
docker rm malbol-builder
docker build -t malbol-builder .
docker run --name malbol-builder malbol-builder &
docker cp malbol-builder://src/malbol ../files/malbol
docker stop malbol-builder
rm malbol.cob
