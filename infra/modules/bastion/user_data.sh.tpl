#!/bin/bash
set -euxo pipefail

# Instalar iptables (AL2023 no lo trae por defecto, usa nftables)
dnf install -y iptables

# Habilitar IP forwarding
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# MASQUERADE para que las subredes privadas salgan a Internet a través de esta instancia
INTERFACE=$(ip -o -4 route show to default | awk '{print $5}')
iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
iptables -F FORWARD
iptables -P FORWARD ACCEPT

# Persistir las reglas de iptables tras reinicios
mkdir -p /etc/iptables
iptables-save > /etc/iptables/rules.v4

# Agente de CloudWatch
dnf install -y amazon-cloudwatch-agent