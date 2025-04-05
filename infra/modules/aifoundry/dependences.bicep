param location string
param suffix string

var tag = {
  description: 'AI Foundry'
}

module storage 'br/public:avm/res/storage/storage-account:0.18.2' = {
  name: 'storagefoundry'
  params: {
    name: 'strf${suffix}'
    location: location
    publicNetworkAccess: 'Enabled'
    tags: tag
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

module keyvault 'br/public:avm/res/key-vault/vault:0.12.1' = {
  name: 'keyvaultregistry'
  params: {
    name: 'vault-ai-${suffix}'
    location: location
    tags: tag
    publicNetworkAccess: 'Enabled'
    enableRbacAuthorization: true
    enablePurgeProtection: false
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.9.1' = {
  name: 'foundryregistry'
  params: {
    name: 'acrai${suffix}'
    location: location
    tags: tag
    publicNetworkAccess: 'Enabled'
    exportPolicyStatus: 'enabled'
    acrAdminUserEnabled: false
    zoneRedundancy: 'Disabled'
  }
}

module loganalytics 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'loganalyticsfoundry'
  params: {
    name: 'log-ai-${suffix}'
    location: location
    tags: tag
  }
}

module appinsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'appinsightsfoundry'
  params: {
    name: 'app-ai-${suffix}'
    workspaceResourceId: loganalytics.outputs.resourceId
    tags: tag
    location: location
  }
}

/* AI Services */
module openai 'br/public:avm/res/cognitive-services/account:0.10.1' = {
  params: {
    name: 'openai-${suffix}'
    kind: 'OpenAI'
    location: location
    publicNetworkAccess: 'Enabled'
    customSubDomainName: 'openai-${suffix}'
    managedIdentities: {
      systemAssigned: true
    }
  }
}
/* Search Services */
module search 'br/public:avm/res/search/search-service:0.7.2' = {
  params: {
    name: 'search-${suffix}'
    disableLocalAuth: true
    location: location
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: 'Enabled'
    partitionCount: 1
    replicaCount: 1
    sku: 'standard'
  }
}

output storageResourceId string = storage.outputs.resourceId
output storageResourceName string = storage.outputs.name
output keyvaultResourceId string = keyvault.outputs.resourceId
output containerRegistryResourceId string = containerRegistry.outputs.resourceId
output appInsightResourceId string = appinsights.outputs.resourceId
output openaiResourceId string = openai.outputs.resourceId
output openaiEndpoint string = openai.outputs.endpoint
output openAiManagedIdentity string = openai.outputs.systemAssignedMIPrincipalId!
output searchResourceName string = search.outputs.name
output searchResourceId string = search.outputs.resourceId
output searchManagedIdentity string = search.outputs.systemAssignedMIPrincipalId
