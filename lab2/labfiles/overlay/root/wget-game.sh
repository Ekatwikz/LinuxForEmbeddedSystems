#!/usr/bin/env sh

set -e

# script for faster testing, BR package installs anyway
main () {
	rm -fv ./led-memory-game
	wget http://spages.mini.pw.edu.pl/~katwikirizee/LinES/led-memory-game
	chmod +x ./led-memory-game
	./led-memory-game
}

main "$@"

