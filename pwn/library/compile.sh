#!/bin/bash

cp library.c library-docker.c
sed -i -E 's/CSGAMES\{PLACEHOLDER_CSFLAG\}/CSGAMES\{CUR53D_L18R4RY_8R34CH3D\}/' library-docker.c
# This is for the docker (SHOULD contain the flag)
gcc -s -static -o server/library library-docker.c
# This is for the players (should NOT contain the flag)
gcc -s -static -o files/library library.c
rm library-docker.c
