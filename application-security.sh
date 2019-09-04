#!/bin/bash

# This script sample is released under the MIT license. For more information,
# see https://github.com/fouldsy/oreilly-azure-security-fundamentals/blob/master/LICENSE

# Create an Azure Key Vault
# This vault is enabled for use during deployments and for disk encryption
# Soft delete or secrets and purge protection is also enabled
# PROVIDE YOUR OWN UNIQUE KEY VAULT NAME
az keyvault create \
    --resource-group oreilly-security-essentials \
    --name key-vault-centralus \
    --enable-purge-protection true \
    --enable-soft-delete true \
    --enabled-for-deployment true \
    --enabled-for-disk-encryption true \
    --enabled-for-template-deployment true

# Create an Azure identity
az identity create \
    --resource-group oreilly-security-essentials \
    --name identity-sql

# Create a SQL Server
# As it takes a few minutes to create the SQL server, return control to the CLI
# PROVIDE YOUR OWN SECURE --admin-password
az sql server create  \
    --resource-group oreilly-security-essentials \
    --name sql-centralus \
    --admin-user oreillyuser \
    --admin-password P@ssw0rdP@ssw0rd \
    --assign-identity \
    --no-wait

# Create a Cosmos DB instance
# As it takes a few minutes to create the Cosmos DB intance, return control to the CLI
# PROVIDE YOUR OWN UNIQUE COSMOS DB NAME
az cosmosdb create \
    --resource-group oreilly-security-essentials \
    --name cosmosdb-oreilly \
    --kind mongodb \
    --enable-virtual-network true

# Create a Recovery Services vault for Backup and Site Recovery
# PROVIDE YOUR OWN UNIQUE RECOVERY SERVICES VAULT NAME
az backup vault create \
    --resource-group oreilly-security-essentials \
    --name recoveryvault-centralus \
    --location centralus
