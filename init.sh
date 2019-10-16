#!/bin/bash
set -eo pipefail

. commons.sh

# See the following references:
# - https://github.com/kylemanna/docker-openvpn/blob/master/README.md
# - https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md
# - https://github.com/kylemanna/docker-openvpn/blob/master/docs/otp.md
# - https://github.com/kylemanna/docker-openvpn/blob/master/docs/paranoid.md#crypto-hardening
# - https://wiki.archlinux.org/index.php/OpenVPN#Hardening_the_server

echo -e "\n\n### Creating server configuration ..."

# -u  Server protocol, external host name and port
# -2  Enable two factor authentication using Google Authenticator
# -C  Encrypt packets with the given cipher algorithm instead of the default one (cipher)
# -a  Authenticate packets with HMAC using the given message digest algorithm (auth)
# -T  A list of allowable TLS ciphers delimited by a colon (tls-cipher)
docker-compose run --rm openvpn \
	ovpn_genconfig \
	-u "$SERVER_URL" \
	-2 \
	-C 'AES-256-GCM' \
	-a 'SHA512' \
	-T 'TLS-DHE-RSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-128-GCM-SHA256:TLS-DHE-RSA-WITH-AES-256-CBC-SHA:TLS-DHE-RSA-WITH-CAMELLIA-256-CBC-SHA:TLS-DHE-RSA-WITH-AES-128-CBC-SHA:TLS-DHE-RSA-WITH-CAMELLIA-128-CBC-SHA' \
	-e 'tls-version-min 1.2'

echo -e "\n\n### Creating PKI environment ..."

docker-compose run --rm openvpn \
	ovpn_initpki

echo -e "\n\n### Finished successfully"
