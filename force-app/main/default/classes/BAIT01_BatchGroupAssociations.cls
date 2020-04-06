global class BAIT01_BatchGroupAssociations implements Database.Batchable<Sobject>, Database.Stateful {

    private String query = 'SELECT id, name, IT_Group_Code__c, IT_Client_Code__c From IT_Group_Code__c Where IT_Group__c = \'\'';
    global Map<String, String> idGroups = new Map<String, String>(); 

    global BAIT01_BatchGroupAssociations(){
        idGroups = new Map<String, String>();    
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('query: '+query);
        List<IT_Group_Code__c> listGroupCode = Database.query(query);
        List<String> groupNames = new List<String>();
        List<IT_Group__c> groupList = new List<IT_Group__c>();
        for(IT_Group_Code__c item : listGroupCode){
            groupNames.add(item.IT_Group_Code__c);
        }
        groupList = [Select id, name, IT_Group_Code__c From IT_Group__c Where IT_Group_Code__c IN: groupNames];
        if(groupList != null && groupList.size() > 0){
            for(IT_Group__c itemGroup : groupList){
                idGroups.put(itemGroup.IT_Group_Code__c, itemGroup.Id);    
            }    
        }
        return  Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<IT_Group_Code__c> scope){
        System.debug('scope: '+scope);
        System.debug('idGroups: '+idGroups);
        List<IT_Group_Code__c> upGroupCode = new List<IT_Group_Code__c>();
        List<IT_Group_Code__c> groupCodeOK = new List<IT_Group_Code__c>();
        groupCodeOK  = scope;
        for(IT_Group_Code__c itemGroupCode : groupCodeOK){
            if(idGroups != null && idGroups.size() > 0 && idGroups.keyset().contains(itemGroupCode.IT_Group_Code__c)){
                itemGroupCode.IT_Group__c = idGroups.get(itemGroupCode.IT_Group_Code__c);
                upGroupCode.add(itemGroupCode);
            }    
        }
        if(upGroupCode != null && upGroupCode.size() > 0)
            update upGroupCode;
    }   
    
    global void finish(Database.BatchableContext BC){

    }     
}