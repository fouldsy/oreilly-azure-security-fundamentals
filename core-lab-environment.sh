#!/bin/bash

# This script sample is released under the MIT license. For more information,
# see https://github.com/fouldsy/oreilly-azure-security-fundamentals/blob/master/LICENSE

# Create a resource group
az group create --name oreilly-security-essentials --location centralus

# Create a virtual network and subnet
# Three virtual networks are created, with Central US as the primary region
# A number of subnets are created for VPN gateways, Azure Firewall, and Azure AD Domain Services
az network vnet create \
    --resource-group oreilly-security-essentials \
    --name vnet-centralus \
    --address-prefix 10.10.0.0/20 \
    --subnet-name frontend-subnet \
    --subnet-prefix 10.10.1.0/24

az network vnet subnet create \
    --resource-group oreilly-security-essentials \
    --vnet-name vnet-centralus \
    --name backend-subnet \
    --address-prefixes 10.10.2.0/24

az network vnet subnet create \
    --resource-group oreilly-security-essentials \
    --vnet-name vnet-centralus \
    --name GatewaySubnet \
    --address-prefixes 10.10.3.0/24

az network vnet subnet create \
    --resource-group oreilly-security-essentials \
    --vnet-name vnet-centralus \
    --name AzureFirewallSubnet \
    --address-prefixes 10.10.4.0/24

az network vnet subnet create \
    --resource-group oreilly-security-essentials \
    --vnet-name vnet-centralus \
    --name DomainServices \
    --address-prefixes 10.10.5.0/24

az network vnet create \
    --resource-group oreilly-security-essentials \
    --name vnet-westus \
    --location westus \
    --address-prefix 10.20.0.0/20 \
    --subnet-name apps-subnet \
    --subnet-prefix 10.20.1.0/24

az network vnet subnet create \
    --resource-group oreilly-security-essentials \
    --vnet-name vnet-westus \
    --name AzureBastionSubnet \
    --address-prefixes 10.20.2.0/24

az network vnet create \
    --resource-group oreilly-security-essentials \
    --name vnet-eastus \
    --location eastus \
    --address-prefix 10.30.0.0/20 \
    --subnet-name apps-subnet \
    --subnet-prefix 10.30.1.0/24

az network vnet create \
    --resource-group oreilly-security-essentials \
    --name vnet-northeurope \
    --location northeurope \
    --address-prefix 10.30.0.0/20 \
    --subnet-name apps-subnet \
    --subnet-prefix 10.30.1.0/24
    
az network vnet subnet create \
    --resource-group oreilly-security-essentials \
    --vnet-name vnet-northeurope \
    --name GatewaySubnet \
    --address-prefixes 10.30.2.0/24

# Create virtual network peerings
# Just to create a multi-region deployment, peer the virtual networks
az network vnet peering create \
    --resource-group oreilly-security-essentials \
    --name centralus-eastus \
    --vnet-name vnet-centralus \
    --remote-vnet vnet-eastus \
    --allow-vnet-access \
    --allow-gateway-transit

az network vnet peering create \
    --resource-group oreilly-security-essentials \
    --name centralus-westus \
    --vnet-name vnet-centralus \
    --remote-vnet vnet-westus \
    --allow-vnet-access \
    --allow-gateway-transit

az network vnet peering create \
    --resource-group oreilly-security-essentials \
    --name eastus-centraluis \
    --vnet-name vnet-eastus \
    --remote-vnet vnet-centralus \
    --allow-vnet-access

az network vnet peering create \
    --resource-group oreilly-security-essentials \
    --name westus-centralus \
    --vnet-name vnet-westus \
    --remote-vnet vnet-centralus \
    --allow-vnet-access

# Create a network security group and ssociate with Central US frontend subnet
# No rules are created here, just the basic subnet association
az network nsg create \
    --resource-group oreilly-security-essentials \
    --name centralus-frontend

az network vnet subnet update \
    --resource-group oreilly-security-essentials \
    --vnet-name vnet-centralus \
    --name frontend-subnet \
    --network-security-group centralus-frontend

# Create an application security group
az network asg create \
    --resource-group oreilly-security-essentials \
    --name webservers

# Create basic Windows VMs
# Provide your own secure password when prompted
# As it takes a few minutes to create the VM, return control to the CLI
az vm create \
    --resource-group oreilly-security-essentials \
    --name windows-web \
    --image Win2019Datacenter \
    --size Standard_B1ms \
    --admin-username oreillyuser \
    --vnet-name vnet-centralus \
    --subnet frontend-subnet \
    --nsg "" \
    --no-wait

az vm create \
    --resource-group oreilly-security-essentials \
    --name ad-ds \
    --location westus \
    --image Win2019Datacenter \
    --size Standard_B1ms \
    --admin-username oreillyuser \
    --vnet-name vnet-westus \
    --subnet apps-subnet \
    --nsg "" \
    --no-wait

az vm create \
    --resource-group oreilly-security-essentials \
    --name aad-ds-mgmt \
    --location westus \
    --image Win2019Datacenter \
    --size Standard_B1ms \
    --admin-username oreillyuser \
    --vnet-name vnet-westus \
    --subnet apps-subnet \
    --nsg "" \
    --no-wait

# Create a basic Linux VM
# SSH key pair is generated or default pair from ~/.ssh used if already exists
# As it takes a few minutes to create the VM, return control to the CLI
az vm create \
    --resource-group oreilly-security-essentials \
    --name linux-web \
    --image ubuntults \
    --size Standard_B2ms \
    --admin-username oreillyuser \
    --vnet-name vnet-centralus \
    --subnet frontend-subnet \
    --nsg "" \
    --generate-ssh-keys \
    --no-wait