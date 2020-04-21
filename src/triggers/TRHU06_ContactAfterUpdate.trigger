trigger TRHU06_ContactAfterUpdate on Contact (after update) {
    /*
    ----------------------------------------------------------------------
    -- - Name          : TRHU06_ContactAfterUpdate 
    -- - Author        : AAB
    -- - Description   : Trigger on Contact update (To update the Contact through EDG)        
    -- Maintenance History:
    --
    -- Date         Name                Version     Remarks 
    -- -----------  -----------         --------    ---------------------------------------
    -- 08-JUN-2018  AAB                 1.0         Initial version
    ---------------------------------------------------------------------------------------
    */

    System.Debug('--- APHU10_SynchronizeContactWS begin prepare');

    Set <Id> contactSetToUpdate = new Set <Id> ();
    
    static map <String, map < String, RecordType >> recordTypeMap;

    if (!WSHU10_SynchronizeContactWS.alreadyExecutedContact) {
        // Loop through the contacts list and add them all to the set
        for (Contact ct: trigger.new) {
            if (ct.ER_Business_Unit__c == 'HU') {
                contactSetToUpdate.add(ct.Id);
            }
        }
    }

    System.Debug('--- APHU10_SynchronizeContactWS end prepare');
    
    /* Bypass the trigger */
    User currentUser =  [select id, ER_bypassTrigger__c from User where id =: UserInfo.getUserId()];
        
    if (!contactSetToUpdate.isEmpty() && !currentUser.ER_bypassTrigger__c) {
        WSHU10_SynchronizeContactWS.updateContactsFuture(contactSetToUpdate, null, false);
    }
}