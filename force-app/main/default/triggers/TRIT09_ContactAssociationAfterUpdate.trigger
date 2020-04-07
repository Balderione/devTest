trigger TRIT09_ContactAssociationAfterUpdate on IT_Contact_Association__c (after insert, after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!ControlTrigger){
        List<String> idContactAss = new List<String>();
        List<IT_Contact_Association__c> listContactAss = new List<IT_Contact_Association__c>();
        for(IT_Contact_Association__c singleContactASS : trigger.new){
            idContactAss.add(singleContactASS.Id);
        }
        SObjectType contactAssType = Schema.getGlobalDescribe().get('IT_Contact_Association__c');
        Map<String,Schema.SObjectField> contactAssFields = contactAssType.getDescribe().fields.getMap();
        String query = 'SELECT ';
        for(String field : contactAssFields.keySet()) {
            query+=field+',';
        }
        SObjectType contactDetType = Schema.getGlobalDescribe().get('IT_Contact_Detail__c');
        Map<String,Schema.SObjectField> conDetFields = contactDetType.getDescribe().fields.getMap();
        for(String field : conDetFields.keySet()) {
            query+='IT_Contact_Detail__r.'+field+',';
        }
        SObjectType contactType = Schema.getGlobalDescribe().get('Contact');
        Map<String,Schema.SObjectField> contactFields = contactType.getDescribe().fields.getMap(); 
        for(String field : contactFields.keySet()) {
            query+='IT_Contact_Detail__r.IT_Contact__r.'+field+',';
        }
        query = query.removeEnd(',');

        System.debug(query);
        query += ' FROM IT_Contact_Association__c WHERE Id IN: idContactAss';
        listContactAss = Database.query(query);
        if(listContactAss != null && listContactAss.size() > 0)
            APIT12_CallOutbound.createRequestContactAss(listContactAss);
    }
}