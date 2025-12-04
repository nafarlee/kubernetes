#!/usr/bin/env bash
set -euo pipefail
cluster_domain=$1
cluster_ip="$(dig +short "$cluster_domain")"
gpg -d secrets.yaml.gpg > secrets.yaml
talosctl gen config \
  --output-types=talosconfig \
  --with-secrets=secrets.yaml \
  "$cluster_domain" \
  "https://$cluster_ip"
talosctl --talosconfig=talosconfig config endpoint \
  "$cluster_ip"
talosctl --talosconfig=talosconfig config node \
  "$cluster_ip"
rm secrets.yaml
