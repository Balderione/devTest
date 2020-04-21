/*
----------------------------------------------------------------------
-- - Name          : TRER10_ER_StoreBeforeUpdate
-- - Author        : OLA
-- - Description   :
1 - Check Solutions Count : if empty ==> disable Store
							else    ==> enable Store
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Jun-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
trigger TRER10_ER_StoreBeforeUpdate on ER_Store__c (before update) {

    if (APER10_User_Management.canTrigger) {

    	Map<id,ER_Store__c> newStores = trigger.newMap;
    	Map<id,ER_Store__c> oldStores = trigger.oldMap;

    	List<ER_Store__c> storeToEnable = new List<ER_Store__c>();
    	List<ER_Store__c> storeToDisable = new List<ER_Store__c>();

        System.debug('###:TRER10_ER_StoreBeforeUpdate before update Start');
        
        for(ER_Store__c store : newStores.values()){

        	if(oldStores.get(store.Id).ER_Solution_Count__c!=0 && store.ER_Solution_Count__c==0){
        		storeToDisable.add(store);
        	}
        	else if(oldStores.get(store.Id).ER_Solution_Count__c==0 && store.ER_Solution_Count__c!=0){
        		storeToEnable.add(store);
        	}
        }
        

        if(!storeToEnable.isEmpty()){

        	System.debug('###:storeToEnable : '+storeToEnable);
        	APER14_Store_Management.enableStores(storeToEnable);
        }

        if(!storeToDisable.isEmpty()){

        	System.debug('###:storeToDisable : '+storeToDisable);
        	APER14_Store_Management.disableStores(storeToDisable);
        }
        System.debug('###:TRER10_ER_StoreBeforeUpdate before update End');
    }
}