trigger TRIT15_RequestAfterUpdate on IT_Request__c (after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    String ControlOK = '';
    if(!ControlTrigger){
        List<IT_Request__c> listTrigger = new List<IT_Request__c>();
        List<ER_Financial_Center__c> finCentList = new List<ER_Financial_Center__c>();
        List<String> listTriggerKey = new List<String>();
        Set<String> contractOld = new Set<String>();
        List<Contract> contractOldList = new List<Contract>();
        Map<String, List<Contract>> mapContractOld = new Map<String, List<Contract>>();
        Map<String, ER_Financial_Center__c> mapFC = new Map<String, ER_Financial_Center__c>();
        Set<String> controlSendOdContract = new Set<String>();
        List<Contract> controlSendOdContractList = new List<Contract>();
        for(IT_Request__c singleRequest : trigger.new){
            System.debug('singleRequest.IT_Client_Code__c:: '+singleRequest.IT_Client_Code__c);
            if(!String.isblank(singleRequest.IT_Client_Code__c) && trigger.newMap.get(singleRequest.Id).IT_Request_Status__c != trigger.oldMap.get(singleRequest.Id).IT_Request_Status__c && singleRequest.IT_Request_Status__c == '4'){    
                listTriggerKey.add(singleRequest.IT_Client_Code__c); 
                listTrigger.add(singleRequest);
            }
            if(trigger.newMap.get(singleRequest.Id).IT_Request_Flow_Control__c != trigger.oldMap.get(singleRequest.Id).IT_Request_Flow_Control__c && singleRequest.IT_Request_Flow_Control__c == true){
                controlSendOdContract.add(singleRequest.IT_Client_Code__c);
            }
            System.debug('controlSendOdContract:: '+controlSendOdContract);      
        } 

        if((listTriggerKey != null && listTriggerKey.size() > 0) || (controlSendOdContract != null && controlSendOdContract.size() > 0)){
            System.debug('listTriggerKeyc:: '+listTriggerKey);
            SObjectType finCenterType = Schema.getGlobalDescribe().get('ER_Financial_Center__c');
            Map<String,Schema.SObjectField> finCenterFields = finCenterType.getDescribe().fields.getMap();
            String query = 'SELECT ';
            for(String field : finCenterFields.keySet()) {
                query+=field+',';
            }
            SObjectType bankAccountType = Schema.getGlobalDescribe().get('ER_Bank_Account__c');
            Map<String,Schema.SObjectField> bankAccountFields = bankAccountType.getDescribe().fields.getMap();
            query +='(SELECT ';
            for(String field : bankAccountFields.keySet()) {
                query+=field+',';
            }
            query = query.removeEnd(',');
            query += ' FROM Bank_Accounts__r) ';
            SObjectType fcType = Schema.getGlobalDescribe().get('Contract');
            Map<String,Schema.SObjectField> fcFields = fcType.getDescribe().fields.getMap();
            query +=', (SELECT '; 
            for(String field : fcFields.keySet()) {
                query+=field+',';
            }
            query = query.removeEnd(',');
            query += ' FROM Contracts__r) ';
            System.debug('QUERY::: '+query);
            query += ' FROM ER_Financial_Center__c WHERE IT_Financial_Center__c IN: listTriggerKey OR IT_Financial_Center__c IN: controlSendOdContract';
            finCentList = Database.query(query);
        }    

        System.debug('finCentList::: '+finCentList);
        if(((listTrigger != null && listTrigger.size() > 0) || (controlSendOdContract != null && controlSendOdContract.size() > 0)) && finCentList != null && finCentList.size() > 0){
            for(ER_Financial_Center__c singleFC : finCentList){
                mapFC.put(singleFC.IT_Financial_center__c, singleFC);
                contractOld.add(singleFC.IT_Contract__c);
            }
            System.debug('mapFC:: '+mapFC);
            if(contractOld != null && contractOld.size() > 0){
                SObjectType contractOldType = Schema.getGlobalDescribe().get('Contract');
                Map<String,Schema.SObjectField> contractOldFields = contractOldType.getDescribe().fields.getMap();
                String queryContract = 'SELECT ';
                for(String field : contractOldFields.keySet()) {
                    queryContract+=field+',';
                }
                SObjectType financialCentType = Schema.getGlobalDescribe().get('ER_Financial_Center__c');
                Map<String,Schema.SObjectField> finCentFields = financialCentType.getDescribe().fields.getMap();
                for(String fieldF : finCentFields.keySet()) {
                    queryContract+='IT_Financial_center__r.'+fieldF+',';
                }
                queryContract = queryContract.removeEnd(',');
                queryContract += ' FROM Contract WHERE Id IN: contractOld';
                contractOldList = Database.query(queryContract);
                System.debug('contractOldList::: '+contractOldList);
                if(controlSendOdContract != null && controlSendOdContract.size() > 0 && contractOldList != null && contractOldList.size() > 0){
                    List<Contract> sendCallContrListT = new List<Contract>();
                    for(IT_Request__c itemSingleT : trigger.new){
                        for(Contract singleContract : contractOldList){
                            Contract sendOldContrT = new Contract();
                            sendOldContrT = singleContract;
                            sendOldContrT.EndDate = itemSingleT.IT_Contract_Start_Date__c - 1;     
                            sendOldContrT.IT_Contract_Closing_Type__c = '017';
                            sendOldContrT.IT_Contract_Status__c = '03';
                            sendCallContrListT.add(sendOldContrT);   
                        }    
                        APIT12_CallOutbound.createRequestContract(sendCallContrListT, 'Contract');
                    } 
                }else if(contractOldList != null && contractOldList.size() > 0){
                    for(contract singleContract : contractOldList){
                        List<Contract> oldContract = new List<Contract>();
                        oldContract.add(singleContract);
                        mapContractOld.put(singleContract.IT_Financial_center__r.IT_Financial_Center__c, oldContract);    
                    }
                    System.debug('mapContractOld::: '+mapContractOld);
                    if(mapContractOld != null && mapContractOld.size() > 0){
                        if(String.isBlank(listTrigger[0].IT_New_Service__c) && String.isBlank(listTrigger[0].IT_New_VAT_Number__c) && listTrigger[0].IT_Contract_Start_Date__c > System.today()){
                            List<IT_Request__c> requestFuture = new List<IT_Request__c>();
                            requestFuture.add(listTrigger[0]);
                            APIT12_CallOutbound.createRequestCustomFlow(requestFuture, mapContractOld.get(listTrigger[0].IT_Client_Code__c)[0], null, 1);
                        }       
                        ControlOK = APIT11_Utilities.saveChangeCondition(listTrigger, mapFC, mapContractOld);
                    }    
                }     
            }    
        }
        if(ControlOK == '' || ControlOK == 'ConditionChangeOK')
            APIT12_CallOutbound.createRequestCustom(trigger.new);           
    }
    /*if(!ControlTrigger){
        List<IT_Request__c> listUpdateRequest = new List<IT_Request__c>();
        for(IT_Request__c singleRequest : trigger.new){
            if(!String.isblank(singleRequest.IT_Client_Code__c) && (singleRequest.IT_Request_Status__c == '2' || singleRequest.IT_Request_Status__c == '5')){
                listUpdateRequest.add(singleRequest);
            }       
        }
        System.debug('listUpdateRequest::: '+listUpdateRequest);
        if(listUpdateRequest != null && listUpdateRequest.size() > 0){
            APIT12_CallOutbound.createRequestCustom(listUpdateRequest); 
        }    
    }*/ 
}