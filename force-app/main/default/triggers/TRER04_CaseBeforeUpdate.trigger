/*
----------------------------------------------------------------------
-- - Name          : TRER04_CaseBeforeUpdate
-- - Author        : OLA
-- - Description   : Trigger on Case before update (
- Manage BU.

-- Maintenance History:
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
-- JUN-2019         OLA                1.0                 Initial version
---------------------------------------------------------------------------------------
*/
trigger TRER04_CaseBeforeUpdate on Case (before update) {
    
   List<Case> casesAssets = new List<Case>();
   Map<id,Case> oldCasesMap = Trigger.oldMap;
    
    if (APER10_User_Management.canTrigger) {
        
        System.debug('###:TRER04_CaseBeforeUpdate before update Start');
        
        for (Case cs : Trigger.New) {
            if(cs.ER_Business_Unit__c != oldCasesMap.get(cs.id).ER_Business_Unit__c  && String.isNotBlank(cs.ER_Business_Unit__c)){
                
                cs.ER_BUPicklist__c = cs.ER_Business_Unit__c;
            }
            if(cs.AssetId != oldCasesMap.get(cs.id).AssetId)
            {
                casesAssets.add(cs);
            }
        }
        
        System.debug('###:TRER04_CaseBeforeUpdate before update Start');
    }
    if (!casesAssets.isEmpty()) 
    {
        System.debug('###:TRER04_CaseBeforeUpdate casesAssets '+casesAssets);
        APER08_Case_Management.manageCasesAssets(casesAssets);
    }
}