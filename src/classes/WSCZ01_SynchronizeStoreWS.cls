public class WSCZ01_SynchronizeStoreWS {
    
/*
    public static Boolean alreadyExecutedAcceptor = false;
    
    public static final String xp_salesforce_endpoint = System.Label.LAB_SF_EndpointEDG_WS;
    public static final String xp_salesforce_clientId = System.Label.LAB_SF_Client_Id_WS;
    public static final String xp_salesforce_requester = System.Label.LAB_SF_Requester_WS;
    
    public static ER_Store__c store = new ER_Store__c();
    
    
    public static void updateAddStoreFuture(ID storeId) {
        updateAddStore(storeId);
    }
    

    public static String updateAddStore(ID storeId) {
         
        store = [SELECT Id,ER_Business_Unit__c, ER_Merchant__c, Name,ER_Contact__c, ER_Street__c, ER_City__c, ER_Zip_Code__c, ER_Creation_Date_In_OS__c, ER_Financial_Center__c, ER_Financial_Center__r.ER_Creation_date_in_OS__c , ER_Last_Date_Of_Sync__c, ER_Contact__r.Fax, CZ_Store_reference__c,
                 ER_Contact__r.Email, ER_Contact__r.Phone, ER_Contact__r.MobilePhone, ER_Contact__r.FirstName, ER_Contact__r.LastName, ER_Contact__r.Salutation, CreatedDate, ER_Brand__c, ER_E_Shop__c, 
                 ER_Contact__r.MailingStreet, ER_Contact__r.MailingCity, ER_Contact__r.MailingPostalCode, ER_Contact__r.MailingCountry, ER_Contact__r.MailingLatitude, ER_Description__c, ER_Do_not_publish__c,
                 ER_Contact__r.MailingLongitude, ER_Contact__r.ER_Business_Unit_2__c, ER_Contact__r.CZ_AcademicTitle__c, (SELECT id, Name, ER_MID_Authorization__c , ER_AID_Authorization__c , ER_MCC_Authorization__c , 
                                                  ER_TID_Authorization__c, ER_TID_Clearing__c, ER_MID_Clearing__c , ER_AID_Clearing__c , ER_MCC_Clearing__c , 
                                                  ER_Card_Operational_System_ID__c, ER_Business_Unit__c FROM Acceptors__r) FROM ER_Store__c WHERE Id = :storeId];
            
          
        
        Map<String, String> EdgMatrixError = WSHU02_SynchronizeMerchantWS.getEDGMatrices();
        
        System.debug('--- Which is related to the following financial center ? ' + store.ER_Financial_Center__c);    
        
        ER_Financial_Center__c theInvC = [Select id, ER_Creation_date_in_OS__c, ER_Account_Name__c, ER_Paper_Operational_System_ID__c, ER_Card_Operational_System_ID__c from ER_Financial_Center__c where id = :store.ER_Financial_Center__c];
        
        String themerchant = store.ER_Merchant__c;
        
        System.debug('--- The financial center ? ' + theInvC);
        
        
        HttpResponse res;
        
            System.debug('--- WSCZ01_SynchronizeStoreWS.callWSAddStore start ');  
            res = WSCZ01_SynchronizeStoreWS.callWSAddStore(store, themerchant, true);
            System.debug('--- WSCZ01_SynchronizeStoreWS.callWSAddStore end ');
    
        System.debug('--- The status code returned was : ' +
                     res.getStatusCode() + ' ' + res.getStatus() + ' ' + res.getBody());
        
        List<APHU05_EDGMessageHandler> myResponse = APHU05_EDGMessageHandler.parse(res.getBody()); 
        
        System.debug('--- The final message is : ' + myResponse);
        
        
        if (myResponse[0].meta.status == 'succeeded') {
            System.debug('--- Is success : ');
            store.ER_Creation_Date_In_OS__c = DateTime.now();
            System.debug('--- ER_Creation_Date_In_OS__c Updated : ');
        }
        
        else {
            System.debug('--- Is Error : ');
            //acceptors[0].ER_Last_date_of_Sync__c = DateTime.now();
        }
        
        // Update the related account
        WSCZ01_SynchronizeStoreWS.alreadyExecutedAcceptor = true;
        System.debug('Stoooore :' + store);
        update store;
        System.debug('Stoooore Updated:' + store);
        return null;
    }
    
   
    public static HttpResponse callWSAddStore(ER_Store__c aStore, String aMerchant, Boolean isComplex) {
        String result;
        
        // Current date -- Ok	
        String currentDate = String.valueOf(datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
        
        WSHU03_MerchantTemplateWS.Stores theStore = new WSHU03_MerchantTemplateWS.Stores(aStore);
        

        String body = JSON.serializePretty(theStore, true);
        System.debug('BODYYY'+ body);
        String afterblobToStringbis = APHU06_CryptoTokenGeneration.getEncodedbody(body);
        String hmacToken;
        HttpRequest req;
        
        if(store.ER_Business_Unit__c == 'CZ'){
             System.debug('BUUUU');
            // get the HmacToken to be send
            hmacToken = APHU06_CryptoTokenGeneration.getHmacToken('/merchants/ds.merchant.technical_id-' + aMerchant
                                                                  + '/stores',afterblobToStringbis, currentDate);
                                                                       
            req = APHU06_CryptoTokenGeneration.getHttpRequest('/merchants/ds.merchant.technical_id-' + aMerchant
                                                              + '/stores','POST', hmacToken, currentDate, afterblobToStringbis);  
        } 
        
 
        Http h = new Http();
        
        
        HttpResponse res;
        res = h.send(req);
        
        return  res;
    }
    
    
 */
    
}