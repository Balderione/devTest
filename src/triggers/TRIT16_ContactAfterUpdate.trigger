trigger TRIT16_ContactAfterUpdate on Contact (Before insert, After Update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!ControlTrigger){
        if(trigger.isAfter){
            List<Contact> contactTrigger = new List<Contact>();
            List<Contact> contactTriggerUpdateOK = new List<Contact>();
            List<String> idContactTrigger = new List<String>();
            for(Contact singleContact : trigger.new){
                idContactTrigger.add(singleContact.Id);
            }
            SObjectType contractType = Schema.getGlobalDescribe().get('Contact');
            Map<String,Schema.SObjectField> contractFields = contractType.getDescribe().fields.getMap();
            String query = 'SELECT ';
            for(String field : contractFields.keySet()) {
                query+=field+',';
            }
            SObjectType bankAccountType = Schema.getGlobalDescribe().get('IT_Contact_Detail__c');
            Map<String,Schema.SObjectField> bankAccountFields = bankAccountType.getDescribe().fields.getMap();
                query +='(SELECT ';
            for(String field : bankAccountFields.keySet()) {
                query+=field+',';
            }
            query = query.removeEnd(',');

            query += ' FROM Contact_Details__r), ';

            SObjectType contactASSType = Schema.getGlobalDescribe().get('IT_Contact_Association__c');
            Map<String,Schema.SObjectField> cASSFields = contactASSType.getDescribe().fields.getMap();
                query +='(SELECT ';
            for(String field : cASSFields.keySet()) {
                query+=field+',';
            }
            query = query.removeEnd(',');
    
            query += ' FROM IT_Contact_Association__r) ';

            System.debug(query);
            query += ' FROM Contact WHERE Id IN: idContactTrigger';
            contactTrigger = Database.query(query);

            for(Contact itemContact : contactTrigger){
                if(itemContact.IT_Contact_Association__r != null && itemContact.IT_Contact_Association__r.size() > 0 && itemContact.IT_Type__c != 'Soc')
                    contactTriggerUpdateOK.add(itemContact);
            }
            
            System.debug('contactTriggerUpdateOK:: '+contactTriggerUpdateOK);

            if(contactTriggerUpdateOK != null && contactTriggerUpdateOK.size() > 0)
                APIT12_CallOutbound.createContactOnlyCustom(contactTriggerUpdateOK);
        }
        if(trigger.isBefore){
            for(Contact singleContact : trigger.new){
                if(!String.isBlank(singleContact.FirstName)){
                    singleContact.FirstName = singleContact.FirstName.toUppercase();
                }
                if(!String.isBlank(singleContact.LastName)){
                    singleContact.LastName = singleContact.LastName.toUppercase();
                }
            }
        }        
    }    
}