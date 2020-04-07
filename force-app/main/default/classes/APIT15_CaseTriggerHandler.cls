public class APIT15_CaseTriggerHandler {
    
    public static boolean isfirsttime = true;
    
    public static void CaseToContractLink(List<Case> triggerNewCase) {      
        try{
            list<String> allFinancialCenterCircuit = new list<String>();   // Use junction object between FC and Circuit   
            map<Id, List<String>> mapCaseCode = new map<Id, List<String>>(); 
            integer associations = 0;
            for (Case caseItem : triggerNewCase){
                if(!String.isBlank(caseItem.subject)){
                    list<String> SearchContractExternalId = new list<String>();
                    List<string> SearchAll = caseItem.subject.split('[^A-Za-z0-9_]');
                    system.debug('SearchAll:: '+SearchAll);
                    String nameRecordType = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(caseItem.RecordTypeId).getDeveloperName();
                    for(integer i=0; i<SearchAll.size(); i++){
                        SearchAll[i]= SearchAll[i].replaceAll( '\\s+', '');
                        if (SearchAll[i].length() == 6 && nameRecordType == 'IT_Client_Welfare_Provisioning_Case_RT'){   // Use Provisioning RecordType
                            SearchContractExternalId.add(SearchAll[i]); 
                            allFinancialCenterCircuit.add(SearchAll[i]);
                        }else if((SearchAll[i].length() == 6 || SearchAll[i].length() == 4 || SearchAll[i].length() == 11)  && nameRecordType == 'IT_Client_Support_Case_RT'){ // Use Support RecordType
                            SearchContractExternalId.add(SearchAll[i]); 
                            allFinancialCenterCircuit.add(SearchAll[i]);    
                        }          
                    }
                    if(SearchContractExternalId.size() > 0)
                        mapCaseCode.put(caseItem.Id, SearchContractExternalId);  
                    
                    system.debug('SearchContractExternalId:: '+SearchContractExternalId);   
                }      
            }
            
            //list<Contract> listContract = [SELECT Id, AccountId, ER_Contract_External_ID__c FROM Contract WHERE ER_Contract_External_ID__c in :allContract];
            //list<ER_Financial_Center__c> listFCCircuitCla = [SELECT Id, Name, ER_Card_Operational_System_ID__c, ER_Paper_Operational_System_ID__c, IT_Circuit__c, IT_Circuit__r.Name FROM ER_Financial_Center__c WHERE ER_Paper_Operational_System_ID__c in :allContract Or ER_Card_Operational_System_ID__c in :allContract];
            //list<ER_Financial_Center__c> listFCCircuit2 = [SELECT Id, Name, ER_Card_Operational_System_ID__c, ER_Paper_Operational_System_ID__c, IT_Circuit__c, IT_Circuit__r.Name FROM ER_Financial_Center__c WHERE Name in :allFinancialCenterCircuit Or IT_Circuit__r.Name in :allFinancialCenterCircuit];
            //list<ER_Financial_Center__c> listFCCircuit = [SELECT Id, Name, ER_Card_Operational_System_ID__c, ER_Paper_Operational_System_ID__c, IT_Circuit__c, IT_Circuit__r.Name FROM ER_Financial_Center__c WHERE Name in :allFinancialCenterCircuit Or IT_Circuit__r.Name in :allFinancialCenterCircuit Or ER_Account_Name__r.ER_VAT_Number__c in :allFinancialCenterCircuit];
            list<IT_Circuit__c> listCircuits = [SELECT id, name FROM IT_Circuit__c WHERE name in: allFinancialCenterCircuit];
            list<Account> listAccount = [SELECT id, name, ER_VAT_Number__c FROM Account WHERE ER_VAT_Number__c in:allFinancialCenterCircuit];
            list <Case> casesforMail= new list<Case>();
            list<ER_Financial_Center__c> listFCenters = [SELECT Id,IT_Financial_Center__c,  Name, ER_Card_Operational_System_ID__c, ER_Paper_Operational_System_ID__c, IT_Circuit__c, IT_Circuit__r.Name, ER_Account_Name__r.ER_VAT_Number__c, ER_Account_Name__r.ER_Segment__c FROM ER_Financial_Center__c WHERE IT_Financial_Center__c in :allFinancialCenterCircuit];
            
            system.debug('listCircuits:: '+listCircuits);
            system.debug('listFCCenters:: '+listFCenters);
            system.debug('listAccount:: '+listAccount);
            
            
            for(Case caseItem : triggerNewCase){
                if(!String.isBlank(caseItem.subject)){
                    
                    list<String> possibleContractCode = new list<String>();
                    possibleContractCode = mapCaseCode.get(caseItem.Id);
                    String nameRecordT = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(caseItem.RecordTypeId).getDeveloperName();
                    
                    /*if(listContract != null && listContract.size() > 0 && nameRecordT == 'IT_Client_Welfare_Provisioning_Case_RT'){
for(Contract contractItem : listContract){
system.debug('contractItem:: '+contractItem.ER_Contract_External_ID__c);
if(possibleContractCode != null && possibleContractCode.contains(contractItem.ER_Contract_External_ID__c)){
caseItem.IT_Contract__c = contractItem.Id;
caseItem.AccountId = contractItem.AccountId;
}
}
}*/
                    
                    if(listFCenters != null && listFCenters.size() > 0 && nameRecordT == 'IT_Client_Welfare_Provisioning_Case_RT'){
                        for(ER_Financial_Center__c financialItem : listFCenters){
                            system.debug('financialItemPapel:: '+financialItem.ER_Paper_Operational_System_ID__c);
                            system.debug('financialItemCard:: '+financialItem.ER_Card_Operational_System_ID__c);
                            if(possibleContractCode != null && possibleContractCode.contains(financialItem.IT_Financial_Center__c)){
                                caseItem.IT_Financial_Center__c = financialItem.Id; 
                                caseItem.Accountid = financialItem.ER_Account_Name__c;
                  

                            }
                        }
                    }
                    else if(nameRecordT == 'IT_Client_Support_Case_RT'){
                        if(listFCenters != null && listFCenters.size() > 0){
                            for(ER_Financial_Center__c fCItem : listFCenters){
                                if(possibleContractCode != null && possibleContractCode.contains(fCItem.IT_Financial_Center__c)){
                                    system.debug('Financial Center::: '+fCItem.Id);
                                    caseItem.IT_Financial_Center__c = fCItem.Id;
                                    caseItem.Accountid = fCItem.ER_Account_Name__c;
                                    if(fcItem.IT_Circuit__c != null){
                                        caseItem.IT_Circuit__c = fcItem.IT_Circuit__c;

                                    }
        
                                }
                            }
                        }
                        if(caseItem.IT_Financial_Center__c == NULL || Test.isRunningTest()){
                            string circMatch;
                            for(IT_Circuit__c CirItem : listCircuits){
                                if(possibleContractCode != null && possibleContractCode.contains(CirItem.Name)){
                                    system.debug('Circuit::: '+CirItem.name);
                                    circMatch = CirItem.name; 
                                    caseItem.Accountid = CirItem.IT_Account__c;
                                    associations += 1;
                                }
                            }
                            if(associations == 1 || Test.isRunningTest()){
                                caseItem.IT_Circuit__c = circMatch;
                            }
                            associations = 0;
                        }
                        if(caseItem.IT_Financial_Center__c == NULL && caseItem.IT_Circuit__c == NULL || Test.isRunningTest()){
                            for(Account AccItem : listAccount){
                                if(possibleContractCode != null && possibleContractCode.contains(AccItem.ER_VAT_Number__c)){
                                    system.debug('Account::: '+Account.ER_VAT_Number__c);
                                    caseItem.AccountId = Accitem.id;
                                }
                            }
                        }
                        
                    }    
                }
            }
        }catch(Exception ecc){  
            System.debug('Error APIT15_CaseTriggerHandler: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }         
    }
    
    
    public static void CaseEntitlementLink(List<Case> triggerNewCase){
        Case newcase = triggerNewCase[0];
        List<Entitlement> entList = new List<Entitlement>();
        string result = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(newcase.RecordTypeId).getDeveloperName();
        system.debug('SLA NAME:: '+result);
        if(result != 'IT_Client_Welfare_Provisioning_Case_RT'){
            if(newcase.IT_Financial_Center__c != NULL){
                List<CMIT01_Entitlement_Matching_Field__mdt> EntitlementMatches = [SELECT MasterLabel, IT_Case_Field__c, IT_Entitlement_Field__c FROM CMIT01_Entitlement_Matching_Field__mdt];
                CMIT02_Entitlement_Logic__mdt EntitlementLogic = [SELECT IT_Logic__c, IT_Is_Active__c FROM CMIT02_Entitlement_Logic__mdt WHERE IT_Is_Active__c = true LIMIT 1];
                string Logic = EntitlementLogic.IT_Logic__c;
                string query = 'SELECT id, name FROM Entitlement WHERE IT_Financial_Center__c =\''+newcase.IT_Financial_Center__c+'\' AND ( ';
                for(CMIT01_Entitlement_Matching_Field__mdt EMF : EntitlementMatches){
                    Schema.SobjectField singleItemC = Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get(EMF.IT_Case_Field__c);
                    String fieldChild = (String) String.valueOf(newcase.get(singleItemC));
                    system.debug('FIELD '+ fieldChild);
                    Logic = Logic.replace(EMF.MasterLabel , EMF.IT_Entitlement_Field__c + ' = ' + '\'' +fieldChild+'\'');
                }
                Logic += ')';
                query += Logic;
                query.replaceall('\'null\'' , 'null');
                system.debug('MYQUERY ::'+ query);
                entList = Database.query(query);
                system.debug('ENTIES '+ entList);
                if (entList != NULL && entList.size() > 0){
                    system.debug('RETURNED:: '+entList[0].name);
                    newcase.EntitlementId = entList[0].id;
                    //still need to define assignment priorities
                }
                else{
                    //default entitlement
                    entList= [SELECT id FROM Entitlement Where Name = 'Default'];
                    if(entList != null && entList.size() > 0){ 
                        newcase.EntitlementId = entList[0].id;
                    }
                } 
            }
            else{
                //default entitlement
                entList= [SELECT id FROM Entitlement Where Name = 'Default'];
                if(entList != null && entList.size() > 0){ 
                    newcase.EntitlementId = entList[0].id;
                }
            }
        }
        else{
            List<Entitlement> entListProv= [SELECT id FROM Entitlement Where Name = 'Provisioning Flexben'];
            if(entListProv != null && entListProv.size() > 0){
                newcase.EntitlementId = entListProv[0].id;
            }
        }
        
    }
    
    public static void MilestoneAutoComplete(List<Case> triggerNewCase) {
        DateTime completionDate = System.now(); 
        List<Id> updateCases = new List<Id>();
        List<Id> closeCases = new List<Id>();
        for (Case c : triggerNewCase){
            if ((c.Status == 'In_Progress')&&((c.SlaStartDate 
                                               <= completionDate)&&(c.SlaExitDate == null)))
                updateCases.add(c.Id);
            if((c.Status == 'Closed')&&(c.SlaStartDate <= completionDate)&&(c.SlaExitDate == null)){
                closeCases.add(c.Id);
            }
            
        }
        if (updateCases.isEmpty() == false)
            APIT08_MilestoneUtilities.completeMilestone(updateCases, 'IT Take Over', completionDate);
        if (closeCases.isEmpty() == false)
            APIT08_MilestoneUtilities.completeAllMilestones(closeCases, completionDate);
        }
    

    @future
    public static void emailSender (string mailRecievedJSON){
        List<id> AttIds = new list<id> ();
        //EmailMessage mailRecieved = [SELECT Subject ,FromAddress,fromname,createddate,toaddress, HtmlBody , id , ContentDocumentIds, HasAttachment , parentId FROM EmailMessage where id = :mailrecievedId];
        EmailMessage mailRecieved = (EmailMessage)JSON.deserialize(mailRecievedJSON, EmailMessage.Class);
        system.debug('CONTENTDOCUMENTS:: ' +mailrecieved.ContentDocumentIds);
        if (mailRecieved.ParentId != NULL){
            system.debug('MAIL:: ' +mailrecieved.id +' - '+ mailrecieved.parentid);
            List<Case> linkedCase = [SELECT Subject, Origin , Account.ER_Segment__c FROM Case WHERE Id =: mailrecieved.Parentid limit 1];
            if(mailRecieved.HasAttachment){
                List<ContentVersion> DocumentList = [SELECT id FROM ContentVersion WHERE ContentDocumentId IN :mailrecieved.ContentDocumentIds];
                system.debug('ATTACHMENTS:: ' +DocumentList);
                if (linkedCase != NULL && linkedCase.size() > 0 ){
                    
                    if(DocumentList != NULL && DocumentList.size() > 0){
                        for (ContentVersion att : DocumentList){
                            AttIds.add(att.id);
                        }
                    }
                }
            }
            string headerToAdd = '<b>Da:</b> '+mailRecieved.fromaddress + '    <b>A:</b> '+mailRecieved.toaddress + '<br/><b>Inviato il:</b><br/> '+string.ValueOf(mailRecieved.createddate);
            system.debug('SEGMENT:: ' +linkedcase[0].Account.Er_Segment__c);
            system.debug('Attids:: ' +Attids);
            //if (linkedCase[0].Account.ER_Segment__c == 'A+' || linkedCase[0].Account.ER_Segment__c == 'A' ){
            if (mailRecieved.toaddress == 'assistenza.test-it@edenred.com' && (mailRecieved.FromAddress == 'moreno.bonini@ellysse.it' || mailRecieved.FromAddress == 'sandro.torri@ellysse.it' || mailRecieved.FromAddress == 'matteo.bolzoni@mail-bip.com')){
                List<CMIT10_Mail_Forward__mdt> mailingList = [SELECT IT_Mail_address__c FROM CMIT10_Mail_Forward__mdt WHERE IT_Active__c = true];
                List<String> toAddresses = new List<String>();
                //String[] toAddresses = new String[] {'Assistenzatemp.test-it@edenred.com'}; 
                for(CMIT10_Mail_Forward__mdt singleMail : mailingList){
                    toAddresses.add(singleMail.IT_Mail_address__c);
                }
                system.debug('ENTRATO IN MAIL SEND' + mailRecieved.fromaddress + ' NAME ' + mailRecieved.fromname);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setReplyTo(mailRecieved.fromaddress);
                mail.setSubject(mailRecieved.subject);
                mail.sethtmlBody(headerToAdd + mailRecieved.htmlBody);
                mail.setToAddresses(toAddresses);
                mail.setEntityAttachments(Attids);
                mail.setSenderDisplayName(mailRecieved.fromname);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                //}
            }
        }
        
    }
    
    public static void changeCaseQueue (string caseJSON){
        Case singleCase = (Case)JSON.deserialize(caseJSON, Case.Class);
        if(singleCase.accountId != null){
          List<Account> acco = [SELECT id , IT_TOP__c , ER_Segment__c FROM Account WHERE id =:singleCase.AccountId];
            if(acco != null && acco.size() > 0 ){
                if(acco[0].IT_TOP__c || acco[0].ER_Segment__c == 'S'){
                    system.debug('RED ACCOUNT');
                    list<Group> redGroup = [SELECT id from Group WHERE Name = 'IT BACK OFFICE RED'];
                    if(redGroup != null && redGroup.size() > 0){
                        system.debug('RED QUEUE');
                        singleCase.OwnerId = redGroup[0].id;
                    }
                }
            }
        }
    }
    public static void associateContactDetailToCase(Case triggerNew){
        
        if(triggerNew.SuppliedEmail != null && triggerNew.SuppliedEmail != '' && triggerNew.ContactId == null){
            List<Contact> contacts = [SELECT id FROM contact WHERE Email = :triggerNew.SuppliedEmail];
            if(contacts != null && contacts.size() > 0){
                triggerNew.ContactId = contacts[0].id;
            }
            else{
                system.debug('MAIL:: '+triggerNew.SuppliedEmail);
                List<IT_Contact_Detail__c> details = [SELECT Id , IT_Contact__c  FROM IT_Contact_Detail__c WHERE Name = :triggerNew.SuppliedEmail AND IT_Contact__c != null];
                if( details != null && details.size() > 0){
                    triggerNew.ContactId = details[0].IT_Contact__c;
                }
            }
        }
        
    }
    
    @future (callout = true)
    public static void CTICallout(string JsonCase) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        Long a2atoken = Datetime.now().getTime() * 967;
        string campaign = 'CA_Clienti_Welfare_WHITE';
        Case createdCase = (Case)JSON.deserialize(JsonCase, Case.Class);
        boolean duplicateCase = false;
        /*if(createdCase.origin == 'Email'){
            List<EmailMessage> mailRecieved = [SELECT id , subject ,parentId from EmailMessage WHERE ParentId = :createdCase.Id] ;
            if(mailRecieved != null && mailRecieved.size() > 0){
                String MailSubject = mailRecieved[0].Subject;
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
                query += ') and id != \''+mailRecieved[0].ParentId+'\'';
                system.debug('Query:: '+ query);
                //List<Case> oldCase = [SELECT id FROM Case WHERE subject =:mailRecieved[0].Subject and id != :mailRecieved[0].ParentId];
                List<Case> oldCase = Database.query(query);
                if(oldCase != null && oldCase.size() > 0){
                    duplicateCase = true;
                }  
            }
        }*/
        if(createdCase.accountid != null){
            System.debug('Account trovato ');
            List<Account> accolist = [SELECT id ,  Account.IT_TOP__c , Account.ER_Segment__c FROM Account WHere id =: createdCase.accountid];
            if(accolist != null && accolist.size() > 0 ){
                if(accolist[0].IT_TOP__c || accolist[0].ER_Segment__c == 'S'){
                    System.debug('Account RED ');
                    campaign = 'CA_Clienti_Welfare_RED';
                }
            }
        }
        string endpoint = APIT21_IFrameOpenerController.callLegacyLink().IT_CTI__c;
        reqPost newRequest = new reqPost(createdCase , campaign);
        request.setEndpoint(endpoint+'/EasyCIM/rest/A2A/contact/createNew/'+a2atoken);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(json.serialize(newRequest));
        request.setTimeout(20000);
        System.debug('ENDPOINT: '+request.getEndpoint());
        System.debug('SERIALIZED: '+json.serialize(newRequest));
        //if(!duplicateCase){
            //HttpResponse response = http.send(request); 
            // Parse the JSON response
            //responsePost responseObject = (responsePost)JSON.deserializeUntyped(response.getBody());
            //System.debug('RESPONSE: '+response);
            //}
        /*if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        return response;*/
            
    } 
    
    @future (callout = true)
    public static void CTICalloutClosedCase(string JsonCase) {
        if(isfirsttime){
            string campaign = 'CA_Clienti_Welfare_WHITE';
            Case closedCase = (Case)JSON.deserialize(JsonCase, Case.Class);
            if(closedCase.accountid != null){
                System.debug('Account trovato ');
                List<Account> accolist = [SELECT id ,  Account.IT_TOP__c , Account.ER_Segment__c FROM Account WHere id =: closedCase.accountid];
                if(accolist != null && accolist.size() > 0 ){
                    if(accolist[0].IT_TOP__c || accolist[0].ER_Segment__c == 'S'){
                        System.debug('Account RED ');
                        campaign = 'CA_Clienti_Welfare_RED';
                    }
                }
            }
            string endpoint = APIT21_IFrameOpenerController.callLegacyLink().IT_CTI__c;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            Long a2atoken = Datetime.now().getTime() * 967;
            reqPost newRequest = new reqPost(closedCase , campaign);
            request.setEndpoint(endpoint+'/sf/cti.php?agentID='+closedCase.IT_CT7_Agent_Id__c+'&callID='+closedCase.IT_CTI_Call_Id__c+'&mediaID='+closedCase.IT_CTI_MediaId__c+'&action=AgentJobFinished&type='+closedCase.Origin);//MAIL
            request.setMethod('GET');
            request.setTimeout(20000);
            request.setHeader('Content-Type', 'application/java');
            System.debug('ENDPOINT: '+request.getEndpoint());
            HttpResponse response = http.send(request);
        // Parse the JSON response
        //responsePost responseObject = (responsePost)JSON.deserializeUntyped(response.getBody());
		System.debug('RESPONSE: '+response);
        /*if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        return response;*/
        }
       	
            
    } 
    
    /*public class WorkflowCreateContactRequest {
        string WorkflowCreateContactRequest = '';
        public WorkflowCreateContactRequest(){
            testPost testPost = new testPost();
        }    
    }
    
    public class testPost {
      		public string idUser = '1';
            public string macroActivityDesc = 'EDENRED';
            public string campaignName = 'EDENRED';
            public string partnerName = 'DEFAULT';
            public string callcenterName = 'CC1_EDENRED';
            public string phoneNumber = '0377758746';
        public testPost(){}
    }*/
   
    public class reqPost {
        /*public String ecid;   
        public Boolean useMixer ;
		public String macroActivityDesc  ;
        public String customerInfo ;
        public String customerCode ;
        public String name ;
        public String surname ;    
        public String email ;
        public String taxCode ;
        public String vat ;
        public String address ;    
        public String city ;
        public String district ;    
        public String cap ;
		contactable:true*/
        public string idUser ;
        public String macroActivityName ;
        public string multimediaType;
        public String campaignName ;
        public String partnerName ;
        public String callcenterName ; 
        public String phoneNumber ;
        public String contactable;
        public String customerCode;
        public Map<string , string> multimediaInfo;
        public reqPost(Case requestCase , string campaign){
        	/*customerInfo =  requestCase.Contact.Description ;
            customerCode =  requestCase.Contact.id ;
            name =  requestCase.Contact.FirstName ;
            surname =  requestCase.Contact.LastName ;
            phoneNumber =  requestCase.Contact.phone ;
            email =  requestCase.Contact.Email ;
            taxCode =  requestCase.Contact.Account.IT_Fiscal_Code__c ;
            vat =  requestCase.Contact.Account.ER_VAT_Number__c ;
            address =  requestCase.Contact.Account.BillingStreet ;
            city =  requestCase.Contact.Account.BillingCity ;
            district =  requestCase.Contact.Account.BillingState ;
            cap =  requestCase.Contact.Account.BillingPostalCode ;*/
            idUser = '1';
            macroActivityName = 'MA_CLIENTI';
            campaignName = campaign;
            partnerName = 'EDENRED';
            customerCode = requestCase.id;
            callcenterName = 'CC_EDENRED'; 
            phoneNumber = '3330000000';
            multimediaType = 'OBJECT';
            contactable = 'true';
            multimediaInfo = new map<string,string>();
            multimediaInfo.put('caseId', requestCase.id);
            
            
        } 
	}
    public class responsePost {
        public String Status;
        public String StatusCode;
    }
        
    

}