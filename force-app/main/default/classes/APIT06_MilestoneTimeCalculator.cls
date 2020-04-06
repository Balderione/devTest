global class APIT06_MilestoneTimeCalculator implements Support.MilestoneTriggerTimeCalculator {   
    global Integer calculateMilestoneTriggerTime(String caseId, String milestoneTypeId){
        list<Case> singleCase = [SELECT Priority, EntitlementId, RecordType.DeveloperName, IT_Statement__c, IT_Financial_Center__r.IT_Product2__r.IT_Card__c FROM Case WHERE Id=:caseId];
        list<MilestoneType> mt = [SELECT Name FROM MilestoneType WHERE Id=:milestoneTypeId];
        list<Entitlement> Ent = [SELECT IT_Milestone_Take_Over__c, IT_Closing_Milestone_Minute__c From Entitlement WHERE Id=:singleCase[0].EntitlementId];
        System.debug('MILESTONE NAME:: ' +mt[0].name);
        if(singleCase[0].EntitlementId != null){
            if(singleCase[0].RecordType.DeveloperName == 'IT_Client_Consip_Case_RT' || singleCase[0].RecordType.DeveloperName == 'IT_Client_Support_Case_RT'){ // || singleCase[0].RecordType.DeveloperName == 'IT_Client_Support_Case_RT'
                List<CMIT12_Consip_Milestone_Duration__mdt> msDurationConsip = [SELECT MasterLabel, IT_Milestone_Name__c, IT_BP_8_Cartaceo__c, IT_BP_8_Elettronico__c, IT_BPE_1_Elettronico__c FROM CMIT12_Consip_Milestone_Duration__mdt];
                for(CMIT12_Consip_Milestone_Duration__mdt item : msDurationConsip){
                    if(mt[0].Name == item.IT_Milestone_Name__c){
                        if(singleCase[0].IT_Statement__c == 'Consip BPE 1'){
                            return (integer)item.IT_BPE_1_Elettronico__c;
                        }
                        else if(singleCase[0].IT_Statement__c == 'Consip BP 8'){
                            if(singleCase[0].IT_Financial_Center__r.IT_Product2__r.IT_Card__c){
                                return (integer)item.IT_BP_8_Elettronico__c;
                            }
                            else{
                                return (integer)item.IT_BP_8_Cartaceo__c;
                            }
                        }
                    }
                }
            }
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