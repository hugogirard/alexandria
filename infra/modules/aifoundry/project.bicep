param projectName string
param location string
param hubResourceId string

module project 'br/public:avm/res/machine-learning-services/workspace:0.11.0' = {
  name: projectName
  params: {
    name: projectName
    sku: 'Standard'
    kind: 'Project'
    location: location
    publicNetworkAccess: 'Disabled'
    hubResourceId: hubResourceId
    managedIdentities: {
      systemAssigned: true
    }
  }
}

output systemAssignedMIPrincipalId string = project.outputs.systemAssignedMIPrincipalId!
output resourceId string = project.outputs.resourceId
