trigger TRHU02_AccountAfterUpdate on Account(after update) {
    /*
    ----------------------------------------------------------------------
    -- - Name          : TRHU02_AccountAfterUpdate
    -- - Author        : AAB
    -- - Description   : Trigger on Account update (To update the new merchant to EDG)
    -- Maintenance History:
    --
    -- Date         Name                Version     Remarks
    -- -----------  -----------         --------    ---------------------------------------
    -- 02-MAR-2018  AAB                 1.0         Initial version
    -- 19-APR-2018  AAB                 2.0         Add the acceptance point creation (acceptor)
    -- 15-NOV-2018  AAB                 2.1         call update contact if the Head Office contact is changed
    -- 03-May-2019  OLA                 2.0         Merge MC comment lines
    ---------------------------------------------------------------------------------------
    */
    if (APER10_User_Management.canTrigger) {

        System.Debug('### TRHU02_AccountAfterUpdate Start');

        Set <Id> mechandSetToUpdate = new Set <Id> ();
        Set <Id> contactSetToUpdate = new Set <Id> ();
        Set <Id> mechandContractSet = new Set <Id> ();
        Map<Id,Account> accountMap = trigger.newMap;
        Map<Id,Boolean> accountHasMerchantFinancialCenter = new Map<Id,Boolean>();
        /*
        static map <String, map < String, RecordType >> recordTypeMap;


        // RecordTypes
        recordTypeMap = APER01_Account_RelatedClient.getRecordTypesBySObject(new List < String > {
            'Account'
        });
        */
        //OLA Merge MC 03052019
        for(ER_Financial_Center__c fc : [Select id, ER_Type__c, ER_Account_Name__c From ER_Financial_Center__c where ER_Account_Name__c IN : accountMap.keySet() and ER_Type__c =: Label.LABS_SF_FinancialCenter_Merchant ]){

            accountHasMerchantFinancialCenter.put(fc.ER_Account_Name__c,true);
        }

        if (!WSHU02_SynchronizeMerchantWS.alreadyExecutedAccount) {
            // Loop through the Account lists and add the necessary account to the set
            for (Account acc : accountMap.values()) {

                System.debug('accountHasMerchantFinancialCenter : '+acc.Id+' : '+accountHasMerchantFinancialCenter.get(acc.Id));
                if (acc.ER_Creation_date_in_OS__c != null && accountHasMerchantFinancialCenter.get(acc.Id)==true && acc.ER_Business_Unit__c == 'HU') {
                    mechandSetToUpdate.add(acc.Id);

                    Account oldAccount = Trigger.oldMap.get(acc.ID);

                    /* check if the Head office contact had been changed */
                    if (acc.HU_HQ_Contact__c != oldAccount.HU_HQ_Contact__c) {
                        contactSetToUpdate.add(acc.HU_HQ_Contact__c);
                    }
                }
            }
        }

        /*if (!mechandContractSet.isEmpty()) {
            APHU04_SynchronizeContractWS.addContractsFuture(mechandSet);
        }*/


        if (!mechandSetToUpdate.isEmpty()) {
            WSHU02_SynchronizeMerchantWS.updateMerchantsFuture(mechandSetToUpdate);
        }

        if (!contactSetToUpdate.isEmpty()) {
            WSHU10_SynchronizeContactWS.updateContactsFuture(contactSetToUpdate, null, false);
        }
        System.Debug('### TRHU02_AccountAfterUpdate End');
    }
}