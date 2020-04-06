trigger TRIT08_IntentDeclarationAfterUpdate on IT_Intent_Declaration__c (after insert, after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!ControlTrigger){
        APIT12_CallOutbound.createRequestIntentDeclaration(trigger.new);
    }    
}