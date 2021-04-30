#!/bin/bash
set -eo pipefail

# See the following references:
# - https://github.com/kylemanna/docker-openvpn/blob/master/README.md
# - https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md
# - https://github.com/kylemanna/docker-openvpn/blob/master/docs/clients.md

usage(){
	if [ $# -gt 0 ]; then
		echo -e "$*\n"
	fi
	echo "Usage: $(basename $0) <client-name> [<openvpn ovpn_revokeclient options>]" >&2
	echo "" >&2
	echo "Example: $(basename $0) klausk remove" >&2
	exit 64
}

if [ $# -lt 1 ]; then
	usage "Too few arguments given"
fi

export CLIENTNAME="${1:-client1}"
shift


. commons.sh


echo -e "\n\n### Revoking client keys ..."

docker-compose run --rm openvpn \
	ovpn_revokeclient "$CLIENTNAME" "$@"

echo -e "\n\n### Finished successfully"
