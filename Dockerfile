FROM ubuntu:16.04

RUN apt update -y && apt install -y vpnc

CMD ["/etc/service/vpnc/run"]

# Enable NAT, firewall rules

RUN sysctl net.ipv4.ip_forward

RUN iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
RUN iptables -A FORWARD -i ens192 -o tun0 -j ACCEPT
RUN iptables -A FORWARD -i ens192 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Setup vpnc service
RUN mkdir -p /etc/service/vpnc
COPY bin/vpnc.sh /etc/service/vpnc/run

# Clean up
RUN apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

