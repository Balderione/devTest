public with sharing class APER03_Lead_CreateFinancialCenter {
/*
----------------------------------------------------------------------
-- - Name          : APER03_Lead_CreateFinancialCenter
-- - Author        : AAB
-- - Description   : Process the Financial Center creation on lead conversion       
-- Maintenance History:
--
-- Date         Name                Version     Remarks 
-- -----------  -----------         --------    ---------------------------------------
-- 16-JUL-2018  AAB                 1.0         Initial version
-- 17-JUL-2018  AAB                 2.0         Add the related store creation
-- 29-APR-2019  OLA                 2.1         Add Financial center type condition
---------------------------------------------------------------------------------------
*/

public static void createFinancialCenter(List<Lead> listOflead) {
    List<ER_Financial_Center__c> financialC = new List<ER_Financial_Center__c>();
    List<ER_Store__c> listofStore = new List<ER_Store__c>();
    Database.SaveResult sr;
    Database.SaveResult sr1;
    String financialCenterType;

    APER05_DoNotRunTrigger donotRunTrigger = new  APER05_DoNotRunTrigger();
    donotRunTrigger.setDoNotRunTrigger();  

    for (Lead ld : listOflead) {

            //OLA Add New Conditions for Type. 29042019
            if(ld.recordTypeId == Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ER_Merchant_Lead_RT').getRecordTypeId()){
                financialCenterType = Label.LABS_SF_FinancialCenter_Merchant;
                //////// Update the address of the account with the custom address of the lead
                Account AccConverted = new Account();
                AccConverted.Id = ld.ConvertedAccountId;
                AccConverted.BillingStreet = ld.ER_Legal_Street__c;
                AccConverted.BillingCity = ld.ER_Legal_City__c;
                AccConverted.BillingCountry = ld.ER_Legal_Country__c;
                AccConverted.BillingPostalCode = ld.ER_Legal_Zip_Code__c;
                AccConverted.BillingState = ld.ER_Legal_State_Province__c;
                update AccConverted;
                ////////
            }
            else if(ld.recordTypeId == Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ER_Client_Lead_RT').getRecordTypeId()){
                financialCenterType = Label.LABS_SF_FinancialCenter_Client;
            }

            ER_Financial_Center__c myFinancialCenter = new ER_Financial_Center__c(Name = ld.Company,
             ER_Account_Name__c = ld.ConvertedAccountId,                         
             ER_Street__c = ld.Street,
             ER_City__c = ld.City,
             ER_Zip_Code__c = ld.PostalCode ,
             ER_Country__c = ld.Country,
             ER_Invoicing_Site__c = true,
             ER_Type__c = financialCenterType);
            
            
            // Insert the "Financial Center"
            sr = Database.insert(myFinancialCenter, false);
            
            ER_Store__c mystore = null;

            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('The batch has been successfully proceed. Financial Center ID: ' + sr.getId());
                
                if (myFinancialCenter.ER_Type__c == Label.LABS_SF_FinancialCenter_Merchant) {

                    mystore = new ER_Store__c(Name = ld.ER_Store_Name__c != null ? ld.ER_Store_Name__c : ld.Company,
                        ER_Merchant__c = ld.ConvertedAccountId,
                        ER_Financial_Center__c = myFinancialCenter.Id,
                        ER_Street__c = ld.Street,
                        ER_City__c = ld.City,
                        ER_Zip_Code__c = ld.PostalCode ,
                        ER_Country__c = ld.Country);

                    // Insert the "Financial Center"
                    sr1 = Database.insert(mystore, false);

                    System.debug('The batch has been successfully proceed. Store Center ID: ' + sr.getId() + mystore);
                     ER_Acceptor__c myAcceptor = null;

                    if (sr1.isSuccess() && ld.ER_Terminal__c == 'Yes') {

                        myAcceptor = new ER_Acceptor__c(Name = mystore.Name, ER_Store__c = mystore.Id,
                        ER_AID__c = ld.ER_AID__c,
                        ER_AID_Authorization__c = ld.ER_AID_Authorization__c,
                        ER_AID_Clearing__c = ld.ER_AID_Clearing__c,
                        ER_MCC_Authorization__c = ld.ER_MCC_Authorization__c,
                        ER_MCC_Clearing__c = ld.ER_MCC_Clearing__c, 
                        ER_MID__c = ld.ER_MID__c,
                        ER_MID_Authorization__c = ld.ER_MID_Authorization__c,
                        ER_MID_Clearing__c = ld.ER_MID_Clearing__c,
                        ER_MID_AID__c = ld.ER_MID_AID__c,
                        ER_SubMID_Authorization__c = ld.ER_Sub_MID_Authorization__c,
                        ER_Sub_MID_Clearing__c = ld.ER_Sub_MID_Clearing__c, 
                        ER_TID_Authorization__c = ld.ER_TID_Authorization__c,
                        ER_TID_Clearing__c = ld.ER_TID_Clearing__c
                        );

                        sr1 = Database.insert(myAcceptor, false);
                        myAcceptor = null; 
                    }

                }
            }
            
            myFinancialCenter = null;



            
        }
    }
}