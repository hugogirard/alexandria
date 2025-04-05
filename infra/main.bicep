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

@description('The name of the project to create')
param projectName string

resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: location
}

var suffix = uniqueString(rg.id)

module hub 'modules/aifoundry/foundry.bicep' = {
  scope: rg
  params: {
    location: location
    suffix: suffix
  }
}

module project 'modules/aifoundry/project.bicep' = {
  scope: rg
  params: {
    location: location
    hubResourceId: hub.outputs.hubResourceId
    projectName: projectName
  }
}

module rbacFoundry 'modules/rbac/foundry.bicep' = {
  scope: rg
  params: {
    aiSearchResourceId: hub.outputs.searchResourceId
    openAiSystemAssignedMIPrincipalId: hub.outputs.openAiManagedIdentity
    openaiResourceId: hub.outputs.openaiResourceId
    searchAiSystemAssignedMIPrincipalId: hub.outputs.searchManagedIdentity
    storageResourceId: hub.outputs.storageResourceId
  }
}

module rbacUser 'modules/rbac/user.bicep' = {
  scope: rg
  params: {
    aiSearchResourceId: hub.outputs.searchResourceId
    openaiResourceId: hub.outputs.openaiResourceId
    storageResourceId: hub.outputs.storageResourceId
    userObjectId: userObjectId
  }
}
