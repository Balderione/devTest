@isTest
public class Test_APIT00_InvokeApexFromFlowController {
   
    @isTest(SeeAllData = true) static void invalidRequest(){
        
        List<Lead> leadList = new List<Lead>();
        
        Lead lead = new Lead(
            LeadSource = 'Webform',
            LastName = 'testLastName',
            FirstName = 'testName',
            Salutation = 'Mr.',
            Status = 'New',
            ER_Lead_Type__c = 'Merchant',
            ER_Store_Name__c = 'StoreName'
           );   
       
        insert lead;  
        
        //insert leadList; 
        
        lead.FirstName = 'testNameUpdate';
        lead.OwnerId = '00G0E000004zuo6UAA';
        update lead;
        
        
        List<LeadHistory> leadListHistory = new List<LeadHistory>();
        leadListHistory = [SELECT id, OldValue, NewValue, Field, CreatedById, CreatedDate FROM LeadHistory LIMIT 1];
        System.debug('LeadHistory: ' +  leadListHistory);
        
        APIT00_InvokeApexFromFlowController.FlowInputs flowInput = new  APIT00_InvokeApexFromFlowController.FlowInputs();
        flowInput.History = leadListHistory[0];
        List<APIT00_InvokeApexFromFlowController.FlowInputs> flowHistory = new List<APIT00_InvokeApexFromFlowController.FlowInputs> ();
        
         APIT00_InvokeApexFromFlowController.invokeThisMetho(
         new List<APIT00_InvokeApexFromFlowController.FlowInputs>{ flowInput }
         );
    
}
    
    
    
}