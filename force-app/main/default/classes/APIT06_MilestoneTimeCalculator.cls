global class APIT06_MilestoneTimeCalculator implements Support.MilestoneTriggerTimeCalculator {   
    global Integer calculateMilestoneTriggerTime(String caseId, String milestoneTypeId){
        
        list<Case> singleCase = [SELECT Priority, EntitlementId FROM Case WHERE Id=:caseId];
        list<MilestoneType> mt = [SELECT Name FROM MilestoneType WHERE Id=:milestoneTypeId];
        list<Entitlement> Ent = [SELECT IT_Milestone_Take_Over__c, IT_Closing_Milestone_Minute__c From Entitlement WHERE Id=:singleCase[0].EntitlementId];
        System.debug('MILESTONE NAME:: ' +mt[0].name);
        if(singleCase[0].EntitlementId != null){
            if(mt[0].Name == 'Take Over'){
                if(Ent[0].IT_Milestone_Take_Over__c != null){
                    return (integer)Ent[0].IT_Milestone_Take_Over__c;
                }
                else{
                    return 100;
                }
            }
            else if(Ent[0].IT_Closing_Milestone_Minute__c != null){
                return (integer)Ent[0].IT_Closing_Milestone_Minute__c;
            }
            else{
                return 100;
            }
        }
        else{
            return 100;
        }
        
        
    }
}