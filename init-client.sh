#!/bin/bash
set -eo pipefail

# See the following references:
# - https://github.com/kylemanna/docker-openvpn/blob/master/README.md
# - https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md
# - https://github.com/kylemanna/docker-openvpn/blob/master/docs/otp.md

CLIENT_DIR=clients

usage(){
	if [ $# -gt 0 ]; then
		echo -e "$*\n"
	fi
	echo "Usage: $(basename $0) [-2] <client-name> [<easyrsa build-client-full options>]" >&2
	echo "" >&2
	echo "  -2  Use two factor authentication using Google Authenticator" >&2
	echo "" >&2
	echo "Example: $(basename $0) -2 klausk" >&2
	exit 64
}

twofa=0
while getopts 2 OPT; do
	case "${OPT}" in
		2) twofa=1;;
	esac
done
shift $(( $OPTIND - 1 ))

if [ $# -lt 1 ]; then
	usage "Too few arguments given"
fi

export CLIENTNAME="${1:-client1}"
shift

nopass=
[ $twofa -eq 1 ] && nopass=nopass


. commons.sh


echo -e "\n\n### Creating client keys ..."

docker-compose run --rm openvpn \
	easyrsa build-client-full "$CLIENTNAME" $nopass "$@"

echo -e "\n\n### Generating client profile file ..."

docker-compose run --rm openvpn \
	ovpn_getclient "$CLIENTNAME" > "$CLIENT_DIR/$CLIENTNAME".ovpn

if [ $twofa -ne 1 ]; then
	echo -e "\n\n### Finished successfully"
	exit 0
fi

echo -e "\n\n### Generating two factor authentication configuration ..."

docker-compose run --rm openvpn \
	ovpn_otp_user "$CLIENTNAME"

echo -e "\n\n### Finished successfully"
