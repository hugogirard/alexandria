//*********************************************************************
//          RBAC needed for Azure AI Foundry and secure chat playground
//          https://learn.microsoft.com/en-us/azure/ai-foundry/concepts/rbac-ai-foundry#scenario-connections-using-microsoft-entra-id-authentication
//          https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/secure-data-playground
//*********************************************************************

param openAiSystemAssignedMIPrincipalId string
param openaiResourceId string
param searchAiSystemAssignedMIPrincipalId string
param aiSearchResourceId string
param storageResourceId string

@description('Built-in Role: [Cognitive Services OpenAI Contributor]')
resource cognitive_service_openai_contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'a001fd3d-188f-4b5d-821b-7da978bf7442'
  scope: subscription()
}

@description('Build-in Role: [Search Index Data Reader]')
resource searchIndexDataReader 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '1407120a-92aa-4202-b7e9-c0e197c71c8f'
  scope: subscription()
}

@description('Built-in Role: [Search Index Data Contributor]')
resource searchIndexDataContributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
  scope: subscription()
}

@description('Built-in Role: [Search Service Contributor]')
resource searchServiceContributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
  scope: subscription()
}

@description('Built-in Role: [Storage Blob Data Contributor]')
resource storage_blob_data_contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  scope: subscription()
}

module openai_searchindex_data_reader 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'openai_searchindex_data_reader'
  params: {
    principalId: openAiSystemAssignedMIPrincipalId
    resourceId: aiSearchResourceId
    roleDefinitionId: searchIndexDataReader.id
  }
}

module openai_searchindex_data_contributor 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'openai_searchindex_data_contributor'
  params: {
    principalId: openAiSystemAssignedMIPrincipalId
    resourceId: aiSearchResourceId
    roleDefinitionId: searchIndexDataContributor.id
  }
}

module openai_search_service_contributor 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'openai_search_service_contributor'
  params: {
    principalId: openAiSystemAssignedMIPrincipalId
    resourceId: aiSearchResourceId
    roleDefinitionId: searchServiceContributor.id
  }
}

module openai_storage_data_blob_contributor 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'openai_storage_data_blob_contributor'
  params: {
    principalId: openAiSystemAssignedMIPrincipalId
    resourceId: storageResourceId
    roleDefinitionId: storage_blob_data_contributor.id
  }
}

module search_service_openai_contributor 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'search_service_openai_contributor'
  params: {
    principalId: searchAiSystemAssignedMIPrincipalId
    resourceId: openaiResourceId
    roleDefinitionId: cognitive_service_openai_contributor.id
  }
}

module search_service_storage_data_blob_contributor 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'search_service_storage_data_blob_contributor'
  params: {
    principalId: searchAiSystemAssignedMIPrincipalId
    resourceId: storageResourceId
    roleDefinitionId: storage_blob_data_contributor.id
  }
}
