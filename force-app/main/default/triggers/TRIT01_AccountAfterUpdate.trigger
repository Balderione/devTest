trigger TRIT01_AccountAfterUpdate on Account (after update) {

    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean AcoidControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!AcoidControlTrigger && APIT12_CallOutbound.firstTrigger){
        for(Account singleAcc : trigger.new){
           if( trigger.newMap.get(singleAcc.Id).IT_Group_VAT_Number__c != trigger.oldMap.get(singleAcc.Id).IT_Group_VAT_Number__c || 
               trigger.newMap.get(singleAcc.Id).IT_VAT_Group_Naming__c != trigger.oldMap.get(singleAcc.Id).IT_VAT_Group_Naming__c || 
               trigger.newMap.get(singleAcc.Id).IT_VAT_Group_PEC__c != trigger.oldMap.get(singleAcc.Id).IT_VAT_Group_PEC__c ||
               trigger.newMap.get(singleAcc.Id).IT_VAT_Group_SDI__c != trigger.oldMap.get(singleAcc.Id).IT_VAT_Group_SDI__c){
                   APIT12_CallOutbound.createRequestAccount(trigger.new, 'VatGroup');
                       
           }else{
               APIT12_CallOutbound.createRequestAccount(trigger.new, 'Account');
           }

        }        
    }   
         for(Account singleAcc : trigger.new){
           if( trigger.newMap.get(singleAcc.Id).BillingCity!= trigger.oldMap.get(singleAcc.Id).BillingCity || 
               trigger.newMap.get(singleAcc.Id).BillingPostalCode != trigger.oldMap.get(singleAcc.Id).BillingPostalCode ){
               system.debug('sono dentro trigger');
          APIT00_TerritoryAssignment.AssignTerritory(singleAcc.Id,APIT00_TerritoryAssignment.getTerritory( trigger.newMap.get(singleAcc.Id).BillingCity,trigger.newMap.get(singleAcc.Id).BillingPostalCode));
           }
           }
}