param serverName string
param resourceGroupName string
param location string = resourceGroup().location

resource stopPostgresWorkflow 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'stop-postgres-945pm'
  location: location
  properties: {
    state: 'Enabled'
    definition: {
      "$schema": "https://schema.management.azure.com/schemas/2016-06-01/workflowdefinition.json#"
      "contentVersion": "1.0.0.0"
      "triggers": {
        "Recurrence": {
          "type": "Recurrence"
          "recurrence": {
            "frequency": "Day"
            "interval": 1
            "schedule": {
              "hours": [21]
              "minutes": [45]
            }
          }
        }
      }
      "actions": {
        "Stop_PostgreSQL_Server": {
          "type": "Http"
          "inputs": {
            "method": "POST"
            "uri": "https://management.azure.com/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.DBforPostgreSQL/flexibleServers/${serverName}/stop?api-version=2022-12-01"
          }
        }
      }
      "outputs": {}
    }
  }
}