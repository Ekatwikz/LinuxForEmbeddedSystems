#!/usr/bin/env sh

SSHPORT=22
HTTPPORT=8000
USAGE="Usage: $0 [-p SSHPORT] [-q HTTPPORT] SSHDEST HTTPSERVERHOSTNAME [FILES]... | -h"
SCRIPTDIR="$(realpath $(dirname "$0"))"
BRDIR="/malina/$USER/buildroot-2023.02"
MOUNTEDDOWNLOADDIR="user"

main() {
	SSHDEST=$1
	HTTPSERVERHOSTNAME=$2
	shift 2 || err_msg "$USAGE"

	# $? always 0??
	ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[${SSHDEST##*@}]:$SSHPORT" #|| err_msg "Coulnd't clear SSH key??"
	rm -v "$HOME/.ssh/known_hosts" # tmp ...

	# TODO: add -C ... opt
	#cd "$BRDIR/output/images" || err_msg "Couldn't find images folder??"

	echo
	printf "Files in %s:\n" "$(pwd)"
	ls -lah

	echo
	printf "Starting Python HTTP server\n"
	python3 -m http.server $HTTPPORT &
	SERVER_PID=$!

	kill_server() {
		echo
		printf "Killing HTTP server\n"
		kill -15 $SERVER_PID || err_msg "Couldn't kill server??"
	}

	err_kill_server() {
		kill_server
		err_msg "$1"
	}

	trap "err_kill_server 'Upload canceled'" INT QUIT TERM # Orphan process ??

	TODOWNLOAD="$@"
	[ $# -ne 0 ] || TODOWNLOAD="$(ls)"
	printf "Starting SSH script\n"

	$SCRIPTDIR/ssh-script.sh -p $SSHPORT "$SSHDEST" $SCRIPTDIR/download-to-mmcblk0p1.sh \
		$MOUNTEDDOWNLOADDIR "http://$HTTPSERVERHOSTNAME":$HTTPPORT ${TODOWNLOAD:+ $TODOWNLOAD} || err_kill_server "SSH script failed"
	kill_server
}

check_opts() {
	while getopts ":p:q:h" opt; do
		case "${opt}" in
			p)
				SSHPORT=${OPTARG} ;;
			q)
				HTTPPORT=${OPTARG} ;;
			h)
				printf "%s\n" "$USAGE" && exit ;;
			*)
				err_msg "$USAGE" ;;
		esac
	done
	shift $((OPTIND-1))

	( main "$@" ) # Subshell so cd and stuff doesn't go wild
}

err_msg() {
	printf "%s\n" "$1" >&2
	exit 1
}

check_opts "$@"

