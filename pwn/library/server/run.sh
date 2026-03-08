#!/bin/bash
docker rm csgames2026-pwn-library
docker build -t csgames2026-pwn-library .
docker run -p 12345:12345 --name csgames2026-pwn-library csgames2026-pwn-library
