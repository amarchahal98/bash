#!/bin/bash
# ------------- SOURCED VARIABLES LIST ---------------#
# Student ID
declare sid='1'

# Network Interfaces
declare ext_if='eth0'
declare local_if='eth1'
declare wifi_if='wlp0s11u2'

declare ext_cidr='24'
declare local_cidr='25'
declare wifi_cidr='25'

declare ext_sub='255.255.255.0'
declare local_sub='255.255.255.128'
declare wifi_sub='255.255.255.128'

declare wifi_channel='11'
declare wifi_mode='Master'
declare wifi_type='Wireless'
