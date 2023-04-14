#!/usr/bin/env sh

# SSHs to destination and runs a script on it

set -e

PORT=22
USAGE="Usage: $0 [-p PORT] DEST SCRIPT [SCRIPTARGS]... | -h"

main() {
	# TODO: make this part nicer?
	DESTINATION=$1
	SCRIPT=$2
	shift 2 || err_msg "$USAGE"

	printf "Trying to SSH to %s:%s and run %s:\n\n" "$DESTINATION" "$PORT" "$SCRIPT"
	ssh -p "$PORT" "$DESTINATION" "sh -s" -- < "$SCRIPT" "$@"
}

check_opts() {
	while getopts ":p:h" opt; do
		case "${opt}" in
			p)
				PORT=${OPTARG} ;;
			h)
				printf "%s\n" "$USAGE" && exit ;;
			*)
				err_msg "$USAGE" ;;
		esac
	done
	shift $((OPTIND-1))

	main "$@"
}

err_msg() {
    printf "%s\n" "$1" >&2
    exit 1
}

check_opts "$@"

