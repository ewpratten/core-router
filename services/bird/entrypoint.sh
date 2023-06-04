#! /bin/bash
# Core router BIRD entrypoint script
set -ex

# Load env vars into /usr/local/etc/envvars.conf
cat > /usr/local/etc/envvars.conf <<EOF
router id ${BIRD_ROUTER_ID};

define OWNAS=${BIRD_ROUTER_ASN};
define VULTR_SESSION_PASS="${VULTR_SESSION_PASS}";
EOF

# Run BIRD
exec /usr/local/sbin/bird -f -c /usr/local/etc/bird.conf