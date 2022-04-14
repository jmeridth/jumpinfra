# WireGuard Access

Install [Wireguard](https://www.wireguard.com/install/) (MacOS users should also `brew install wireguard-tools`)

1. Generate WireGuard Key on your workstation
2. Add your public key to this repo under `wireguard/pubkeys/` and create a PR, assigned to a member of devops
3. A member of devops will send the config file to connect with the server
4. Paste your private key into the config file for the server (will mark the spot for it)
5. In WireGuard - “Import Tunnel(s) from File”
6. Select the config file
7. Once connected go to http://10.10.21.195/admin/login to access the Admin area

# Generating Keys Locally

```
wg genkey > my-workstation.key
wg pubkey < my-workstation.key > my-workstation.pub
```
