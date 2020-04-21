trigger TRIT09_ContactAssociationAfterUpdate on IT_Contact_Association__c (after insert, after update, before insert) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!ControlTrigger){
        List<String> idContactAss = new List<String>();
        List<String> clientCode = new List<String>();
        List<String> detailIdCode = new List<String>();
        List<IT_Contact_Association__c> listContactAss = new List<IT_Contact_Association__c>();

        Map<String, Integer> contactDetailUpdateMapSoc = new Map<String, Integer>();
        Map<String, Integer> contactDetailUpdateMapRef = new Map<String, Integer>();
        Map<String, String> controlSocRef = new Map<String, String>();

        for(IT_Contact_Association__c singleContactASS : trigger.new){
            idContactAss.add(singleContactASS.Id);
            clientCode.add(singleContactASS.IT_Client_Code__c);
            detailIdCode.add(singleContactASS.IT_Contact_Detail__c);
        }
        System.debug('clientCode::: '+clientCode); 

        if(Trigger.isAfter){ 
            SObjectType contactAssType = Schema.getGlobalDescribe().get('IT_Contact_Association__c');
            Map<String,Schema.SObjectField> contactAssFields = contactAssType.getDescribe().fields.getMap(); 
            String query = 'SELECT ';
            for(String field : contactAssFields.keySet()) {
                query+=field+',';
            }
            SObjectType contactDetType = Schema.getGlobalDescribe().get('IT_Contact_Detail__c');
            Map<String,Schema.SObjectField> conDetFields = contactDetType.getDescribe().fields.getMap();
            for(String field : conDetFields.keySet()) {
                query+='IT_Contact_Detail__r.'+field+',';
            }
            SObjectType contactType = Schema.getGlobalDescribe().get('Contact');
            Map<String,Schema.SObjectField> contactFields = contactType.getDescribe().fields.getMap(); 
            for(String field : contactFields.keySet()) {
                query+='IT_Contact_Detail__r.IT_Contact__r.'+field+',';
            }
            SObjectType accountType = Schema.getGlobalDescribe().get('Account');
            Map<String,Schema.SObjectField> accountFields = accountType.getDescribe().fields.getMap(); 
            for(String field : accountFields.keySet()) {
                query+='IT_Contact_Detail__r.IT_Contact__r.Account.'+field+',';
            }
            query = query.removeEnd(',');

            System.debug(query);
            query += ' FROM IT_Contact_Association__c WHERE Id IN: idContactAss';
            listContactAss = Database.query(query);
   
            if(listContactAss != null && listContactAss.size() > 0)
                APIT12_CallOutbound.createRequestContactAss(listContactAss);
        
        }else if(Trigger.isBefore){

            list<ER_Financial_Center__c> listFC = new list<ER_Financial_Center__c>();
            list<IT_Contact_Detail__c> listDetail = new list<IT_Contact_Detail__c>();
            set<String> listDetailId = new set<String>();
            Integer maxDetailSoc = 0;
            Integer maxDetailRef = 0;
            SObjectType fcType = Schema.getGlobalDescribe().get('ER_Financial_Center__c');
            Map<String,Schema.SObjectField> fcFields = fcType.getDescribe().fields.getMap();
            String queryFc = 'SELECT ';
            for(String fieldFc : fcFields.keySet()) {
                queryFc+=fieldFc+',';
            }
            SObjectType contactASSOType = Schema.getGlobalDescribe().get('IT_Contact_Association__c');
            Map<String,Schema.SObjectField> cASSFields = contactASSOType.getDescribe().fields.getMap();
                queryFc +='(SELECT ';
            for(String field : cASSFields.keySet()) {
                queryFc+=field+',';
            }
            queryFc = queryFc.removeEnd(',');
     
            queryFc += ' FROM Contact_Association__r Where IT_Contact_Detail__r.IT_Contact__r.IT_Type__c = \'Soc\' Order by IT_Association_progressive__c desc NULLS LAST Limit 1) ';
    
            System.debug('Query after contact::: '+queryFc);
            queryFc += ' FROM ER_Financial_Center__c WHERE IT_Financial_Center__c IN: clientCode';
            listFC = Database.query(queryFc);
            System.debug('listFC::: '+listFC);

            SObjectType detailType = Schema.getGlobalDescribe().get('IT_Contact_Detail__c');
            Map<String,Schema.SObjectField> detailFields = detailType.getDescribe().fields.getMap();
            String queryDetail = 'SELECT ';
            for(String fieldDetail : detailFields.keySet()) {
                queryDetail+=fieldDetail+',';
            }
            SObjectType contactType = Schema.getGlobalDescribe().get('Contact');
            Map<String,Schema.SObjectField> contactFields = contactType.getDescribe().fields.getMap();  
            for(String fieldContact : contactFields.keySet()) {
                queryDetail+='IT_Contact__r.'+fieldContact+',';
            }
            SObjectType contactASType = Schema.getGlobalDescribe().get('IT_Contact_Association__c');
            Map<String,Schema.SObjectField> cASFields = contactASType.getDescribe().fields.getMap();
                queryDetail +='(SELECT ';
            for(String field : cASFields.keySet()) {
                queryDetail+=field+',';
            }
            queryDetail = queryDetail.removeEnd(',');
     
            queryDetail += ' FROM Contact_Association__r Order by IT_Association_progressive__c desc NULLS LAST) ';
    
            System.debug('Query after contact::: '+queryDetail);
            queryDetail += ' FROM IT_Contact_Detail__c WHERE Id IN: detailIdCode';

            listDetail = Database.query(queryDetail);

            List<IT_Contact_Association__c> contactList = new List<IT_Contact_Association__c>();
            List<String> contactListId = new List<String>();
            Map<String, Integer> contactMapId = new Map<String, Integer>();

            if(listDetail != null && listDetail.size() > 0){
                for(IT_Contact_Detail__c singleDetail : listDetail){
                    controlSocRef.put(singleDetail.Id, singleDetail.IT_Contact__r.IT_Type__c);
                    contactListId.add(singleDetail.IT_Contact__c);
                }        
            }

            contactList = [Select Id, IT_Association_progressive__c, IT_Contact_Detail__r.IT_Contact__c From IT_Contact_Association__c Where IT_Contact_Detail__r.IT_Contact__c IN: contactListId Order by IT_Association_progressive__c desc NULLS LAST];
            Integer assoMax = 0;
            if(contactList != null && contactList.size() > 0 && !String.isBlank(contactList[0].IT_Association_progressive__c))
                assoMax = integer.valueOf(contactList[0].IT_Association_progressive__c);

            for(IT_Contact_Association__c singleASS : contactList){
                if(!contactMapId.Keyset().contains(singleASS.IT_Contact_Detail__c) && !String.isBlank(singleASS.IT_Contact_Detail__c) && !String.isBlank(singleASS.IT_Association_Progressive__c)){
                    System.debug('singleASS.IT_Contact_Detail__c::: '+singleASS.IT_Contact_Detail__c);
                    System.debug('singleASS.IT_Association_Progressive__c::: '+ singleASS.IT_Association_Progressive__c);
                    contactMapId.put(singleASS.IT_Contact_Detail__c, Integer.valueOf(singleASS.IT_Association_Progressive__c));
                }           
            } 

            for(IT_Contact_Association__c singleAS : trigger.new){
                if(contactMapId != null && contactMapId.size() > 0){
                    if(contactMapId.keyset().contains(singleAS.IT_Contact_Detail__c)){
                        contactDetailUpdateMapRef.put(singleAS.IT_Contact_Detail__c, contactMapId.get(singleAS.IT_Contact_Detail__c));
                    }else{ 
                        contactDetailUpdateMapRef.put(singleAS.IT_Contact_Detail__c, assoMax + 1);  
                    } 
                }else{
                    contactDetailUpdateMapRef.put(singleAS.IT_Contact_Detail__c, 1);      
                }            
            }
             
            Map<String, String> controlDetail = new Map<String, String>();
            if(listFC != null && listFC.size() > 0){
                list<String> financialCode = new list<String>();
                list<IT_Contact_Association__c> financialCodeList = new list<IT_Contact_Association__c>();
                Map<String, List<IT_Contact_Association__c>> mapAssoFC = new Map<String, List<IT_Contact_Association__c>>(); 
                for(ER_Financial_Center__c sinFcPre : listFC){
                    financialCode.add(sinFcPre.IT_Financial_Center__c);    
                }
                SObjectType conatactAssoType = Schema.getGlobalDescribe().get('IT_Contact_Association__c');
                Map<String,Schema.SObjectField> assocFields = conatactAssoType.getDescribe().fields.getMap();
                String queryAssoc = 'SELECT ';
                for(String fieldFc : assocFields.keySet()) {
                    queryAssoc+=fieldFc+',';
                }
                queryAssoc = queryAssoc.removeEnd(',');
                queryAssoc += ' FROM IT_Contact_Association__c Where IT_Client_Code__c IN: financialCode And IT_Contact_Detail__r.IT_Contact__r.IT_Type__c = \'Soc\' Order by IT_Association_progressive__c desc NULLS LAST ';
                financialCodeList = Database.query(queryAssoc);
                if(financialCodeList != null && financialCodeList.size() > 0){
                    for(IT_Contact_Association__c sinAS : financialCodeList){
                        if(mapAssoFC != null && mapAssoFC.size() > 0 && mapAssoFC.keyset().contains(sinAS.IT_Client_Code__c)){
                            List<IT_Contact_Association__c> financialCodeListTemp = new list<IT_Contact_Association__c>();
                            financialCodeListTemp = mapAssoFC.get(sinAS.IT_Client_Code__c);
                            financialCodeListTemp.add(sinAS);
                            mapAssoFC.put(sinAS.IT_Client_Code__c, financialCodeListTemp);
                        }else{
                            List<IT_Contact_Association__c> financialCodeListTemp = new list<IT_Contact_Association__c>();
                            financialCodeListTemp.add(sinAS);
                            mapAssoFC.put(sinAS.IT_Client_Code__c, financialCodeListTemp);    
                        }
                    }
                }

                for(ER_Financial_Center__c sinFc : listFC){
                    if(mapAssoFC != null && mapAssoFC.size() > 0 && mapAssoFC.keyset().contains(sinFc.IT_Financial_Center__c)){
                        for(IT_Contact_Association__c sinAss : mapAssoFC.get(sinFc.IT_Financial_Center__c)){ 
                            if(!controlDetail.keyset().contains(sinAss.IT_Contact_Detail__c) && sinAss.IT_Association_Progressive__c != null)
                                controlDetail.put(sinAss.IT_Contact_Detail__c, sinAss.IT_Association_Progressive__c);
                        }
                    }            
                }
                for(ER_Financial_Center__c singleFc : listFC){
                    if(singleFc.Contact_Association__r != null && singleFc.Contact_Association__r.size() > 0 && !String.isBlank(singleFc.Contact_Association__r[0].IT_Association_Progressive__c)){
                        maxDetailSoc = Integer.valueOf(singleFc.Contact_Association__r[0].IT_Association_Progressive__c) + 1;
                        contactDetailUpdateMapSoc.put(singleFc.IT_Financial_Center__c, maxDetailSoc);
                    }else{
                        contactDetailUpdateMapSoc.put(singleFc.IT_Financial_Center__c, 1);
                    }
                }        
            }      
            for(IT_Contact_Association__c sinAss : trigger.new){
                System.debug('controlSocRef.get(sinAss.IT_Client_Code__c):: '+controlSocRef.get(sinAss.IT_Client_Code__c)); 
                System.debug('contactDetailUpdateMapRef:: '+contactDetailUpdateMapRef);
                System.debug('contactDetailUpdateMapSoc:: '+contactDetailUpdateMapSoc);
                if(controlSocRef != null && controlSocRef.size() > 0 && controlSocRef.get(sinAss.IT_Contact_Detail__c) == 'Soc' && contactDetailUpdateMapSoc != null && contactDetailUpdateMapSoc.size() > 0 && contactDetailUpdateMapSoc.keyset().contains(sinAss.IT_Client_Code__c)){
                    if(controlDetail.keyset().contains(sinAss.IT_Contact_Detail__c)){
                        sinAss.IT_Association_Progressive__c = controlDetail.get(sinAss.IT_Contact_Detail__c);
                    }else{    
                        sinAss.IT_Association_Progressive__c = String.valueOf(contactDetailUpdateMapSoc.get(sinAss.IT_Client_Code__c));
                    }    
                }else if(controlSocRef != null && controlSocRef.size() > 0 && controlSocRef.get(sinAss.IT_Contact_Detail__c) == 'Ref' && contactDetailUpdateMapRef != null && contactDetailUpdateMapRef.size() > 0 && contactDetailUpdateMapRef.keyset().contains(sinAss.IT_Contact_Detail__c)){    
                    sinAss.IT_Association_Progressive__c = String.valueOf(contactDetailUpdateMapRef.get(sinAss.IT_Contact_Detail__c));
                }   
            } 
        }    
    }
}