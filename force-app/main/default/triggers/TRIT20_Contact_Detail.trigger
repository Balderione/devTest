trigger TRIT20_Contact_Detail on IT_Contact_Detail__c (before update) {
    if(trigger.new[0].IT_Contact__c != trigger.old[0].IT_Contact__c) {
        List<Contact> newContact = [SELECT id, ER_FinancialCenter__c FROM Contact Where id =:trigger.new[0].IT_Contact__c];
        List<Contact> oldContact = [SELECT id, ER_FinancialCenter__c FROM Contact Where id =:trigger.old[0].IT_Contact__c];
        if(newContact  != null && newContact.size() > 0 && oldContact  != null && oldContact.size() > 0 ){
            system.debug('ID NEW'+ newContact[0].ER_FinancialCenter__c + 'ID OLD'+ oldContact[0].ER_FinancialCenter__c);
            if(newContact[0].ER_FinancialCenter__c!= oldContact[0].ER_FinancialCenter__c){
                trigger.new[0].adderror('Non è possibile associare ad un recapito un referente a cui è associato un Financial Center diverso');
            }
        }
        
    }
}