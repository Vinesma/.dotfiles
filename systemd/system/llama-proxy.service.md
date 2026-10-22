# Pi Docker → local llama.cpp connection

This setup keeps `llama-server` listening on `127.0.0.1:9931`. A host-side
`socat` proxy listens on the Docker bridge address at port `9932` and forwards
connections to llama-server.

## Requirements

Install `socat`:

```bash
sudo pacman -S socat
```

## Find the Docker bridge address

Run:

```bash
ip -4 addr show docker0
```

Find the `inet` address, for example `172.17.0.1/16`. Use just the IP part
(`172.17.0.1`) in the systemd unit below. If Docker uses a different address,
use that instead.

## Install the systemd unit

Replace `172.17.0.1` in the `llama-proxy.service` file with the address from `docker0`:

Move it to:

```text
/etc/systemd/system/llama-proxy.service
```

Custom systemd unit files belong in `/etc/systemd/system/`. <citation src="1"></citation>

Load and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now llama-proxy.service
```

Check it with:

```bash
systemctl status llama-proxy.service
```

## Use it from Pi in Docker

Include this in the Docker command:

```bash
--add-host=host.docker.internal:host-gateway
```

In Pi’s llama.cpp login, use:

```text
http://host.docker.internal:9932
```

## Notes

- llama-server stays on `127.0.0.1:9931`; the proxy forwards Docker connections
  to it.
- The proxy listens only on the Docker bridge IP, not on every host interface.
  Containers on that bridge can connect to the proxy.
- If the `docker0` IP changes, update the `bind=` address in the unit, then run
  `sudo systemctl daemon-reload` and `sudo systemctl restart llama-proxy.service`.
