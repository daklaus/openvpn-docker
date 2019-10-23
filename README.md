# OpenVPN docker-compose project

This is a docker-compose project using [kylemanna's docker-openvpn image](https://github.com/kylemanna/docker-openvpn) to create an OpenVPN server with two factor authentication from scratch.

## Usage

1. Change the hostname and port in [`commons.sh`](commons.sh) to the DNS name/IP address and port at which your VPN server will be reachable from your clients.
2. Run the [`init.sh`](init.sh) script to configure the server.
3. Run [`init-client.sh -2 <client-name>`](init-client.sh) to configure each client user (the `-2` is for 2FA).
4. You will get a *.ovpn profile file for each client in the base directory of this project. Use this and the Google Authenticator QR code link/secret you got during the execution of the client config script to configure the client's program (e.g. OpenVPN Connect) and Google Authenticator app.

## Docu

- See the help messages of the [`init-client.sh`](init-client.sh) script.
- If you're interested, have a look at the [docker-compose.yml](docker-compose.yml).
- Have a look at [the original project by kylemanna](https://github.com/kylemanna/docker-openvpn), especially the [docs](https://github.com/kylemanna/docker-openvpn/tree/master/docs) directory for advanced configurations.
