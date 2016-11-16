﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace PraticeManagement.TitleService {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(ConfigurationName="TitleService.ITitleService")]
    public interface ITitleService {
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/ITitleService/GetAllTitles", ReplyAction="http://tempuri.org/ITitleService/GetAllTitlesResponse")]
        DataTransferObjects.Title[] GetAllTitles();
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/ITitleService/GetTitleTypes", ReplyAction="http://tempuri.org/ITitleService/GetTitleTypesResponse")]
        DataTransferObjects.TitleType[] GetTitleTypes();
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/ITitleService/GetTitleById", ReplyAction="http://tempuri.org/ITitleService/GetTitleByIdResponse")]
        DataTransferObjects.Title GetTitleById(int titleId);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/ITitleService/TitleInset", ReplyAction="http://tempuri.org/ITitleService/TitleInsetResponse")]
        void TitleInset(string title, int titleTypeId, int sortOrder, int pTOAccural, System.Nullable<int> minimumSalary, System.Nullable<int> maximumSalary, string userLogin);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/ITitleService/TitleUpdate", ReplyAction="http://tempuri.org/ITitleService/TitleUpdateResponse")]
        void TitleUpdate(int titleId, string title, int titleTypeId, int sortOrder, int pTOAccural, System.Nullable<int> minimumSalary, System.Nullable<int> maximumSalary, string userLogin);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/ITitleService/TitleDelete", ReplyAction="http://tempuri.org/ITitleService/TitleDeleteResponse")]
        void TitleDelete(int titleId, string userLogin);
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface ITitleServiceChannel : PraticeManagement.TitleService.ITitleService, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class TitleServiceClient : System.ServiceModel.ClientBase<PraticeManagement.TitleService.ITitleService>, PraticeManagement.TitleService.ITitleService {
        
          public TitleServiceClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public TitleServiceClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public TitleServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public TitleServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public DataTransferObjects.Title[] GetAllTitles() {
            return base.Channel.GetAllTitles();
        }
        
        public DataTransferObjects.TitleType[] GetTitleTypes() {
            return base.Channel.GetTitleTypes();
        }
        
        public DataTransferObjects.Title GetTitleById(int titleId) {
            return base.Channel.GetTitleById(titleId);
        }
        
        public void TitleInset(string title, int titleTypeId, int sortOrder, int pTOAccural, System.Nullable<int> minimumSalary, System.Nullable<int> maximumSalary, string userLogin) {
            base.Channel.TitleInset(title, titleTypeId, sortOrder, pTOAccural, minimumSalary, maximumSalary, userLogin);
        }
        
        public void TitleUpdate(int titleId, string title, int titleTypeId, int sortOrder, int pTOAccural, System.Nullable<int> minimumSalary, System.Nullable<int> maximumSalary, string userLogin) {
            base.Channel.TitleUpdate(titleId, title, titleTypeId, sortOrder, pTOAccural, minimumSalary, maximumSalary, userLogin);
        }
        
        public void TitleDelete(int titleId, string userLogin) {
            base.Channel.TitleDelete(titleId, userLogin);
        }
    }
}

