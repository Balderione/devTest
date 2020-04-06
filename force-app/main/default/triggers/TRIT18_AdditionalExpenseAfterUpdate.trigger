trigger TRIT18_AdditionalExpenseAfterUpdate on IT_Additional_Expenses__c (after insert, after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!ControlTrigger){
        Set<Id> listId = new Set<Id>();  
        for(IT_Additional_Expenses__c singleAddExp : trigger.new){
            if(Trigger.isInsert || (Trigger.isUpdate && trigger.newMap.get(singleAddExp.Id).IT_Progressive__c == trigger.oldMap.get(singleAddExp.Id).IT_Progressive__c))
                listId.add(singleAddExp.Id);
        }
        List<IT_Additional_Expenses__c> listAddExp = new List<IT_Additional_Expenses__c>();
        //Set<Id> listId = new Set<Id>();
        //listId = new Set<Id>(trigger.newMap.Keyset());
        SObjectType addExpType = Schema.getGlobalDescribe().get('IT_Additional_Expenses__c');
        Map<String,Schema.SObjectField> addExpFields = addExpType.getDescribe().fields.getMap();
        String query = 'SELECT ';
        for(String field : addExpFields.keySet()) {
            query+=field+',';
        }
        SObjectType fcType = Schema.getGlobalDescribe().get('ER_Financial_Center__c');
        Map<String,Schema.SObjectField> fcFields = fcType.getDescribe().fields.getMap();
        for(String field : fcFields.keySet()) {
            query+='IT_Financial_Center__r.'+field+',';
        }
        query = query.removeEnd(',');

        System.debug(query);
        query += ' FROM IT_Additional_Expenses__c WHERE Id IN: listId';
        listAddExp = Database.query(query);

        if(listAddExp != null && listAddExp.size() > 0)
            APIT12_CallOutbound.createRequestAdditionalExpenses(listAddExp);
    }
}