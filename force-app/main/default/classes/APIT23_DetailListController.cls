public class APIT23_DetailListController {
    
    //private static String query = 'SELECT Id, Name, FirstName, LastName, Email, MobilePhone FROM Contact';
    @AuraEnabled
    public static ResultWrapper getData( Integer pageSize, Integer pageNumber, String sortBy, String sortOrder, String recordId, boolean isViewAll, boolean isAssociation ){
        List<ER_Financial_Center__c> fincentList = [SELECT id, ER_Account_Name__c FROM ER_Financial_Center__c WHERE id = :recordId];
        String query = 'SELECT id,Name,IT_Contact__c,IT_Contact__r.Name,IT_Contact__r.IT_Client_Billing_Recepits__c,IT_Contact__r.IT_Contact_Type__c,IT_Send_SUT__c,IT_Contact_Detail__c,IT_Contact_Detail__r.Name,IT_Contact_Detail__r.IT_Contact_Info__c,IT_Order_Confirm_Address__c,IT_Financial_Center__c,IT_Financial_Center__r.Name,IT_Billing_Confirm_Address__c,IT_Notifications__c FROM IT_Contact_Association__c WHERE IT_Financial_Center__r.ER_Account_Name__c = \''+fincentList[0].ER_Account_Name__c+'\' AND (IT_Type__c = \'AM\' OR  IT_Type__c = \'Ref\') AND IT_Delivery_Site__c = null AND IT_Distribution_Point__c = null  AND IT_Contact__r.IT_Type__c = \'Soc\' ';
        
        if( sortby != NULL && sortOrder != NULL  ){
            query += ' ORDER BY '+ sortby+' '+ sortOrder+'  NULLS LAST';
        }
        if(!isViewAll){
           query +=  ' LIMIT 10';
        }
       
         
        
            List<IT_Contact_Association__c> contactList = database.query( query );
            if(contactList != null && contactList.size() > 0){
                List<string> detailIdsToFilter = new List<string>();
                for(IT_Contact_Association__c singleAss : contactList){
                    if(singleAss.IT_Contact_Detail__c != null){
                        detailIdsToFilter.add(singleAss.IT_Contact_Detail__c);
                    }
                }
                List<IT_Contact_Detail__c> contactDetailList = [SELECT id , Name, IT_Contact__c, IT_Contact__r.Name, IT_Contact__r.IT_Contact_Type__c FROM IT_Contact_Detail__c WHERE id NOT IN : detailIdsToFilter AND IT_Contact__r.AccountId = :fincentList[0].ER_Account_Name__c AND IT_Contact__r.IT_Type__c = 'Soc'];
                return new ResultWrapper( contactList, contactDetailList, contactList.size());
                
            }
            else{
            system.debug('AssoNOTFound');
             
            String query2 = 'SELECT id , Name, IT_Contact__c, IT_Contact__r.Name, IT_Contact__r.IT_Contact_Type__c FROM IT_Contact_Detail__c WHERE IT_Contact__r.AccountId = \''+fincentList[0].ER_Account_Name__c+'\' AND IT_Contact__r.IT_Type__c = \'Soc\' ';  
            if( sortby != NULL && sortOrder != NULL  ){
                query2 += ' ORDER BY '+ sortby+' '+ sortOrder+'  NULLS LAST';
            }
            if(!isViewAll){
                query2 +=  ' LIMIT 10';
            }
            List<IT_Contact_Detail__c> contactList2 = database.query( query2 );
            if(contactList2 != null && contactList2.size() > 0){
                system.debug('contactListFOUND');
                return new ResultWrapper( new list<IT_Contact_Association__c>(), contactList2, contactList2.size());
            }
            else return new ResultWrapper( new list<IT_Contact_Association__c>(),new list<IT_Contact_Detail__c>(),  0);        
        }
                  

    } 
    
        @AuraEnabled
    public static ContactWrapper getContactData( Integer pageSize, Integer pageNumber, String sortBy, String sortOrder, String recordId, boolean isViewAll ){
        List<ER_Financial_Center__c> fincentList = [SELECT id, ER_Account_Name__c FROM ER_Financial_Center__c WHERE id = :recordId];
        //String query = 'SELECT id,Name,IT_Client_Billing_Recepits__c,IT_Ticket_Receipts__c,ER_FinancialCenter__r.IT_Financial_Center__c FROM Contact WHERE ER_FinancialCenter__r.ER_Account_Name__c = \''+fincentList[0].ER_Account_Name__c+'\' ';
        String query = 'SELECT id,Name,IT_Contact__c,IT_Contact_Detail__c,IT_Contact__r.Name,IT_Contact__r.IT_Ticket_Receipts__c,IT_Contact__r.IT_Contact_Type__c,IT_Financial_Center__c,IT_Financial_Center__r.Name FROM IT_Contact_Association__c WHERE IT_Financial_Center__r.ER_Account_Name__c = \''+fincentList[0].ER_Account_Name__c+'\' AND (IT_Type__c = \'AM\' OR  IT_Type__c = \'Ref\') AND IT_Delivery_Site__c = null AND IT_Distribution_Point__c = null  AND IT_Contact__r.IT_Type__c = \'Ref\' ';

        if( sortby != NULL && sortOrder != NULL  ){
            query += ' ORDER BY '+ sortby+' '+ sortOrder+'  NULLS LAST';
        }
        if(!isViewAll){
           query +=  ' LIMIT 10';
        }
        
         
        
        List<IT_Contact_Association__c> contactList = database.query( query );
        if(contactList != null && contactList.size() > 0){
            system.debug('AssoFound');
            system.debug(contactList);
            Map<string , IT_Contact_Association__c> assomap = new Map<string , IT_Contact_Association__c>();
            List<string> detailIdsToFilter = new List<string>();
            for(IT_Contact_Association__c singleAss : contactList){
                if(singleAss.IT_Contact__c != null){
                    string concatIds = singleAss.IT_Contact__c;
                    concatIds += singleAss.IT_Financial_Center__c;
                    assomap.put(concatIds, singleAss );
                    detailIdsToFilter.add(singleAss.IT_Contact__c);
                }
            }
            List<IT_Contact_Association__c> deduplicatedAsso = assomap.values();
            List<Contact> noAssContactList = [SELECT id , Name, IT_Contact_Type__c, IT_Ticket_Receipts__c FROM Contact WHERE id NOT IN : detailIdsToFilter AND AccountId = :fincentList[0].ER_Account_Name__c AND IT_Type__c = 'Ref'];
            
            return new ContactWrapper( deduplicatedAsso, noAssContactList, deduplicatedAsso.size()+noAssContactList.size());
        }
        else{
            system.debug('AssoNOTFound');
             
            String query2 = 'SELECT id,Name,IT_Contact_Type__c,IT_Client_Billing_Recepits__c,IT_Ticket_Receipts__c FROM Contact WHERE AccountId = \''+fincentList[0].ER_Account_Name__c+'\' AND IT_Type__c = \'Ref\' ';  
            if( sortby != NULL && sortOrder != NULL  ){
                query2 += ' ORDER BY '+ sortby+' '+ sortOrder+'  NULLS LAST';
            }
            if(!isViewAll){
                query2 +=  ' LIMIT 10';
            }
            List<Contact> contactList2 = database.query( query2 );
            if(contactList2 != null && contactList2.size() > 0){
                system.debug('contactListFOUND');
                return new ContactWrapper( new list<IT_Contact_Association__c>(), contactList2, contactList2.size());
            }
            else return new ContactWrapper( new list<IT_Contact_Association__c>(),new list<Contact>(),  0);        
        }
            
        

    } 
    
    @AuraEnabled
    public static void updateRecords( List<sObject> detailList){
        update detailList;
    }
    
    
    public class ResultWrapper {
        
        @AuraEnabled
        public List<IT_Contact_Association__c> result {get;set;}
        @AuraEnabled
        public List<IT_Contact_Detail__c> resultDet {get;set;}
        @AuraEnabled
        public Integer totalNumberOfRecords {get;set;}
        
        public ResultWrapper( List<IT_Contact_Association__c> result, List<IT_Contact_Detail__c> resultDet, Integer totalNumberOfRecords) {
            this.result = result;
            this.resultDet = resultDet;
            this.totalNumberOfRecords = totalNumberOfRecords;
        }
    }
    
    public class ContactWrapper {
        
        @AuraEnabled
        public List<IT_Contact_Association__c> result {get;set;}
        @AuraEnabled
        public List<Contact> resultCon {get;set;}
        @AuraEnabled
        public Integer totalNumberOfRecords {get;set;}
        
        public ContactWrapper( List<IT_Contact_Association__c> result, List<Contact> resultCon,  Integer totalNumberOfRecords) {
            this.result = result;
            this.resultCon = resultCon;
            this.totalNumberOfRecords = totalNumberOfRecords;
        }
    }
    
}