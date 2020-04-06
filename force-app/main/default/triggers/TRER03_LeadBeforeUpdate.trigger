/*
----------------------------------------------------------------------
-- - Name          : TRER03_LeadBeforeUpdate 
-- - Author        : AAB
-- - Description   : Trigger on Lead update 
					 Manage Rating based on lead source values.
--
-- Date         Name                Version     Remarks 
-- -----------  -----------         --------    ---------------------------------------
-- Sep-2019  		OLA               1.0         Initial version
---------------------------------------------------------------------------------------
*/
trigger TRER03_LeadBeforeUpdate on Lead (before update) {
    
    Map<Id,Lead> newLeadMap =  trigger.newMap;
    Map<Id,Lead> oldLeadMap =  trigger.oldMap;
    List<Lead> ChangedLeadSource = new List<Lead>();
    
    if (APER10_User_Management.canTrigger) {
        
        System.debug('###:TRER03_LeadBeforeUpdate before update Start');
        for(Lead lead : newLeadMap.values()){
            if(lead.leadSource != oldLeadMap.get(lead.Id).leadSource){
                
                ChangedLeadSource.add(lead);
            }
        }
        
        if(!ChangedLeadSource.isEmpty()){
            
            APER18_Lead_Management.manageRating(ChangedLeadSource);
        }        
        
        System.debug('###:TRER03_LeadBeforeUpdate before update End');
    }
}