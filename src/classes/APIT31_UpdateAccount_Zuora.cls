global class APIT31_UpdateAccount_Zuora {
     @future (callout=true)
    global static void getToken (List<String> idAcc){
        
        List<Account> acc=[SELECT id, IT_Special_Account__c, Name, IT_Tax_Region_c__c, (SELECT id, Zuora__Zuora_Id__c FROM Zuora__R00N40000001kyLcEAI__r ) FROM Account WHERE id in: idAcc];
		
        ZuoraParams params = getZuoraParameters();
        
        FOR(Account singleAcc: acc){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(params.endpoint + '/oauth/token');
        request.setHeader('Content_Type', 'application/x-www-form-urlencoded');
        request.setBody('grant_type=client_credentials' + '&client_secret=' + params.ClientSecret + '&client_id=' + params.ClientId);
		
        Map<String, String> resultMap = new  Map<String, String>();
        if(!Test.isRunningTest()){
        HTTPResponse res = http.send(request);
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        resultMap.put('access_token', (String) response.get('access_token'));
        System.debug('resultMap:  '+resultMap);
        }
        ELSE{
            System.debug('Test running');
        	resultMap.put('access_token', 'sdsashnnjjeyr');
        }
        
            List<String> listAcc = new list<String>();
            if(!test.isrunningtest()){
            IF(singleAcc.Zuora__R00N40000001kyLcEAI__r != NULL && singleAcc.Zuora__R00N40000001kyLcEAI__r[0].Zuora__Zuora_Id__c != NULL)
            listAcc.add(singleAcc.Zuora__R00N40000001kyLcEAI__r[0].Zuora__Zuora_Id__c);
            }
            IF(singleAcc.IT_Special_Account__c != NULL)
            listAcc.add(string.valueof(singleAcc.IT_Special_Account__c));
            IF(singleAcc.Name != NULL)
            listAcc.add(singleAcc.Name);
            IF(singleAcc.IT_Tax_Region_c__c != NULL)
            listAcc.add(singleAcc.IT_Tax_Region_c__c);
            
        genJson generatore= new genJson(listAcc,'Account');
              
        
        String stringBody=JSON.serializePretty(generatore, true); 
            System.debug('bodystrin:'+stringBody);
            
        updateAccount(resultMap, stringBody);
            
        
        }
    }
    
    global static void updateAccount(Map<String, String> resultToken, String jsonRequest){
		        
        	ZuoraParams params = getZuoraParameters();
        	Http http = new Http();
        	HttpRequest request = new HttpRequest();
        	request.setMethod('POST');
        	request.setEndpoint(params.endpoint +'/v1/action/update');
        	request.setHeader('Content-Type', 'application/json');
        	request.setHeader( 'Authorization', 'Bearer ' + resultToken.get('access_token'));
        	request.setBody(jsonRequest);
        	System.debug('body:' +jsonRequest);
        
        	if(!Test.isRunningTest()){
        	HTTPResponse response1 = http.send(request);
        	System.debug('request1: ' +request);
        	System.debug('response1:  '+response1);
                
                /*List<object> responseList = (List<object>) JSON.deserializeUntyped(response1.getBody());
                Map<String, Object> responseMap = new Map<String, Object>(); 
                FOR(object singleobject: responseList){
                    responseMap=(Map<String, Object>) JSON.deserializeUntyped(string.valueof(singleobject));
                    
                }
                System.debug('responseMap'+responseMap);*/
        	//Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response1.getBody());
    		}

    }
    
    public class genJson{
        public List<String> objects {get; set;}
        public String type {get; set;}
        public genJson(List<String> paramObject, String tipeObject){
            objects=paramObject;
            type=tipeObject;
            
        }
    }
    
    global static ZuoraParams getZuoraParameters (){
        CMIT13_Zuora_WS_Setting__mdt ZuoraCredentials = [SELECT IT_PROD_ClientId__c, IT_PROD_ClientSecret__c, IT_PROD_Endpoint__c, IT_SDX_ClientId__c, IT_SDX_ClientSecret__c, IT_SDX_Endpoint__c FROM CMIT13_Zuora_WS_Setting__mdt LIMIT 1];
        Boolean isSandbox = [Select isSandbox From Organization limit 1].isSandbox;
        ZuoraParams params = new ZuoraParams();
        if(isSandbox){
            params.endpoint =+ ZuoraCredentials.IT_SDX_Endpoint__c;
            params.ClientId = ZuoraCredentials.IT_SDX_ClientId__c;
            params.ClientSecret = ZuoraCredentials.IT_SDX_ClientSecret__c;
        }
        else{
            params.endpoint =+ ZuoraCredentials.IT_PROD_Endpoint__c;
            params.ClientId = ZuoraCredentials.IT_PROD_ClientId__c;
            params.ClientSecret = ZuoraCredentials.IT_PROD_ClientSecret__c;
        }
        return params;
    }
    
    global class ZuoraParams{
        String endpoint;
        String ClientId;
        String ClientSecret;
    }
}