#!/bin/bash

# Run this script as root before crio.service starts

swapoff -a
modprobe br_netfilter
sysctl -w net.ipv4.ip_forward=1
