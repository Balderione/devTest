trigger TRHU01_FinancialCenterAfterUpdate on ER_Financial_Center__c(after insert, after update) {
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
    -- 15-NOV-2018  AAB                  1.1         call update contact if the contact is changed
    ---------------------------------------------------------------------------------------
    */

    System.Debug('--- WSHU07_SynchronizeFinancialWS begin prepare');

    Set <Id> financialSetToUpdate = new Set <Id> ();
    List<ER_Financial_Center__c> fcContactToUpdate = new List<ER_Financial_Center__c>();
    
    static map <String, map < String, RecordType >> recordTypeMap;

    if (!WSHU07_SynchronizeFinancialWS.alreadyExecutedFinancialCenter) {
        for (ER_Financial_Center__c fc: trigger.new) {
            //if (!(fc.ER_Paper_Operational_System_ID__c != null && fc.ER_Card_Operational_System_ID__c == null) && (fc.ER_Business_Unit__c == 'HU' ||  fc.ER_Business_Unit__c == 'CZ')) {
            if ((!(fc.ER_Paper_Operational_System_ID__c != null && fc.ER_Card_Operational_System_ID__c == null) && fc.ER_Business_Unit__c == 'HU') ||  (fc.ER_Business_Unit__c == 'CZ')) {
                financialSetToUpdate.add(fc.Id);
                
                System.Debug('--- Trigger.isUpdate ' + Trigger.isUpdate);
                
                if (Trigger.isUpdate && fc.ER_Business_Unit__c == 'HU') {
                    ER_Financial_Center__c oldFC = Trigger.oldMap.get(fc.ID);
                    
                    System.Debug('--- is updated contact new ' + fc.ER_Contact__c + '--- contact old ' + oldFC.ER_Contact__c);
                    
                    /* check if the Head office contact had been changed */
                    if (fc.ER_Contact__c != oldFC.ER_Contact__c) {
                        
                        System.Debug('--- and the contact changed to ' + fc.ER_Contact__c);
                        fcContactToUpdate.add(fc);
                    }
                }
            }
        }
    }

    System.Debug('--- WSHU07_SynchronizeFinancialWS end prepare');
    
    /* Bypass the trigger */
    User currentUser =  [select id, ER_bypassTrigger__c from User where id =: UserInfo.getUserId()];
    
    if (!financialSetToUpdate.isEmpty() && !currentUser.ER_bypassTrigger__c && !APER05_DoNotRunTrigger.doNotRunTrigger) {
        WSHU07_SynchronizeFinancialWS.addupdateFinancialCentersFuture(financialSetToUpdate);
    }
    
    if (!fcContactToUpdate.isEmpty() && !currentUser.ER_bypassTrigger__c && !APER05_DoNotRunTrigger.doNotRunTrigger) {
        
        // Do a new call to the server
        WSHU10_SynchronizeContactWS updatecontact = new WSHU10_SynchronizeContactWS(fcContactToUpdate[0].ER_Contact__c, fcContactToUpdate[0].Id);
        
        // enqueue the job for processing
        ID jobID = System.enqueueJob(updatecontact);
    }
}