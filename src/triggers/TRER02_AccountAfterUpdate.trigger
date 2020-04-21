trigger TRER02_AccountAfterUpdate on Account (after update) {
    /*
----------------------------------------------------------------------
-- - Name          : TRER02_AccountAfterUpdate
-- - Author        : OLA
-- - Description   : Trigger on Account after 
						1- check if the address changed and the field Account address sync is flaged,
						   if so update all contact (linked to the account) addresses 
-- Maintenance History:
--
-- Date         		Name             Version     				Remarks
-- -----------  	-----------         --------    ---------------------------------------
-- 28-August-2019  		OLA               1.0         			Initial version
---------------------------------------------------------------------------------------
*/
    if (APER10_User_Management.canTrigger) {
        
        System.debug('### TRER02_AccountAfterUpdate Start');
        Map<id,Account> newAccountMap = trigger.newMap;
        Map<id,Account> oldAccountMap = trigger.oldMap;
        
        Map<id,Account> accountMapToSyncAddress = new Map<id,Account>();
        
        // Loop through the Account lists and add the necessary account to the set
        for (Account acc : newAccountMap.values()) {
            
            if ((acc.BillingStreet != oldAccountMap.get(acc.id).BillingStreet || acc.BillingPostalCode != oldAccountMap.get(acc.id).BillingPostalCode || acc.BillingCity != oldAccountMap.get(acc.id).BillingCity || acc.BillingCountry != oldAccountMap.get(acc.id).BillingCountry || acc.BillingPostalCode != oldAccountMap.get(acc.id).BillingPostalCode )) {
                
               accountMapToSyncAddress.put(acc.id, acc);
            }
        }
        
        if(!accountMapToSyncAddress.isEmpty()){
            
            APER17_Contact_Management.syncAddressFromAccount(accountMapToSyncAddress);
        }
        
        System.debug('### TRER02_AccountAfterUpdate End');
    }
}