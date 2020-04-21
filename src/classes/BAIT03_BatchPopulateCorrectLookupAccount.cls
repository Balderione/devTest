global class BAIT03_BatchPopulateCorrectLookupAccount implements Database.Batchable<Sobject>, Database.Stateful {

    private String query = 'SELECT Id, IT_Account_Active__c, IT_Account_Provisioning__c, IT_Account_Closed__c, ER_Account_Name__c, IT_Client_Status__c FROM ER_Financial_Center__c WHERE (IT_Account_Active__c = null And IT_Account_Provisioning__c = null And IT_Account_Closed__c = null) Or (IT_Account_Active__c = null And (IT_Client_Status__c = \'02\' Or IT_Client_Status__c = \'05\')) Or 	(IT_Account_Provisioning__c = null And IT_Client_Status__c = \'01\') Or (IT_Account_Closed__c = null And IT_Client_Status__c != \'02\' And IT_Client_Status__c != \'05\' And IT_Client_Status__c != \'01\')';
    List<ER_Financial_center__c> updateListFC = new List<ER_Financial_center__c>();
    Map<String, ER_Financial_Center__c> mapFCUpdateId = new Map<String, ER_Financial_Center__c>();
    
    global BAIT03_BatchPopulateCorrectLookupAccount(){
        updateListFC = new List<ER_Financial_center__c>();
        mapFCUpdateId = new Map<String, ER_Financial_Center__c>();      
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('query: '+query);
        List<ER_Financial_Center__c> listFC = Database.query(query);
        for(ER_Financial_Center__c singleItem : listFC){
            if(singleItem.IT_Client_Status__c == '02'){
                singleItem.IT_Account_Active__c = singleItem.ER_Account_Name__c;
                singleItem.IT_Account_Provisioning__c = null;
                singleItem.IT_Account_Closed__c = null;    
            }else if(singleItem.IT_Client_Status__c == '01' || singleItem.IT_Client_Status__c == '05'){
                singleItem.IT_Account_Provisioning__c = singleItem.ER_Account_Name__c;
                singleItem.IT_Account_Active__c = null;
                singleItem.IT_Account_Closed__c = null;
            }else{
                singleItem.IT_Account_Closed__c = singleItem.ER_Account_Name__c;
                singleItem.IT_Account_Active__c = null;
                singleItem.IT_Account_Provisioning__c = null;
            }
            mapFCUpdateId.put(singleItem.Id, singleItem);
        }
        return  Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ER_Financial_center__c> scope){
        System.debug('scope: '+scope);
        for(ER_Financial_Center__c singleItemFC : scope){
            ER_Financial_Center__c newFc = new ER_Financial_Center__c();
            if(mapFCUpdateId != null && mapFCUpdateId.size() > 0 && mapFCUpdateId.keyset().contains(singleItemFC.Id)){
                newFc = mapFCUpdateId.get(singleItemFC.Id);
                updateListFC.add(newFc);
            }    
        }
    }   
    
    global void finish(Database.BatchableContext BC){  
        System.debug('updateListFC::: '+updateListFC);
        System.debug('updateListFC.size::: '+updateListFC.size());
    }     
}