param aiSearchResourceId string
param storageResourceId string
param openaiResourceId string
param userObjectId string

@description('Built-in Role: [Search Services Contributor]')
resource search_service_contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
  scope: subscription()
}

@description('Built-in Role: [Search Index Data Contributor]')
resource search_index_data_contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
  scope: subscription()
}

@description('Built-in Role: [Cognitive Services Contributor]')
resource cognitive_service_contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '25fbc0a9-bd7c-42a3-aa1a-3b75d497ee68'
  scope: subscription()
}

@description('Built-in Role: [Cognitive Services OpenAI Contributor]')
resource cognitive_service_openai_contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'a001fd3d-188f-4b5d-821b-7da978bf7442'
  scope: subscription()
}

@description('Built-in Role: [Contributor]')
resource contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  scope: subscription()
}

@description('Built-in Role: [Storage Blob Data Contributor]')
resource storage_blob_data_contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  scope: subscription()
}

@description('Built-in Role: [Storage File Data Privileged Contributor]')
resource storage_file_data_privileged_contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '69566ab7-960f-475b-8e7c-b3118f30c6bd'
  scope: subscription()
}

// @description('Built-in Role: [AI Developer]')
// resource ai_developer 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
//   name: '64702f94-c441-49e6-a78b-ef80e0188fee'
//   scope: subscription()
// }

// module ai_developer_project 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(userObjectId)) {
//   name: 'ai_developer_project'
//   params: {
//     principalId: userObjectId
//     resourceId: projectResourceId
//     roleDefinitionId: ai_developer.id
//   }
// }

module search_index_data_contributor_user 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(userObjectId)) {
  name: 'search_index_data_contributor_user'
  params: {
    principalId: userObjectId
    resourceId: aiSearchResourceId
    roleDefinitionId: search_index_data_contributor.id
  }
}

module search_service_contributor_user 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(userObjectId)) {
  name: 'search_service_contributor_user'
  params: {
    principalId: userObjectId
    resourceId: aiSearchResourceId
    roleDefinitionId: search_service_contributor.id
  }
}

module cognitive_service_openai_contributor_user 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(userObjectId)) {
  name: 'cognitive_service_openai_contributor_user'
  params: {
    principalId: userObjectId
    resourceId: openaiResourceId
    roleDefinitionId: cognitive_service_openai_contributor.id
  }
}

module cognitive_service_contributor_user 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(userObjectId)) {
  name: 'cognitive_service_contributor_user'
  params: {
    principalId: userObjectId
    resourceId: aiSearchResourceId
    roleDefinitionId: cognitive_service_contributor.id
  }
}

module openai_contributor 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(userObjectId)) {
  name: 'openai_contributor'
  params: {
    principalId: userObjectId
    resourceId: openaiResourceId
    roleDefinitionId: contributor.id
  }
}

module storage_blob_data_contributor_user 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(userObjectId)) {
  name: 'storage_blob_data_contributor_user'
  params: {
    principalId: userObjectId
    resourceId: storageResourceId
    roleDefinitionId: storage_blob_data_contributor.id
  }
}

module storage_file_data_privileged_contributor_user 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (!empty(userObjectId)) {
  name: 'storage_file_data_privileged_contributor_user'
  params: {
    principalId: userObjectId
    resourceId: storageResourceId
    roleDefinitionId: storage_file_data_privileged_contributor.id
  }
}
