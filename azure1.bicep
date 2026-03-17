@description('Name of the PostgreSQL Flexible Server')
param serverName string

@description('Location for the server')
param location string = resourceGroup().location

@description('Administrator username')
param adminUser string

@secure()
@description('Administrator password')
param adminPassword string

@description('PostgreSQL version')
param postgresVersion string = '14'

@description('Storage size in GB')
param storageSizeGB int = 32

@description('Backup retention days')
param backupRetentionDays int = 7

resource postgresServer 'Microsoft.DBforPostgreSQL/flexibleServers@2023-06-01-preview' = {
  name: serverName
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
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
  }
}

output serverName string = postgresServer.name
output serverLocation string = postgresServer.location