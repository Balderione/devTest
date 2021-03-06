@isTest
public class WSHU02_SynchronizeMerchantWS_Test {
/*
----------------------------------------------------------------------
-- - Name          : WSHU02_SynchronizeMerchantWS_Test
-- - Author        : AAB
-- - Description   : Test class related to the Apex classes cited below
					- APHU02_SynchronizeMerchantWS
-- Maintenance History:
--
-- Date         Name  				Version  	Remarks 
-- -----------  ----------- 		--------  	---------------------------------------
-- 05-MAR-2018  AAB    				1.0      	Initial version
---------------------------------------------------------------------------------------
*/
    

    
    public static List<ER_Acceptor__c> createacceptorsStandard(Integer numaAcceptors, Id storeId, Boolean isToInsert) {
        List<ER_Acceptor__c> acceptors = new List<ER_Acceptor__c>();
        
        for(Integer i=0;i<numaAcceptors;i++) {
            ER_Acceptor__c acceptor = new ER_Acceptor__c(
                Name ='CANDA HOTEL' + i,
                ER_Store__c = storeId,
                ER_Card_Operational_System_ID__c = '15235',
                ER_MID_Authorization__c = '12091993'
            	);
            acceptors.add(acceptor);
        }
         
         if (isToInsert) {
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
    
    
    
    public static List<Contact> createcontactsStandard(Integer numContacts, Id accId, Boolean isToInsert) {
        List<Contact> contacts = new List<Contact>();
        
        for(Integer i=0;i<numContacts;i++) {
            Contact ct = new Contact(
                Salutation='Mr.',
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
             insert contacts;
         } 

        return contacts;
    }
    
    
    
    
    public static List<ER_Bank_Account__c> createbankAccountsStandard(Integer numBankAccts, Id finCenterId, Boolean isToInsert) {
        List<ER_Bank_Account__c> bankAccts = new List<ER_Bank_Account__c>();
        
        for(Integer i=0;i<numBankAccts;i++) {
            ER_Bank_Account__c bankAcc = new ER_Bank_Account__c(
                Name='BNP' + i,
            	ER_Financial_Center__c = finCenterId,
            	ER_Bank_Account_Status__c = 'Open',
                ER_Bank_City__c = 'Paris',
                ER_Bank_Account_Number_Prefix__c = 'FR',
                ER_Bank_Account_Number__c = '14',
                ER_IBAN__c = '30001019-01000006-70670320'
            	);
            bankAccts.add(bankAcc);
        }
         
         if (isToInsert) {
             insert bankAccts;
         } 

        return bankAccts;
    }
    
    public static List<ER_Financial_Center__c> createFinCentersStandard(Integer numFcenters, Id accId, Id contactId, Boolean isToInsert, String fcType) {
        List<ER_Financial_Center__c> finCenters = new List<ER_Financial_Center__c>();
        
        for(Integer i=0; i<numFcenters ; i++) {
            ER_Financial_Center__c fc = new ER_Financial_Center__c(
                Name='CANADA HOTEL KFT.' + i,
            	ER_Invoicing_Site__c = true,
                ER_Account_Name__c = accId,
                ER_Contact__c = contactId,
				ER_Email__c = 'levi.mali@programming-pool.com',
                ER_Street__c = 'Aradi u. 62.',
                ER_City__c = 'Budaörs',
                ER_Zip_Code__c = '2040',
                ER_Country__c = 'HUN',
                ER_Type__c = fcType
            	);
            finCenters.add(fc);
        }
         
         if (isToInsert) {
             insert finCenters;
         } 

        return finCenters;
    }
    
    
    
    
     public static List<Account> createAccountsStandard(Integer numAccts, Id recordType, String vatNumber, Boolean isToInsert) {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(
                Name='CANADA HOTEL KFT.' + i,
            	RecordTypeId = recordType,
            	ER_VAT_Number__c = vatNumber,
            	ER_Status__c = 'Prospect',
                BillingStreet = 'Soroksári út 132.', BillingCity = 'BUDAPEST', BillingPostalCode = '1095',
                ShippingStreet = 'Soroksári út 132.', ShippingCity = 'BUDAPEST', ShippingPostalCode = '1095'
            	);
            accts.add(a);
        }
         
         if (isToInsert) {
             insert accts;
         } 

        return accts;
    }
}