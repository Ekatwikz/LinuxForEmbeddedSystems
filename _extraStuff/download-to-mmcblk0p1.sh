#!/usr/bin/env sh

# Downloads files from url to partition 1 of SD card,
# nice for uploading new Kernels to the Pi in the labs
# NB: Don't actually run this on the host! run my upload-images-to-pi script

set -e
MOUNTDEVICE=mmcblk0p1

USAGE="Usage: $0 DOWNLOADDIR BASEURL [FILES]... | -h"

main() {
	SDMMOUNTPATH="/mnt/$MOUNTDEVICE"
	DOWNLOADDIR="$1"
	BASEURL=$2 # TODO: "cleanup" url?
	shift 2 || err_msg "$USAGE"
	[ $# -ne 0 ] || err_msg "$USAGE"

	printf "Info:\n\
===\nUser: %s\n\
System: %s\n\
Mount Info:\n\
%s\n===\n" \
	"$(whoami)" "$(uname -a)" "$(mount)"

	echo
	printf "Making mount path and mounting SD\n"
	mkdir -pv $SDMMOUNTPATH
	mount -v "/dev/$MOUNTDEVICE" $SDMMOUNTPATH || true # TODO: fix this...
	cd "$SDMMOUNTPATH"/"$DOWNLOADDIR"

	echo
	printf "Files in %s:\n" "$(pwd)"
	ls -lah

	echo
	for DOWNLOADFILE in "$@"
	do
		printf "Trying to download %s/%s\n" "$BASEURL" "$DOWNLOADFILE"
		wget "$BASEURL"/"$DOWNLOADFILE" -O "$DOWNLOADFILE"
	done

	echo
	printf "Files in %s:\n" "$(pwd)"
	ls -lah

	echo
	printf "Done, synchronizing.\n"
	sync
	#printf "Rebooting.\n" #TMP! TODO: Add option to reboot.
	#reboot
}

check_opts() {
	while getopts ":h" opt; do
		case "${opt}" in
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

