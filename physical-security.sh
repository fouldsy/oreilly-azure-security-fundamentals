#!/bin/bash

# This script sample is released under the MIT license. For more information,
# see https://github.com/fouldsy/oreilly-azure-security-fundamentals/blob/master/LICENSE

# Create a public IP address and VPN gateway
# It will take 30-40 mins for the VPN gateway to be created, so --no-wait is
# used to return control the CLI prompt right away.

# PROVIDE YOUR OWN UNIQUE --dns-name
az network public-ip create \
    --resource-group oreilly-security-essentials \
    --name ip-vpn-gateway-centralus \
    --dns-name vpngatewaycentralus

az network vnet-gateway create \
    --resource-group oreilly-security-essentials \
    --name gateway-centralus \
    --vnet vnet-centralus \
    --public-ip-addresses ip-vpn-gateway-centralus \
    --no-wait

# PROVIDE YOUR OWN UNIQUE --dns-name
az network public-ip create \
    --resource-group oreilly-security-essentials \
    --name ip-vpn-gateway-northeurope \
    --location northeurope \
    --dns-name vpngatewaynortheurope

az network vnet-gateway create \
    --resource-group oreilly-security-essentials \
    --name gateway-northeurope \
    --location northeurope \
    --vnet vnet-northeurope \
    --public-ip-addresses ip-vpn-gateway-northeurope \
    --no-wait

# Create and configure an Azure firewall
az extension add --name azure-firewall

az network firewall create \
    --resource-group oreilly-security-essentials \
    --name firewall-centralus

az network public-ip create \
    --resource-group oreilly-security-essentials \
    --name ip-firewall \
    --sku Standard

az network firewall ip-config create \
    --resource-group oreilly-security-essentials \
    --name firewall-ip-config \
    --vnet-name vnet-centralus \
    --firewall-name firewall-centralus \
    --public-ip-address ip-firewall

# Create an Azure Storage account for encrupted blob data and HTTPS
# PROVIDE YOUR OWN UNIQUE STORAGE ACCOUNT NAME
az storage account create \
    --resource-group oreilly-security-essentials \
    --name storagecentralus \
    --encryption-services blob \
    --https-only true \
    --sku Standard_LRS
