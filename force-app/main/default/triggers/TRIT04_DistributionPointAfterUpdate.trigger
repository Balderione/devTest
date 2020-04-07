trigger TRIT04_DistributionPointAfterUpdate on ER_Distribution_Point__c (after insert, after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean AcoidControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    System.debug('AcoidControlTrigger:: '+AcoidControlTrigger);
    if(!AcoidControlTrigger){
        if (Trigger.isUpdate) {
            if(trigger.new[0].IT_Change_Address__c)
                APIT12_CallOutbound.createRequestAddress(trigger.new, 'ER_Distribution_Point__c');
            else
                APIT12_CallOutbound.createRequestDistributionPoint(trigger.new, null, 'Update');      
        }
        /*if (Trigger.isInsert) {
            List<String> idDistributionPoint = new List<String>();
            List<String> idDeliverySite = new List<String>();
            List<ER_Distribution_Point__c> listDP = new List<ER_Distribution_Point__c>();
            List<ER_Delivery_Site__c> listDS = new List<ER_Delivery_Site__c>();
            for(ER_Distribution_Point__c singleDP : trigger.new){
                if(!String.isBlank(singleDP.IT_AC_Activity__c) && !String.isBlank(singleDP.IT_SF_Activity__c)){
                    idDistributionPoint.add(singleDP.Id);
                    idDeliverySite.add(singleDP.ER_Delivery_Site__c); 
                }       
            }
            SObjectType finCenterType = Schema.getGlobalDescribe().get('ER_Distribution_Point__c');
            Map<String,Schema.SObjectField> finCenterFields = finCenterType.getDescribe().fields.getMap();
            String query = 'SELECT ';
            for(String field : finCenterFields.keySet()) {
                query+=field+',';
            }
            SObjectType FCType = Schema.getGlobalDescribe().get('ER_Financial_Center__c');
            Map<String,Schema.SObjectField> FCFields = FCType.getDescribe().fields.getMap();  
            for(String fieldFC : FCFields.keySet()) {
                query+='IT_Financial_Center__r.'+fieldFC+',';
            }
            query = query.removeEnd(',');
            System.debug(query);
            query += ' FROM ER_Distribution_Point__c WHERE Id IN: idDistributionPoint';

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
            System.debug(queryDS);
            queryDS += ' FROM ER_Delivery_Site__c WHERE Id IN: idDeliverySite';

            listDP = Database.query(query);
            listDS = Database.query(queryDS);

            if(listDP != null && listDS != null && listDP.size() > 0 && listDS.size() > 0)
                APIT12_CallOutbound.createRequestDistributionPoint(listDP, listDS, 'Insert');       
        }*/
    }
}