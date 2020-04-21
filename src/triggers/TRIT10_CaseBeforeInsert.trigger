trigger TRIT10_CaseBeforeInsert on Case (before insert, before update, after insert, after update) {
    if(trigger.isInsert && trigger.isBefore){
        //AD encrypt case number
        IT_Custom_Control__c mhc = IT_Custom_Control__c.getInstance('KeyCaseNumber'); 
        String stringKey = ''; 
        if (!test.isRunningTest())  {
            stringKey = mhc.IT_Custom_Text__c;
        }
        else{
            stringKey = '1v4XI+JZGajcDlmOaZnpmpXQfvMOZH+u63nPV9G0XZE=';
        }
        Blob keyEn = EncodingUtil.base64Decode(stringKey);
        String caseAuto = '';
        if (test.isRunningTest())  {
            caseAuto = '00000001';
        }else{
            caseAuto = [select CaseNumber From Case Order by CaseNumber desc limit 1].CaseNumber;
        }
        Integer newCaseNumbercount = 1;
        for(Case singleCase : trigger.new){
            Integer newCaseNumber = Integer.valueOf(caseAuto) + newCaseNumbercount;
            Integer numTemp = 8 - String.valueOf(newCaseNumber).length();
            String caseNumberOk = '';
            for(integer i=0; i<numTemp; i++){
                caseNumberOk = caseNumberOk+='0';
            }
            caseNumberOk = caseNumberOk += String.valueOf(newCaseNumber);
            system.debug('caseNumberOk:: '+caseNumberOk);
            Blob caseNum = Blob.valueOf(caseNumberOk);
            Blob codeEncrypt =  Crypto.encryptWithManagedIV('AES256', keyEn, caseNum);
            singleCase.IT_Case_Number_Cripted__c = EncodingUtil.urlEncode(EncodingUtil.base64Encode(codeEncrypt), 'UTF-8');
            newCaseNumbercount++;
        }   
        //AD encrypt case number - END
        APIT15_CaseTriggerHandler.CaseToContractLink(Trigger.New);
        string result = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(trigger.new[0].RecordTypeId).getDeveloperName();
        if(result == 'IT_Client_Welfare_Provisioning_Case_RT'){
            List<Entitlement> entList= [SELECT id FROM Entitlement Where Name = 'Provisioning Flexben'];
            if(entList != null && entList.size() > 0){
                trigger.new[0].EntitlementId = entList[0].id;
            }
        }
        if(result == 'IT_Client_Consip_Case_RT'){
            APIT15_CaseTriggerHandler.populateCaseMilestoneFields(trigger.new[0]);
        }

    }
    if(trigger.isInsert && trigger.IsBefore){
        APIT15_CaseTriggerHandler.associateContactDetailToCase(Trigger.new[0]);
        
    }
    if(trigger.isBefore){
        String strinCode = APIT15_CaseTriggerHandler.CaseToContractLink(Trigger.New);
        if(!String.isBlank(strinCode)){
            APIT24_AccountCodeCheck.EncryptModel encryptIstance = new APIT24_AccountCodeCheck.EncryptModel(strinCode);
            String codeEncrypted = encryptIstance.encrypt();
            trigger.New[0].IT_Incentive_URL__c = codeEncrypted;
        }
        APIT15_CaseTriggerHandler.CaseEntitlementLink(Trigger.New);
    }
    if(trigger.isAfter && trigger.isUpdate){
        APIT15_CaseTriggerHandler.MilestoneAutoComplete(Trigger.New);
        if((trigger.new[0].status == 'Closed' && trigger.old[0].status != 'Closed') || (trigger.new[0].status == 'Waiting' && trigger.old[0].status != 'Waiting')){
            APIT15_CaseTriggerHandler.CTICalloutClosedCase(JSON.serialize(trigger.new[0]));
        }
        
    }
    /*if(trigger.isAfter && trigger.isInsert){
        APIT15_CaseTriggerHandler.caseEmailHandler(Trigger.New);
    }*/
    if(trigger.isAfter && trigger.isInsert){
        string result = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(trigger.new[0].RecordTypeId).getDeveloperName();
        system.debug('RECTYPE:: '+result);
        if(trigger.New[0].Origin == 'Email' && trigger.New[0].Status != 'Closed' && Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(trigger.new[0].RecordTypeId).getDeveloperName() == 'IT_Client_Support_Case_RT'){
            APIT15_CaseTriggerHandler.CTICallout(JSON.serialize(trigger.new[0]));
        }
        APIT15_CaseTriggerHandler.changeCaseQueue(JSON.serialize(trigger.new[0]));    

    }
    
        
       
    
}