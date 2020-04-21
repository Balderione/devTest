public class APER17_Contact_Management {
/*
----------------------------------------------------------------------
-- - Name          : APER17_Contact_Management
-- - Author        : OLA
-- - Description   : Contact Management, This class is used to group all the functionnality linked to the object Contact
--
-- Date         Name                Version     				Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Aug-2019       OLA                1.0         			Initial version
---------------------------------------------------------------------------------------
*/
    
    public static void syncAddressFromAccount(Map<id,Account> accountMap) {
        
        List<Contact> contactToUpdate = new List<Contact>();
        
        for(Contact cont : [select id,accountId from Contact where accountId in : accountMap.keyset() and ER_Account_Address_Sync__c =: Label.LABS_SF_Account_SyncAddressContact and ER_Status__c !=: Label.LAB_SF_Contact_Inactive]){
            
            cont.MailingStreet = accountMap.get(cont.accountId).BillingStreet;
            cont.MailingPostalCode = accountMap.get(cont.accountId).BillingPostalCode;
            cont.MailingCity = accountMap.get(cont.accountId).BillingCity;
            cont.MailingCountry = accountMap.get(cont.accountId).BillingCountry;
            cont.MailingPostalCode = accountMap.get(cont.accountId).BillingPostalCode;
            
            contactToUpdate.add(cont);
        }
        if(!contactToUpdate.isEmpty()){
            
            System.debug('###APER17_Contact_Management syncAddressFromAccount contactToUpdate : '+contactToUpdate);
            update contactToUpdate;
        }
    }  
}