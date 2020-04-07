trigger TRIT10_CaseBeforeInsert on Case (before insert, before update, after insert, after update) {
    if(trigger.isInsert && trigger.isBefore){
        APIT15_CaseTriggerHandler.CaseToContractLink(Trigger.New);
        string result = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(trigger.new[0].RecordTypeId).getDeveloperName();
        if(result == 'IT_Client_Welfare_Provisioning_Case_RT'){
            List<Entitlement> entList= [SELECT id FROM Entitlement Where Name = 'Provisioning Flexben'];
            if(entList != null && entList.size() > 0){
                trigger.new[0].EntitlementId = entList[0].id;
            }
        }
    }
    if(trigger.isInsert && trigger.IsBefore){
        APIT15_CaseTriggerHandler.associateContactDetailToCase(Trigger.new[0]);
        
    }
    if(trigger.isBefore){
		APIT15_CaseTriggerHandler.CaseEntitlementLink(Trigger.New);
    }
    if(trigger.isAfter && trigger.isUpdate){
        APIT15_CaseTriggerHandler.MilestoneAutoComplete(Trigger.New);
        if((trigger.new[0].status == 'Closed' && trigger.old[0].status != 'Closed') || (trigger.new[0].status == 'Waiting' && trigger.old[0].status != 'Waiting')){
            APIT15_CaseTriggerHandler.CTICalloutClosedCase(JSON.serialize(trigger.new[0]));
        }
        
    }
    /*if(trigger.isAfter && trigger.isInsert){
        APIT15_CaseTriggerHandler.caseEmailHandler(Trigger.New);
    }*/
    if(trigger.isAfter && trigger.isInsert){
        system.debug('RECTYPE:: '+Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(trigger.new[0].RecordTypeId).getDeveloperName());
        if(trigger.New[0].Origin == 'Email' && trigger.New[0].Status != 'Closed' && Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(trigger.new[0].RecordTypeId).getDeveloperName() == 'IT_Client_Support_Case_RT'){
            APIT15_CaseTriggerHandler.CTICallout(JSON.serialize(trigger.new[0]));
        }
        APIT15_CaseTriggerHandler.changeCaseQueue(JSON.serialize(trigger.new[0]));
    }
    
        
       
    
}