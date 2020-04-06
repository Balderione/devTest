trigger TRIT19_NoteAfterUpdate on IT_Note__c (after insert, after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!ControlTrigger){
        List<String> idNotes = new List<String>();
        for(IT_Note__c singleNote : trigger.new){
            if(Trigger.isInsert || (Trigger.isUpdate && trigger.newMap.get(singleNote.Id).IT_Progressive__c == trigger.oldMap.get(singleNote.Id).IT_Progressive__c && trigger.newMap.get(singleNote.Id).IT_Financial_Center__c == trigger.oldMap.get(singleNote.Id).IT_Financial_Center__c))
                idNotes.add(singleNote.Id);
        }     
        List<IT_Note__c> listnote = new List<IT_Note__c>();
        //Set<Id> listId = new Set<Id>();
        //listId = new Set<Id>(trigger.newMap.Keyset());
        
        SObjectType noteType = Schema.getGlobalDescribe().get('IT_Note__c');
        Map<String,Schema.SObjectField> noteFields = noteType.getDescribe().fields.getMap();
        String query = 'SELECT ';
        for(String field : noteFields.keySet()) {
            query+=field+',';
        }
        SObjectType fcType = Schema.getGlobalDescribe().get('ER_Financial_Center__c');
        Map<String,Schema.SObjectField> fcFields = fcType.getDescribe().fields.getMap();
        for(String field : fcFields.keySet()) {
            query+='IT_Financial_Center__r.'+field+',';
        }
        SObjectType dsType = Schema.getGlobalDescribe().get('ER_Delivery_Site__c');
        Map<String,Schema.SObjectField> dsFields = dsType.getDescribe().fields.getMap();
        for(String field : dsFields.keySet()) {
            query+='IT_Delivery_Site__r.'+field+',';
        }
        query = query.removeEnd(',');

        System.debug(query);
        query += ' FROM IT_Note__c WHERE Id IN: idNotes';
        listnote = Database.query(query);

        if(listnote != null && listnote.size() > 0)
            APIT12_CallOutbound.createRequestNotes(listnote);
    }
}