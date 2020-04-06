public class APIT13_EmailMessageTriggerHandler {
    
    
    public static void SemanticEngine (EmailMessage singleMail){
        
        Case CaseTest = [SELECT Id , Origin From Case Where Id = :singleMail.ParentId ];
        List<CMIT03_Semantic_Engine__mdt> CaseKeyWords = [SELECT MasterLabel, Case_Reason__c , Priority__c, Keywords__c FROM CMIT03_Semantic_Engine__mdt WHERE Active__c = true];
        integer maxfindsLow = 0;
        string caseReasonLow = '';
        integer maxfindsMedium = 0;
        string caseReasonMedium = '';
        integer maxfindsHigh = 0;
        string caseReasonHigh = '';
        for(CMIT03_Semantic_Engine__mdt CKW : CaseKeyWords){
            string compilerString = '(' + CKW.Keywords__c.deleteWhitespace().replaceAll(',' , '|') + ')';
            system.debug('CompilerString: '+compilerString);
            pattern myPattern = pattern.compile(compilerString);
            matcher myMatcher = myPattern.matcher(singleMail.Subject);
            integer count = 0;
            while (myMatcher.find()){
                count++;
            }
            if(singleMail.TextBody != null){
                matcher myMatcher2 = myPattern.matcher(singleMail.TextBody);
                while (myMatcher2.find()){
                    count++;
                }
            }
            if(CKW.Priority__c == 'High'){
                if(count > maxfindsHigh){
                    maxfindsHigh = count;
                    caseReasonHigh = CKW.Case_Reason__c;
                }
            }
            if(CKW.Priority__c == 'Medium'){
                if(count > maxfindsMedium){
                    maxfindsMedium = count;
                    caseReasonMedium = CKW.Case_Reason__c;
                }
            }
            if(CKW.Priority__c == 'Low'){
                if(count > maxfindsLow){
                    maxfindsLow = count;
                    caseReasonLow = CKW.Case_Reason__c;
                }
            }
        }
        if(maxfindsHigh > 0){
            CaseTest.Reason = caseReasonhigh;
        }
        else if(maxfindsMedium > 0){
            CaseTest.Reason = caseReasonMedium;
        }
        else if(maxfindsLow > 0){
            CaseTest.Reason = caseReasonLow;
        }else{
            CaseTest.Reason = 'Other';
        }
        update caseTest;
    }
    

}