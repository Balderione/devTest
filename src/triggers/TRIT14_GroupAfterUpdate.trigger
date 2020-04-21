trigger TRIT14_GroupAfterUpdate on IT_Group__c (after insert, after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!ControlTrigger){
        List<String> idGroup = new List<String>();
        List<IT_Group__c> updateGroup = new List<IT_Group__c>();
        for(IT_Group__c singleGroup : trigger.new){
            idGroup.add(singleGroup .Id);
        }
        updateGroup = [Select Id, IT_Group_Code__c, IT_Group_Type__c, IT_Forcing__c, IT_Amount__c, IT_Service__c, IT_Parent_Company__r.IT_Financial_Center__c, IT_Financial_Center_Code__c, IT_Description__c, IT_AC_User__c, IT_Validity_Start_Date__c, IT_Validity_End_Date__c From IT_Group__c Where Id IN: idGroup];
        if(updateGroup  != null && updateGroup .size() > 0)
            APIT12_CallOutbound.createRequestGroup(updateGroup);
    }
}