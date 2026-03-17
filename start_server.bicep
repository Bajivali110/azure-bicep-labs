param serverName string = 'bajiserver0'
param location string = 'westus'
param administratorLogin string = 'saadmin'

@secure()
param administratorLoginPassword string

resource postgresServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: serverName
  location: location
  sku: {
    name: 'Standard_D4ads_v5'
    tier: 'GeneralPurpose'
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '17'
    storage: {
      storageSizeGB: 128
    }
    state: 'Ready'
  }
}