# Nextcloud AIO Setup for Self-Hosting on a Private Server

This guide explains how to self-host a Nextcloud All-in-One (AIO) instance using DuckDNS as the dynamic DNS provider and Caddy as the reverse proxy for your nextcloud instance.

Make sure to open **TCP port 443** on your server to make it reachable.  
This port will be used to establish a TLS connection when accessing your Nextcloud instance via `https://your-nextcloud-domain`.  
A reachable port 443 is required to ensure a secure HTTPS connection between the client and your Nextcloud server.

## 1. Add a Dynamic DNS Record on [www.duckdns.org](https://www.duckdns.org)

- Create an account on [DuckDNS](https://www.duckdns.org) if you haven't already.
- Add a dynamic DNS record that points your domain to your server’s public IP address.

Example:  
```
your-domain.duckdns.org → your server's public IP
```

**Note:**  
DNS propagation may take some time after updating the record.

## 2. Update the Caddy Environment Variables

Edit the file `/etc/caddy/env` and set the following variables accordingly:

```
DOMAIN=your-domain.duckdns.org
DUCKDNS_TOKEN=your_duckdns_token
```

**Note:**  
You can find your `DUCKDNS_TOKEN` on your DuckDNS dashboard after logging in.

Then, create the following systemd configuration override to load these environment variables when starting Caddy:

```bash
sudo mkdir -p /etc/systemd/system/caddy.service.d/
sudo nano /etc/systemd/system/caddy.service.d/envfile.conf
```

Paste the following content inside `envfile.conf`:

```
[Service]
EnvironmentFile=/etc/caddy/env
```

This tells systemd to load the environment variables from `/etc/caddy/env` into the environment where the Caddy process runs, allowing the `Caddyfile` to use the defined variables.

## 3. Start the Nextcloud Instance

To start the instance, simply run:

```bash
sudo bash start_nextcloud_instance.sh
```

This will pull the docker images and start the containers.
Once the containers are running, open your web browser and navigate to:

```bash
https://your-server-public-ip:8080
```

You will be guided through the initial setup via the Nextcloud AIO web interface.

During the setup :

1. You will be asked to enter the domain you registered with DuckDNS (e.g., your-nextcloud-domain.duckdns.org).

2. The Nextcloud mastercontainer will attempt to reach your domain via HTTPS to validate it.

3. Meanwhile, the reverse proxy (Caddy) will automatically request a valid SSL certificate from Let's Encrypt for your domain and serve it to incoming HTTPS requests.

Important: Make sure that TCP port 443 is open and accessible from the Internet; otherwise, domain validation and certificate issuance will fail and you won't be able to go to the next step of the setup.

# Useful Commands

## Update the Caddy Configuration

After editing `/etc/caddy/Caddyfile`, run:

```bash
sudo bash update_caddy.sh
```

Then restart the Caddy service (if running under systemd):

```bash
sudo systemctl restart caddy
```

## View Caddy Logs Continuously

To view Caddy logs in real-time:

```bash
sudo journalctl -f -u caddy
```

