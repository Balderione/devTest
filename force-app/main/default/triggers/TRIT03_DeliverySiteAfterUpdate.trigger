trigger TRIT03_DeliverySiteAfterUpdate on ER_Delivery_Site__c (after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean AcoidControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!AcoidControlTrigger){
        if(trigger.new[0].IT_Change_Address__c)
            APIT12_CallOutbound.createRequestAddress(trigger.new, 'ER_Delivery_Site__c');
        else
            APIT12_CallOutbound.createRequestDeliverySite(trigger.new);      
    }    
}