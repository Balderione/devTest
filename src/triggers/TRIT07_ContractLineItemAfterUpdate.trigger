trigger TRIT07_ContractLineItemAfterUpdate on ER_ContractLineItem__c (after insert, after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!ControlTrigger){
        APIT12_CallOutbound.createRequestContractLineItem(trigger.new);
    }    
}