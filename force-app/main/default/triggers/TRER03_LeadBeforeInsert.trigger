/*
----------------------------------------------------------------------
-- - Name          : TRER03_LeadBeforeInsert 
-- - Author        : OLA
-- - Description   : Trigger on Lead Insert 
Manage Rating based on lead source values.
--
-- Date         Name                Version     Remarks 
-- -----------  -----------         --------    ---------------------------------------
-- Sep-2019  		OLA               1.0         Initial version
---------------------------------------------------------------------------------------
*/
trigger TRER03_LeadBeforeInsert on Lead (before insert) {
    
    if (APER10_User_Management.canTrigger) {
        
        System.debug('###:TRER03_LeadBeforeInsert before insert Start');
        
        APER18_Lead_Management.manageRating(trigger.new);
        
        System.debug('###:TRER03_LeadBeforeInsert before insert End');
    }
}