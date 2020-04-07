@isTest
public class APHU11_EdgSyncCallout_Test {

        public static final Integer iNumAccts = 1;
        //VAT '11111111-1-11'
        //public static final String sVatNumber = null;
        public static final Boolean bIsToInsert = true;
    
    	public static final Integer iNumCnt = 1;
    	public static final Integer iNumFC = 1;
        
        public static List<Account> merchantList;
        public static List<Contact> contactList;
        public static List<ER_Financial_Center__c> financialList;
        public static List<ER_Store__c> storeList;
    	public static List<ER_Acceptor__c> acceptorList;
    
        static map<String, map<String, RecordType>> recordTypeMap;
        static List<Account> merchantAcctList;
        static List<ER_Financial_Center__c> financCenterList;
        static List<ER_Bank_Account__c> bankAccList;
        //static List<Contact> contactList;
        //static List<ER_Store__c> storeList;
        //static List<ER_Acceptor__c> acceptorList;
    
    	//public static List<Account> accListWithContact;    
    
    	public static String sErrorJson;
    	public static String[] sResponseSave;

  
        @istest
        public static void TestErrorsBeforeEDG()
        {
                Test.startTest();
            	
            	List<Account> listAcc = createAccountsStandard(iNumAccts, null, bIsToInsert, null, null, null, null);
				System.debug('***' + listAcc[0].Name);
            
                Account newAccount = APHU11_EdgSyncCallout.getAccountWS(listAcc[0].Id);

            	List<Contact> listCnt = createcontactsStandard(iNumCnt, listAcc[0].Id, bIsToInsert, null);
  
  				//APHU11_EdgSyncCallout myCallout = new APHU11_EdgSyncCallout(listAcc[0].Id);
            
            	 Set<Id> lstAccId = new Set<Id>();
        		 lstAccId.add(listAcc[0].Id);
            
            	 merchantList = APHU11_EdgSyncCallout.getMerchants(lstAccId);
            	 
                 Set<Id> cntId = new Set<Id>();
        		 cntId.add(listCnt[0].Id);       		
            
                 contactList = APHU11_EdgSyncCallout.getContacts(cntId);
            	
                 //With null HO Contact 
            	 APHU14_ResponseBeforeEdg myResponse1 = APHU11_EdgSyncCallout.beforeEdg(lstAccId, true); 
            
            	List<ER_Financial_Center__c> listFC =  createFinCentersStandard(iNumFC, listAcc[0].Id, listcnt[0].Id, bIsToInsert, null, Label.LABS_SF_FinancialCenter_Merchant);
         
            
            	List<ER_Bank_Account__c> listBank = createbankAccountsStandard(1, listFC[0].id, true, null); 
            
            	
            	List<ER_Financial_Center__c> listFCwithBank =  createFinCentersStandard(iNumFC, listAcc[0].Id, listcnt[0].Id, bIsToInsert, listBank[0].Id, Label.LABS_SF_FinancialCenter_Merchant);
                
            
            	Set<Id> listFinId = new Set<Id>();
        		listFinId.add(listFCwithBank[0].Id);
            
            	//System.debug('*** Id Financial= ' + listFinId);
            	
            	financialList =  APHU11_EdgSyncCallout.getFinancialCenters(listFinId, ' and ER_Type__c = \'' + Label.LABS_SF_FinancialCenter_Merchant+'\'');
            
            	List<ER_Store__c> listStr =  createstoresStandard(1, listAcc[0].Id, listFC[0].Id, listCnt[0].Id, true);
            
            	Set<Id> listStrId = new Set<Id>();
        		listStrId.add(listStr[0].Id);
               
            	storeList = APHU11_EdgSyncCallout.getStores(listStrId);	
        
          
            	 //Attach Contact Head Office	
            	 List<Account> accListWithContact = UpdateHQContact(lstAccId, cntId);	 
            
                 APHU14_ResponseBeforeEdg myResponse2 = APHU11_EdgSyncCallout.beforeEdg(lstAccId, true);
            
            	 //Aleady existing in OS
            	 //isToUpdate = merchantList[0].HU_Creation_date_in_OS__c != null;    	 
                //UpdateCreationDateInOS(lstAccId);
            	//APHU14_ResponseBeforeEdg myResponse3 = APHU11_EdgSyncCallout.beforeEdg(lstAccId, true);	
            	
                sErrorJson = APHU11_EdgSyncCallout.beforeEdgWS(listAcc[0].Id);
            
                Test.stopTest();
        }
    
     
       @istest
        public static void TestExistingInEDG()
        {
                Test.startTest();
            	
                Date myDate = Date.newInstance(2018, 2, 17);
            	List<Account> listAcc = createAccountsStandard(iNumAccts, null, bIsToInsert, myDate, null, null, null);
				
            	 Set<Id> lstAccId = new Set<Id>();
        		 lstAccId.add(listAcc[0].Id);
            
                 APHU14_ResponseBeforeEdg myResponseExisting = APHU11_EdgSyncCallout.beforeEdg(lstAccId, true);
  
                Test.stopTest();
        }

    
    	 @istest
        public static void TestGoodForEDG()
        {
                Test.startTest();
            	
            	List<Account> listAcc = createAccountsStandard(iNumAccts, '11111111-1-11', bIsToInsert, null, 'Soroksári út 132.', '1095', 'BUDAPEST');
				System.debug('***' + listAcc[0].Name);
            
                Account newAccount = APHU11_EdgSyncCallout.getAccountWS(listAcc[0].Id);
              
            
            	List<Contact> listCnt = createcontactsStandard(iNumCnt, listAcc[0].Id, bIsToInsert, 'Mr.');
   
            
            	//List<ER_Acceptor__c> listAcp = createacceptorsStandard(1, listStr[0].Id, true);
            
				//Set<Id> listAcpId = new Set<Id>();
        		//listAcpId.add(listAcp[0].Id);
            
  				//acceptorList =  APHU11_EdgSyncCallout.getAcceptors(listAcpId);
  
  				APHU11_EdgSyncCallout myCallout = new APHU11_EdgSyncCallout(listAcc[0].Id);
            
            	 Set<Id> lstAccId = new Set<Id>();
        		 lstAccId.add(listAcc[0].Id);
            
            	 merchantList = APHU11_EdgSyncCallout.getMerchants(lstAccId);
            	 
                 Set<Id> cntId = new Set<Id>();
        		 cntId.add(listCnt[0].Id);       		
            
                 contactList = APHU11_EdgSyncCallout.getContacts(cntId);
            	
                 //With null HO Contact 
            	 //APHU14_ResponseBeforeEdg myResponse1 = APHU11_EdgSyncCallout.beforeEdg(lstAccId, true); 
            
            	List<ER_Financial_Center__c> listFC =  createFinCentersStandard(iNumFC, listAcc[0].Id, listcnt[0].Id, bIsToInsert, null, Label.LABS_SF_FinancialCenter_Merchant);
            
            	            
            	//00000000-00000000-0000
            	//30001019-01000006-70670320
            	List<ER_Bank_Account__c> listBank = createbankAccountsStandard(1, listFC[0].id, true, '30001019-01000006-70670320'); 
            
                listFC[0].ER_Bank_Account__c = listBank[0].Id;
            	listFC[0].ER_Contact__c = listCnt[0].Id; 
            	WSHU07_SynchronizeFinancialWS.alreadyExecutedFinancialCenter = true;
            	update listFC;
            
            	//List<ER_Financial_Center__c> listFCwithBank =  createFinCentersStandard(iNumFC, listAcc[0].Id, listcnt[0].Id, bIsToInsert, listBank[0].Id, Label.LABS_SF_FinancialCenter_Merchant);

            	//System.debug('***' + listFCwithBank);
            
            	List<ER_Store__c> listStr =  createstoresStandard(1, listAcc[0].Id, listFC[0].Id, listCnt[0].Id, true);
            
            	Set<Id> listStrId = new Set<Id>();
        		listStrId.add(listStr[0].Id);
               
            	storeList = APHU11_EdgSyncCallout.getStores(listStrId);	
          
            	 //Attach Contact Head Office	
            	 List<Account> accListWithContact = UpdateHQContact(lstAccId, cntId);	 	
            
            	 WSHU09_SynchronizeAcceptorWS.alreadyExecutedAcceptor = true;
            	 List<ER_Acceptor__c> listAcp = createacceptorsStandard(1, listStr[0].Id, true);
            
				Set<Id> listAcpId = new Set<Id>();
        		listAcpId.add(listAcp[0].Id);
            
  				acceptorList =  APHU11_EdgSyncCallout.getAcceptors(listAcpId);	
            
      
            	// Define the Callout mock based on static resources
                /*StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
                mock.setStaticResource('SRHU01_CreateMerchantSuccess');
                mock.setStatusCode(200);
                mock.setHeader('Content-Type', 'application/json');
        
                 Test.setMock(HttpCalloutMock.class, mock);*/
                 //sResponseSave = APHU11_EdgSyncCallout.saveEdgWS(listAcc[0].Id);
                 //System.debug('**** Save Response=' + sResponseSave);	
            
                Test.stopTest();
        }

    
		//RecordTypeId = recordType,
        public static List<Account> createAccountsStandard(Integer numAccts, String sVatNumber, Boolean isToInsert, Date dtCreaInOS, String sShippingStreet, String sShippingPostalCode, String sShippingCity) 
        {
        //OLA Merge Update
        //List<RecordType> lstRecordType = [SELECT Id FROM RecordType Where DeveloperName='ER_Merchant_Account_RT' Limit 1]; 
            
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(
                Name='CANADA HOTEL KFT.' + i,
            	ER_VAT_Number__c = sVatNumber,
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ER_Company_Account_RT').getRecordTypeId(),//lstRecordType[0].Id,
            	ER_Status__c = 'Prospect',
                /*BillingStreet = 'Soroksári út 132.', BillingPostalCode = '1095', BillingCity = 'BUDAPEST',*/
                ER_Creation_date_in_OS__c = dtCreaInOS,
                BillingStreet = sShippingStreet, BillingPostalCode = sShippingPostalCode, BillingCity = sShippingCity
            	);
            accts.add(a);
        }
         
         if (isToInsert) {
             WSHU02_SynchronizeMerchantWS.alreadyExecutedAccount = true;
             insert accts;
         } 

        return accts;
    }
    
    
    	//Salutation='Mr.' for working version
        public static List<Contact> createcontactsStandard(Integer numContacts, Id accId, Boolean isToInsert, String sSalutation) {
        List<Contact> contacts = new List<Contact>();
        
        for(Integer i=0;i<numContacts;i++) {
            Contact ct = new Contact(
                Salutation= sSalutation,
                FirstName = 'firstname' + i,
                LastName = 'test' + i,
                AccountId = accId,
                Phone = '+36-1-111-1111',
                Fax = '+36-1-111-1111',
                Email = 'test'+i+'@canadahotel.hu',
                MailingStreet = 'Test Street' + i, 
                MailingCity = 'BUDAPEST', 
                MailingPostalCode = '1095'
            	);
            contacts.add(ct);
        }
         
         if (isToInsert) {
             WSHU10_SynchronizeContactWS.alreadyExecutedContact = true;
             insert contacts;
         } 

        return contacts;
    }
    
        public static List<ER_Financial_Center__c> createFinCentersStandard(Integer numFcenters, Id accId, Id contactId, Boolean isToInsert, Id bankId, String fcType) 
        {
        List<ER_Financial_Center__c> finCenters = new List<ER_Financial_Center__c>();
        
        for(Integer i=0; i<numFcenters ; i++) {
            ER_Financial_Center__c fc = new ER_Financial_Center__c(
                Name='CANADA HOTEL KFT.'+ DateTime.now().getTime() + i,
            	ER_Invoicing_Site__c = true,
                ER_Account_Name__c = accId,
                //ER_Contact__c = contactId,
				ER_Email__c = 'levi.mali@programming-pool.com',
                ER_Street__c = 'Aradi u. 62.',
                ER_City__c = 'Budaörs',
                ER_Zip_Code__c = '2040',
                ER_Country__c = 'HUN',
                ER_Type__c = fcType
            	);
            fc.ER_Bank_Account__c = bankId;
            
            //APHU07_SynchronizeFinancialWS.alreadyExecutedFinancialCenter = true;
            
            finCenters.add(fc);
        }
            
         
         if (isToInsert == true) 
             WSHU07_SynchronizeFinancialWS.alreadyExecutedFinancialCenter = true;
             insert finCenters;


        return finCenters;
    }  

  
    public static List<ER_Acceptor__c> createacceptorsStandard(Integer nbAcceptors, Id storeId, Boolean isToInsert) 
    {
        List<ER_Acceptor__c> acceptors = new List<ER_Acceptor__c>();
      
        for(Integer i=0; i<nbAcceptors; i++) 
        {
            ER_Acceptor__c acceptor = new ER_Acceptor__c(
                Name ='CANDA HOTEL' + i,
                ER_Store__c = storeId,
                ER_Card_Operational_System_ID__c = '15235'
            	);
            acceptors.add(acceptor);
        }
         
         if (isToInsert) {
             WSHU09_SynchronizeAcceptorWS.alreadyExecutedAcceptor = true;
             insert acceptors;
         }

        return acceptors;
    }
    
    
    
    public static List<ER_Store__c> createstoresStandard(Integer numStores, Id accId, Id FinCenterId, Id contId, Boolean isToInsert) {
        List<ER_Store__c> stores = new List<ER_Store__c>();
        
        for(Integer i=0;i<numStores;i++) {
            ER_Store__c store = new ER_Store__c(
                Name ='CANDA HOTEL' + i,
                ER_Merchant__c = accId,
                ER_Financial_Center__c = FinCenterId,
                ER_Contact__c = contId,
                ER_Street__c = 'Test Street' + i, 
                ER_City__c = 'BUDAPEST', 
                ER_Zip_Code__c = '1095'
            	);
            stores.add(store);
        }
         
         if (isToInsert) {
             insert stores;
         } 

        return stores;
    }
    
    
    public static List<ER_Bank_Account__c> createbankAccountsStandard(Integer numBankAccts, Id finCenterId, Boolean isToInsert, String sIban) {
        List<ER_Bank_Account__c> bankAccts = new List<ER_Bank_Account__c>();
        
        for(Integer i=0;i<numBankAccts;i++) {
            ER_Bank_Account__c bankAcc = new ER_Bank_Account__c(
                Name='BNP' + i,
            	ER_Financial_Center__c = finCenterId,
            	ER_Bank_Account_Status__c = 'Open',
                ER_Bank_City__c = 'Paris',
                ER_Bank_Account_Number_Prefix__c = 'FR',
                ER_Bank_Account_Number__c = '14',
                ER_IBAN__c = sIban
            	);
            bankAccts.add(bankAcc);
        }
         
         if (isToInsert) {
             WSHU07_SynchronizeFinancialWS.alreadyExecutedFinancialCenter = true;
             insert bankAccts;
         } 
        return bankAccts;
    }
    
    public static List<Account> UpdateHQContact(Set<Id> sAccIdList, Set<Id> sCntIdList)
    {
       List<Account> myAcc = [Select HU_HQ_Contact__c from Account where Id IN:sAccIdList]; 
       List<Contact> myCnt = [Select Id from Contact where Id IN:sCntIdList];
        
        if(myAcc.Size() == 1)
        {
           if(myCnt.Size() == 1)
           {
              myAcc[0].HU_HQ_Contact__c = myCnt[0].Id;
              update myAcc; 
           }
        }
       return myAcc;
    }
    
     public static List<Account> UpdateCreationDateInOS(Set<Id> sAccIdList)
    {
       List<Account> myAcc = [Select HU_HQ_Contact__c from Account where Id IN:sAccIdList]; 
        
        if(myAcc.Size() == 1)
        {
            Date myDate = Date.newInstance(2018, 2, 17);
			//Date newDate = mydate.addDays(2);
            myAcc[0].ER_Creation_date_in_OS__c = myDate;
            update myAcc; 
        }
      
       return myAcc;
    }
    
    
     static void init() {
        
		/** RecordTypes **/
        recordTypeMap = getRecordTypesBySObject(new List<String>{
                'Account'
            });
        
        System.debug('--- Create Account ---');
        
		/** Merchant Account **/
        merchantAcctList = new List<Account>();
        //OLA MERGE UPDATE
        merchantAcctList.addAll(WSHU02_SynchronizeMerchantWS_Test.createAccountsStandard(1, recordTypeMap.get('Account').get('ER_Company_Account_RT').Id, '12345678-9-12', true));
        
        /** Asociated records
         * Bank Account
         * Contacts (Head Quarter/Financial)
		**/
        
        /* HQ contact /Invoicing contact */
        System.debug('--- Create Contacts ---');
        contactList = new List<Contact>();
        contactList.addAll(WSHU02_SynchronizeMerchantWS_Test.createcontactsStandard(2, merchantAcctList[0].Id, true));
        
        
        /* Update Account */
		System.debug('--- Update Account ---');
        merchantAcctList[0].HU_HQ_Contact__c = contactList[0].Id;
        update merchantAcctList;
        
        
        /* Financial center */
		System.debug('--- Create Financial Center ---');  
        financCenterList = new List<ER_Financial_Center__c>();
        financCenterList.addAll(WSHU02_SynchronizeMerchantWS_Test.createFinCentersStandard(1, merchantAcctList[0].Id, contactList[1].Id, true, Label.LABS_SF_FinancialCenter_Merchant));
        
        
        /* Bank Account */
		System.debug('--- Create bank Account ---'); 
        bankAccList = new List<ER_Bank_Account__c>();
        bankAccList.addAll(WSHU02_SynchronizeMerchantWS_Test.createbankAccountsStandard(1, financCenterList[0].Id, true));
        
        /* Update Account */
		System.debug('--- Update Account ---');
        financCenterList[0].ER_Bank_Account__c = bankAccList[0].Id;
        update financCenterList;

        
        /* Store */
		System.debug('--- Create Account ---');
        storeList = new List<ER_Store__c>();
        storeList.addAll(WSHU02_SynchronizeMerchantWS_Test.createstoresStandard(1, merchantAcctList[0].Id, financCenterList[0].Id, contactList[1].Id, true));
        
        /* Store */
		System.debug('--- Create associated Acceptor ---');
        acceptorList = new List<ER_Acceptor__c>();
        acceptorList.addAll(WSHU02_SynchronizeMerchantWS_Test.createacceptorsStandard(1, storeList[0].Id, true));
	}
    
       /** Return the record types by objet **/
    public static map<String, map<String, RecordType>> getRecordTypesBySObject(List<String> sObjectName){
        map<String, map<String, RecordType>> result = new map<String, map<String, RecordType>>();
        
        List<RecordType> recordTypeList = [
            SELECT Id, Name, DeveloperName, SobjectType
            FROM RecordType
            WHERE SobjectType IN :sObjectName
        ];
        
        for(RecordType aRecordType : recordTypeList){
            
            if(!result.containsKey(aRecordType.SobjectType)){
                result.put(aRecordType.SobjectType, new map<String, RecordType>());
            }
            
            result.get(aRecordType.SobjectType).put(aRecordType.DeveloperName, aRecordType);
        }
        
        return result;
    }


}//Koniec