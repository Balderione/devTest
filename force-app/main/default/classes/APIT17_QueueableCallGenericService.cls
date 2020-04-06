public with sharing class APIT17_QueueableCallGenericService implements Queueable {
    String stringJson;
    
    public APIT17_QueueableCallGenericService(String jsonCall, List<SObject> updateFlags, String nameObject){
        List<SObject> updateFlagsTotal = new List<SObject>();
        System.debug('updateFlags: '+updateFlags);
        System.debug('nameObject: '+nameObject);
        if(nameObject == 'Account' || nameObject == 'ER_Financial_Center__c' || nameObject == 'ER_Delivery_Site__c' || nameObject == 'ER_Distribution_Point__c'){
            for(SObject singleObj : updateFlags){
                Object updateFlagsSingle;
                Map<String,Object> mapObj = (Map<String,Object>)Json.deserializeUntyped(Json.serialize(singleObj));
                Boolean TriggerControl = false;
                if(mapObj != null && mapObj.Keyset().contains('IT_Change_Address__c') && mapObj.get('IT_Change_Address__c') == true){
                    System.debug('mapObj.getAddress: '+mapObj.get('IT_Change_Address__c'));
                    mapObj.put('IT_Change_Address__c', false);
                    TriggerControl = true;  
                }
                if(TriggerControl){
                    String cObjJsonDrunk = JSON.serialize(mapObj);
                    SObject customObject = (SObject)JSON.deserialize(cObjJsonDrunk, Sobject.class);
                    System.debug('customObject: '+customObject);
                    if(null != mapObj.get('IT_Change_VAT_Group__c') && nameObject == 'Account'){
                        updateFlagsTotal.add(customObject); 
                        System.debug('mapObj: '+mapObj);
                        System.debug('updateFlagsTotal: '+updateFlagsTotal); 
                    }
                    if(nameObject != 'Account'){
                        updateFlagsTotal.add(customObject); 
                        System.debug('mapObj: '+mapObj);
                        System.debug('updateFlagsTotal: '+updateFlagsTotal); 
                    }
                }      

                System.debug('mapObj.getPost: '+mapObj.get('IT_Change_VAT_Group__c'));   
            }
            if(updateFlagsTotal != null && updateFlagsTotal.size() > 0)
                update updateFlagsTotal;
        }    

        this.stringJson = jsonCall;
    }
      
    public void execute(QueueableContext context){
        System.debug('context: '+context);
        //APIT11_Utilities.postRequest('clients', stringJson);
    }   
}