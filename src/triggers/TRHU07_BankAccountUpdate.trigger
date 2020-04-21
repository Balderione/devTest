trigger TRHU07_BankAccountUpdate on ER_Bank_Account__c(after update) {
    /*
    ----------------------------------------------------------------------
    -- - Name          : TRHU01_FinancialCenterAfterUpdate 
    -- - Author        : AAB
    -- - Description   : Trigger on Financial Center update (To create/update the Financial center through EDG)        
    -- Maintenance History:
    --
    -- Date         Name                Version     Remarks 
    -- -----------  -----------         --------    ---------------------------------------
    -- 24-JULY-2018  AAB                 1.0         Initial version
    ---------------------------------------------------------------------------------------
    */

    System.Debug('--- APHU07_SynchronizeFinancialWS begin prepare');

    Set <Id> financialSetToUpdate = new Set <Id> ();
    
    static map <String, map < String, RecordType >> recordTypeMap;

    if (!WSHU07_SynchronizeFinancialWS.alreadyExecutedFinancialCenter) {
        // Loop through the Financial Center lists and add the necessary invoice center to the set
        for (ER_Bank_Account__c fc: trigger.new) {
            if (fc.ER_Business_Unit__c == 'HU'){
                financialSetToUpdate.add(fc.ER_Financial_Center__c);
            }
        }
    }

    System.Debug('--- APHU07_SynchronizeFinancialWS end prepare');
    
    /* Bypass the trigger */
    User currentUser =  [select id, ER_bypassTrigger__c from User where id =: UserInfo.getUserId()];
    
    if (!financialSetToUpdate.isEmpty() && !currentUser.ER_bypassTrigger__c) {
        WSHU07_SynchronizeFinancialWS.addupdateFinancialCentersFuture(financialSetToUpdate);
    }
}