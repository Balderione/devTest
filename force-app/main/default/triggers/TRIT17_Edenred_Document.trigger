trigger TRIT17_Edenred_Document on IT_Edenred_Document__c (after update, before insert) {
    if(trigger.isBefore && trigger.isInsert){
        if(trigger.new[0].IT_Refund_Amount__c != null){
            string caseId;
            if(trigger.new[0].IT_Case__c != null){
                caseId = trigger.new[0].IT_Case__c; 
            }
            List<Case> caseList = [SELECT Id, IT_Refund_Amount__c FROM Case WHERE id = :caseId];
            if(caseList != null && caseList.size() > 0){
                if(caseList[0].IT_Refund_Amount__c!= null){
                    caseList[0].IT_Refund_Amount__c = caseList[0].IT_Refund_Amount__c + trigger.new[0].IT_Refund_Amount__c;
                }
                else{
                    caseList[0].IT_Refund_Amount__c = trigger.new[0].IT_Refund_Amount__c;
                }
                update caseList[0];
            }
        }
    }
    if(trigger.isAfter && trigger.isUpdate){
        if(trigger.new[0].IT_Refund_Amount__c != null && trigger.new[0].IT_Refund_Amount__c != trigger.old[0].IT_Refund_Amount__c){
            string caseId;
            if(trigger.new[0].IT_Case__c != null){
                caseId = trigger.new[0].IT_Case__c; 
            }
            List<Case> caseList = [SELECT Id, IT_Refund_Amount__c FROM Case WHERE id = :caseId];
            if(caseList != null && caseList.size() > 0){
                if(caseList[0].IT_Refund_Amount__c!= null){
                    if(trigger.old[0].IT_Refund_Amount__c != null){
                        caseList[0].IT_Refund_Amount__c = caseList[0].IT_Refund_Amount__c + trigger.new[0].IT_Refund_Amount__c - trigger.old[0].IT_Refund_Amount__c;
                    }
                    else{
                        caseList[0].IT_Refund_Amount__c = caseList[0].IT_Refund_Amount__c + trigger.new[0].IT_Refund_Amount__c;
                    }
                    
                }
                else{
                    caseList[0].IT_Refund_Amount__c = trigger.new[0].IT_Refund_Amount__c;
                }
                update caseList[0];
            }
        }
        if(trigger.new[0].IT_Accepted__c == true && trigger.old[0].IT_Accepted__c == false){
            IT_Edenred_Document__c eDoc = trigger.new[0];
            APIT18_FileUploadController.completeCONSIPMilestones(eDoc.IT_Case__c , eDoc.IT_Type__c);
        }
        if(trigger.new[0].IT_Accepted__c == false && trigger.old[0].IT_Accepted__c == true){
            IT_Edenred_Document__c eDoc = trigger.new[0];
            APIT18_FileUploadController.reopenCONSIPMilestones(eDoc.IT_Case__c , eDoc.IT_Type__c);
        }
    }

    
}