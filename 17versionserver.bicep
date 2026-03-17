targetScope = 'resourceGroup'

@description('Name of the PostgreSQL Flexible Server')
param serverName string

@description('Location for the server')
param location string = resourceGroup().location

@description('Administrator username')
param adminUser string

@secure()
@description('Administrator password')
param adminPassword string

@description('PostgreSQL version (set to 17). Note: deployment will fail if PG 17 is not supported in the selected region/API yet.')
param postgresVersion string = '17'

@description('Compute SKU name')
param skuName string = 'Standard_B1ms'

@description('Compute tier')
@allowed([
  'Burstable'
  'GeneralPurpose'
  'MemoryOptimized'
])
param skuTier string = 'Burstable'

@description('Storage size in GB')
param storageSizeGB int = 32

@description('Backup retention days')
param backupRetentionDays int = 7

@description('Enable public network access')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Create a firewall rule that allows Azure services to access this server (0.0.0.0). Only applies when publicNetworkAccess=Enabled.')
param allowAzureServices bool = true

resource postgresServer 'Microsoft.DBforPostgreSQL/flexibleServers@2023-06-01-preview' = {
  name: serverName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    createMode: 'Default'
    version: postgresVersion
    administratorLogin: adminUser
    administratorLoginPassword: adminPassword

    storage: {
      storageSizeGB: storageSizeGB
    }

    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: 'Disabled'
    }

    highAvailability: {
      mode: 'Disabled'
    }

    network: {
      publicNetworkAccess: publicNetworkAccess
    }
  }
}

resource allowAzureFirewallRule 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2023-06-01-preview' = if (publicNetworkAccess == 'Enabled' && allowAzureServices) {
  name: '${postgresServer.name}/AllowAzureServices'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

output serverName string = postgresServer.name
output serverLocation string = postgresServer.location
output serverFqdn string = postgresServer.properties.fullyQualifiedDomainName
output postgresVersionDeployed string = postgresServer.properties.version