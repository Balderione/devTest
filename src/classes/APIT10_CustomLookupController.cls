public without sharing  class APIT10_CustomLookupController {
    
    @AuraEnabled
    public static Case populateValues(id recordId) {
        system.debug('CASE RID '+recordId);
        list<Case> recordCase = [SELECT id , Subject , RecordTypeId , Status , Account.Name , Account.Id , IT_Circuit__r.Id , IT_Circuit__r.Name , IT_Financial_Center__r.Id , IT_Financial_Center__r.Name FROM Case WHERE id =: recordId];
        system.debug('RECORDCASE '+recordCase);
        if(recordCase != null){
        return recordCase[0];
        }
        else {
        return NULL; 
        }
        
    }
    @AuraEnabled
    public static List<Account> lookUp(String searchTerm, string myObject) {
		
        String myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' OR ER_VAT_Number__c Like  \'%' + searchTerm + '%\' LIMIT 50';
        List <Account> lookUpList = database.query(myQuery);
        system.debug('lookUpList:::'+lookUpList);
        return lookUpList;    
    }
    
    @AuraEnabled
    public static List<IT_Circuit__c> lookUp2(String searchTerm, string myObject, id additionalFilter) {

        String myQuery = 'Select Id, Name, IT_Circuit__r.Name, IT_Circuit__r.id from ER_Financial_Center__c Where'; 
        if(searchTerm != null){
            myQuery += ' IT_Circuit__r.Name Like  \'%' + searchTerm + '%\' ';
        }
        if(searchTerm != null && additionalFilter != null){
            myQuery += ' AND ';
        }
        if (additionalFilter != null){
            myQuery += ' ER_Account_Name__c = \'' + additionalFilter +'\' ';
        }
        
        myQuery += ' LIMIT 50';
        List <ER_Financial_Center__c> lookUpList = database.query(myQuery);
        Set <IT_Circuit__c> lookUpListCircreturn = new Set<IT_Circuit__c>(); 
        for(ER_Financial_Center__c fincent : lookUpList){
            lookUpListCircreturn.add(fincent.IT_Circuit__r);
        }
        system.debug('lookUpList:::'+lookUpListCircreturn);
        List <IT_Circuit__c> lookUpListCirc = new List<IT_Circuit__c>(); 
        for(IT_Circuit__c circ : lookUpListCircreturn){
            lookUpListCirc.add(circ);
        }
        return lookUpListCirc;    
    }
    
        @AuraEnabled
    public static List<ER_Financial_Center__c> lookUp3(String searchTerm, string myObject, id additionalFilter , string recordTypeId) {
        
        //String myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' LIMIT 5';
        //string rtypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(recordTypeId).getDeveloperName();
        String myQuery2 = 'SELECT id, name , IT_Circuit__r.Name, IT_Circuit__r.Id , ER_Account_Name__r.Name , ER_Account_Name__r.Id FROM ER_Financial_Center__c WHERE  ';
        if(searchTerm != null){
            myQuery2 += ' Name Like  \'%' + searchTerm + '%\' ';
        }
        if(searchTerm != null && additionalFilter != null){
            myQuery2 += ' AND ';
        }
        if (additionalFilter != null){
            String sObjName = additionalFilter.getSObjectType().getDescribe().getName();
            if(sObjName == 'Account'){
                myQuery2 += ' ER_Account_Name__c = \'' + additionalFilter +'\' ';
            }
            else if (sObjName == 'IT_Circuit__c'){
                myQuery2 += ' IT_Circuit__c = \'' + additionalFilter +'\' ';
            }
            
        }
        //SE PROVISIONING MYQUERY += AND CLIENT STATUS = IN DEFINIZIONE
        /*if(rtypeName == 'IT_Client_Welfare_Provisioning_Case_RT'){
			  myQuery2 += ' AND IT_Client_Status__c = \'01\' ';          
        }*/
        myQuery2 += ' LIMIT 50';
        system.debug('QUERYFINCENT:::'+myQuery2);
        List <ER_Financial_Center__c> lookUpList = database.query(myQuery2);
        system.debug('lookUpList:::'+lookUpList);
        return lookUpList;    
    }

    @AuraEnabled
    public static void saveRecord(id accountId, id finCenterId, id circuitId, id caseId) {
        List <Case> CaseToUpdate = [SELECT id , Subject , Status  FROM Case WHERE id =: caseId ];
        CaseToUpdate[0].AccountId = accountId;
        CaseToUpdate[0].IT_Financial_Center__c = finCenterId;
        CaseToUpdate[0].IT_Circuit__c = circuitId;
        update CaseToUpdate[0];
    }
    
    @AuraEnabled
    public static boolean verifyMatch(id caseId) {
        List <Case> CaseToUpdate = [SELECT id , IT_Circuit__c , AccountId  FROM Case WHERE id =: caseId ];
        if(CaseToUpdate[0].IT_Circuit__c == null || CaseToUpdate[0].AccountId == null){
            return false;
        }
        List<ER_Financial_Center__c> fincents= [SELECT id FROM ER_Financial_Center__c Where IT_Circuit__c = :CaseToUpdate[0].IT_Circuit__c AND ER_Account_Name__c = :CaseToUpdate[0].AccountId];
        /* List<IT_Circuit__c> circList = [SELECT id, Name ,  IT_Account__c FROM IT_Circuit__c WHERE IT_Account__c =:CaseToUpdate[0].AccountId];
       for(IT_Circuit__c circ : circList){
            if(circ.id == CaseToUpdate[0].IT_Circuit__c){
                system.debug('MATCH! '+circ.Name + ' '+ CaseToUpdate[0].AccountId);
                return false;
            }
        }*/
        if(fincents != null && fincents.size() > 0 ){
            return false;
        }
        return true;
    }


}