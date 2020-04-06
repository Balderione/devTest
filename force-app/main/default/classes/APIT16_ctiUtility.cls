global class APIT16_ctiUtility {
    
    global static string changeOwner (string MEDIAID ,id caseId , string agentid ,  string CT7AGENTID, string callId ){
        //UUID già in createCase
        system.debug('CASE:: '+caseId);
        system.debug('USER:: '+agentId);
        List<Case> casetoChange = [SELECT id , OwnerId from Case where id = :caseId LIMIT 1];
        if(casetoChange != NULL && casetoChange.size() > 0){ 
            casetoChange[0].OwnerId = agentId;
            casetoChange[0].IT_CTI_MediaId__c = MEDIAID;
            caseToChange[0].IT_CT7_Agent_Id__c = CT7AGENTID;
            CasetoChange[0].IT_CTI_Call_Id__c = callId;
            update caseToChange[0];
            return (string)caseId;
        }
        else{
            return 'ERROR:: CASE NOT FOUND';
        }   
    }
    global static string logCall(string caseId , string callDuration, string callStartDate, string callEndDate, string outcome, boolean isOutbound){
        //callduration è in secondi
        //outcome -> reason
        //creo anche activity FORSE NO
        //task tipo chiamata collegata al caso se esiste referente (del caso) lo collego
        //
        //
        

        system.debug('CALL DURATION: '+callDuration);
        system.debug('CALL callStartDate: '+callStartDate);
        system.debug('CALL callEndDate: '+callEndDate);
        Long l = Long.valueOf(callStartDate+'000');
        Long l2 = Long.valueOf(callEndDate+'000');
        system.debug(DateTime.newInstance(l));
        string result = ' TEST COMPLETE , OUTCOME =  ' + outcome;
        string descr = 'Chiamata ';
        if(isOutbound){
            descr += 'outbound: ';
        }
        else{
            descr += 'inbound: ';
        }
        descr += '\n Inizio chiamata alle: ' +string.valueof(DateTime.newInstance(l))+'\n Fine Chiamata alle: '+string.valueof(DateTime.newInstance(l2))+'\n Durata: '+callDuration;
        Task newTask = new Task (WhatId = caseId, Description = descr);
        insert newTask;
        system.debug('ID TASK'+newtask.id);
        return 'ID TASK'+newtask.id;
    }
    global static id getCurrentUser(){
        system.debug('USER:: '+UserInfo.getUserId());
        return UserInfo.getUserId();
        
    }
    global static string getCurrentUserExt(){
        system.debug('USER:: '+UserInfo.getUserId());
        return UserInfo.getUserId() + '|' + UserInfo.getUserEmail();
        
    }
    global static string createCase (string MEDIAID ,string accountId, string ivrCh1 , string ivrCh2 ,  string ivrCh3 , string DNIS, string codCli, string ANI, string UUID, string CALLID, string CT7AGENTID ){
        //AGGIUNGERE UUID e CALLID
        system.debug('ANI : '+ ANI + ' FINCENTER : ' + codCli + ' DNIS : '+DNIS);
        case testCase = new Case();
        list<ER_Financial_Center__c> finC = new list <ER_Financial_Center__c>();
        list<Contact> con = new List<Contact>();
        List<IT_Circuit__c> circs = new List<IT_Circuit__c>();
        if(ANI != '' && ANI != null && ANI != 'PRIVATENUMBER'){
            con = [SELECT id from contact where MobilePhone = :ANI OR Phone =:ANI];
            testCase.SuppliedPhone = ANI;
        }
        if(con != null && con.size() > 0){
            testCase.ContactId = con[0].id;
        }
        if(codCli != null && codCli != ''){
            finC = [SELECT Id , IT_Circuit__r.Id from ER_Financial_Center__c where Name = :codCli];
        }
        if(finC != null && finC.size() >0){
            testCase.IT_Financial_Center__c = finc[0].id;
            if(finc[0].IT_Circuit__r.Id != null){
                testCase.IT_Circuit__c = finc[0].IT_Circuit__r.Id;
            }
        }
        if(finC == null || finC.size() == 0){
            circs = [SELECT id FROM IT_Circuit__c WHERE IT_Circuit_Code__c =:codCli];
        }
        if(circs != null && circs.size() > 0 ){
            testCase.IT_Circuit__c = circs[0].id;
        }
        testCase.AccountId = null;
        testCase.IT_CTI_Call_Id__c  = CALLID;
        testCase.IT_CT7_Agent_Id__c = CT7AGENTID;
        testCase.IT_CTI_MediaId__c = MEDIAID;
        testCase.IT_IVR_Level_1__c = ivrCh1;
        testCase.IT_IVR_Level_2__c = ivrCh2;
        testCase.IT_IVR_Level_3__c = ivrCh3;
        testCase.IT_IVR_Number_Email_Address__c = DNIS;
        testCase.Origin = 'Phone';
        testCase.Status = 'In_Progress';
        
        string ivrdetail;
        List<Schema.PicklistEntry> pickvals = Case.IT_IVR_Level_3__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry f : pickvals){
            if(f.getValue() == ivrCh3){
                system.debug('VALUEPICK' +f.getLabel());
                ivrdetail = f.getLabel();
            }
        }
        string caseSubj = 'Chiamata in Arrivo';
        if(codCLi != null){
            caseSubj += ' - '+codCli;
        }
        if(ivrDetail != null){
            caseSubj += ' - '+ivrDetail;
        }
        testCase.Subject = caseSubj;
        
        testCase.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Support_Case_RT').getRecordTypeId();
        try{
            insert testCase; 
        }
        catch(exception ecc){
            System.debug('Error CTIUTILITY: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
        
        
        return testCase.Id;
        
    }
}