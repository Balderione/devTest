public class APIT05_GetRecordType {
    
    public static boolean isfirsttime = true;
    
    
    @auraenabled
    public static string getRecordType (string recordId){
        List<Case> caseItem = [SELECT id,RecordTypeId , IT_Financial_Center__c, IT_Circuit__c from case where id =:recordId LIMIT 1];
        List<ER_Financial_Center__c> linkedFC = [SELECT id , IT_Service__c, IT_Product2__r.IT_Card__c FROM ER_Financial_Center__c WHERE Id =:caseItem[0].IT_Financial_Center__c];
        List<IT_Circuit__c> circ = [SELECT id , Name , IT_Circuit_Code__c from IT_Circuit__c where id = :caseItem[0].IT_Circuit__c];//FIX THIS
        string result;
        string isCard;
        if(caseItem != null && caseItem.size() > 0){
            result = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(caseItem[0].RecordTypeId).getDeveloperName();
        }
        if(linkedFC != null && linkedFC.size() > 0){
            if(linkedFC[0].IT_Service__c == '1X' || linkedFC[0].IT_Service__c == '2X'){
                result+='§gestione-conto';
            }
            else if(linkedFC[0].IT_Service__c == '1W' || linkedFC[0].IT_Service__c == '1L' || linkedFC[0].IT_Service__c == '1M' || linkedFC[0].IT_Service__c == '1N' || linkedFC[0].IT_Service__c == '1O' || linkedFC[0].IT_Service__c == '1Y' || linkedFC[0].IT_Service__c == '1B' ){
                result+='§gestione-piano';
            }
            else if(linkedFC[0].IT_Service__c == '1V' || linkedFC[0].IT_Service__c == '1R' || linkedFC[0].IT_Service__c == 'R' || linkedFC[0].IT_Service__c == 'C' ){
                result+='§gestione-carte';
            }
            else if(linkedFC[0].IT_Service__c == '1G' || linkedFC[0].IT_Service__c == '1F' || linkedFC[0].IT_Service__c == '0D' || linkedFC[0].IT_Service__c == 'H' || linkedFC[0].IT_Service__c == '0G' || linkedFC[0].IT_Service__c == '0F' || linkedFC[0].IT_Service__c == '0H' || linkedFC[0].IT_Service__c == '2F' || linkedFC[0].IT_Service__c == '2G' || linkedFC[0].IT_Service__c == '0J' || linkedFC[0].IT_Service__c == '1E' || linkedFC[0].IT_Service__c == '2K' || linkedFC[0].IT_Service__c == '1H' || linkedFC[0].IT_Service__c == '2J' || linkedFC[0].IT_Service__c == '0K' ){
                result+='§ordine-ticket';
            }
            else{
                result+='§home';
            }
            if(linkedFC[0].IT_Product2__r.IT_Card__c){
                isCard = 'card';
            }
            else{
                isCard = 'ticket';
            }
        }
        else{
            result+='§home';
        }
        result += '§';
        if(circ != null && circ.size() >0){
            result += circ[0].IT_Circuit_Code__c;
        }
        result += '§'+isCard;

        
        return result;
    }
    
    @auraenabled
    public static Case getCaseInfo (string recordId){
        Case caseItem = [SELECT id,Subject,Description,CaseNumber,IT_Jira_Code__c from case where id =:recordId LIMIT 1];
        return caseItem;
    }
    
  /* @future
    public static void deleteAndLinkMailToCase (string mailMessageJSON){
        EmailMessage mailRecieved = (EmailMessage) JSON.deserialize(mailMessageJSON, EmailMessage.class);
        String MailSubject = mailRecieved.Subject;
        list<CMIT09_Mail_Deduplicate_Criteria__mdt> maildetList = [SELECT IT_Mail_Beginning_With__c from CMIT09_Mail_Deduplicate_Criteria__mdt];
        for(CMIT09_Mail_Deduplicate_Criteria__mdt item : maildetList){
            MailSubject = Mailsubject.replace( item.IT_Mail_Beginning_With__c+' ' , '');
        }
        String query = 'SELECT id FROM Case WHERE (subject = \''+MailSubject.replace('\'', '\\\'')+'\'';

        system.debug('SUBJECT CROPPATO:: '+MailSubject);
        for(CMIT09_Mail_Deduplicate_Criteria__mdt item : maildetList){
            string subjectTemp = item.IT_Mail_Beginning_With__c + ' ' + Mailsubject;
            query += ' OR subject = \''+subjectTemp.replace('\'', '\\\'')+'\' ';
        }
        query += ') and id != \''+mailRecieved.ParentId+'\'';
        system.debug('Query:: '+ query);
        //List<Case> oldCase = [SELECT id FROM Case WHERE subject =:mailRecieved.Subject and id != :mailRecieved.ParentId];
        List<Case> oldCase = Database.query(query);
        if(oldCase != null && oldCase.size() > 0){
            EmailMessage newMail = mailRecieved.clone(false,false,false,false);
            system.debug('HAS ATTACHMENT? '+newMail.HasAttachment);
            newMail.ParentId = oldCase[0].id;
            insert newMail;
            Case CasetoDelete = [SELECT id , IT_CT7_Agent_Id__c , IT_CTI_Call_Id__c, IT_CTI_MediaId__c , Origin, accountid from case where id =:mailRecieved.ParentId LIMIT 1 FOR UPDATE];
            EmailMessage mailTodelete = [SELECT id FROM EmailMessage Where Id =:mailRecieved.id LIMIT 1 FOR UPDATE];
            /*if(!Test.isRunningTest()){
                APIT15_CaseTriggerHandler.CTICalloutClosedCase(JSON.serialize(CasetoDelete));
            }
            delete mailTodelete;
            delete casetoDelete;
        } 
    }*/
    
    /*@auraenabled
    public static string getStatementsGHOST (String caseId){
        List<Case> cases = [SELECT Id , IT_Financial_Center__r.IT_Financial_Center__c FROM Case WHERE id = :caseId];
        if(cases != null && cases.size() > 0){
            string clientRef = cases[0].IT_Financial_Center__r.IT_Financial_Center__c;
            if(clientRef != null){
                String responseBody = '';
                date dateFrom = date.today().addmonths(-2);
                date dateTo = date.today();
                try{
                    Http callHttp = new Http();
                    HttpRequest req = APER06_WebserviceUtility.getHttpRequest(
                        '/invoices?client-ref='+clientRef+'&client-type=T&date-from='+string.valueOf(dateFrom)+'&date-to='+string.valueOf(dateTo)+'&user-profile=GIWEBCOCLI&company=832&temporary-table=EC_'+clientRef+'&truncate-temporary-table=true&search-by-vatcode=false&order-by-status=false&order-by-date=false&is-open-document=false&is-balance-programme=false&is-document-history=true&is-notice=false&is-transfert-back=false&is-tax-rate=false',
                        'GET',
                        null,
                        null);
                    req.setHeader('Content-Type', 'application/java');
                    HttpResponse res = callHttp.send(req);
                    responseBody = res.getbody();
                    System.debug('responseBody::: '+responseBody);
                }catch(Exception ecc){
                    System.debug('Error getStatements: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                    return null;
                }
                return responseBody;
            }
            else{
                return 'NO CLIENT REF';
            }
        }
        else{
            return 'NO CASE';
        }
        
        
    }*/
    
      /*  @auraenabled
    public static Boolean getUserPresence (){
        List< UserServicePresence> presence = [SELECT ServicePresenceStatusId,UserId from UserServicePresence where UserId =:UserInfo.getUserId() LIMIT 1];
        if(presence[0].ServicePresenceStatusId == '0N51w00000000N1'){
            return true;
        }
        else{
            return false;
        }
    }*/
}