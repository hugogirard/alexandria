param location string
param suffix string

module dependencies 'dependences.bicep' = {
  name: 'aifoundrydependencies'
  params: {
    location: location
    suffix: suffix
  }
}

module hub 'br/public:avm/res/machine-learning-services/workspace:0.11.0' = {
  params: {
    name: 'hub-${suffix}'
    description: 'Hub Contoso'
    sku: 'Basic'
    kind: 'Hub'
    managedIdentities: {
      systemAssigned: true
    }
    associatedStorageAccountResourceId: dependencies.outputs.storageResourceId
    associatedKeyVaultResourceId: dependencies.outputs.keyvaultResourceId
    associatedApplicationInsightsResourceId: dependencies.outputs.appInsightResourceId
    associatedContainerRegistryResourceId: dependencies.outputs.containerRegistryResourceId
    publicNetworkAccess: 'Enabled'
    connections: [
      {
        name: 'openai'
        target: dependencies.outputs.openaiEndpoint
        category: 'AzureOpenAI'
        connectionProperties: {
          authType: 'AAD'
        }
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure'
          ResourceId: dependencies.outputs.openaiResourceId
        }
      }
      {
        name: 'aisearch'
        target: 'https://${dependencies.outputs.searchResourceName}/search.windows.net'
        category: 'CognitiveSearch'
        connectionProperties: {
          authType: 'AAD'
        }
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure'
          ResourceId: dependencies.outputs.searchResourceId
        }
      }
    ]
    serverlessComputeSettings: null
    systemDatastoresAuthMode: 'Identity'
  }
}

output hubResourceId string = hub.outputs.resourceId
output storageResourceId string = dependencies.outputs.storageResourceId
output openaiResourceId string = dependencies.outputs.openaiResourceId
output openAiManagedIdentity string = dependencies.outputs.openAiManagedIdentity
output searchResourceId string = dependencies.outputs.searchResourceId
output searchManagedIdentity string = dependencies.outputs.searchManagedIdentity
