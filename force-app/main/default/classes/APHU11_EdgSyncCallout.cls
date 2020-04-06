public with sharing class APHU11_EdgSyncCallout {

    public static Boolean isToUpdate = false;
  
    /* All Salesforce attributes */
    public static List <Account> merchantList;
    public static List <ER_Financial_Center__c> financialC;
    public static List <ER_Store__c> storeList;
    public static List <Contact> contactList;

    //public static List <wrapFinancialCenter> financialCW;
    public static String merchantID;
    public static List<String> responseToshow =  new List<String>();
    
    //public static List<APHU12_BeforeEdgEntity> oErrors =  new List<APHU12_BeforeEdgEntity>();
    
    
    // Contructor needed for data initialization for the queuing
    public APHU11_EdgSyncCallout (String myId) {
        merchantID = myId;
        
    }
  
    @AuraEnabled
    public static String beforeEdgWS(Id merchantId) {
        Set<Id> listofMerchant = new Set<Id>();
        listofMerchant.add(merchantId);
        
        System.debug('-- APHU11_EdgSyncCallout listofMerchant : ' + listofMerchant);

        String sJson = JSON.serialize(beforeEdg(listofMerchant, true));
        System.debug('-- APHU11_EdgSyncCallout Json bafore Edg: ' + sJson);
        return sJson; 
    }
    
    @AuraEnabled
    public static String[] saveEdgWS(Id merchantId) {
        
        Set<Id> listofMerchant = new Set<Id>();
        listofMerchant.add(merchantId);    
        System.debug('-- APHU11_EdgSyncCallout listofMerchant : ' + listofMerchant);
        
        //Call Ahmada's function! Yeah!
        return WSHU02_SynchronizeMerchantWS.addUpdateMerchants(listofMerchant, true);
    }

            
    public static APHU14_ResponseBeforeEdg beforeEdg(Set<Id> merchantId, Boolean fromAura) {
        System.debug('--- There are '+ merchantId.size() +  ' merchants triggered, which are' );
        System.debug('--- merchantIds : ' + merchantId);   
        
        //System.debug('-- APHU11_EdgSyncCallout listofMerchant : ' + listofMerchant);
        
        APHU14_ResponseBeforeEdg beforeEdg = new APHU14_ResponseBeforeEdg();
        beforeEdg.count = 0;
        beforeEdg.existing = false;
        
        List<APHU13_ErrorBeforeEdg> listError =  new List<APHU13_ErrorBeforeEdg>();
        merchantList = APHU11_EdgSyncCallout.getMerchants(merchantId);
        
        isToUpdate = merchantList[0].ER_Creation_date_in_OS__c != null;
        System.debug('--- Merchant already created in OS : ' + (merchantList[0].ER_Creation_date_in_OS__c != null));

        //AKO checking before EDG Save
        if (isToUpdate == false && fromAura == true) {
            //**********Billing-LEGAL********
            if(merchantList[0].BillingStreet == null)
            {
                APHU13_ErrorBeforeEdg rowAccStreet = new APHU13_ErrorBeforeEdg();     
                rowAccStreet.sObjName = 'Account';
                rowAccStreet.sName = merchantList[0].Name; 
                rowAccStreet.sMessage  = 'Legal Street is empty'; 
                rowAccStreet.sLink = '/lightning/r/Account/' + merchantList[0].Id +'/view';
                rowAccStreet.sSection = 'Address Information-Legal Address';   
                listError.add(rowAccStreet);
                beforeEdg.count = beforeEdg.count + 1;
            }
            
            if(merchantList[0].BillingPostalCode == null)
            {
                APHU13_ErrorBeforeEdg rowAccZip = new APHU13_ErrorBeforeEdg();     
                rowAccZip.sObjName = 'Account';
                rowAccZip.sName = merchantList[0].Name; 
                rowAccZip.sMessage  = 'Legal Zip/Postal Code is empty'; 
                rowAccZip.sLink = '/lightning/r/Account/' + merchantList[0].Id +'/view';
                rowAccZip.sSection = 'Address Information-Legal Address';   
                listError.add(rowAccZip);
                beforeEdg.count = beforeEdg.count + 1;
            }
            
             if(merchantList[0].BillingCity== null)
            {
                APHU13_ErrorBeforeEdg rowAccCity = new APHU13_ErrorBeforeEdg();     
                rowAccCity.sObjName = 'Account';
                rowAccCity.sName = merchantList[0].Name; 
                rowAccCity.sMessage  = 'Legal City is empty'; 
                rowAccCity.sLink = '/lightning/r/Account/' + merchantList[0].Id +'/view';
                rowAccCity.sSection = 'Address Information-Legal Address';   
                listError.add(rowAccCity);
                beforeEdg.count = beforeEdg.count + 1;
            }
            
            System.debug('*** VAT Number = ' + merchantList[0].ER_VAT_Number__c);
            
             if(merchantList[0].ER_VAT_Number__c == null)
            {
                APHU13_ErrorBeforeEdg rowAccVAT = new APHU13_ErrorBeforeEdg();     
                rowAccVAT.sObjName = 'Account';
                rowAccVAT.sName = merchantList[0].Name; 
                rowAccVAT.sMessage  = 'VAT Number is empty'; 
                rowAccVAT.sLink = '/lightning/r/Account/' + merchantList[0].Id +'/view';
                rowAccVAT.sSection = 'Account Information';   
                listError.add(rowAccVAT);
                beforeEdg.count = beforeEdg.count + 1;
            }
            
            //**********HEAD QUARTER CONTACT*************** 
            if (merchantList[0].HU_HQ_Contact__c == null) {
               //The Head Quarter contact is missing on Account ! 
                APHU13_ErrorBeforeEdg rowFinA1 = new APHU13_ErrorBeforeEdg();     
                rowFinA1.sObjName = 'Account';
                rowFinA1.sName = merchantList[0].Name; 
                rowFinA1.sMessage  = 'No Head Office Contact attached to Account'; 
                rowFinA1.sLink = '/lightning/r/Account/' + merchantList[0].Id +'/view';
                rowFinA1.sSection = 'Address Information';   
                listError.add(rowFinA1);
                beforeEdg.count = beforeEdg.count + 1;
            }
            
            System.debug('*** HQ Contact=' +  merchantList[0].HU_HQ_Contact__c);
            if (merchantList[0].HU_HQ_Contact__c != null && merchantList[0].HU_HQ_Contact__r.Salutation == null) 
            {
                System.debug('*** Salutations' +  merchantList[0].HU_HQ_Contact__r.Salutation);
                APHU13_ErrorBeforeEdg rowCntSalutation = new APHU13_ErrorBeforeEdg();     
                rowCntSalutation.sObjName = 'Contact';
                rowCntSalutation.sName = merchantList[0].HU_HQ_Contact__r.FirstName + ' ' + merchantList[0].HU_HQ_Contact__r.LastName; 
                rowCntSalutation.sMessage  = 'Salutations are empty on Head Office Contact'; 
                rowCntSalutation.sLink = '/lightning/r/Contact/' + merchantList[0].HU_HQ_Contact__r.Id +'/view';
                rowCntSalutation.sSection = 'Contact Information-(Name Zone)';   
                listError.add(rowCntSalutation);
                beforeEdg.count = beforeEdg.count + 1;  
            }

 
            //**********FINANCIAL CENTER
            financialC = APHU11_EdgSyncCallout.getFinancialCenters(merchantId, ' and ER_Type__c = \'' + Label.LABS_SF_FinancialCenter_Merchant+'\''); /* is null for simple */
             Set<Id> myFinCIds = new Set<Id>();
      
            //System.debug('--- The number of Financial center related to the merchant (At least one) : ' + financialC.size());
            
            if (financialC.size() == 0){
                //Financial Center not related to Account       
                APHU13_ErrorBeforeEdg rowFinA0 = new APHU13_ErrorBeforeEdg();     
                rowFinA0.sObjName = 'Account';
                rowFinA0.sName = merchantList[0].Name; 
                rowFinA0.sMessage  = 'No Merchant Financial Center related to Account'; 
                rowFinA0.sLink = '/lightning/r/Account/' + merchantList[0].Id +'/view';
                rowFinA0.sSection = 'Financial Center not related to Account';   
                listError.add(rowFinA0);
                beforeEdg.count = beforeEdg.count + 1;
            }
           
  

            if (financialC.size() > 0)
            {
            for (ER_Financial_Center__c financialCe: financialC) 
            {
                myFinCIds.add(financialCe.Id);
                
                
                if (financialCe.ER_Contact__c == null){
                    //responseToshow.add('Contact is missing on Financial Center !');
                     APHU13_ErrorBeforeEdg rowFin1 = new APHU13_ErrorBeforeEdg();     
                     rowFin1.sObjName = 'Financial Center';
                     rowFin1.sName = financialCe.Name; 
                     rowFin1.sMessage  = 'Contact is missing on Financial Center'; 
                     rowFin1.sLink = '/lightning/r/ER_Financial_Center__c/' + financialCe.Id +'/view';
                     rowFin1.sSection = 'Information';   
                     listError.add(rowFin1);
                     beforeEdg.count = beforeEdg.count + 1;   
                }
                
                if (financialCe.ER_Contact__c != null && financialCe.ER_Contact__r.Salutation == null) 
                {
                    APHU13_ErrorBeforeEdg rowCntSalutationInv = new APHU13_ErrorBeforeEdg();     
                    rowCntSalutationInv.sObjName = 'Contact';
                    rowCntSalutationInv.sName = financialCe.ER_Contact__r.FirstName + ' ' + financialCe.ER_Contact__r.FirstName; 
                    rowCntSalutationInv.sMessage  = 'Salutations are empty on FC Contact'; 
                    rowCntSalutationInv.sLink = '/lightning/r/Contact/' + financialCe.ER_Contact__c +'/view';
                    rowCntSalutationInv.sSection = 'Contact Information-(Name Zone)';   
                    listError.add(rowCntSalutationInv);
                    beforeEdg.count = beforeEdg.count + 1;  
                }
                
                if (financialCe.ER_Bank_Account__c == null)
                {
                    //responseToshow.add('Bank Account is missing on Financial Center !');
                     APHU13_ErrorBeforeEdg rowFin2 = new APHU13_ErrorBeforeEdg();     
                     rowFin2.sObjName = 'Financial Center';
                     rowFin2.sName = financialCe.Name; 
                     rowFin2.sMessage  = 'Bank Account is missing on Financial Center'; 
                     rowFin2.sLink = '/lightning/r/ER_Financial_Center__c/' + financialCe.Id +'/view';
                     rowFin2.sSection = 'Information';   
                     listError.add(rowFin2);
                     beforeEdg.count = beforeEdg.count + 1; 
                }
                
                System.debug('*** Bank Account = ' + financialCe.ER_Bank_Account__c);
                if (financialCe.ER_Bank_Account__c != null)
                {
                    if(financialCe.ER_Bank_Account__r.ER_IBAN__c == null){
                   //responseToshow.add('IBAN is missing on Bank Account: [' + financialCe.ER_Bank_Account__r.Name  + '] attached to Financial Center !');
                    
                     APHU13_ErrorBeforeEdg rowIBAN = new APHU13_ErrorBeforeEdg();     
                     rowIBAN.sObjName = 'Bank Account';
                     rowIBAN.sName = financialCe.ER_Bank_Account__r.Name; 
                     rowIBAN.sMessage  = 'IBAN is empty'; 
                     rowIBAN.sLink = '/lightning/r/ER_Bank_Account__c/' + financialCe.ER_Bank_Account__r.Id +'/view';
                     rowIBAN.sSection = 'Bank Account Detail';   
                     listError.add(rowIBAN);
                     beforeEdg.count = beforeEdg.count + 1;   
                     //oErrors.add(element)
                    }
                }
               
            }//end for 
            
               
         
            }//test for zero financial center
            
             
        }
        else if (isToUpdate == true && fromAura == true){
            //The merchand had been already created
            APHU13_ErrorBeforeEdg rowAcc1 = new APHU13_ErrorBeforeEdg();     
            rowAcc1.sObjName = 'Account';
            rowAcc1.sName = merchantList[0].Name; 
            rowAcc1.sMessage  = 'Already created in OS'; 
            rowAcc1.sLink = '/lightning/r/Account/' + merchantList[0].Id +'/view';
            rowAcc1.sSection = 'Creation date in OS - ' + merchantList[0].ER_Creation_date_in_OS__c;    
            listError.add(rowAcc1);
            beforeEdg.count = beforeEdg.count + 1;
            // ***** Very important : Existing true***
            beforeEdg.existing = true;
        }
        System.debug('--- Check for Errors before EDG :' + beforeEdg);  
        beforeEdg.data = listError;     
        return beforeEdg;
    }
    
    
    // retrieve account list
    public static List<Account> getMerchants(Set <Id> merchantIdList) {
        String soql = 
            'SELECT Id,ER_BUPicklist__c,ER_Registration_Number__c, Name, ER_Card_Operational_System_ID__c, ER_Paper_Operational_System_ID__c, ' + 
            'Industry, ER_VAT_Number__c, CreatedDate, CreatedById, ER_Status__c, ' +
            
            /* HQ contact information */
            'HU_HQ_Contact__c, ' +
            'HU_HQ_Contact__r.Email, HU_HQ_Contact__r.Phone, HU_HQ_Contact__r.MobilePhone, HU_HQ_Contact__r.Fax, ' +
            'HU_HQ_Contact__r.FirstName, HU_HQ_Contact__r.LastName,HU_HQ_Contact__r.ER_Business_Unit_2__c,HU_HQ_Contact__r.CZ_AcademicTitle__c, HU_HQ_Contact__r.Salutation, ' +
            'HU_HQ_Contact__r.MailingStreet, HU_HQ_Contact__r.MailingCity, HU_HQ_Contact__r.MailingPostalCode, ' +
            'HU_HQ_Contact__r.MailingCountry, HU_HQ_Contact__r.MailingLatitude, HU_HQ_Contact__r.MailingLongitude, ' +
            
            'ER_Creation_date_in_OS__c, ER_Last_date_of_Sync__c, ' +
            
            'BillingStreet, BillingCity, BillingPostalCode, ' +
            'BillingCountry, BillingLatitude, BillingLongitude ' +
            'FROM Account ' +
            'WHERE Id IN: merchantIdList';
        
        return Database.query(soql);
    }
  
    
    // retrieve contact list
    public static List <Contact> getContacts(Set <Id> contactsIdList) {
        String soql = 
            'SELECT Id,ER_Role__c,ER_Business_Unit_2__c,CZ_AcademicTitle__c,  AccountId, Salutation, ' +
            'Email, Phone, MobilePhone, ' + 
            'Fax, FirstName, ' +
            'LastName, Title, Department, ' +
            'MailingStreet, MailingCity, MailingPostalCode, ' +
            'MailingCountry, MailingLatitude, MailingLongitude ' +
            'FROM Contact ' +
            'WHERE Id IN: contactsIdList';

        return Database.query(soql);
    }
    
    

    // retrieve Store list
    public static List <ER_Store__c> getStores(Set <Id> merchantIdList) {
        
        string firstelement = (new List<Id>(merchantIdList))[0];
        String mycondition = (firstelement.startsWithIgnoreCase('001')) ? 'ER_Merchant__c' : 'ER_Financial_Center__c';
        
        String soql =
            'SELECT Id,ER_Brand__c,CZ_Store_reference__c,CreatedDate,ER_E_Shop__c,ER_Do_not_publish__c,ER_Description__c,ER_Business_Unit__c, ER_Merchant__c, Name, '+
            'ER_Contact__c, ER_Street__c, ER_City__c, ER_Creation_Date_In_OS__c,ER_Latitude_Longitude__Latitude__s,ER_Latitude_Longitude__Longitude__s,'+
            'ER_Zip_Code__c, ER_Financial_Center__c,ER_Financial_Center__r.ER_Creation_date_in_OS__c,ER_Contact__r.ER_Role__c, ER_Contact__r.Fax, '+
            'ER_Contact__r.Email,ER_Contact__r.ER_Business_Unit_2__c,ER_Contact__r.CZ_AcademicTitle__c, ER_Contact__r.Phone, ER_Contact__r.MobilePhone, '+
            'ER_Contact__r.FirstName, ER_Contact__r.LastName, ER_Contact__r.Salutation, '+
            'ER_Contact__r.MailingStreet, ER_Contact__r.MailingCity, ER_Contact__r.MailingPostalCode, '+
            'ER_Contact__r.MailingCountry, ER_Contact__r.MailingLatitude, ER_Contact__r.MailingLongitude, '+
            '( '+
            'SELECT id, Name, ER_MID_Authorization__c, ER_MID_Clearing__c, '+
                'ER_TID_Clearing__c, ER_Card_Operational_System_ID__c '+
                'FROM Acceptors__r) '+
            'FROM ER_Store__c '+
            'WHERE ' + mycondition + ' IN: merchantIdList';
        
        return Database.query(soql);
    }
    
    
    // retrieve acceptor list
    public static List <ER_Acceptor__c> getAcceptors(Set <Id> accpId) {
        return [
            SELECT id, Name, ER_MID_Authorization__c,
                ER_TID_Clearing__c, ER_Card_Operational_System_ID__c, ER_MID_Clearing__c,
                ER_Store__r.ER_Financial_Center__c, ER_Store__r.ER_Merchant__c, ER_Store__r.ER_Creation_Date_In_OS__c,
                ER_Last_date_of_Sync__c, CreatedDate
            FROM ER_Acceptor__c
            WHERE Id IN: accpId
        ];
    }
    
   // retrieve Financial Center list 
   public static List <ER_Financial_Center__c> getFinancialCenters(Set<Id> merchantIdList, String additionalCondition) {
         
       // Convert Set<Id> to Set<String>
       String themerchantId =  ((List<String>)new List<Id>(merchantIdList))[0];
       
       String soql = 'SELECT Id,ER_Business_Unit__c, ER_Account_Name__c, Name, ' +
                        'ER_Bank_Account__c, ER_Contact__c, ER_Street__c, ER_Type__c, ' + 
                        'ER_City__c, ER_Zip_Code__c, ER_Contact__r.Fax, ' +
                        'ER_Card_Operational_System_ID__c, ER_Creation_date_in_OS__c, ' +

                        /* and referenced Bank Account*/
                        'ER_Contact__r.FirstName,ER_Contact__r.ER_Role__c, ER_Contact__r.LastName, ' +
                        'ER_Contact__r.Salutation,ER_Contact__r.ER_Business_Unit_2__c,ER_Contact__r.CZ_AcademicTitle__c, ER_Contact__r.Email, ' +
                        'ER_Contact__r.Phone, ER_Contact__r.MobilePhone, ' +
                        'ER_Contact__r.MailingStreet, ER_Contact__r.MailingCity, ER_Contact__r.MailingPostalCode, ' +
                        'ER_Contact__r.MailingCountry, ER_Contact__r.MailingLatitude, ER_Contact__r.MailingLongitude, ' +

           
                        /* and referenced Bank Account*/
                        'ER_Bank_Account__r.Name, ER_Bank_Account__r.ER_Bank_Name__c, ' +
                        'ER_Bank_Account__r.ER_Bank_Account_Number__c, ER_Bank_Account__r.ER_IBAN__c, ' +
                        'ER_Bank_Account__r.ER_Bank_Account_Number_Prefix__c '+
            
            'FROM ER_Financial_Center__c ' +
            'WHERE ';
       
       /* if an account id or an invoice center id */ 
       if (themerchantId.startsWithIgnoreCase('001')) { /* account id */
           soql += 'ER_Account_Name__c IN: merchantIdList';
       }
       else {
           soql += 'Id IN: merchantIdList';
       }
       soql += additionalCondition;
       
       System.debug('--- Invoice center request : ' + soql);
       
        System.debug('--- Invoice center request : ' + merchantIdList);
       
        return (List<ER_Financial_Center__c>)Database.query(soql);
    }
   
    
    @AuraEnabled
    public static Account getAccountWS(Id accId) {
        return [SELECT Name FROM Account WHERE Id = :accId];
    }
}