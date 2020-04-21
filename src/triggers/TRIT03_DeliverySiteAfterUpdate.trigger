trigger TRIT03_DeliverySiteAfterUpdate on ER_Delivery_Site__c (after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean AcoidControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!AcoidControlTrigger){
        if(trigger.newMap.get(trigger.new[0].Id).IT_Count_Distribution_Point__c == trigger.oldMap.get(trigger.new[0].Id).IT_Count_Distribution_Point__c && trigger.newMap.get(trigger.new[0].Id).IT_Delivery_SF__c == trigger.oldMap.get(trigger.new[0].Id).IT_Delivery_SF__c){
            System.debug('trigger.new.size():::::: '+trigger.new.size());
            if(trigger.new[0].IT_Change_Address__c){
                APIT12_CallOutbound.createRequestAddress(trigger.new, 'ER_Delivery_Site__c');
            }else if(trigger.new.size() == 1 && trigger.newMap.get(trigger.new[0].Id).IT_Change_Address__c == trigger.oldMap.get(trigger.new[0].Id).IT_Change_Address__c){
                List<String> idDeliverySite = new List<String>();
                List<ER_Delivery_Site__c> listDS = new List<ER_Delivery_Site__c>();
                for(ER_Delivery_Site__c singleDS : trigger.new){
                    idDeliverySite.add(singleDS.Id);        
                }
                SObjectType DSType = Schema.getGlobalDescribe().get('ER_Delivery_Site__c');
                Map<String,Schema.SObjectField> DSFields = DSType.getDescribe().fields.getMap();
                String queryDS = 'SELECT ';
                for(String fieldDS : DSFields.keySet()) {
                    queryDS+=fieldDS+',';
                }
                SObjectType FCTypeD = Schema.getGlobalDescribe().get('ER_Financial_Center__c');
                Map<String,Schema.SObjectField> FCFieldsD = FCTypeD.getDescribe().fields.getMap();  
                for(String fieldFCD : FCFieldsD.keySet()) {
                    queryDS+='ER_Financial_Center__r.'+fieldFCD+',';
                }
                queryDS = queryDS.removeEnd(',');
                SObjectType disType = Schema.getGlobalDescribe().get('ER_Distribution_Point__c');
                Map<String,Schema.SObjectField> fcFields = disType.getDescribe().fields.getMap();
                queryDS +=', (SELECT '; 
                for(String field : fcFields.keySet()) {
                    queryDS+=field+',';
                }
                queryDS = queryDS.removeEnd(',');
                queryDS += ' FROM Distribution_Points__r) ';
                System.debug('Query Trigger TRIT03 '+queryDS);
                queryDS += ' FROM ER_Delivery_Site__c WHERE Id IN: idDeliverySite';

                listDS = Database.query(queryDS);

                APIT12_CallOutbound.createRequestDeliverySite(listDS, trigger.oldMap); 
            }    
        }              
    }    
}