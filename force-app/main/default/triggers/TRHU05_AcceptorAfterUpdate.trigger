trigger TRHU05_AcceptorAfterUpdate on ER_Acceptor__c(after insert, after update) {
    /*
    ----------------------------------------------------------------------
    -- - Name          : TRHU05_AcceptorAfterUpdate 
    -- - Author        : AAB
    -- - Description   : Trigger on Acceptor update (To cretae/update the Acceptor/store through EDG)        
    -- Maintenance History:
    --
    -- Date         Name                Version     Remarks 
    -- -----------  -----------         --------    ---------------------------------------
    -- 06-JUN-2018  AAB                 1.0         Initial version
    ---------------------------------------------------------------------------------------
    */

    System.Debug('--- APHU09_SynchronizeAcceptorWS begin prepare');

    Set <Id> acceptorSet = new Set <Id> ();
    
    static map <String, map < String, RecordType >> recordTypeMap;

    if (!WSHU09_SynchronizeAcceptorWS.alreadyExecutedAcceptor) {
        // Loop through the acceptors list and add them all to the set
        for (ER_Acceptor__c accPoint: trigger.new) {
            if (accPoint.ER_MID_Authorization__c == null) {
                accPoint.addError('The MID Authorization is missing');
            } else if (accPoint.ER_Business_Unit__c == 'HU'){
                acceptorSet.add(accPoint.Id);
            }
        }
    }

    System.Debug('--- APHU09_SynchronizeAcceptorWS end prepare');
    
    /* Bypass the trigger */
    User currentUser =  [select id, ER_bypassTrigger__c from User where id =: UserInfo.getUserId()];
    
    if (!acceptorSet.isEmpty() && !currentUser.ER_bypassTrigger__c) {
        WSHU09_SynchronizeAcceptorWS.updateAddAcceptorsFuture(acceptorSet);
    }
}