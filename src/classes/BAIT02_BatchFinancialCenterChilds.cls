global class BAIT02_BatchFinancialCenterChilds implements Database.Batchable<Sobject>, Database.Stateful {

    private String query = 'Select Id, IT_Circuit_Code__c, IT_VAT_Number__c, IT_Service__c, IT_DEMO_Financial_Center__c From ER_Financial_Center__c Where IT_DEMO_Financial_Center__c = \'\' And IT_Circuit_Code__c != \'\'';
    Map<String, String> mapFCUpdateId = new Map<String, String>();

    List<ER_Financial_center__c> updateListFC = new List<ER_Financial_center__c>();

    global BAIT02_BatchFinancialCenterChilds(){
        mapFCUpdateId = new Map<String, String>(); 
        updateListFC = new List<ER_Financial_center__c>();   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('query: '+query);
        List<ER_Financial_Center__c> listFC = Database.query(query);
        for(ER_Financial_Center__c singleItem : listFC){
            if(singleItem.It_Service__c == '1B'){
                mapFCUpdateId.put(singleItem.IT_Circuit_Code__c+singleItem.IT_VAT_Number__c, singleItem.Id);
            }
        }
        return  Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ER_Financial_center__c> scope){
        System.debug('scope: '+scope);
        List<ER_Financial_Center__c> financialCenterOK = new List<ER_Financial_Center__c >(); 
        financialCenterOK = scope;
        for(ER_Financial_Center__c itemSingle : financialCenterOK){
            ER_Financial_Center__c singleFC = new ER_Financial_Center__c();
            if(itemSingle.IT_Service__c != '1B' && !String.isBlank(itemSingle.IT_Circuit_Code__c) && !String.isBlank(itemSingle.IT_VAT_Number__c) && mapFCUpdateId != null && mapFCUpdateId.size() > 0 && mapFCUpdateId.keyset().contains(itemSingle.IT_Circuit_Code__c+itemSingle.IT_VAT_Number__c)){
                singleFC = new ER_Financial_Center__c(Id = itemSingle.Id);
                singleFC.IT_DEMO_Financial_Center__c = mapFCUpdateId.get(itemSingle.IT_Circuit_Code__c+itemSingle.IT_VAT_Number__c);
                updateListFC.add(singleFC);    
            }
        }   
    }   
    
    global void finish(Database.BatchableContext BC){
        update updateListFC;
    }     
}