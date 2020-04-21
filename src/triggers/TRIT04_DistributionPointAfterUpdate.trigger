trigger TRIT04_DistributionPointAfterUpdate on ER_Distribution_Point__c (after update, before update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean AcoidControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    System.debug('AcoidControlTrigger:: '+AcoidControlTrigger);
    System.debug('trigger.new:: '+trigger.new.size());
    if(!AcoidControlTrigger){
        if (Trigger.isAfter && Trigger.isUpdate) {
            System.debug('trigger.newMap.get(trigger.new[0].Id).ER_Delivery_Site__c:: '+trigger.newMap.get(trigger.new[0].Id).ER_Delivery_Site__c);
            System.debug('trigger.oldMap.get(trigger.new[0].Id).ER_Delivery_Site__c:: '+trigger.oldMap.get(trigger.new[0].Id).ER_Delivery_Site__c);
            if(trigger.newMap.get(trigger.new[0].Id).IT_Suspension__c == trigger.oldMap.get(trigger.new[0].Id).IT_Suspension__c && trigger.newMap.get(trigger.new[0].Id).IT_Suspension_Reason__c == trigger.oldMap.get(trigger.new[0].Id).IT_Suspension_Reason__c && trigger.newMap.get(trigger.new[0].Id).ER_Delivery_Site__c == trigger.oldMap.get(trigger.new[0].Id).ER_Delivery_Site__c && trigger.newMap.get(trigger.new[0].Id).IT_SF_Activity__c == trigger.oldMap.get(trigger.new[0].Id).IT_SF_Activity__c){
                System.debug('trigger.new:: '+trigger.new.size());
                if(trigger.new[0].IT_Change_Address__c){
                    APIT12_CallOutbound.createRequestAddress(trigger.new, 'ER_Distribution_Point__c');
                }else if(trigger.new.size() == 1 && trigger.newMap.get(trigger.new[0].Id).IT_Change_Address__c == trigger.oldMap.get(trigger.new[0].Id).IT_Change_Address__c && trigger.newMap.get(trigger.new[0].Id).IT_AC_Activity__c == trigger.oldMap.get(trigger.new[0].Id).IT_AC_Activity__c){
                    List<String> idDistributionPoint = new List<String>();
                    List<String> idDeliverySite = new List<String>();
                    List<ER_Distribution_Point__c> listDP = new List<ER_Distribution_Point__c>();
                    List<ER_Delivery_Site__c> listDS = new List<ER_Delivery_Site__c>();
                    for(ER_Distribution_Point__c singleDP : trigger.new){
                        idDistributionPoint.add(singleDP.Id);
                        idDeliverySite.add(singleDP.ER_Delivery_Site__c);        
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
                        APIT12_CallOutbound.createRequestDistributionPoint(listDP, listDS, null, 'Update', trigger.oldMap);       
                } 
            }              
        }
        if(Trigger.isBefore) {
            List<ER_Distribution_Point__c> costCenterControl = [Select Id, IT_Cost_Center_End_Date__c, IT_Cost_Center__c From ER_Distribution_Point__c Where IT_Financial_Center__r.IT_Financial_Center__c =: trigger.new[0].IT_Client_Code__c];
            for(ER_Distribution_Point__c singleDp : trigger.new){
                if(trigger.newMap.get(trigger.new[0].Id).IT_Cost_Center_End_Date__c != trigger.oldMap.get(trigger.new[0].Id).IT_Cost_Center_End_Date__c && costCenterControl != null && costCenterControl.size() > 1){
                    Integer contrlAllCenterCost = 0;
                    for(ER_Distribution_Point__c allDp : costCenterControl){
                        if(String.isBlank(allDp.IT_Cost_Center__c))
                            contrlAllCenterCost++;
                    }
                    if(contrlAllCenterCost > 0)
                        singleDp.addError('Le attività del cliente non hanno il centro di costo valorizzato'); 
                }
            }
        }
    }else{
        if(Trigger.isAfter) {
            String profileName = [Select Name From Profile Where Id =: UserInfo.getProfileId() limit 1].Name;
            List<ER_Distribution_Point__c> singleListDP = new List<ER_Distribution_Point__c>();
            //if(profileName == 'IT System Integration'){
                for(ER_Distribution_Point__c sinDis : trigger.new){
                    if(trigger.newMap.get(sinDis.Id).IT_AC_Activity__c != trigger.oldMap.get(sinDis.Id).IT_AC_Activity__c && String.isblank(trigger.oldMap.get(sinDis.Id).IT_AC_Activity__c)){
                        if(!String.isBlank(sinDis.IT_Data_Type_To_Display_2__c) || !String.isBlank(sinDis.IT_Data_To_Display_2__c)){
                            ER_Distribution_Point__c ticketActivity2 = new ER_Distribution_Point__c();
                            ticketActivity2 = sinDis.clone(true, true, false, false);
                            ticketActivity2.IT_Data_Type_To_Display__c = sinDis.IT_Data_Type_To_Display_2__c;
                            ticketActivity2.IT_Data_To_Display__c = sinDis.IT_Data_To_Display_2__c;
                            ticketActivity2.IT_Raw_Number_for_Display__c = 2;
                            singleListDP = new List<ER_Distribution_Point__c>();
                            singleListDP.add(ticketActivity2);
                            APIT12_CallOutbound.createRequestDistributionPoint(singleListDP, null, null, 'Update', trigger.oldMap);   
                        }
                        if(!String.isBlank(sinDis.IT_Data_Type_To_Display_3__c) || !String.isBlank(sinDis.IT_Data_To_Display_3__c)){
                            ER_Distribution_Point__c ticketActivity3 = new ER_Distribution_Point__c();
                            ticketActivity3 = sinDis.clone(true, true, false, false);
                            ticketActivity3.IT_Data_Type_To_Display__c = sinDis.IT_Data_Type_To_Display_3__c;
                            ticketActivity3.IT_Data_To_Display__c = sinDis.IT_Data_To_Display_3__c;
                            ticketActivity3.IT_Free_Description_to_Display__c = sinDis.IT_Free_Description_to_Display_2__c;
                            ticketActivity3.IT_Raw_Number_for_Display__c = 3;                           
                            singleListDP = new List<ER_Distribution_Point__c>();
                            singleListDP.add(ticketActivity3);
                            APIT12_CallOutbound.createRequestDistributionPoint(singleListDP, null, null, 'Update', trigger.oldMap);
                        }
                        if(!String.isBlank(sinDis.IT_Data_Type_To_Display_4__c) || !String.isBlank(sinDis.IT_Data_To_Display_4__c)){
                            ER_Distribution_Point__c ticketActivity4 = new ER_Distribution_Point__c();
                            ticketActivity4 = sinDis.clone(true, true, false, false);
                            ticketActivity4.IT_Data_Type_To_Display__c = sinDis.IT_Data_Type_To_Display_4__c;
                            ticketActivity4.IT_Data_To_Display__c = sinDis.IT_Data_To_Display_4__c;
                            ticketActivity4.IT_Free_Description_to_Display__c = sinDis.IT_Free_Description_to_Display_3__c;
                            ticketActivity4.IT_Raw_Number_for_Display__c = 4;
                            singleListDP = new List<ER_Distribution_Point__c>();
                            singleListDP.add(ticketActivity4);
                            APIT12_CallOutbound.createRequestDistributionPoint(singleListDP, null, null, 'Update', trigger.oldMap);
                        }        
                    } 
                }
            //}    
        }    
    }
}