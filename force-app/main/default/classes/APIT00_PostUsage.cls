global with sharing class APIT00_PostUsage {
    @future(callout = true)    
    global static void getToken (String AccountNumber, String UOM, Decimal Quantity, DateTime StartDateTime, DateTime EndDateTime, String SubscriptionNumber, String ChargeNumber, String Description, String id_ordine_target, String Source, Boolean checkDelete, List<String> idUsage){
        // dopo i parametri in ingresso metto un booleano che arriva dal trigger "checkDelete"
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://rest.sandbox.eu.zuora.com/oauth/token');
        request.setHeader('Content_Type', 'application/x-www-form-urlencoded');
        request.setBody('grant_type=client_credentials' + '&client_secret=' + '0stxf=t1JaeLnDrgPUax8JpBYnhZLwWisViLQVL8u' + '&client_id=' + 'ff27e789-5cd5-4e40-b00b-53d7aaa52557');

        Map<String, String> resultMap = new  Map<String, String>();
        if(!Test.isRunningTest()){
        HTTPResponse res = http.send(request);
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
       
        resultMap.put('access_token', (String) response.get('access_token'));
        System.debug('resultMap:  '+resultMap);
        }
        ELSE{
            
        resultMap.put('access_token', 'sdsashnnjjeyr');
        }
            
        //in base al booleano faccio if, se viene parametro dal trigger faccio la chiamata delete altrimenti la postUsage
        IF(checkDelete == TRUE){
            deleteFromZuora(idUsage, resultMap);
            System.debug('ELIMINATO');
        }
        ELSE{
            postUsage(AccountNumber, UOM, Quantity, StartDateTime, EndDateTime, SubscriptionNumber, ChargeNumber, Description, id_ordine_target, Source, resultMap);
        	 System.debug('CREATO');
        }
        
      }
    
    global static void newUsage (List<IT_Usage__c> itUsa){
        String AccountNumber = itUsa[0].IT_Account_Number__c;
        System.debug('AccountNumber: '+AccountNumber);
        //String UOM = itUsa[0].IT_Usage_Type__c;
        Decimal Quantity;
        IF(itUsa[0].IT_Quantity__c == NULL){
            Quantity = itUsa[0].IT_Used_Quantity__c;
        }
        ELSE IF(itUsa[0].IT_Quantity__c != NULL){
            Quantity = itUsa[0].IT_Percentage__c/100;
        }
       
        DateTime StartDateTime = itUsa[0].IT_Date__c;
        DateTime EndDateTime = itUsa[0].IT_Date__c;
        String SubscriptionNumber = itUsa[0].IT_Num_Subscription__c;
        String ChargeNumber = itUsa[0].IT_Charge_ID__c;
        String Description=itUsa[0].IT_Description__c;
        //System.debug('Description: '+Description);
        String id_ordine_target=itUsa[0].ID;
        String Source='SF';
        String UOM = itUsa[0].IT_Usage_Type__c;
        System.debug(' itUsa[0].IT_Usage_Type__c'+  itUsa[0].IT_Usage_Type__c);
        IF(!string.isBlank(UOM))
        UOM = UOM.replaceAll('<[/a-zAZ0-9]*>','');
       
        getToken(AccountNumber, UOM, Quantity, StartDateTime, EndDateTime, SubscriptionNumber, ChargeNumber,Description,id_ordine_target, Source, FALSE, NULL);
    }
    
    @InvocableMethod
    global static void createRecord(list<flowVars> flvrs){
    System.debug('flvrs::: '+flvrs);
    newUsage(flvrs[0].itUsage);
       }

    global class flowVars{
    @invocablevariable
    global List<IT_Usage__c> itUsage;
    }
    
	global static void postUsage(String AccountNumber, String UOM, Decimal Quantity, DateTime StartDateTime, DateTime EndDateTime, String SubscriptionNumber, String ChargeNumber, String Description, String id_ordine_target, String Source, Map<String, String> resultToken){
         JSONGenerator gen = JSON.createGenerator(true);   
        gen.writeStartObject();     
         if(!String.ISBLANK(AccountNumber))
        gen.writeStringField('AccountNumber', AccountNumber);
        if(!String.ISBLANK(UOM))
        gen.writeStringField('UOM', UOM);
        if(Quantity != NULL)
        gen.writeNumberField('Quantity', Quantity);
        if(StartDateTime!= NULL)
        gen.writeDateTimeField('StartDateTime', StartDateTime);
        if(EndDateTime!= NULL)
        gen.writeDateTimeField('EndDateTime', EndDateTime);
        if(!String.ISBLANK(SubscriptionNumber))
        gen.writeStringField('SubscriptionNumber', SubscriptionNumber);
        if(!String.ISBLANK(ChargeNumber))
        gen.writeStringField('ChargeNumber', ChargeNumber);
        if(!String.ISBLANK(Description))
        gen.writeStringField('Description', Description);
        if(!String.ISBLANK(id_ordine_target))
        gen.writeStringField('id_ordine_target__c', id_ordine_target);
        if(!String.ISBLANK(Source))
        gen.writeStringField('Source__c', Source);
        gen.writeEndObject();   
        String jsonS = gen.getAsString();
        System.debug('jsonMaterials'+jsonS);
        
       
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://rest.sandbox.eu.zuora.com/v1/object/usage');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Cache-Control', 'no_cache');
        request.setHeader( 'Authorization', 'Bearer ' + resultToken.get('access_token'));
        request.setBody(jsonS);
        
        if(!Test.isRunningTest()){
        HTTPResponse response1 = http.send(request);
        System.debug('request1: ' +request);
        System.debug('response1:  '+response1);
                
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response1.getBody());
        responseMap.put('Id', (String) responseMap.get('Id')); 
 		System.debug('responseMap '+responseMap);
			//Map<String, String> finalMap = new Map<String, String>();
			//finalMap.put('zuora_id', jsonString);
			String zuora_id = String.valueOf(responseMap.get('Id'));
            System.debug('zuora_id: '+ zuora_id);
        saveID(zuora_id, id_ordine_target);
        }
    }
    
    global static void saveID (String zuora_id, String usageid){

        IT_Usage__c oneUsage = [SELECT IT_Account_Number__c FROM IT_Usage__c WHERE Id=:usageid LIMIT 1];
        oneUsage.IT_Zuora_ID__c=zuora_id;
        update oneUsage;
        System.debug('IT_Zuora_ID__c: '+ oneUsage.IT_Zuora_ID__c);
        System.debug('oneUsage ' +oneUsage);
    }
    
    //nuovo metodo con delete usage da zuora metto solo con id record nell'endpoint + quello che passo dal trigger {id}
    global static void deleteFromZuora(List<String> idUsage, Map<String, String> resultToken){
        FOR(String idSingle: idUsage){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint('https://rest.sandbox.eu.zuora.com/v1/object/usage/'+idSingle);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Cache-Control', 'no_cache');
        request.setHeader( 'Authorization', 'Bearer ' + resultToken.get('access_token'));
       
        if(!Test.isRunningTest()){
        HTTPResponse response2 = http.send(request);
        System.debug('request2: ' +request);
        System.debug('response2:  '+response2);
        }
            
       }
    }
      
}