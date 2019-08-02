#!/bin/bash

# This script sample is released under the MIT license. For more information,
# see https://github.com/fouldsy/oreilly-azure-security-fundamentals/blob/master/LICENSE

# Create a public IP address and VPN gateway
# It will take 30-40 mins for the VPN gateway to be created, so --no-wait is
# used to return control the CLI prompt right away.
az network public-ip create \
    --resource-group oreilly-security-essentials \
    --name ip-vpn-gateway \
    --dns-name vpngatewayikf

az network vnet-gateway create \
    --resource-group oreilly-security-essentials \
    --name centralus-gateway \
    --vnet vnet-centralus \
    --public-ip-addresses ip-vpn-gateway \
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
# You need to provide your own unique storage account name
az storage account create \
    --resource-group oreilly-security-essentials \
    --name storage-centralus \
    --encryption-services blob \
    --https-only true \
    --sku Standard_LRS