/*
----------------------------------------------------------------------
-- - Name          : TRER10_ER_StoreAfterInsert
-- - Author        : OLA
-- - Description   :
1 - Create Store line item get all solutions from contract
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Jun-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
trigger TRER10_ER_StoreAfterInsert on ER_Store__c (after insert) {
    
    
    User currentUser =  [select id, ER_bypassTrigger__c from User where id =: UserInfo.getUserId()];
    
    if (APER10_User_Management.canTrigger) {
        System.debug('###:TRER10_ER_StoreAfterInsert after insert Start');
        
        APER14_Store_Management.manageSLIForNewStore(trigger.newMap);
        
        System.debug('###:TRER10_ER_StoreAfterInsert after insert End');
    }
   /* if (!WSCZ01_SynchronizeStoreWS.alreadyExecutedAcceptor) {
        
        for(ER_Store__c store : Trigger.new){
            
            if (store.ER_Business_Unit__c == 'CZ' && !currentUser.ER_bypassTrigger__c){
                
                WSCZ01_SynchronizeStoreWS.updateAddStoreFuture(store.Id);
            }
        }
    }*/

    if(trigger.isinsert && APER10_User_Management.canTrigger)
    { 
        // Create Store to loops related to the new Stores created
        APER21_StoreToLoopManagement.CreatenewStoreToLoopOnStoreInsert(trigger.new);
        
    }
    
}