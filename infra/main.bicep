targetScope = 'subscription'

@allowed([
  'canadaeast'
  'eastus2'
])
@description('The location of the resources')
param location string

@description('The name of the resource group')
@minLength(4)
@maxLength(20)
param resourceGroupName string

@description('The object ID of the user needed for the RBAC on the protected resources')
param userObjectId string

resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: location
}

var suffix = uniqueString(rg.id)

module aifoundry 'modules/aifoundry/foundry.bicep' = {
  scope: rg
  params: {
    location: location
    suffix: suffix
  }
}

module rbacFoundry 'modules/rbac/foundry.bicep' = {
  scope: rg
  params: {
    aiSearchResourceId: aifoundry.outputs.searchResourceId
    openAiSystemAssignedMIPrincipalId: aifoundry.outputs.openAiManagedIdentity
    openaiResourceId: aifoundry.outputs.openaiResourceId
    searchAiSystemAssignedMIPrincipalId: aifoundry.outputs.searchManagedIdentity
    storageResourceId: aifoundry.outputs.storageResourceId
  }
}

module rbacUser 'modules/rbac/user.bicep' = {
  scope: rg
  params: {
    aiSearchResourceId: aifoundry.outputs.searchResourceId
    openaiResourceId: aifoundry.outputs.openaiResourceId
    storageResourceId: aifoundry.outputs.storageResourceId
    userObjectId: userObjectId
  }
}
