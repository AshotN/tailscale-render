#!/usr/bin/env bash

tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
PID=$!

until tailscale up --authkey="${TAILSCALE_AUTHKEY}" --hostname="${RENDER_SERVICE_NAME}"; do
  sleep 0.1
done
export ALL_PROXY=socks5://localhost:1055/
tailscale_ip=$(/render/tailscale ip)
echo "Tailscale is up at IP ${tailscale_ip}"

tailscale serve ${TAILSCALE_SERVE}

wait ${PID}
