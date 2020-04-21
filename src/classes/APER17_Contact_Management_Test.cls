/*
----------------------------------------------------------------------
-- - Name          : APER17_Contact_Management_Test
-- - Author        : OLA
-- - Description   : TEST for Contact Management class
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Aug-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
@isTest
public class APER17_Contact_Management_Test {
    
    @testSetup
    static void testSetup() {
        
        Account newMerchantAccount = APER07_UtilityTestMethod.getCompany('APER17_Contact_Management_Test');
        newMerchantAccount.Name='APER17_Contact_Management_Test';
        insert newMerchantAccount;
        
        Contact contactTest = APER07_UtilityTestMethod.getContact('ER_Contact_RT','Test','APER17_Contact_Management_Test');
        contactTest.AccountId = newMerchantAccount.Id;
        contactTest.email = 'APER17_Contact_Management_Test@edenred.com';
        contactTest.ER_Account_Address_Sync__c = LAbel.LABS_SF_Account_SyncAddressContact ;
        insert contactTest;
    }
    
    static testMethod void syncAddressFromAccount() {
        
        List<Account> accList = [select id from Account where Name='APER17_Contact_Management_Test'];
        if(!accList.isEmpty()){
            
            accList[0].BillingStreet = 'APER17_Contact_Management Street';
            update accList[0];
        }
    }
}