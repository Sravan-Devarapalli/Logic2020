﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.1
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace PraticeManagement.PersonRoleService {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(ConfigurationName="PersonRoleService.IPersonRoleService")]
    public interface IPersonRoleService {
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IPersonRoleService/GetPersonRoles", ReplyAction="http://tempuri.org/IPersonRoleService/GetPersonRolesResponse")]
        DataTransferObjects.PersonRole[] GetPersonRoles();
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface IPersonRoleServiceChannel : PraticeManagement.PersonRoleService.IPersonRoleService, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class PersonRoleServiceClient : System.ServiceModel.ClientBase<PraticeManagement.PersonRoleService.IPersonRoleService>, PraticeManagement.PersonRoleService.IPersonRoleService {
       
        public PersonRoleServiceClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public PersonRoleServiceClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public PersonRoleServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public PersonRoleServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public DataTransferObjects.PersonRole[] GetPersonRoles() {
            return base.Channel.GetPersonRoles();
        }
    }
}

