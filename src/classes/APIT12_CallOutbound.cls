global without sharing class APIT12_CallOutbound {

    public static boolean firstTrigger = true;
    

    
    public static String createRequestAccount(List<Account> accTriggernew, String AccountGroup){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(accTriggernew, AccountGroup, userAC);
        System.debug('wrapperPivotal::: '+wrapperPivotal);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, accTriggernew, 'Account');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        System.debug('jsonRequest::: '+jsonRequest);
        if(AccountGroup != 'Account')
            APIT11_Utilities.updateAllAccountForVatGroup(accTriggernew);
        return 'OK';          
    }

    public static String createRequestFinancialCenter(Map<String, List<ER_Financial_Center__c>> fCTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        List<String> callJson = new List<String>();
        for(String typeList : fCTriggernew.Keyset()){
            String jsonRequest = '';
            RequestForUpdate wrapperPivotal = new RequestForUpdate(fCTriggernew.get(typeList), typeList, userAC);
            jsonStructure structureTot = new jsonStructure(wrapperPivotal);
            jsonRequest = JSON.serializePretty(structureTot, true);
            System.debug('jsonRequest::: '+jsonRequest);
            callJson.add(jsonRequest);
            
        }    
        for(String singleJSON : callJson){
            APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(singleJSON, null, 'FC');
            ID jobID = System.enqueueJob(calloutJob);
            System.debug('jobID::: '+jobID);
        }
        return 'OK';          
    }

    public static String createRequestFinancialCenterActivation(List<ER_Financial_Center__c> fCActiveTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        List<String> callJson = new List<String>();
        for(ER_Financial_Center__c item : fCActiveTriggernew){
            String jsonRequest = '';
            RequestForUpdate wrapperPivotal = new RequestForUpdate(item, userAC);
            jsonStructure structureTot = new jsonStructure(wrapperPivotal);
            jsonRequest = JSON.serializePretty(structureTot, true);
            System.debug('jsonRequest::: '+jsonRequest);
            callJson.add(jsonRequest);
            
        }    
        for(String singleJSON : callJson){
            APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(singleJSON, null, 'FC');
            ID jobID = System.enqueueJob(calloutJob);
            System.debug('jobID::: '+jobID);
        }
        return 'OK';          
    }

    public static String createRequestDeliverySite(List<ER_Delivery_Site__c> dsTriggernew, Map<Id, ER_Delivery_Site__c> mapOldValue){
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false; 
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(dsTriggernew, userAC, mapOldValue);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, dsTriggernew, 'ER_Delivery_Site__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }
    
    public static String createRequestDistributionPoint(List<ER_Distribution_Point__c> dpTriggernew, List<ER_Delivery_Site__c> dsTriggernew, String typeFlow, String dmlType, Map<Id, ER_Distribution_Point__c> mapOldValue){
        System.debug('typeFlow:: '+typeFlow);
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser); 
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = null;
        if(!String.isBlank(typeFlow)) 
            wrapperPivotal = new RequestForUpdate(dpTriggernew, dsTriggernew, dmlType, userAC, mapOldValue, typeFlow);
        else
            wrapperPivotal = new RequestForUpdate(dpTriggernew, dsTriggernew, dmlType, userAC, mapOldValue);     
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, dpTriggernew, 'ER_Distribution_Point__c');  
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    public static String createRequestBankAccount(List<ER_Bank_Account__c> baTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser); 
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(baTriggernew, userAC);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, baTriggernew, 'ER_Bank_Account__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    public static String createRequestContract(List<Contract> contractTriggernew, String contractEC){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(contractTriggernew, contractEC, userAC);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, contractTriggernew, 'Contract');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    public static String createRequestIntentDeclaration(List<IT_Intent_Declaration__c> intentDeclarationTriggernew){
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(intentDeclarationTriggernew, userAC);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, intentDeclarationTriggernew, 'IT_Intent_Declaration__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    public static String createRequestContractLineItem(List<ER_ContractLineItem__c> cliTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(cliTriggernew, userAC);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, cliTriggernew, 'ER_ContractLineItem__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    public static String createRequestAddress(List<SObject> addressTriggernew, String nameSObject){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(addressTriggernew, nameSObject, userAC);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, addressTriggernew, nameSObject);
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    public static String createRequestContactAss(List<IT_Contact_Association__c> contactAssTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(contactAssTriggernew, userAC);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, contactAssTriggernew, 'IT_Contact_Association__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    public static String createRequestGroupCode(List<IT_Group_Code__c> groupCodeTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(groupCodeTriggernew, userAC);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, groupCodeTriggernew, 'IT_Group_Code__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    public static String createRequestGroup(List<IT_Group__c> groupTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(groupTriggernew, userAC);
        System.debug('jsonRequest::: '+jsonRequest);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, groupTriggernew, 'IT_Group__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    public static String createRequestCustom(List<Contract> requestContract, List<IT_Request__c> requestTriggernew, ER_Financial_Center__c requestFC){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(requestContract, requestTriggernew, requestFC, userAC);
        System.debug('wrapperPivotal::: '+wrapperPivotal);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, requestTriggernew, 'IT_Request__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        System.debug('jsonRequest::: '+jsonRequest);
        return 'OK';          
    }

    public static String createRequestCustomFlow(List<IT_Request__c> requestTriggernew, Contract addField, ER_Financial_Center__c fcRecord){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(requestTriggernew, addField, fcRecord, userAC);
        System.debug('wrapperPivotal::: '+wrapperPivotal);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, requestTriggernew, 'IT_Request__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        System.debug('jsonRequest::: '+jsonRequest);
        return 'OK';          
    }

    public static String updateRequest(IT_Request__c requestTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(requestTriggernew, userAC);
        System.debug('wrapperPivotal::: '+wrapperPivotal);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        List<IT_Request__c> listForQueueable = new List<IT_Request__c>();
        listForQueueable.add(requestTriggernew);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, listForQueueable, 'IT_Request__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        System.debug('jsonRequest::: '+jsonRequest);
        return 'OK';          
    }

    public static String createContactOnlyCustom(List<Contact> contactOnlyTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(contactOnlyTriggernew, userAC);
        System.debug('wrapperPivotal::: '+wrapperPivotal);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, contactOnlyTriggernew, 'Contact');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        System.debug('jsonRequest::: '+jsonRequest);
        return 'OK';          
    }

    public static String createRequestAdditionalExpenses(List<IT_Additional_Expenses__c> addExpTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser);
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(addExpTriggernew, userAC);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, addExpTriggernew, 'IT_Additional_Expenses__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    public static String createRequestNotes(List<IT_Note__c> noteTriggernew){ 
        String idConnectUser = userinfo.getuserid();
        String userAC = getUserAC(idConnectUser); 
        firstTrigger = false;
        String jsonRequest = '';
        RequestForUpdate wrapperPivotal = new RequestForUpdate(noteTriggernew, userAC);
        jsonStructure structureTot = new jsonStructure(wrapperPivotal);
        jsonRequest = JSON.serializePretty(structureTot, true);
        System.debug('jsonRequest::: '+jsonRequest);
        APIT17_QueueableCallGenericService calloutJob = new APIT17_QueueableCallGenericService(jsonRequest, noteTriggernew, 'IT_Note__c');
        ID jobID = System.enqueueJob(calloutJob);
        System.debug('jobID::: '+jobID);
        return 'OK';          
    }

    private static String getUserAC(String userId){
        String acUser = '';
        List<User> listUserSF = new List<User>();
        if(!String.isBlank(userId)){
           listUserSF = [Select Id, IT_AC_User_Code__c From User Where Id =: userId Limit 1];
           if(listUserSF != null && listUserSF.size() > 0)
            acUser = listUserSF[0].IT_AC_User_Code__c;
        }
        return acUser;
    }

    public class RequestForUpdate{
        public List<accounts> accounts {get;set;}
        public List<contacts_association> contacts_association {get;set;}
        public List<intents_declaration> intents_declaration {get;set;}
        public List<economics_condition> economics_condition {get;set;}
        public List<activities> activities {get;set;}
        public List<deliveries_site> deliveries_site {get;set;}
        public List<contracts> contracts {get;set;}
        public List<administratives_data> administratives_data {get;set;}
        public List<products_data> products_data {get;set;}
        public List<groups> groups {get;set;}
        public List<clients_group> clients_group {get;set;}
        public List<documents> documents {get;set;}
        public List<vats_group> vats_group {get;set;}
        public List<addresses> addresses {get;set;}
        public List<conditions_change> conditions_change {get;set;}
        public List<contacts> contacts {get;set;}
        public List<additional_expenses> additional_expenses {get;set;}
        public List<notes> notes {get;set;}
        public RequestForUpdate(List<Account> sinAccQuery, String accGroup, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            vats_group = new List<vats_group>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            System.debug('accGroup:: '+accGroup);
            if(accGroup == 'Account'){
                vats_group = new List<vats_group>();
                for(Account singleAccount : sinAccQuery){
                    accounts reqAccSingle = new accounts(singleAccount, ac_User);
                    accounts.add(reqAccSingle);    
                }
            }else if(accGroup == 'VatGroupAccount'){ 
                accounts = new List<accounts>();
                for(Account singleAccount : sinAccQuery){
                    vats_group newVatGroup = new vats_group(singleAccount, ac_User);
                    vats_group.add(newVatGroup);
                    accounts reqAccSingle = new accounts(singleAccount, ac_User);
                    accounts.add(reqAccSingle);
                }    
            }else{
                accounts = new List<accounts>();
                for(Account singleAccount : sinAccQuery){
                    vats_group newVatGroup = new vats_group(singleAccount, ac_User);
                    vats_group.add(newVatGroup);
                }        
            }           
        }  
        public RequestForUpdate(List<ER_Delivery_Site__c> sinDelSiteQuery, String ac_User, Map<Id, ER_Delivery_Site__c> mapValueOld){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(ER_Delivery_Site__c singleDeliverySite : sinDelSiteQuery){
                deliveries_site reqDelSiteSingle = new deliveries_site(singleDeliverySite, ac_User, null, mapValueOld);
                deliveries_site.add(reqDelSiteSingle);
            }        
        } 
        public RequestForUpdate(List<ER_Distribution_Point__c> sinDistPointQuery, List<ER_Delivery_Site__c> sinDSQuery, String typeDml, String ac_User, Map<Id, ER_Distribution_Point__c> maDPOld){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            System.debug('typeDml::: '+typeDml);
            for(ER_Distribution_Point__c singleDistributionPoint : sinDistPointQuery){
                activities reqDistPointSingle = new activities(singleDistributionPoint, ac_User, maDPOld);
                activities.add(reqDistPointSingle);
                if(typeDml == 'Insert' || singleDistributionPoint.ER_Delivery_Site__c != maDPOld.get(singleDistributionPoint.Id).ER_Delivery_Site__c){
                    addresses reqAddressDP = new addresses(singleDistributionPoint, 'ER_Distribution_Point__c', ac_User);
                    addresses.add(reqAddressDP);
                    for(ER_Delivery_Site__c singleDeliverySite : sinDSQuery){
                        deliveries_site reqDSSingle = new deliveries_site(singleDeliverySite, ac_User, singleDistributionPoint, null);
                        deliveries_site.add(reqDSSingle);
                        addresses reqAddressDS = new addresses(singleDeliverySite, 'ER_Delivery_Site__c', ac_User);
                        addresses.add(reqAddressDS); 
                    }    
                }
            }       
        }
        public RequestForUpdate(List<ER_Distribution_Point__c> sinDistPointQuery, List<ER_Delivery_Site__c> sinDSQuery, String typeDml, String ac_User, Map<Id, ER_Distribution_Point__c> maDPOld, String controlUpdateDelivery){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            System.debug('typeDml::: '+typeDml);
            System.debug('controlUpdateDelivery::: '+controlUpdateDelivery);
            for(ER_Distribution_Point__c singleDistributionPoint : sinDistPointQuery){
				if(controlUpdateDelivery == '1' || controlUpdateDelivery == '2'){
					activities reqDistPointSingle = new activities(singleDistributionPoint, ac_User, maDPOld);
					activities.add(reqDistPointSingle);
					addresses reqAddressDP = new addresses(singleDistributionPoint, 'ER_Distribution_Point__c', ac_User);
					addresses.add(reqAddressDP);
				}		
				for(ER_Delivery_Site__c singleDeliverySite : sinDSQuery){
					deliveries_site reqDSSingle = new deliveries_site(singleDeliverySite, ac_User, singleDistributionPoint, null);
					deliveries_site.add(reqDSSingle);
					if(controlUpdateDelivery == '1' || controlUpdateDelivery == '3'){
						addresses reqAddressDS = new addresses(singleDeliverySite, 'ER_Delivery_Site__c', ac_User);
						addresses.add(reqAddressDS);
					}	   
                }
            }             
        }   
        public RequestForUpdate(List<Contract> sinContrQuery, String contractEC, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            if(contractEC == 'EconomicConditions'){
                for(Contract singleContract : sinContrQuery){
                    SObject contractSObj = (SObject) singleContract;
                    economics_condition reqECSingle = new economics_condition(contractSObj, 'Contract', null, null, ac_User);
                    economics_condition.add(reqECSingle);     
                }
            }else if(contractEC == 'Document'){
                for(Contract singleContract : sinContrQuery){
                    documents newDocument = new documents(singleContract, ac_User);
                    documents.add(newDocument);
                }    
            }else{
                for(Contract singleContract : sinContrQuery){
                    contracts reqContrSingle = new contracts(singleContract, ac_User); 
                    contracts.add(reqContrSingle); 
                }
            }            
        }
        public RequestForUpdate(List<ER_ContractLineItem__c> productQuery, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(ER_ContractLineItem__c singleProduct : productQuery){
                products_data reqProductSingle = new products_data(singleProduct, ac_User);
                products_data.add(reqProductSingle);

            }
        } 
        public RequestForUpdate(List<SObject> addressQuery, String sObjectName, String ac_User){ 
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(SObject singleSObject : addressQuery){
                addresses reqAddressSingle = new addresses(singleSObject, sObjectName, ac_User);
                addresses.add(reqAddressSingle);
            }        
        }
        public RequestForUpdate(List<ER_Bank_Account__c> backAccountQuery, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(ER_Bank_Account__c singleBA : backAccountQuery){
                SObject bASObject = (SObject) singleBA;
                economics_condition reqBASingle = new economics_condition(bASObject, 'ER_Bank_Account__c', null, null, ac_User);
                economics_condition.add(reqBASingle);
            }        
        }
        public RequestForUpdate(List<ER_Financial_Center__c> listFinCen, String typeList, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            if(typeList == 'ER_Financial_Center__c'){
                for(ER_Financial_Center__c singleFiCen : listFinCen){
                    administratives_data reqFCSingle = new administratives_data(singleFiCen, ac_User);
                    administratives_data.add(reqFCSingle);
                }
            }else if(typeList == 'EconomicCondition'){
                for(ER_Financial_Center__c singleFiCen : listFinCen){
                    SObject econominContSObj = (SObject) singleFiCen;
                    economics_condition reqECSingle = new economics_condition(econominContSObj, 'ER_Financial_Center__c', null, null, ac_User);
                    economics_condition.add(reqECSingle);
                }
            }else{
                for(ER_Financial_Center__c singleFiCen : listFinCen){
                    administratives_data reqFCSingle = new administratives_data(singleFiCen, ac_User);
                    administratives_data.add(reqFCSingle);
                    SObject econominContSObj = (SObject) singleFiCen;
                    economics_condition reqECSingle = new economics_condition(econominContSObj, typeList, null, null, ac_User);
                    economics_condition.add(reqECSingle);
                }
            }
                  
        }
        public RequestForUpdate(ER_Financial_Center__c singleFinCen, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            if(singleFinCen != null){
                administratives_data reqFCSingle = new administratives_data(singleFinCen, ac_User);
                administratives_data.add(reqFCSingle);
                SObject econominContSObj = (SObject) singleFinCen;
                economics_condition reqECSingle = new economics_condition(econominContSObj, 'ER_Financial_Center__c', null, null, ac_User);
                economics_condition.add(reqECSingle);
                contracts reqContrSingle = new contracts(singleFinCen, ac_User);
                contracts.add(reqContrSingle);     
            }

        }    
        public RequestForUpdate(List<IT_Contact_Association__c> contactAssQuery, String ac_User){ 
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            Set<String> controlContact = new Set<String>();
            for(IT_Contact_Association__c singleConASS : contactAssQuery){
                contacts_association reqConAssSingle = new contacts_association(singleConASS, ac_User);
                contacts_association.add(reqConAssSingle);
                if(!controlContact.contains(singleConASS.IT_Contact_Detail__r.IT_Contact__c)){
                    contacts reqConSingle = new contacts(singleConASS, ac_User);
                    contacts.add(reqConSingle);
                    controlContact.add(singleConASS.IT_Contact_Detail__r.IT_Contact__c);
                }    
            }        
        }
        public RequestForUpdate(List<IT_Group_Code__c> groupCodeQuery, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(IT_Group_Code__c singleGroupCode: groupCodeQuery){
                clients_group reqGCSingle = new clients_group(singleGroupCode, ac_User);
                clients_group.add(reqGCSingle);
            }        
        }
        public RequestForUpdate(List<IT_Group__c> groupQuery, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(IT_Group__c singleGroup: groupQuery){
                groups reqGSingle = new groups(singleGroup, ac_User);
                groups.add(reqGSingle);
            }        
        }
        public RequestForUpdate(List<IT_Intent_Declaration__c> intentDeclarationQuery, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(IT_Intent_Declaration__c singleIntentDeclaration: intentDeclarationQuery){
                intents_declaration reqIntentDecingle = new intents_declaration(singleIntentDeclaration, ac_User);
                intents_declaration.add(reqIntentDecingle);
            }        
        }
        public RequestForUpdate(List<Contract> reqContract, List<IT_Request__c> listRequest, ER_Financial_Center__c reqFC, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(IT_Request__c singleRequest : listRequest){
                conditions_change reqRequestSingle = new conditions_change(singleRequest, ac_User);
                conditions_change.add(reqRequestSingle);
            }
            for(Contract singleContr : reqContract){
                if(singleContr.Enddate == null || (singleContr.Enddate != null && listRequest[0].IT_Editing_Reason__c == '03' && reqFC.IT_Client_Status__c != '03')){     
                    contracts reqRequestSingle = new contracts(singleContr, ac_User);
                    contracts.add(reqRequestSingle);
                }    
            }
            if(listRequest[0].IT_Editing_Reason__c == '03'){
                SObject econominContSObj = (SObject) reqFC;
                economics_condition reqECSingle = new economics_condition(econominContSObj, 'ER_Financial_Center__c', null, null, ac_User);
                economics_condition.add(reqECSingle);  
            }           
        }
        public RequestForUpdate(List<IT_Request__c> listRequest, Contract fieldForAdd, ER_Financial_Center__c fieldsForEC, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(IT_Request__c singleRequest : listRequest){
                conditions_change reqRequestSingle = new conditions_change(singleRequest, ac_User);
                conditions_change.add(reqRequestSingle);
            }    
            if(listRequest[0].IT_Editing_Reason__c == '03'){
                SObject econominContSObj = (SObject) listRequest[0];
                economics_condition reqECSingle = new economics_condition(econominContSObj, 'IT_Request__c', fieldForAdd, fieldsForEC, ac_User);
                economics_condition.add(reqECSingle);
            }    

            if(listRequest[0].IT_Editing_Reason__c == '03' && fieldsForEC.IT_Client_Status__c != '03'){            
                contracts reqRequestSingle = new contracts(fieldForAdd, ac_User);
                contracts.add(reqRequestSingle);
            }
            contracts reqContrSingle = new contracts(listRequest[0], fieldForAdd, ac_User);
            contracts.add(reqContrSingle); 
       
        }
        public RequestForUpdate(IT_Request__c reqQuery, String ac_User){ 
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            
            conditions_change reqRequestSingle = new conditions_change(reqQuery, ac_User);
            conditions_change.add(reqRequestSingle);       
        }
        public RequestForUpdate(List<Contact> contactQuery, String ac_User){ 
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(Contact singleCon : contactQuery){
                contacts reqConSingle = new contacts(singleCon, ac_User);
                contacts.add(reqConSingle);
                if(singleCon.IT_Contact_Association__r != null && singleCon.IT_Contact_Association__r.size() > 0){
                    for(IT_Contact_Association__c singleASS: singleCon.IT_Contact_Association__r){ 
                        contacts_association reqConAssSingle = new contacts_association(singleASS, ac_User);
                        contacts_association.add(reqConAssSingle);
                    }
                }    
            }        
        }
        public RequestForUpdate(List<IT_Additional_Expenses__c> addExpQuery, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(IT_Additional_Expenses__c singleAddexp: addExpQuery){
                additional_expenses reqAESingle = new additional_expenses(singleAddexp, ac_User);
                additional_expenses.add(reqAESingle);
            }        
        }
        public RequestForUpdate(List<IT_Note__c> noteQuery, String ac_User){
            accounts = new List<accounts>();
            intents_declaration = new List<intents_declaration>();
            contacts_association = new List<contacts_association>();
            economics_condition = new List<economics_condition>();
            activities = new List<activities>();
            deliveries_site = new List<deliveries_site>();
            contracts = new List<contracts>();
            administratives_data = new List<administratives_data>();
            products_data = new List<products_data>();
            groups = new List<groups>();
            clients_group = new List<clients_group>();
            documents = new List<documents>();
            vats_group = new List<vats_group>();
            addresses = new List<addresses>();
            conditions_change = new List<conditions_change>();
            contacts = new List<contacts>();
            additional_expenses = new List<additional_expenses>();
            notes = new List<notes>();
            for(IT_Note__c singleAnote: noteQuery){
                notes reqNoteSingle = new notes(singleAnote, ac_User);
                notes.add(reqNoteSingle); 
            }        
        } 
    }

    public class jsonStructure{
        section_1 section_1 {get;set;}
        section_2 section_2 {get;set;}
        section_3 section_3 {get;set;}
        section_4 section_4 {get;set;}
        public jsonStructure(RequestForUpdate wrapperTotal){
            section_1 = new section_1(wrapperTotal);
            section_2 = new section_2(wrapperTotal);
            section_3 = new section_3(wrapperTotal);
            section_4 = new section_4(wrapperTotal);
        }
    }

    public class section_1{
        List<accounts> accounts {get;set;}
        List<intents_declaration> intents_declaration {get;set;}
        List<vats_group> vats_group {get;set;}
        public section_1(RequestForUpdate wrapperTotal){
            accounts = wrapperTotal.accounts;
            vats_group = wrapperTotal.vats_group;
            intents_declaration = wrapperTotal.intents_declaration;   
        }    
    }
    public class section_2{
        List<activities> activities {get;set;}
        List<economics_condition> economics_condition {get;set;}
        List<deliveries_site> deliveries_site {get;set;}
        List<contracts> contracts {get;set;}
        List<administratives_data> administratives_data {get;set;}
        List<products_data> products_data {get;set;}
        List<documents> documents {get;set;}
        List<groups> groups {get;set;}
        List<clients_group> clients_group {get;set;}
        List<addresses> addresses {get;set;}
        List<additional_expenses> additional_expenses {get;set;}
        List<notes> notes {get;set;}
        public section_2(RequestForUpdate wrapperTotal){
            activities = wrapperTotal.activities;
            economics_condition = wrapperTotal.economics_condition;
            deliveries_site = wrapperTotal.deliveries_site;
            contracts = wrapperTotal.contracts;
            administratives_data = wrapperTotal.administratives_data;
            products_data = wrapperTotal.products_data;
            documents = wrapperTotal.documents;
            groups = wrapperTotal.groups;
            clients_group = wrapperTotal.clients_group;
            addresses = wrapperTotal.addresses; 
            additional_expenses = wrapperTotal.additional_expenses;
            notes = wrapperTotal.notes; 
              
        }    
    }
    public class section_3{
        List<contacts> contacts {get;set;}
        List<contacts_association> contacts_association {get;set;}
        public section_3(RequestForUpdate wrapperTotal){
            contacts = wrapperTotal.contacts;
            contacts_association = wrapperTotal.contacts_association;          
        }    
    }
    public class section_4{
        List<conditions_change> conditions_change {get;set;}
        public section_4(RequestForUpdate wrapperTotal){
            conditions_change = wrapperTotal.conditions_change;    
        }    
    }

    public class accounts{
        public String vat_number {get;set;}
        public String foreign_vat_number {get;set;}
        public String fiscal_code {get;set;}
        public String legal_name {get;set;}
        public String legal_form {get;set;}
        public String segment {get;set;}
        public String industry {get;set;}
        public Integer number_of_employees {get;set;}
        public String web_site {get;set;}
        public Boolean flg_institution {get;set;}
        public Boolean flg_private_work_institution {get;set;}
        public Boolean flg_nso {get;set;}
        public Boolean flg_split_payment {get;set;}
        public String vat_group {get;set;}
        public Boolean flg_show_vat_group {get;set;}   
        public Boolean flg_send_sdi {get;set;}           
        public String invoice_naming {get;set;}
        public String province {get;set;}
        public String toponym {get;set;}
        public String address {get;set;}
        public String short_address {get;set;}
        public String street_number {get;set;}
        public String postal_code {get;set;}
        public String city {get;set;}
        public String hamlet {get;set;}
        public String addictional_locality {get;set;}
        public String province_ref {get;set;}   //long
        public String city_ref {get;set;}       //long
        public String hamlet_ref {get;set;} //integer
        public String district_ref {get;set;}   //integer
        public String street_ref {get;set;} //long
        public String road_arch_ref {get;set;}  //integer
        public Decimal metref_loc_x {get;set;}  //double
        public Decimal metref_loc_y {get;set;}  //double
        public Decimal georef_loc_x {get;set;}  //double
        public Decimal georef_loc_y {get;set;}  //double
        public String extra_urban_specifications {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        
        public accounts(Account sinAcc, String user_AC){
            if(!sinAcc.IT_Foreign_VAT_Number__c){
                vat_number = sinAcc.ER_VAT_Number__c;
            }else{
                vat_number = '99999999990';    
                foreign_vat_number = sinAcc.ER_VAT_Number__c;
            }    
            fiscal_code = sinAcc.IT_Fiscal_Code__c;
            legal_name = sinAcc.Name;
            legal_form = sinAcc.IT_Legal_Form__c;
            segment = sinAcc.ER_Segment__c;
            industry = sinAcc.IT_Industry__c;
            number_of_employees = sinAcc.NumberOfEmployees;
            web_site = sinAcc.Website;
            if(sinAcc.IT_Company_Type__c == 'Private'){
                flg_institution = false;
                flg_private_work_institution = false;
            }else if(sinAcc.IT_Company_Type__c == 'Institution'){
                flg_institution = true;
                flg_private_work_institution = false;    
            }else if(sinAcc.IT_Company_Type__c == 'Private (work for Institution)'){
                flg_institution = false;
                flg_private_work_institution = true;    
            }       
            flg_nso = sinAcc.IT_NSO__c;
            flg_split_payment = sinAcc.IT_Split_Payment__c;
            vat_group = sinAcc.IT_Group_VAT_Number__c;
            flg_show_vat_group = sinAcc.IT_Display_VAT_Group__c;
            flg_send_sdi = sinAcc.IT_Send_Client_Billing_SDI__c;
            invoice_naming = sinAcc.IT_Invoice_Naming__c;
            province = sinAcc.BillingState;
            if(!String.isBlank(sinAcc.BillingStreet) && sinAcc.BillingStreet.contains(', '))
                address = sinAcc.BillingStreet.split(', ')[0];
            if(!String.isBlank(sinAcc.BillingStreet) && sinAcc.BillingStreet.contains(', '))
                street_number = sinAcc.BillingStreet.split(', ')[1];
            postal_code = sinAcc.BillingPostalCode;
            city = sinAcc.BillingCity;
            if(sinAcc.BillingLongitude != null){
                String geoTempX = String.valueOf(sinAcc.BillingLongitude);
                if(geoTempX.length() > 3){
                    geoTempX = geoTempX.left(geoTempX.length()-3);
                    georef_loc_x = Decimal.valueOf(geoTempX);
                }    
            }
            if(sinAcc.BillingLatitude != null){
                String geoTempY = String.valueOf(sinAcc.BillingLatitude);
                if(geoTempY.length() > 3){    
                    geoTempY = geoTempY.left(geoTempY.length()-3);
                    georef_loc_Y = Decimal.valueOf(geoTempY);
                }    
            }    
            toponym = sinAcc.IT_Toponym__c;
            short_address = sinAcc.IT_Short_Address__c;
            hamlet = sinAcc.IT_Hamlet__c;
            addictional_locality = sinAcc.IT_Additional_Locality__c;
            province_ref = sinAcc.IT_State_Code__c;
            city_ref = sinAcc.IT_City_Code__c;
            hamlet_ref = sinAcc.IT_Hamlet_Code__c;
            district_ref = sinAcc.IT_Sestiere_Code__c;
            street_ref = sinAcc.IT_Street_Code__c;
            road_arch_ref = sinAcc.IT_Road_Arch_Code__c;
            if(!String.isBlank(sinAcc.IT_MetRef_Loc_X__c))
                metref_loc_x = Decimal.valueOf(sinAcc.IT_MetRef_Loc_X__c);
            if(!String.isBlank(sinAcc.IT_MetRef_Loc_Y__c))    
                metref_loc_y = Decimal.valueOf(sinAcc.IT_MetRef_Loc_Y__c);  
            extra_urban_specifications = sinAcc.IT_Extra_Urban_Specifications__c;
            user = user_AC;
            //start_date = sinAcc.IT_Validity_Start_Date__c;
            start_date = System.today();
            end_date = sinAcc.IT_Validity_End_Date__c;   
        }
    }

    public class intents_declaration{
        public String fiscal_code {get;set;}
        public String validity_year {get;set;}
        public Integer progressive {get;set;}
        public String declaration_number {get;set;}
        public String type {get;set;}
        public Date presentation_date {get;set;}
        public String exporter_type {get;set;}
        public String operation_type {get;set;}
        public Decimal declared_amount {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public intents_declaration(){}
        public intents_declaration(IT_Intent_Declaration__c singleIntentDeclaration, String user_AC){
            fiscal_code = singleIntentDeclaration.IT_Fiscal_Code__c;
            validity_year = singleIntentDeclaration.IT_Validity_Year__c;
            if(singleIntentDeclaration.IT_Progressive__c != null)
                progressive = Integer.valueOf(singleIntentDeclaration.IT_Progressive__c);
            declaration_number = singleIntentDeclaration.IT_Declaration_Number__c;
            type = singleIntentDeclaration.IT_Type__c;
            presentation_date = singleIntentDeclaration.IT_Presentation_Date__c;
            exporter_type = singleIntentDeclaration.IT_Exporter_Type__c;
            operation_type = singleIntentDeclaration.IT_Operation_Type__c;
            declared_amount = singleIntentDeclaration.IT_Declared_Amount__c;
            user = user_AC;
            //start_date = singleIntentDeclaration.IT_Validity_Start_Date__c;
            start_date = System.today();
            end_date = singleIntentDeclaration.IT_Validity_End_Date__c; 

        }
    }

    public class contacts_association{
        public String code {get;set;}
        public String type {get;set;}
        public String client_ref {get;set;}
        public String AC_activity {get;set;}
        public String SF_activity {get;set;}
        public Integer AC_delivery {get;set;}
        public Integer SF_delivery {get;set;}
        public String contact_progressive {get;set;}
        public String contact_type {get;set;}
        public String contact {get;set;}
        public Boolean flg_order_confirmation {get;set;}
        public Boolean flg_invoice_confirmation {get;set;}
        public Boolean flg_sut {get;set;}
        public Boolean flg_notifications {get;set;}
        public String user {get;set;}
        public Boolean flg_main_contact {get;set;}
        public contacts_association(){
        }
        public contacts_association(IT_Contact_Association__c sinContactAss, String user_AC){
            code = sinContactAss.IT_Code__c;
            type = sinContactAss.IT_Type__c;
            client_ref = sinContactAss.IT_Client_Code__c;
            AC_activity = sinContactAss.IT_Activity_AC__c;
            SF_activity = sinContactAss.IT_Activity_SF__c;
            if(sinContactAss.IT_Delivery_AC__c != null)
                AC_delivery = Integer.valueof(sinContactAss.IT_Delivery_AC__c);
            if(sinContactAss.IT_Delivery_SF__c != null)
                SF_delivery = Integer.valueof(sinContactAss.IT_Delivery_SF__c);    
            contact_progressive = sinContactAss.IT_Association_Progressive__c;
            contact = sinContactAss.IT_Contact_Info__c;
            contact_type = sinContactAss.IT_Apparatus_Type__c;
            flg_order_confirmation = sinContactAss.IT_Order_Confirm_Address__c;
            flg_invoice_confirmation = sinContactAss.IT_Billing_Confirm_Address__c;
            flg_sut = sinContactAss.IT_Send_Sut__c;
            flg_notifications = sinContactAss.IT_Notifications__c;
            user = user_AC;
            flg_main_contact = sinContactAss.IT_Main_Contact__c;
        }
    }

    public class activities{
        public String client_ref {get;set;}
        public String ac_activity {get;set;}
        public String sf_activity {get;set;}
        public Boolean flg_suspension {get;set;}
        public Boolean flg_cancellation {get;set;}
        public String cancellation_type {get;set;}
        public Integer employees_number {get;set;}
        public Integer technical_data_progressive {get;set;}
        public String contact_code {get;set;}
        public String cost_center {get;set;}
        public Boolean flg_free_description_to_display {get;set;}
        public Boolean flg_address_to_display {get;set;}
        public Boolean flg_locality_to_display {get;set;}
        public Boolean flg_naming_to_display {get;set;}
        public Integer raw_number_for_display {get;set;}
        public String data_to_display {get;set;}
        public String data_type_to_display {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public String authorization_suspension_user {get;set;}
        public Date cost_center_end_date {get;set;} 
        public Date suspension_start_date {get;set;} 
        public Date suspension_end_date {get;set;}
        public String suspension_reason {get;set;}
        public String authorization_reactivation_user {get;set;}
        public String notes {get;set;}
        public Date note_validity_start_date {get;set;} 
        public Date note_validity_end_date {get;set;} 
        public activities(){
        }
        public activities(ER_Distribution_Point__c singleActivity, String user_AC, Map<Id, ER_Distribution_Point__c> oldMapDp){
            client_ref = singleActivity.IT_Client_Code__c ;
            user = user_AC;
            if(oldMapDp != null && oldMapDp.size() > 0 && oldMapDp.get(singleActivity.Id).IT_Cost_Center_End_Date__c != singleActivity.IT_Cost_Center_End_Date__c){
                cost_center_end_date = singleActivity.IT_Cost_Center_End_Date__c;
            }else{
                ac_activity = singleActivity.IT_AC_Activity__c ;
                sf_activity = singleActivity.IT_SF_Activity__c ;
                flg_cancellation = singleActivity.IT_Cancellation__c ;
                cancellation_type = singleActivity.IT_Cancellation_Type__c ;
                if(singleActivity.IT_Employees_Number__c != null)
                    employees_number = Integer.valueof(singleActivity.IT_Employees_Number__c);
                if(singleActivity.IT_Technical_Data_Progressive__c != null)
                    technical_data_progressive = Integer.valueof(singleActivity.IT_Technical_Data_Progressive__c);
                contact_code = singleActivity.IT_Contact_Code__c ;
                cost_center = singleActivity.IT_Cost_Center__c ;
                flg_free_description_to_display = singleActivity.IT_Free_Description_to_Display__c ;
                flg_address_to_display = singleActivity.IT_Address_to_Display__c ;
                flg_locality_to_display = singleActivity.IT_Locality_to_Display__c ;
                flg_naming_to_display = singleActivity.IT_Naming_to_Display__c ;
                if(singleActivity.IT_Raw_Number_for_Display__c != null)
                    raw_number_for_display = Integer.valueof(singleActivity.IT_Raw_Number_for_Display__c); 
                data_to_display = singleActivity.IT_Data_to_Display__c ;
                data_type_to_display = singleActivity.IT_Data_Type_to_Display__c ;
                //start_date = singleActivity.IT_Validity_Start_Date__c ;
                start_date = System.today();
                end_date = singleActivity.IT_Validity_End_Date__c ;
                suspension_start_date = singleActivity.IT_Suspension_Start_Date__c;
                suspension_end_date = singleActivity.IT_Suspension_End_Date__c;
                if(oldMapDp != null && oldMapDp.size() > 0 && oldMapDp.get(singleActivity.Id).IT_Suspension_Start_Date__c != singleActivity.IT_Suspension_Start_Date__c && singleActivity.IT_Suspension_Start_Date__c <= System.today()){
                    flg_suspension = true;
                    suspension_reason = '002';
                    authorization_suspension_user = singleActivity.IT_Authorization_Suspension_User_Code__c;
                    APIT11_Utilities.updateDistributionSuspension(singleActivity.Id, '1');
                }else if(oldMapDp != null && oldMapDp.size() > 0 && oldMapDp.get(singleActivity.Id).IT_Suspension_End_Date__c != singleActivity.IT_Suspension_End_Date__c && singleActivity.IT_Suspension_End_Date__c <= System.today() && singleActivity.IT_Suspension_Start_Date__c != null){
                    flg_suspension = false;
                    authorization_reactivation_user = singleActivity.IT_Authorization_Reactivation_User_Code__c;
                    APIT11_Utilities.updateDistributionSuspension(singleActivity.Id, '2');
                }else if(oldMapDp != null && oldMapDp.size() > 0 && oldMapDp.get(singleActivity.Id).IT_Suspension_Start_Date__c != singleActivity.IT_Suspension_Start_Date__c && singleActivity.IT_Suspension_Start_Date__c > System.today()){
                    flg_suspension = singleActivity.IT_Suspension__c;
                    suspension_reason = '002';
                    authorization_suspension_user = singleActivity.IT_Authorization_Suspension_User_Code__c;
                    APIT11_Utilities.updateDistributionSuspension(singleActivity.Id, '3');
                }
                notes = singleActivity.IT_Notes__c;
                note_validity_start_date = singleActivity.IT_Note_Validity_Start_Date__c;
                note_validity_end_date = singleActivity.IT_Note_Validity_End_Date__c;
            }         
        }
    }

    public class economics_condition{
        public String cliente_ref {get;set;}
        public String payment_code {get;set;}
        public String sdd_payment_code {get;set;}
        public String bank_account_code {get;set;}
        public String abi {get;set;}
        public String cab {get;set;}
        public String cc {get;set;}
        public String cin {get;set;}
        public String country {get;set;}
        public String check_iban {get;set;}
        public String sdd_contract_code {get;set;}
        public Date sdd_subscription_date {get;set;}
        public String sdd_fiscal_code {get;set;}
        public String authorized {get;set;}
        public String special_billing_type {get;set;}
        public String commission_type {get;set;}
        public Decimal commission_percentage {get;set;}
        public String discount_type {get;set;}
        public Decimal discount_percentage {get;set;}
        public String fine_interest_type {get;set;}
        public String not_standard_vat {get;set;}
        public String transport_cost {get;set;}
        public String no_cost_reason {get;set;}
        public String promo_code {get;set;}
        public String invoice_detail {get;set;}
        public String invoice_detraction {get;set;}
        public Boolean flg_send_sut_printout {get;set;}
        public String debt_notes {get;set;}
        public Date debt_notes_effective_date {get;set;}
        public Decimal debt_notes_percentage {get;set;}
        public String debt_notes_locale_type {get;set;}
        public Decimal expendia_startup_cost {get;set;}
        public Integer number_of_expendia_cards {get;set;}
        public Decimal expendia_monthly_fee {get;set;}
        public Decimal card_amount {get;set;}
        public Decimal flexben_startup_cost {get;set;}
        public Date flexben_startup_date {get;set;}
        public Decimal flexben_fee_cost {get;set;}
        public Date flexben_fee_date {get;set;}
        public String flexben_fee_frequency {get;set;}
        public Boolean flg_accepts_new_billing_system_pa {get;set;}
        public String office_code {get;set;}
        public String cup_code {get;set;}
        public String order_code {get;set;}
        public String eori_code {get;set;}
        public Boolean flg_accepts_new_billing_system {get;set;}
        public String sdi {get;set;}
        public String pec_mail {get;set;}
        public Boolean flg_dont_send_debt_note {get;set;}
        public Integer particularities_progressive_number {get;set;}
        public String contractual_particularities {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public String billing_frequency {get;set;}
        public Decimal bond {get;set;}
        public String type_extradiscount {get;set;}
        public Decimal extradiscount_percentage {get;set;}
        public Date discount_validity_date_3 {get;set;}
        public Decimal discount_percentage_2 {get;set;}
        public Decimal discount_percentage_3 {get;set;}
        public Date discount_validity_date_2 {get;set;}
        public economics_condition(){
        }
        public economics_condition(Sobject singleEC, String objType, Contract contractAddFields, ER_Financial_Center__c addFieldEC, String user_AC){
            if(objType == 'Contract'){
                Contract contractForEC = (Contract) singleEC;
                commission_type = contractForEC.IT_Commission_Type__c;
                commission_percentage = contractForEC.IT_Commission_Percentage__c;
                discount_type = contractForEC.IT_Discount_Type__c;
                discount_percentage = contractForEC.IT_Discount_Percentage__c;
                fine_interest_type = contractForEC.IT_Fine_Interest_Type__c;
                not_standard_vat = contractForEC.IT_Not_Standard_VAT__c;
                transport_cost = contractForEC.IT_Transport_Cost__c;
                no_cost_reason = contractForEC.IT_No_Cost_Reason__c;
                promo_code = contractForEC.IT_Promo_Code__c;
                invoice_detail = contractForEC.IT_Invoice_Detail__c;
                debt_notes = contractForEC.IT_Debt_Notes__c;
                debt_notes_effective_date = contractForEC.IT_Debt_Notes_Effective_Date__c;
                debt_notes_percentage = contractForEC.IT_Debt_Notes_Percentage__c;
                debt_notes_locale_type = contractForEC.IT_Debt_Notes_Locale_Type__c;
                expendia_startup_cost = contractForEC.IT_Expendia_Startup_Cost__c;
                if(contractForEC.IT_Number_of_Expendia_cards__c != null)
                    number_of_expendia_cards = Integer.valueOf(contractForEC.IT_Number_of_Expendia_cards__c);
                expendia_monthly_fee = contractForEC.IT_Expendia_Monthly_Fee__c;
                card_amount = contractForEC.IT_Expendia_Card_Amount__c;
                flexben_startup_cost = contractForEC.IT_Flexben_Startup_Cost__c;
                flexben_startup_date = contractForEC.IT_Flexben_Startup_Date__c;
                flexben_fee_cost = contractForEC.IT_Flexben_Fee_Cost__c;
                flexben_fee_date = contractForEC.IT_Flexben_Start_Fee_Date__c;
                flexben_fee_frequency = contractForEC.IT_Flexben_Fee_Frequency__c;
                billing_frequency = contractForEC.IT_Billing_Frequency_UTA__c;
                bond = contractForEC.IT_Bond_UTA__c;
                type_extradiscount = contractForEC.IT_Type_Extradiscount__c;
                extradiscount_percentage = contractForEC.IT_Extradiscount_Percentage__c;
                discount_validity_date_3 = contractForEC.IT_Discount_Validity_Date_3__c;
                discount_percentage_2 = contractForEC.IT_Discount_Percentage_2__c;
                discount_percentage_3 = contractForEC.IT_Discount_Percentage_3__c;
                discount_validity_date_2 = contractForEC.IT_Discount_Validity_Date_2__c;
                if(contractForEC.IT_Financial_Center__c != null){
                    cliente_ref = contractForEC.IT_Financial_Center__r.IT_Financial_Center__c;
                    special_billing_type = contractForEC.IT_Financial_Center__r.IT_Special_Billing_Type__c;
                    invoice_detraction = contractForEC.IT_Financial_Center__r.IT_Invoice_Detraction__c;
                    flg_send_sut_printout = contractForEC.IT_Financial_Center__r.IT_Send_SUT_Printout__c;
                    flg_accepts_new_billing_system_pa = contractForEC.IT_Financial_Center__r.IT_Accepts_New_Billing_System_PA__c;
                    office_code = contractForEC.IT_Financial_Center__r.IT_Office_Code__c;
                    cup_code = contractForEC.IT_Financial_Center__r.IT_CUP_Code__c;
                    order_code = contractForEC.IT_Financial_Center__r.IT_Order_Code__c;
                    eori_code = contractForEC.IT_Financial_Center__r.IT_EORI_Code__c;
                    flg_accepts_new_billing_system = contractForEC.IT_Financial_Center__r.IT_Accepts_New_Billing_System__c;
                    sdi = contractForEC.IT_Financial_Center__r.IT_SDI__c;
                    pec_mail = contractForEC.IT_Financial_Center__r.IT_PEC_Mail__c;
                    flg_dont_send_debt_note = contractForEC.IT_Financial_Center__r.IT_Don_t_Send_Debt_Note__c;
                    if(contractForEC.IT_Financial_Center__r.IT_Particularities_Progressive_Number__c != null)
                        particularities_progressive_number = Integer.valueOf(contractForEC.IT_Financial_Center__r.IT_Particularities_Progressive_Number__c);
                    contractual_particularities = contractForEC.IT_Financial_Center__r.IT_Contractual_Particularities__c;
                }
                if(contractForEC.IT_Financial_Center__r.ER_Bank_Account__c != null){
                    payment_code = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_Payment_Code__c;
                    sdd_payment_code = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_SDD_Payment_Code__c;
                    bank_account_code = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_Bank_Account_Code__c;
                    abi = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_ABI__c;
                    cab = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_CAB__c;
                    cc = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_CC__c;
                    cin = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_CIN__c;
                    country = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.ER_Country__c;
                    check_iban = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_Check_Iban__c;
                    sdd_contract_code = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_SDD_Contract_Code__c;
                    sdd_subscription_date = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_SDD_Subscription_Date__c;
                    sdd_fiscal_code = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_SDD_Fiscal_Code__c;
                    authorized = contractForEC.IT_Financial_Center__r.ER_Bank_Account__r.IT_SDD_Authorized__c;
                }
                user = user_AC;
                start_date = System.today(); 
            }else if(objType == 'ER_Financial_Center__c' || objType == 'Dual'){
                ER_Financial_Center__c finCenterForEC = (ER_Financial_Center__c) singleEC;
                cliente_ref = finCenterForEC.IT_Financial_Center__c;
                special_billing_type = finCenterForEC.IT_Special_Billing_Type__c;
                invoice_detraction = finCenterForEC.IT_Invoice_Detraction__c;
                flg_send_sut_printout = finCenterForEC.IT_Send_SUT_Printout__c;
                flg_accepts_new_billing_system_pa = finCenterForEC.IT_Accepts_New_Billing_System_PA__c;
                office_code = finCenterForEC.IT_Office_Code__c;
                cup_code = finCenterForEC.IT_CUP_Code__c;
                order_code = finCenterForEC.IT_Order_Code__c;
                eori_code = finCenterForEC.IT_EORI_Code__c;
                flg_accepts_new_billing_system = finCenterForEC.IT_Accepts_New_Billing_System__c;
                sdi = finCenterForEC.IT_SDI__c;
                pec_mail = finCenterForEC.IT_PEC_Mail__c;
                flg_dont_send_debt_note = finCenterForEC.IT_Don_t_Send_Debt_Note__c;
                if(finCenterForEC.IT_Particularities_Progressive_Number__c != null)
                    particularities_progressive_number = Integer.valueOf(finCenterForEC.IT_Particularities_Progressive_Number__c);
                contractual_particularities = finCenterForEC.IT_Contractual_Particularities__c;
                if(finCenterForEC.IT_Contract__c != null){
                    commission_type = finCenterForEC.IT_Contract__r.IT_Commission_Type__c;
                    commission_percentage = finCenterForEC.IT_Contract__r.IT_Commission_Percentage__c;
                    discount_type = finCenterForEC.IT_Contract__r.IT_Discount_Type__c;
                    discount_percentage = finCenterForEC.IT_Contract__r.IT_Discount_Percentage__c;
                    fine_interest_type = finCenterForEC.IT_Contract__r.IT_Fine_Interest_Type__c;
                    not_standard_vat = finCenterForEC.IT_Contract__r.IT_Not_Standard_VAT__c;
                    transport_cost = finCenterForEC.IT_Contract__r.IT_Transport_Cost__c;
                    no_cost_reason = finCenterForEC.IT_Contract__r.IT_No_Cost_Reason__c;
                    promo_code = finCenterForEC.IT_Contract__r.IT_Promo_Code__c;
                    invoice_detail = finCenterForEC.IT_Contract__r.IT_Invoice_Detail__c;
                    debt_notes = finCenterForEC.IT_Contract__r.IT_Debt_Notes__c;
                    debt_notes_effective_date = finCenterForEC.IT_Contract__r.IT_Debt_Notes_Effective_Date__c;
                    debt_notes_percentage = finCenterForEC.IT_Contract__r.IT_Debt_Notes_Percentage__c;
                    debt_notes_locale_type = finCenterForEC.IT_Contract__r.IT_Debt_Notes_Locale_Type__c;
                    expendia_startup_cost = finCenterForEC.IT_Contract__r.IT_Expendia_Startup_Cost__c;
                    if(finCenterForEC.IT_Contract__r.IT_Number_of_Expendia_cards__c != null)
                        number_of_expendia_cards = Integer.valueOf(finCenterForEC.IT_Contract__r.IT_Number_of_Expendia_cards__c);
                    expendia_monthly_fee = finCenterForEC.IT_Contract__r.IT_Expendia_Monthly_Fee__c;
                    card_amount = finCenterForEC.IT_Contract__r.IT_Expendia_Card_Amount__c;
                    flexben_startup_cost = finCenterForEC.IT_Contract__r.IT_Flexben_Startup_Cost__c;
                    flexben_startup_date = finCenterForEC.IT_Contract__r.IT_Flexben_Startup_Date__c;
                    flexben_fee_cost = finCenterForEC.IT_Contract__r.IT_Flexben_Fee_Cost__c;
                    flexben_fee_date = finCenterForEC.IT_Contract__r.IT_Flexben_Start_Fee_Date__c;
                    flexben_fee_frequency= finCenterForEC.IT_Contract__r.IT_Flexben_Fee_Frequency__c;
                    billing_frequency = finCenterForEC.IT_Contract__r.IT_Billing_Frequency_UTA__c;
                    bond = finCenterForEC.IT_Contract__r.IT_Bond_UTA__c;
                    type_extradiscount = finCenterForEC.IT_Contract__r.IT_Type_Extradiscount__c;
                    extradiscount_percentage = finCenterForEC.IT_Contract__r.IT_Extradiscount_Percentage__c;
                    discount_validity_date_3 = finCenterForEC.IT_Contract__r.IT_Discount_Validity_Date_3__c;
                    discount_percentage_2 = finCenterForEC.IT_Contract__r.IT_Discount_Percentage_2__c;
                    discount_percentage_3 = finCenterForEC.IT_Contract__r.IT_Discount_Percentage_3__c;
                    discount_validity_date_2 = finCenterForEC.IT_Contract__r.IT_Discount_Validity_Date_2__c;
                }
                if(finCenterForEC.ER_Bank_Account__c != null){
                    payment_code = finCenterForEC.ER_Bank_Account__r.IT_Payment_Code__c;
                    sdd_payment_code = finCenterForEC.ER_Bank_Account__r.IT_SDD_Payment_Code__c;
                    bank_account_code = finCenterForEC.ER_Bank_Account__r.IT_Bank_Account_Code__c;
                    abi = finCenterForEC.ER_Bank_Account__r.IT_ABI__c;
                    cab = finCenterForEC.ER_Bank_Account__r.IT_CAB__c;
                    cc = finCenterForEC.ER_Bank_Account__r.IT_CC__c;
                    cin = finCenterForEC.ER_Bank_Account__r.IT_CIN__c;
                    country = finCenterForEC.ER_Bank_Account__r.ER_Country__c;
                    check_iban = finCenterForEC.ER_Bank_Account__r.IT_Check_Iban__c;
                    sdd_contract_code = finCenterForEC.ER_Bank_Account__r.IT_SDD_Contract_Code__c;
                    sdd_subscription_date = finCenterForEC.ER_Bank_Account__r.IT_SDD_Subscription_Date__c;
                    sdd_fiscal_code = finCenterForEC.ER_Bank_Account__r.IT_SDD_Fiscal_Code__c;
                    authorized = finCenterForEC.ER_Bank_Account__r.IT_SDD_Authorized__c;
                }
                user = user_AC;
                start_date = System.today(); 
            }else if(objType == 'ER_Bank_Account__c'){
                ER_Bank_Account__c bAForEC = (ER_Bank_Account__c) singleEC;
                
                payment_code = bAForEC.IT_Payment_Code__c;
                sdd_payment_code = bAForEC.IT_SDD_Payment_Code__c;
                bank_account_code = bAForEC.IT_Bank_Account_Code__c;
                abi = bAForEC.IT_ABI__c;
                cab = bAForEC.IT_CAB__c;
                cc = bAForEC.IT_CC__c;
                cin = bAForEC.IT_CIN__c;
                country = bAForEC.ER_Country__c;
                check_iban = bAForEC.IT_Check_Iban__c;
                sdd_contract_code = bAForEC.IT_SDD_Contract_Code__c;
                sdd_subscription_date = bAForEC.IT_SDD_Subscription_Date__c;
                sdd_fiscal_code = bAForEC.IT_SDD_Fiscal_Code__c;
                authorized = bAForEC.IT_SDD_Authorized__c;
                if(bAForEC.ER_Financial_Center__c != null && bAForEC.ER_Financial_Center__r.IT_Contract__c != null){
                    commission_type = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Commission_Type__c;
                    commission_percentage = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Commission_Percentage__c;
                    discount_type = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Discount_Type__c;
                    discount_percentage = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Discount_Percentage__c;
                    fine_interest_type = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Fine_Interest_Type__c;
                    not_standard_vat = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Not_Standard_VAT__c;
                    transport_cost = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Transport_Cost__c;
                    no_cost_reason = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_No_Cost_Reason__c;
                    promo_code = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Promo_Code__c;
                    invoice_detail = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Invoice_Detail__c;
                    debt_notes = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Debt_Notes__c;
                    debt_notes_effective_date = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Debt_Notes_Effective_Date__c;
                    debt_notes_percentage = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Debt_Notes_Percentage__c;
                    debt_notes_locale_type = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Debt_Notes_Locale_Type__c;
                    expendia_startup_cost = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Expendia_Startup_Cost__c;
                    if(bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Number_of_Expendia_cards__c != null)
                        number_of_expendia_cards = Integer.valueOf(bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Number_of_Expendia_cards__c);
                    expendia_monthly_fee = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Expendia_Monthly_Fee__c;
                    card_amount = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Expendia_Card_Amount__c;
                    flexben_startup_cost = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Flexben_Startup_Cost__c;
                    flexben_startup_date = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Flexben_Startup_Date__c;
                    flexben_fee_cost = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Flexben_Fee_Cost__c;
                    flexben_fee_date = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Flexben_Start_Fee_Date__c;
                    flexben_fee_frequency= bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Flexben_Fee_Frequency__c;
                    billing_frequency = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Billing_Frequency_UTA__c;
                    bond = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Bond_UTA__c;
                    type_extradiscount = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Type_Extradiscount__c;
                    extradiscount_percentage = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Extradiscount_Percentage__c;
                    discount_validity_date_3 = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Discount_Validity_Date_3__c;
                    discount_percentage_2 = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Discount_Percentage_2__c;
                    discount_percentage_3 = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Discount_Percentage_3__c;
                    discount_validity_date_2 = bAForEC.ER_Financial_Center__r.IT_Contract__r.IT_Discount_Validity_Date_2__c;    
                }
                if(bAForEC.ER_Financial_Center__c != null){
                    cliente_ref = bAForEC.ER_Financial_Center__r.IT_Financial_Center__c;
                    special_billing_type = bAForEC.ER_Financial_Center__r.IT_Special_Billing_Type__c;
                    invoice_detraction = bAForEC.ER_Financial_Center__r.IT_Invoice_Detraction__c;
                    flg_send_sut_printout = bAForEC.ER_Financial_Center__r.IT_Send_SUT_Printout__c;
                    flg_accepts_new_billing_system_pa = bAForEC.ER_Financial_Center__r.IT_Accepts_New_Billing_System_PA__c;
                    office_code = bAForEC.ER_Financial_Center__r.IT_Office_Code__c;
                    cup_code = bAForEC.ER_Financial_Center__r.IT_CUP_Code__c;
                    order_code = bAForEC.ER_Financial_Center__r.IT_Order_Code__c;
                    eori_code = bAForEC.ER_Financial_Center__r.IT_EORI_Code__c;
                    flg_accepts_new_billing_system = bAForEC.ER_Financial_Center__r.IT_Accepts_New_Billing_System__c;
                    sdi = bAForEC.ER_Financial_Center__r.IT_SDI__c;
                    pec_mail = bAForEC.ER_Financial_Center__r.IT_PEC_Mail__c;
                    flg_dont_send_debt_note = bAForEC.ER_Financial_Center__r.IT_Don_t_Send_Debt_Note__c;
                    if(bAForEC.ER_Financial_Center__r.IT_Particularities_Progressive_Number__c != null)
                        particularities_progressive_number = Integer.valueOf(bAForEC.ER_Financial_Center__r.IT_Particularities_Progressive_Number__c);
                    contractual_particularities = bAForEC.ER_Financial_Center__r.IT_Contractual_Particularities__c;
                }
                user = user_AC;
                start_date = System.today(); 
            }else if(objType == 'IT_Request__c'){
                IT_Request__c requestForEC = (IT_Request__c) singleEC;
                cliente_ref = requestForEC.IT_Client_Code__c;
                special_billing_type = addFieldEC.IT_Special_Billing_Type__c;
                invoice_detraction = addFieldEC.IT_Invoice_Detraction__c;
                flg_send_sut_printout = addFieldEC.IT_Send_SUT_Printout__c;
                flg_accepts_new_billing_system_pa = addFieldEC.IT_Accepts_New_Billing_System_PA__c;
                office_code = addFieldEC.IT_Office_Code__c;
                cup_code = addFieldEC.IT_CUP_Code__c;
                order_code = addFieldEC.IT_Order_Code__c;
                eori_code = addFieldEC.IT_EORI_Code__c;
                flg_accepts_new_billing_system = addFieldEC.IT_Accepts_New_Billing_System__c;
                sdi = addFieldEC.IT_SDI__c;
                pec_mail = addFieldEC.IT_PEC_Mail__c;
                flg_dont_send_debt_note = addFieldEC.IT_Don_t_Send_Debt_Note__c;
                if(!String.isBlank(addFieldEC.IT_Contractual_Particularities__c) && !String.isBlank(requestForEC.IT_Contractual_Particularities__c) && addFieldEC.IT_Contractual_Particularities__c != requestForEC.IT_Contractual_Particularities__c){
                    if(addFieldEC.IT_Particularities_Progressive_Number__c != null)
                        particularities_progressive_number = Integer.valueOf(addFieldEC.IT_Particularities_Progressive_Number__c)+1;
                    contractual_particularities = requestForEC.IT_Contractual_Particularities__c;
                }else if(!String.isBlank(addFieldEC.IT_Contractual_Particularities__c) && !String.isBlank(requestForEC.IT_Contractual_Particularities__c) && addFieldEC.IT_Contractual_Particularities__c == requestForEC.IT_Contractual_Particularities__c){
                    if(addFieldEC.IT_Particularities_Progressive_Number__c != null)
                        particularities_progressive_number = Integer.valueOf(addFieldEC.IT_Particularities_Progressive_Number__c);
                    contractual_particularities = addFieldEC.IT_Contractual_Particularities__c;    
                }else if(!String.isBlank(addFieldEC.IT_Contractual_Particularities__c) && String.isBlank(requestForEC.IT_Contractual_Particularities__c)){
                    particularities_progressive_number = 0;
                    contractual_particularities = '';
                }
                
                commission_type = requestForEC.IT_Commission_Type__c;
                commission_percentage = requestForEC.IT_Commission_Percentage__c;
                discount_type = requestForEC.IT_Discount_Type__c;
                discount_percentage = requestForEC.IT_Discount_Percentage__c;
                fine_interest_type = contractAddFields.IT_Fine_Interest_Type__c;
                not_standard_vat = contractAddFields.IT_Not_Standard_VAT__c;
                transport_cost = requestForEC.IT_Transport_Cost__c;
                no_cost_reason = requestForEC.IT_No_Cost_Reason__c;
                //promo_code = contractAddFields.IT_Promo_Code__c;
                invoice_detail = contractAddFields.IT_Invoice_Detail__c;
                debt_notes = contractAddFields.IT_Debt_Notes__c;
                debt_notes_effective_date = contractAddFields.IT_Debt_Notes_Effective_Date__c;
                debt_notes_percentage = contractAddFields.IT_Debt_Notes_Percentage__c;
                debt_notes_locale_type = contractAddFields.IT_Debt_Notes_Locale_Type__c;
                expendia_startup_cost = contractAddFields.IT_Expendia_Startup_Cost__c;
                if(contractAddFields.IT_Number_of_Expendia_cards__c != null)
                    number_of_expendia_cards = Integer.valueOf(contractAddFields.IT_Number_of_Expendia_cards__c); 
                expendia_monthly_fee = contractAddFields.IT_Expendia_Monthly_Fee__c;
                card_amount = contractAddFields.IT_Expendia_Card_Amount__c;
                flexben_startup_cost =  contractAddFields.IT_Flexben_Startup_Cost__c;
                flexben_startup_date  = contractAddFields.IT_Flexben_Startup_Date__c;
                flexben_fee_cost = contractAddFields.IT_Flexben_Fee_Cost__c;
                flexben_fee_date = contractAddFields.IT_Flexben_Start_Fee_Date__c;
                flexben_fee_frequency = contractAddFields.IT_Flexben_Fee_Frequency__c;
                billing_frequency = contractAddFields.IT_Billing_Frequency_UTA__c;
                bond = contractAddFields.IT_Bond_UTA__c;

                type_extradiscount = requestForEC.IT_Type_Extradiscount__c;
                extradiscount_percentage = requestForEC.IT_Extradiscount_Percentage__c;
                discount_validity_date_3 = requestForEC.IT_Discount_Validity_Date_3__c;
                discount_percentage_2 = requestForEC.IT_Discount_Percentage_2__c;
                discount_percentage_3 = requestForEC.IT_Discount_Percentage_3__c;
                discount_validity_date_2 = requestForEC.IT_Discount_Validity_Date_2__c;

                payment_code = requestForEC.IT_Payment_Code__c;
                sdd_payment_code = requestForEC.IT_SDD_Payment_Code__c;
                bank_account_code = requestForEC.IT_Bank_Account_Code__c;
                abi = requestForEC.IT_ABI__c;
                cab = requestForEC.IT_CAB__c;
                cc = requestForEC.IT_CC__c;
                cin = requestForEC.IT_CIN__c;
                country = requestForEC.IT_Country__c;
                check_iban = requestForEC.IT_Check_Iban__c;
                sdd_contract_code = requestForEC.IT_SDD_Contract_Code__c;
                sdd_subscription_date = requestForEC.IT_SDD_Subscription_Date__c;
                sdd_fiscal_code = requestForEC.IT_SDD_Fiscal_Code__c;
                authorized = requestForEC.IT_SDD_Authorized__c;

                user = user_AC;
                start_date = requestForEC.IT_Contract_Start_Date__c;
  
            }
        }
    }

    public class deliveries_site{
        public String client_ref {get;set;}
        public Integer ac_delivery {get;set;}
        public Integer sf_delivery {get;set;}
        public String ac_activity {get;set;}
        public String sf_activity {get;set;}
        public String delivery_type {get;set;}
        public Boolean flg_delivery_point {get;set;}
        public String branch  {get;set;}
        public String provider {get;set;}
        public String vehicle {get;set;}
        public Boolean flg_vehicle_forcing {get;set;}
        public String special_service {get;set;}
        public Integer matched_delivery {get;set;}
        public String notes_type {get;set;}
        public String notes {get;set;}
        public String text {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public Date note_validity_start_date {get;set;} 
        public Date note_validity_end_date {get;set;}
        public deliveries_site(){
        }
        public deliveries_site(ER_Delivery_Site__c singleDeliverySite, String user_AC, ER_Distribution_Point__c dpgorDs, Map<Id, ER_Delivery_Site__c> oldvalMAp){
            List<ER_Distribution_Point__c> disList = new List<ER_Distribution_Point__c>();
            disList = singleDeliverySite.Distribution_Points__r;
            client_ref = singleDeliverySite.IT_Client_Code__c ;
            if(singleDeliverySite.IT_Delivery_AC__c != null)
                ac_delivery = Integer.valueOf(singleDeliverySite.IT_Delivery_AC__c);
            if(singleDeliverySite.IT_Delivery_SF__c != null)
                sf_delivery = Integer.valueOf(singleDeliverySite.IT_Delivery_SF__c);    
            if(dpgorDs != null && dpgorDs != new ER_Distribution_Point__c()){        
                ac_activity = dpgorDs.IT_AC_Activity__c ;
                sf_activity = dpgorDs.IT_SF_Activity__c ;
            }else if(singleDeliverySite.Distribution_Points__r != null && singleDeliverySite.Distribution_Points__r.size() > 0){
                ac_activity = singleDeliverySite.Distribution_Points__r[0].IT_AC_Activity__c ;
                sf_activity = singleDeliverySite.Distribution_Points__r[0].IT_SF_Activity__c ;
            }else if(disList == new List<ER_Distribution_Point__c>() || disList.size() == 0){
                ac_activity = singleDeliverySite.IT_Activity_AC__c ;
                sf_activity = singleDeliverySite.IT_Activity_SF__c ;
            }
            delivery_type = singleDeliverySite.IT_Delivery_Type__c ;
            flg_delivery_point = singleDeliverySite.IT_Delivery_Point__c ;
            branch  = singleDeliverySite.IT_Branch__c ;
            provider = singleDeliverySite.IT_Provider__c ;
            vehicle = singleDeliverySite.IT_Vehicle__c ;
            flg_vehicle_forcing = singleDeliverySite.IT_Vehicle_Forcing__c ;
            special_service = singleDeliverySite.IT_Special_Service__c ;
            if(singleDeliverySite.IT_Matched_Delivery__c != null)
                matched_delivery = Integer.valueOf(singleDeliverySite.IT_Matched_Delivery__c);
            if(!String.isBlank(singleDeliverySite.IT_Notes__c)){    
                //notes_type = singleDeliverySite.IT_Notes_Type__c;
                notes_type = '015';
            }    
            notes = singleDeliverySite.IT_Notes__c ;
            text = singleDeliverySite.IT_Text__c ;
            user = user_AC;
            //start_date = singleDeliverySite.IT_Validity_Start_Date__c ;
            start_date = System.today();
            end_date = singleDeliverySite.IT_Validity_End_Date__c ;
            if(!String.isBlank(singleDeliverySite.IT_Text__c) && singleDeliverySite.IT_Text__c != oldvalMAp.get(singleDeliverySite.Id).IT_Text__c)
                note_validity_start_date = System.today(); 
            note_validity_end_date = singleDeliverySite.IT_Note_Validity_End_Date__c;
        }
    }
    
    public class contracts{
        public String opportunity_code {get;set;}
        public String contract_number {get;set;}
        public Integer contract_progressive {get;set;}
        public String client_ref {get;set;}
        public String attendance_type {get;set;}
        public String contract_renewal_type {get;set;}
        public String contract_type {get;set;}
        public String contract_status {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public Date sign_sending_date {get;set;}
        public Date contract_sign_date {get;set;}
        public Date expiration_contract_date {get;set;}
        public String contract_closing_type {get;set;}
        public Boolean flg_penal_presence {get;set;}
        public String delivery_date_bond {get;set;}
        public Integer delivery_term {get;set;}
        public String term_type {get;set;}
        public Integer delivery_fixed_day {get;set;}
        public String fixed_day_type {get;set;}
        public Integer order_reception_term {get;set;}
        public String order_reception_term_type {get;set;}
        public Boolean flg_no_sign_activation_authorization {get;set;}
        public String reception_type {get;set;}
        public Boolean flg_no_massive_print {get;set;}
        public Boolean flg_sdd_payment {get;set;}
        public Boolean flg_multidiscount {get;set;}
        public Boolean flg_extradiscount {get;set;}
        public Boolean flg_no_exclusivity {get;set;}
        public Integer annual_potential {get;set;}
        public String renewal_reason {get;set;}
        public Boolean flg_accepts_privacy {get;set;}
        public String framework_head_code {get;set;}
        public Boolean flg_framework_warrant {get;set;}
        public Boolean flg_only_client_copy {get;set;}
        public Boolean flg_supply_conditions {get;set;}
        public Date campaign_start_date {get;set;}
        public Date campaign_end_date {get;set;}
        public Decimal card_cost {get;set;}
        public String card_cost_billing_type {get;set;}
        public String card_cost_billing_frequency {get;set;}
        public String card_cost_billing_rules {get;set;}
        public Decimal monthly_limit {get;set;}
        public String offer_type {get;set;}
        public Integer vehicles_number {get;set;}
        public String user {get;set;}
        public Boolean flg_stamp_starting {get;set;}
        public Boolean flg_no_data {get;set;}
        public contracts(){
        }
        public contracts(Contract singleContract, String user_AC){
            opportunity_code = singleContract.IT_Opportunity_Code__c ;
            contract_number = singleContract.IT_Contract_Number__c ;
            if(singleContract.IT_Contract_Progressive__c != null)
                contract_progressive = Integer.valueOf(singleContract.IT_Contract_Progressive__c);
            client_ref = singleContract.IT_Client_Code__c ;
            attendance_type = singleContract.IT_Attendance_Type__c ;
            contract_renewal_type = singleContract.IT_Contract_Renewal_Type__c ;
            contract_type = singleContract.IT_Contract_Type__c ;
            contract_status = singleContract.IT_Contract_Status__c ;
            //start_date = singleContract.IT_Start_Validity_Date__c ;
            start_date = singleContract.StartDate;
            end_date = singleContract.EndDate ;
            sign_sending_date = singleContract.IT_Sign_Sending_date__c ;
            contract_sign_date = singleContract.IT_Contract_Sign_Date__c ;
            expiration_contract_date = singleContract.IT_Expiration_Contract_Date__c ;
            contract_closing_type = singleContract.IT_Contract_Closing_Type__c ;
            flg_penal_presence = singleContract.IT_Penal_Presence__c ;
            delivery_date_bond = singleContract.IT_Delivery_Date_Bond__c;
            if(singleContract.IT_Delivery_Date_Bond__c != null)
                delivery_term = Integer.valueOf(singleContract.IT_Delivery_Term__c);
            term_type = singleContract.IT_Term_Type__c ;
            if(singleContract.IT_Delivery_Fixed_Day__c != null)
                delivery_fixed_day = Integer.valueOf(singleContract.IT_Delivery_Fixed_Day__c);
            fixed_day_type = singleContract.IT_Fixed_Day_Type__c ;
            if(singleContract.IT_Order_Reception_Term__c != null)
                order_reception_term = Integer.valueOf(singleContract.IT_Order_Reception_Term__c);
            order_reception_term_type = singleContract.IT_Order_Reception_Term_Type__c ;
            flg_no_sign_activation_authorization = singleContract.IT_No_Sign_Activation_Authorization__c ;
            reception_type = singleContract.IT_Reception_Type__c ;
            flg_no_massive_print = singleContract.IT_No_Massive_Print__c ;
            flg_sdd_payment = singleContract.IT_SDD_Payment__c ;
            flg_multidiscount = singleContract.IT_Multidiscount__c ;
            flg_extradiscount = singleContract.IT_Extradiscount__c ;
            flg_no_exclusivity = singleContract.IT_No_Exclusivity__c;
            if(singleContract.IT_Annual_Potential__c != null)
                annual_potential = Integer.valueOf(singleContract.IT_Annual_Potential__c);
            renewal_reason = singleContract.IT_Renewal_Reason__c ;
            flg_accepts_privacy = singleContract.IT_Accepts_Privacy__c ;
            framework_head_code = singleContract.IT_Framework_Head_Code__c ;
            flg_framework_warrant = singleContract.IT_Framework_Warrant__c ;
            flg_only_client_copy = singleContract.IT_Only_Client_Copy__c ;
            flg_supply_conditions = singleContract.IT_Supply_Conditions__c ;
            campaign_start_date = singleContract.IT_Campaign_Start_Date__c ;
            campaign_end_date = singleContract.IT_Campaign_End_Date__c ;
            card_cost = singleContract.IT_Card_Cost__c ;
            card_cost_billing_type = singleContract.IT_Card_Cost_Billing_Type__c ;
            card_cost_billing_frequency = singleContract.IT_Card_Cost_Billing_Frequency__c ;
            card_cost_billing_rules = singleContract.IT_Card_Cost_Billing_Rules__c ;
            monthly_limit = singleContract.IT_UTA_Monthly_Limit__c ;
            offer_type = singleContract.IT_UTA_Offer_Type__c ;
            if(singleContract.IT_UTA_Vehicles_Number__c != null)
                vehicles_number = Integer.valueOf(singleContract.IT_UTA_Vehicles_Number__c);
            user = user_AC;
        }
        public contracts(ER_Financial_Center__c singleContract, String user_AC){
            opportunity_code = singleContract.IT_Contract__r.IT_Opportunity_Code__c ;
            contract_number = singleContract.IT_Contract__r.IT_Contract_Number__c ;
            if(singleContract.IT_Contract__r.IT_Contract_Progressive__c != null)
                contract_progressive = Integer.valueOf(singleContract.IT_Contract__r.IT_Contract_Progressive__c);
            client_ref = singleContract.IT_Contract__r.IT_Client_Code__c ;
            attendance_type = singleContract.IT_Contract__r.IT_Attendance_Type__c ;
            contract_renewal_type = singleContract.IT_Contract__r.IT_Contract_Renewal_Type__c ;
            contract_type = singleContract.IT_Contract__r.IT_Contract_Type__c ;
            contract_status = singleContract.IT_Contract__r.IT_Contract_Status__c ;
            //start_date = singleContract.IT_Contract__r.IT_Start_Validity_Date__c ;
            start_date = singleContract.IT_Contract__r.StartDate;
            end_date = singleContract.IT_Contract__r.EndDate ;
            sign_sending_date = singleContract.IT_Contract__r.IT_Sign_Sending_date__c ;
            contract_sign_date = singleContract.IT_Contract__r.IT_Contract_Sign_Date__c ;
            expiration_contract_date = singleContract.IT_Contract__r.IT_Expiration_Contract_Date__c ;
            contract_closing_type = singleContract.IT_Contract__r.IT_Contract_Closing_Type__c ;
            flg_penal_presence = singleContract.IT_Contract__r.IT_Penal_Presence__c ;
            delivery_date_bond = singleContract.IT_Contract__r.IT_Delivery_Date_Bond__c;
            if(singleContract.IT_Contract__r.IT_Delivery_Term__c != null)
                delivery_term = Integer.valueOf(singleContract.IT_Contract__r.IT_Delivery_Term__c);
            term_type = singleContract.IT_Contract__r.IT_Term_Type__c ;
            if(singleContract.IT_Contract__r.IT_Delivery_Fixed_Day__c != null)
                delivery_fixed_day = Integer.valueOf(singleContract.IT_Contract__r.IT_Delivery_Fixed_Day__c);
            fixed_day_type = singleContract.IT_Contract__r.IT_Fixed_Day_Type__c ;
            if(singleContract.IT_Contract__r.IT_Order_Reception_Term__c != null)
                order_reception_term = Integer.valueOf(singleContract.IT_Contract__r.IT_Order_Reception_Term__c);
            order_reception_term_type = singleContract.IT_Contract__r.IT_Order_Reception_Term_Type__c ;
            flg_no_sign_activation_authorization = singleContract.IT_Contract__r.IT_No_Sign_Activation_Authorization__c ;
            reception_type = singleContract.IT_Contract__r.IT_Reception_Type__c ;
            flg_no_massive_print = singleContract.IT_Contract__r.IT_No_Massive_Print__c ;
            flg_sdd_payment = singleContract.IT_Contract__r.IT_SDD_Payment__c ;
            flg_multidiscount = singleContract.IT_Contract__r.IT_Multidiscount__c ;
            flg_extradiscount = singleContract.IT_Contract__r.IT_Extradiscount__c ;
            flg_no_exclusivity = singleContract.IT_Contract__r.IT_No_Exclusivity__c;
            if(singleContract.IT_Contract__r.IT_Annual_Potential__c != null)
                annual_potential = Integer.valueOf(singleContract.IT_Contract__r.IT_Annual_Potential__c);
            renewal_reason = singleContract.IT_Contract__r.IT_Renewal_Reason__c ;
            flg_accepts_privacy = singleContract.IT_Contract__r.IT_Accepts_Privacy__c ;
            framework_head_code = singleContract.IT_Contract__r.IT_Framework_Head_Code__c ;
            flg_framework_warrant = singleContract.IT_Contract__r.IT_Framework_Warrant__c ;
            flg_only_client_copy = singleContract.IT_Contract__r.IT_Only_Client_Copy__c ;
            flg_supply_conditions = singleContract.IT_Contract__r.IT_Supply_Conditions__c ;
            campaign_start_date = singleContract.IT_Contract__r.IT_Campaign_Start_Date__c ;
            campaign_end_date = singleContract.IT_Contract__r.IT_Campaign_End_Date__c ;
            card_cost = singleContract.IT_Contract__r.IT_Card_Cost__c ;
            card_cost_billing_type = singleContract.IT_Contract__r.IT_Card_Cost_Billing_Type__c ;
            card_cost_billing_frequency = singleContract.IT_Contract__r.IT_Card_Cost_Billing_Frequency__c ;
            card_cost_billing_rules = singleContract.IT_Contract__r.IT_Card_Cost_Billing_Rules__c ;
            monthly_limit = singleContract.IT_Contract__r.IT_UTA_Monthly_Limit__c ;
            offer_type = singleContract.IT_Contract__r.IT_UTA_Offer_Type__c ;
            if(singleContract.IT_Contract__r.IT_UTA_Vehicles_Number__c != null)
                vehicles_number = Integer.valueOf(singleContract.IT_Contract__r.IT_UTA_Vehicles_Number__c);
            user = user_AC;
        }
        public contracts(IT_Request__c singleContract, Contract oldContr, String user_AC){
            start_date = singleContract.IT_Contract_Start_Date__c;
            contract_number = singleContract.IT_Contract_Number__c;
            attendance_type = singleContract.IT_Attendance_Type__c;
            contract_type = singleContract.IT_Contract_Type__c;
            expiration_contract_date = singleContract.IT_Expiration_Contract_Date__c;
            contract_renewal_type = singleContract.IT_Contract_Renewal_Type__c;
            flg_no_massive_print = singleContract.IT_No_Massive_Print__c;
            flg_no_exclusivity = singleContract.IT_No_Exclusivity__c;
            flg_extradiscount = singleContract.IT_Extradiscount__c;
            flg_multidiscount = singleContract.IT_Multidiscount__c;
            flg_sdd_payment = singleContract.IT_SDD_Payment__c;
            flg_penal_presence = singleContract.IT_Penal_Presence__c;
            delivery_date_bond = singleContract.IT_Delivery_Date_Bond__c;
            if(singleContract.IT_Delivery_Term__c != null)
                delivery_term = Integer.valueOf(singleContract.IT_Delivery_Term__c);
            term_type = singleContract.IT_Term_Type__c;
            if(singleContract.IT_Delivery_Fixed_Day__c != null)
                delivery_fixed_day = Integer.valueOf(singleContract.IT_Delivery_Fixed_Day__c);
            if(singleContract.IT_Order_Reception_Term__c != null)
                order_reception_term = Integer.valueOf(singleContract.IT_Order_Reception_Term__c); 
            if(singleContract.IT_Contract_Progressive__c != null && singleContract.IT_Editing_Reason__c != '18'){
                if(singleContract.IT_Contract_Progressive__c == oldContr.IT_Contract_Progressive__c)
                    contract_progressive = Integer.valueOf(oldContr.IT_Contract_Progressive__c) + 1;
                else
                    contract_progressive = 1;     
            }else{
                contract_progressive = Integer.valueOf(singleContract.IT_Contract_Progressive__c);  
            }          
            framework_head_code = singleContract.IT_Framework_Head_Code__c;
            opportunity_code = singleContract.IT_Opportunity_Code__c;
            campaign_start_date = singleContract.IT_Campaign_Start_Date__c;
            campaign_end_date = singleContract.IT_Campaign_End_Date__c;
            flg_only_client_copy = singleContract.IT_Only_Client_Copy__c;
            card_cost = singleContract.IT_Card_Cost__c;
            flg_supply_conditions = singleContract.IT_Supply_Conditions__c;
            flg_framework_warrant = singleContract.IT_Framework_Warrant__c;
            if(singleContract.IT_UTA_Vehicles_Number__c != null)
                vehicles_number = Integer.valueOf(singleContract.IT_UTA_Vehicles_Number__c);
            monthly_limit = singleContract.IT_UTA_Monthly_Limit__c;
            offer_type = singleContract.IT_UTA_Offer_Type__c;
            card_cost_billing_frequency = singleContract.IT_Card_Cost_Billing_Frequency__c;
            client_ref = singleContract.IT_Client_Code__c ; 
            renewal_reason = oldContr.IT_Renewal_Reason__c ;
            flg_accepts_privacy = oldContr.IT_Accepts_Privacy__c ;
            if(oldContr.IT_Annual_Potential__c != null)
                annual_potential = Integer.valueOf(oldContr.IT_Annual_Potential__c);
            System.debug('singleContract.IT_Contract_Sign_Date__c:: '+singleContract.IT_Contract_Sign_Date__c); 
            System.debug('singleContract.IT_Sign_Sending_Date__c:: '+singleContract.IT_Sign_Sending_Date__c); 
            sign_sending_date = singleContract.IT_Sign_Sending_Date__c ;
            contract_sign_date = singleContract.IT_Contract_Sign_Date__c ;
            if(singleContract.IT_Contract_Sign_Date__c == null && singleContract.IT_Sign_Sending_Date__c == null){
                contract_status = '01';
                flg_no_sign_activation_authorization = true;
            }else if(singleContract.IT_Contract_Sign_Date__c != null && singleContract.IT_Sign_Sending_Date__c == null){
                contract_status = '02';
                flg_no_sign_activation_authorization = false;
            }else if(singleContract.IT_Contract_Sign_Date__c != null && singleContract.IT_Sign_Sending_Date__c != null){
                contract_status = '04';
                flg_no_sign_activation_authorization = false; 
            }       
            user = user_AC;   
        }
    }

    public class administratives_data{
        public String client_ref {get;set;}
        public String service {get;set;}
        public String client_status {get;set;}
        public Integer employee_number {get;set;}
        public Boolean flg_multiactivity {get;set;}
        public String client_situation {get;set;}
        public String opening_outcome {get;set;}
        public String concurrency {get;set;}
        public String beneficiary_type {get;set;}
        public String previous_code {get;set;}
        public String fused_client {get;set;}
        public String new_code {get;set;}
        public String associated_client {get;set;}
        public String company_name {get;set;}
        public String short_name {get;set;}
        public String extended_company_name {get;set;}
        public String cig {get;set;}
        public String derived_cig {get;set;}
        public String circuit_ref {get;set;}
        public String client_type {get;set;}
        public String contact_ref {get;set;}
        public String admin_data_ac_user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public String vat_number {get;set;}
        public administratives_data(){
        }
        public administratives_data(ER_Financial_Center__c singleFC, String user_AC){
            client_ref = singleFC.IT_Financial_Center__c;
            service = singleFC.IT_Service__c;
            client_status = singleFC.IT_Client_Status__c;
            if(singleFC.IT_Employee_Number__c != null)
                employee_number = Integer.valueOf(singleFC.IT_Employee_Number__c);
            flg_multiactivity = singleFC.IT_Single_Client_Multiactivity__c;
            client_situation = singleFC.IT_Client_Situation__c;
            opening_outcome = singleFC.IT_Opening_Outcome__c;
            concurrency = singleFC.IT_Concurrency__c;
            beneficiary_type = singleFC.IT_Beneficiary_Type__c;
            previous_code = singleFC.IT_Previous_Code__c;
            fused_client = singleFC.IT_Fused_Client__c;
            new_code = singleFC.IT_New_Code__c;
            associated_client = singleFC.IT_Associated_Client__c;
            if(!String.isBlank(singleFC.IT_Billing_Company_Name_R3__c)){
                //company_name = singleFC.IT_Billing_Company_Name_R1__c+' '+singleFC.IT_Billing_Company_Name_R2__c+' '+singleFC.IT_Billing_Company_Name_R3__c;
                company_name = singleFC.IT_Billing_Company_Name_R1__c+singleFC.IT_Billing_Company_Name_R2__c+singleFC.IT_Billing_Company_Name_R3__c;
            }else if(!String.isBlank(singleFC.IT_Billing_Company_Name_R2__c)){
                company_name = singleFC.IT_Billing_Company_Name_R1__c;
                for(integer i = singleFC.IT_Billing_Company_Name_R1__c.length(); i < 30; i++){
                    company_name = company_name + ' ';
                }
                    
                company_name = company_name+singleFC.IT_Billing_Company_Name_R2__c; 
            }else{ 
                company_name = singleFC.IT_Billing_Company_Name_R1__c;
            }    
            short_name = singleFC.IT_Short_Name__c;
            extended_company_name = singleFC.IT_Extended_Company_Name__c; 
            cig = singleFC.IT_CIG__c;
            derived_cig = singleFC.IT_Derived_CIG__c;
            circuit_ref = singleFC.IT_Circuit_Code__c;
            client_type = singleFC.IT_Client_Type__c;
            contact_ref = singleFC.IT_Contact_Code__c;
            admin_data_ac_user = user_AC;
            if(singleFC.IT_Admin_Data_Validity_Start_Date__c != null && singleFC.IT_Admin_Data_Validity_Start_Date__c > System.today())
                start_date = singleFC.IT_Admin_Data_Validity_Start_Date__c;
            else
                start_date = System.today();
            end_date = singleFC.IT_Admin_Data_Validity_End_Date__c; 
            vat_number = singleFC.IT_VAT_Number__c;
        }
    } 

    public class products_data{
        public String client_ref {get;set;}
        public Integer technical_data_progressive {get;set;}
        public String product {get;set;}
        public String feedback_type {get;set;}
        public String logo_type {get;set;}
        public Boolean flg_feedback_request {get;set;}
        public String ticket_type {get;set;}
        public String font_type {get;set;}
        public String order_receipts_type {get;set;}
        public String order_frequence_type {get;set;}
        public Boolean flg_single_series_emission {get;set;}
        public Boolean flg_ticket_return_request {get;set;}
        public Boolean flg_itinerant_client {get;set;}
        public Boolean flg_ticket_display {get;set;}
        public Boolean flg_no_ads {get;set;}
        public Boolean flg_no_insert {get;set;}
        public Boolean flg_display_locale {get;set;}
        public Boolean flg_display_address {get;set;}
        public Boolean flg_display_active_name {get;set;}
        public Boolean flg_amount_display {get;set;}
        public Boolean flg_ticket_value {get;set;}
        public Boolean flg_activity_exception {get;set;}
        public Boolean flg_display_active_name_address {get;set;}
        public String address_row_display {get;set;}
        public Decimal amount {get;set;}
        public String logo_code {get;set;}
        public String business_association_logo_type {get;set;}
        public String business_association_font_type {get;set;}
        public String business_association_logo_code {get;set;}
        public Integer printout_employee_copies_number {get;set;}
        public Integer emitted_ticket_copies_number {get;set;}
        public String card_type {get;set;}
        public String web_enabling_level {get;set;}
        public Boolean flg_file_sending_authorization {get;set;}
        public Boolean flg_front_and_back_printout {get;set;}
        public String stock_orders {get;set;}
        public String graphic_layer_front {get;set;}
        public String graphic_layer_back {get;set;}
        public String graphic_background_front {get;set;}
        public String graphic_background_back {get;set;}
        public String envelope {get;set;}
        public String user {get;set;}
        public Date validity_start_date {get;set;}
        public Date validity_end_date {get;set;}
        public products_data(){
        }
        public products_data(ER_ContractLineItem__c singleProduct, String user_AC){
            client_ref = singleProduct.IT_Client_Code__c;
            if(singleProduct.IT_Technical_Data_Progressive__c != null)
                technical_data_progressive = Integer.valueOf(singleProduct.IT_Technical_Data_Progressive__c);
            product = singleProduct.IT_Product__c;
            feedback_type = singleProduct.IT_Feedback_Type__c;
            logo_type = singleProduct.IT_Logo_Type__c;
            flg_feedback_request = singleProduct.IT_Feedback_Request__c;
            ticket_type = singleProduct.IT_Ticket_Type__c;
            font_type = singleProduct.IT_Font_Type__c;
            order_receipts_type = singleProduct.IT_Order_Receipts_Type__c;
            order_frequence_type = singleProduct.IT_Order_Frequence_Type__c;
            flg_single_series_emission = singleProduct.IT_Single_Series_Emission__c;
            flg_ticket_return_request = singleProduct.IT_Ticket_Return_Request__c;
            flg_itinerant_client = singleProduct.IT_Itinerant_Client__c;
            flg_ticket_display = singleProduct.IT_Ticket_Display__c;
            flg_no_ads = singleProduct.IT_No_Ads__c;
            flg_no_insert = singleProduct.IT_No_Insert__c;
            flg_display_locale = singleProduct.IT_Display_Locale__c;
            flg_display_address = singleProduct.IT_Display_Address__c;
            flg_display_active_name = singleProduct.IT_Display_Active_Name__c;
            flg_amount_display = singleProduct.IT_Amount_Display__c;
            flg_ticket_value = singleProduct.IT_Ticket_Value__c;
            flg_activity_exception = singleProduct.IT_Activity_Exception__c;
            flg_display_active_name_address = singleProduct.IT_Address_Row_display__c;
            address_row_display = singleProduct.IT_Data_on_Address_Row__c;
            amount = singleProduct.IT_Amount__c;
            logo_code = singleProduct.IT_Logo_Code__c;
            business_association_logo_type = singleProduct.IT_Business_Association_Logo_Type__c;
            business_association_font_type = singleProduct.IT_Business_Association_Font_Type__c;
            business_association_logo_code = singleProduct.IT_Business_Association_Logo_Code__c;
            if(singleProduct.IT_Printout_Employee_Copies_Number__c != null)    
                printout_employee_copies_number = Integer.valueOf(singleProduct.IT_Printout_Employee_Copies_Number__c);
            if(singleProduct.IT_Emitted_Ticket_Copies_Number__c != null)    
                emitted_ticket_copies_number = Integer.valueOf(singleProduct.IT_Emitted_Ticket_Copies_Number__c);
            card_type = singleProduct.IT_Card_Type__c;
            web_enabling_level = singleProduct.IT_Web_Enabling_Level__c;
            flg_file_sending_authorization = singleProduct.IT_File_Sending_Authorization__c;
            flg_front_and_back_printout = singleProduct.IT_Front_and_Back_Printout__c;
            stock_orders = singleProduct.IT_Stock_Orders__c;
            graphic_layer_front = singleProduct.IT_Graphic_Layer_Front__c;
            graphic_layer_back = singleProduct.IT_Graphic_Layer_Back__c;
            graphic_background_front = singleProduct.IT_Graphic_Background_Front__c;
            graphic_background_back = singleProduct.IT_Graphic_Background_Back__c;
            envelope = singleProduct.IT_Envelope__c;
            user = user_AC;
            //validity_start_date = singleProduct.IT_Validity_Start_Date__c;
            validity_start_date = System.today();
            validity_end_date = singleProduct.IT_Validity_End_Date__c;
        }
    }

    public class documents{
        public String client_ref {get;set;}
        public String document_protocol {get;set;}
        public Integer document_progressive {get;set;}
        public String document_type {get;set;}
        public Date registration_date {get;set;}
        public Date scan_date {get;set;}
        public String barcode {get;set;}
        public String framework_barcode {get;set;}
        public String pdf_file {get;set;}
        public Boolean flg_send_email {get;set;}
        public String email {get;set;}
        public Date email_sending_date {get;set;}
        public String barcode_warrant {get;set;}
        public String service {get;set;}
        public String service_2 {get;set;}
        public String service_3 {get;set;}
        public String barcode_2 {get;set;}
        public String barcode_3 {get;set;}
        public String pdf_file_136 {get;set;}
        public Boolean flg_send_email_136 {get;set;}
        public String email_address_136 {get;set;}
        public Date email_sending_date_136 {get;set;}
        public String user_sender_136 {get;set;}
        public String user {get;set;}
        public documents(){
        }
        public documents(Contract singleContract, String user_AC){
            client_ref = singleContract.IT_Client_Code__c ;
            document_protocol = singleContract.IT_Document_Protocol__c ;
            if(singleContract.IT_Document_Progressive__c != null)
                document_progressive = Integer.valueOf(singleContract.IT_Document_Progressive__c);
            document_type = singleContract.IT_Document_Type__c ;
            registration_date = singleContract.IT_Registration_Date__c ;
            scan_date = singleContract.IT_Scan_Date__c ;
            barcode = singleContract.IT_Barcode__c ;
            framework_barcode = singleContract.IT_Framework_Barcode__c ;
            //pdf_file = singleContract. ;
            flg_send_email = singleContract.IT_Send_Email__c ;
            email = singleContract.IT_Email__c ;
            email_sending_date = singleContract.IT_Email_Sending_Date__c ;
            barcode_warrant = singleContract.IT_Barcode_Warrant__c ;
            service = singleContract.IT_Service__c ;
            service_2 = singleContract.IT_Service_2__c ;
            barcode_2 = singleContract.IT_Barcode_2__c ;
            service_3 = singleContract.IT_Service_3__c ;
            barcode_3 = singleContract.IT_Barcode_3__c ;
            //pdf_file_136 = singleContract. ;
            flg_send_email_136 = singleContract.IT_136_Send_Email__c ;
            email_address_136 = singleContract.IT_136_Email_Address__c ;
            email_sending_date_136 = singleContract.IT_136_Email_Sending_Data__c ;
            user_sender_136 = singleContract.IT_136_User_Sender__c ;
            user = user_AC;
        }
    }

    public class groups{
        public String group_ref {get;set;}
        public String group_type {get;set;}
        public String description {get;set;}
        public String master_client_ref {get;set;}
        public Boolean flg_forcing {get;set;}
        public String service {get;set;}
        public Decimal amount {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public groups(){
        }
        public groups(IT_Group__c singleGroupCode, String user_AC){
            group_ref = singleGroupCode.IT_Group_Code__c;
            group_type = singleGroupCode.IT_Group_Type__c;
            description = singleGroupCode.IT_Description__c;
            master_client_ref = singleGroupCode.IT_Financial_Center_Code__c;
            flg_forcing = singleGroupCode.IT_Forcing__c;
            service = singleGroupCode.IT_Service__c;
            amount = singleGroupCode.IT_Amount__c;
            user = user_AC;
            //start_date = singleGroupCode.IT_Validity_Start_Date__c;
            start_date = System.today();
            end_date = singleGroupCode.IT_Validity_End_Date__c;
        }
    }

    public class clients_group{
        public String group_ref {get;set;}
        public String group_type {get;set;}
        public String client_ref {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public clients_group(){
        }
        public clients_group(IT_Group_Code__c singleGroup, String user_AC){
            group_ref = singleGroup.IT_Group_Code__c;
            group_type = singleGroup.IT_Group_Type__c;
            client_ref = singleGroup.IT_Client_Code__c;
            user = user_AC;
            //start_date = singleGroup.IT_Validity_Start_Date__c;
            start_date = System.today();
            end_date = singleGroup.IT_Validity_End_Date__c;
        }
    }

    public class vats_group{
        public String vat_group {get;set;}
        public String naming {get;set;}
        public String pec {get;set;}
        public String sdi {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public vats_group(){
        }
        public vats_group(Account sinAcc, String user_AC){
            vat_group = sinAcc.IT_Group_VAT_Number__c;
            naming = sinAcc.IT_VAT_Group_Naming__c;
            pec = sinAcc.IT_VAT_Group_PEC__c;
            sdi = sinAcc.IT_VAT_Group_SDI__c;
            user = user_AC;
            //start_date = sinAcc.IT_Vat_Group_End_Date__c;
            start_date = System.today();
            end_date = sinAcc.IT_VAT_Group_End_Date__c;
        }
    }

    public class addresses{
        public String typology {get;set;}
        public String client_ref {get;set;}
        public String AC_activity {get;set;}
        public String SF_activity {get;set;}
        public Integer AC_delivery {get;set;}
        public Integer SF_delivery{get;set;}
        public String ticket_naming {get;set;}
        public String province {get;set;}
        public String toponym {get;set;}
        public String address {get;set;}
        public String short_address {get;set;}
        public String street_number {get;set;}
        public String postal_code {get;set;}
        public String city {get;set;}
        public String hamlet {get;set;}
        public String additional_locality {get;set;}
        public String city_ref {get;set;}
        public String hamlet_ref {get;set;}
        public String sestiere_ref {get;set;}
        public String street_ref {get;set;}
        public String road_arch_ref {get;set;}
        public Decimal metref_loc_x {get;set;}
        public Decimal metref_loc_y {get;set;}
        public Decimal georef_loc_x {get;set;}
        public Decimal georef_loc_y {get;set;}
        public String extra_urban_specifications {get;set;}
        public String zone {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public addresses(){
        }
        public addresses(Object sinObject, String objectType, String user_AC){
            if(objectType == 'ER_Financial_Center__c'){
                ER_Financial_Center__c FinCenterObj = new ER_Financial_Center__c();
                FinCenterObj = (ER_Financial_Center__c) sinObject;
                typology = 'F';
                client_ref = FinCenterObj.IT_Financial_Center__c;
                province = FinCenterObj.IT_Province__c;
                if(!String.isBlank(FinCenterObj.ER_Street__c) && FinCenterObj.ER_Street__c.contains(', '))
                    address = FinCenterObj.ER_Street__c.split(', ')[0];
                if(!String.isBlank(FinCenterObj.ER_Street__c) && FinCenterObj.ER_Street__c.contains(', '))
                    street_number = FinCenterObj.ER_Street__c.split(', ')[1];
                postal_code = FinCenterObj.ER_Zip_Code__c;
                city = FinCenterObj.ER_City__c;
                if(FinCenterObj.IT_GeoRef_Loc_X__c != null)
                    georef_loc_x = Decimal.valueOf(FinCenterObj.IT_GeoRef_Loc_X__c);
                if(FinCenterObj.IT_GeoRef_Loc_Y__c != null)
                    georef_loc_y = Decimal.valueOf(FinCenterObj.IT_GeoRef_Loc_Y__c);
                ticket_naming = FinCenterObj.IT_Ticket_Naming__c;
                toponym = FinCenterObj.IT_Toponym__c;
                short_address = FinCenterObj.IT_Short_Address__c;
                hamlet = FinCenterObj.IT_Hamlet__c;
                additional_locality = FinCenterObj.IT_Additional_Locality__c;
                city_ref = FinCenterObj.IT_City_Code__c;
                if(!String.isBlank(FinCenterObj.IT_Hamlet_Code__c) && FinCenterObj.IT_Hamlet_Code__c != '00000000000')
                    hamlet_ref = FinCenterObj.IT_Hamlet_Code__c;
                sestiere_ref = FinCenterObj.IT_Sestiere_Code__c;
                street_ref = FinCenterObj.IT_Street_Code__c;
                road_arch_ref = FinCenterObj.IT_Road_Arch_Code__c;
                if(FinCenterObj.IT_MetRef_Loc_X__c != null)
                    metref_loc_x = Decimal.valueOf(FinCenterObj.IT_MetRef_Loc_X__c);
                if(FinCenterObj.IT_MetRef_Loc_Y__c != null)
                    metref_loc_y = Decimal.valueOf(FinCenterObj.IT_MetRef_Loc_Y__c);    
                extra_urban_specifications = FinCenterObj.IT_Extra_Urban_Specifications__c;
                zone = FinCenterObj.IT_Zone__c;
                user = user_AC;
                //start_date = FinCenterObj.IT_Address_Validity_Start_Date__c;
                start_date = System.today();
                end_date = FinCenterObj.IT_Address_Validity_End_Date__c;    
            }else if(objectType == 'ER_Delivery_Site__c'){
                ER_Delivery_Site__c delSiteObj = new ER_Delivery_Site__c();
                delSiteObj = (ER_Delivery_Site__c) sinObject;
                typology = 'C';
                client_ref = delSiteObj.IT_Client_Code__c;
                if(delSiteObj.IT_Delivery_AC__c != null)
                    AC_delivery = Integer.valueOf(delSiteObj.IT_Delivery_AC__c);
                if(delSiteObj.IT_Delivery_SF__c != null)    
                    SF_delivery = Integer.valueOf(delSiteObj.IT_Delivery_SF__c);
                province = delSiteObj.IT_Province__c;
                if(!String.isBlank(delSiteObj.ER_Street__c) && delSiteObj.ER_Street__c.contains(', '))
                    address = delSiteObj.ER_Street__c.split(', ')[0];
                if(!String.isBlank(delSiteObj.ER_Street__c) && delSiteObj.ER_Street__c.contains(', '))
                    street_number = delSiteObj.ER_Street__c.split(', ')[1];
                postal_code = delSiteObj.ER_Zip_Code__c;
                city = delSiteObj.ER_City__c;
                if(delSiteObj.IT_GeoRef_Loc_X__c != null)
                    georef_loc_x = Decimal.valueOf(delSiteObj.IT_GeoRef_Loc_X__c);
                if(delSiteObj.IT_GeoRef_Loc_Y__c != null)
                    georef_loc_y = Decimal.valueOf(delSiteObj.IT_GeoRef_Loc_Y__c);
                ticket_naming = delSiteObj.IT_Ticket_Naming__c;
                toponym = delSiteObj.IT_Toponym__c;
                short_address = delSiteObj.IT_Short_Address__c;
                hamlet = delSiteObj.IT_Hamlet__c;
                additional_locality = delSiteObj.ER_Street_additionnal__c;
                city_ref = delSiteObj.IT_City_Code__c;
                if(!String.isBlank(delSiteObj.IT_Hamlet_Code__c) && delSiteObj.IT_Hamlet_Code__c != '00000000000')
                    hamlet_ref = delSiteObj.IT_Hamlet_Code__c;
                sestiere_ref = delSiteObj.IT_Sestiere_Code__c;
                street_ref = delSiteObj.IT_Street_Code__c;
                road_arch_ref = delSiteObj.IT_Road_Arch_Code__c;
                if(delSiteObj.IT_MetRef_Loc_X__c != null)
                    metref_loc_x = Decimal.valueOf(delSiteObj.IT_MetRef_Loc_X__c);
                if(delSiteObj.IT_MetRef_Loc_Y__c != null)
                    metref_loc_y = Decimal.valueOf(delSiteObj.IT_MetRef_Loc_Y__c); 
                extra_urban_specifications = delSiteObj.IT_Extra_Urban_Specifications__c;
                zone = delSiteObj.IT_Zone__c;
                user = user_AC;
                //start_date = delSiteObj.IT_Validity_Start_Date__c;
                start_date = System.today();
                end_date = delSiteObj.IT_Validity_End_Date__c;         
            }else if(objectType == 'ER_Distribution_Point__c'){
                ER_Distribution_Point__c disPointObj = new ER_Distribution_Point__c();
                disPointObj = (ER_Distribution_Point__c) sinObject;
                typology = 'AT';
                client_ref = disPointObj.IT_Client_Code__c;
                AC_activity = disPointObj.IT_AC_Activity__c;
                AC_activity = disPointObj.IT_AC_Activity__c;
                province = disPointObj.IT_Province__c;
                if(!String.isBlank(disPointObj.ER_Street__c) && disPointObj.ER_Street__c.contains(', '))
                    address = disPointObj.ER_Street__c.split(', ')[0];
                if(!String.isBlank(disPointObj.ER_Street__c) && disPointObj.ER_Street__c.contains(', '))
                    street_number = disPointObj.ER_Street__c.split(', ')[1];
                postal_code = disPointObj.ER_Zip_Code__c;
                city = disPointObj.ER_City__c;
                if(disPointObj.IT_GeoRef_Loc_X__c != null)
                    georef_loc_x = Decimal.valueOf(disPointObj.IT_GeoRef_Loc_X__c);
                if(disPointObj.IT_GeoRef_Loc_Y__c != null)
                    georef_loc_y = Decimal.valueOf(disPointObj.IT_GeoRef_Loc_Y__c);
                ticket_naming = disPointObj.IT_Ticket_Naming__c;
                toponym = disPointObj.IT_Toponym__c;
                short_address = disPointObj.IT_Short_Address__c;
                hamlet = disPointObj.IT_Hamlet__c;
                additional_locality = disPointObj.IT_Additional_Locality__c;
                city_ref = disPointObj.IT_City_Code__c;
                if(!String.isBlank(disPointObj.IT_Hamlet_Code__c) && disPointObj.IT_Hamlet_Code__c != '00000000000')
                    hamlet_ref = disPointObj.IT_Hamlet_Code__c;
                sestiere_ref = disPointObj.IT_Sestiere_Code__c;
                street_ref = disPointObj.IT_Street_Code__c;
                road_arch_ref = disPointObj.IT_Road_Arch_Code__c;
                if(disPointObj.IT_MetRef_Loc_X__c != null)
                    metref_loc_x = Decimal.valueOf(disPointObj.IT_MetRef_Loc_X__c);
                if(disPointObj.IT_MetRef_Loc_Y__c != null)
                    metref_loc_y = Decimal.valueOf(disPointObj.IT_MetRef_Loc_Y__c);  
                extra_urban_specifications = disPointObj.IT_Extra_Urban_Specifications__c;
                SF_activity = disPointObj.IT_SF_Activity__c;
                zone = disPointObj.IT_Zone__c;
                user = user_AC;
                //start_date = disPointObj.IT_Validity_Start_Date__c;
                start_date = System.today();
                end_date = disPointObj.IT_Validity_End_Date__c;  
            }
        }
    }

    public class conditions_change{
        public Integer payment_progressive {get;set;}
        public String client_ref {get;set;}
        public String sales_manager {get;set;}
        public String payment_ref {get;set;}
        public String reasons {get;set;}
        public String commission_type {get;set;}
        public Decimal commission_percentage {get;set;}
        public String discount_type {get;set;}
        public Decimal discount_percentage {get;set;}
        public String user_authorization_code {get;set;}
        public String request_status {get;set;}
        public Date request_date {get;set;}
        public Date accepted_request_date {get;set;}
        public Date start_date {get;set;}
        public String bank_account_code {get;set;}
        public String abi {get;set;}
        public String cab {get;set;}
        public String cc {get;set;}
        public String administrative_group {get;set;}
        public String statistic_group {get;set;}
        public String transport_cost {get;set;}
        public Boolean flg_transport_cost_presence {get;set;}
        public String no_cost_reason {get;set;}
        public String editing_reason {get;set;}
        public String contract_number {get;set;}
        public String attendance_type {get;set;}
        public String contract_type{get;set;}
        public Date expiration_contract_date {get;set;}
        public String contract_renewal_type {get;set;}
        public String applicant_user {get;set;}
        public Date authorization_date {get;set;}
        public String acceptance_user {get;set;}
        public Date registration_date {get;set;}
        public String registration_user {get;set;}
        public Boolean flg_printed_contract {get;set;}
        public Boolean flg_signed_contract {get;set;}
        public Boolean flg_forcing {get;set;}
        public String contractual_particularities {get;set;}
        public Boolean flg_no_massive_print {get;set;}
        public Date reopening_date {get;set;}
        public String opening {get;set;}
        public String opening_outcome {get;set;}
        public Integer employee_number {get;set;}
        public String order_frequence_type {get;set;}
        public String concurrency {get;set;}
        public Boolean flg_no_exclusivity {get;set;}
        public Boolean flg_extradiscount {get;set;}
        public Boolean flg_multidiscount {get;set;}
        public Decimal extradiscount_percentage {get;set;}
        public String extradiscount_type {get;set;}
        public Boolean flg_date_presence {get;set;}
        public Boolean flg_sdd_payment {get;set;}
        public Boolean flg_no_date_presence {get;set;}
        public String cig {get;set;}
        public Decimal discount_percentage_2 {get;set;}
        public Date discount_validity_date_2 {get;set;}
        public Decimal discount_percentage_3  {get;set;}
        public Date discount_validity_date_3 {get;set;}
        public Boolean flg_penal_presence {get;set;}
        public String delivery_date_bond {get;set;}
        public Integer delivery_term {get;set;}
        public String term_type {get;set;}
        public Integer delivery_fixed_day {get;set;}
        public String fixed_day_type {get;set;}
        public Integer order_reception_term {get;set;}
        public String order_reception_term_type {get;set;}
        public String sdd_payment_code {get;set;}
        public String cin {get;set;}
        public String country {get;set;}
        public String check_iban {get;set;}
        public String sdd_contract_code {get;set;}
        public String sdd_fiscal_code {get;set;}
        public String authorized {get;set;}
        public Date sdd_subscription_date {get;set;}
        public Integer contract_progressive {get;set;}
        public Boolean flg_not_send_contract {get;set;}
        public Boolean flg_company_name_change {get;set;}
        public String billing_company_name {get;set;}
        public String short_company_name {get;set;}
        public String extended_company_name {get;set;}
        public String province {get;set;}
        public String toponym {get;set;}
        public String address {get;set;}
        public String short_address {get;set;}
        public String street_number {get;set;}
        public String city {get;set;}
        public String additional_locality {get;set;}
        public String postal_code {get;set;}
        public Long municipality_ref {get;set;}
        public Long hamlet_ref {get;set;}
        public String hamlet {get;set;}
        public Long district_ref {get;set;}
        public Long street_ref {get;set;}
        public Long road_arch_ref {get;set;}
        public Boolean flg_no_sign_activation_authorization {get;set;}
        public Boolean flg_address_change {get;set;}
        public String fax {get;set;}
        public String head_framework_ref {get;set;}
        public String opportunity_code {get;set;}
        public String new_client {get;set;}
        public String new_service {get;set;}
        public Date campaign_start_date {get;set;}
        public Date campaign_end_date {get;set;}
        public Boolean flg_only_client_copy {get;set;}
        public Decimal card_cost {get;set;}
        public Boolean flg_standard_master_data {get;set;}
        public Boolean flg_supply_conditions {get;set;}
        public Boolean flg_framework_warrant {get;set;}
        public String extra_urban_specifications {get;set;}
        public Integer uta_vehicles_number {get;set;}
        public Decimal uta_monthly_limit {get;set;}
        public String uta_offer_type {get;set;}
        public Decimal flexben_startup_cost {get;set;}
        public Decimal flexben_fee_cost {get;set;}
        public String flexben_fee_frequency {get;set;}
        public String billing_frequency {get;set;}
        public Integer bond {get;set;}
        public String beneficiary_type {get;set;}
        public String user {get;set;}
        public String new_vat_number {get;set;}
        public String new_fiscal_code {get;set;}
        public String new_legal_name {get;set;}
        public String new_legal_form {get;set;}
        public String new_local_client_segmentation {get;set;}
        public Boolean flg_new_split_payment {get;set;}
        public String new_unique_office_code {get;set;}
        public String new_sdi {get;set;}
        public Integer new_employees_number {get;set;}
        public Integer new_signatures_number {get;set;}
        public String new_beneficiary_type {get;set;}
        public String new_zone {get;set;}
        public String new_sales_manager {get;set;}
        public Boolean flg_new_institution {get;set;}
        public String new_industry {get;set;}
        public String new_province {get;set;}
        public String new_city {get;set;}
        public String new_additional_locality {get;set;}
        public String new_toponym {get;set;}
        public String new_address {get;set;}
        public String new_street_number {get;set;}
        public String new_postal_code {get;set;}
        public String new_opening_type {get;set;}
        public String new_concurrency {get;set;}
        public String new_phone {get;set;}
        public String new_fax {get;set;}
        public String new_mail {get;set;}
        public String new_pec_mail {get;set;}
        public String new_billing_pec_mail {get;set;}
        public conditions_change(){
        }
        public conditions_change(IT_Request__c singleRequest, String user_AC){
            if(singleRequest.IT_Payment_Progressive_Number__c != null)
                payment_progressive = Integer.valueOf(singleRequest.IT_Payment_Progressive_Number__c);
            client_ref = singleRequest.IT_Client_Code__c;
            sales_manager = singleRequest.IT_Sales_Manager__c;
            payment_ref = singleRequest.IT_Payment_Code__c;
            reasons = singleRequest.IT_Reason__c;
            commission_type = singleRequest.IT_Commission_Type__c;
            commission_percentage = singleRequest.IT_Commission_Percentage__c;
            discount_type = singleRequest.IT_Discount_Type__c;
            discount_percentage = singleRequest.IT_Discount_Percentage__c;
            user_authorization_code = singleRequest.IT_User_Authorization_Code__c;
            request_status = singleRequest.IT_Request_Status__c;
            request_date = singleRequest.IT_Request_Date__c;
            accepted_request_date = singleRequest.IT_Accepted_Request_Date__c;
            start_date = singleRequest.IT_Contract_Start_Date__c;
            //start_date = System.today();
            bank_account_code = singleRequest.IT_Bank_Account_Code__c;
            abi = singleRequest.IT_ABI__c;
            cab = singleRequest.IT_CAB__c;
            cc = singleRequest.IT_CC__c;
            administrative_group = singleRequest.IT_Administrative_Group__c;
            statistic_group = singleRequest.IT_Statistic_Group__c;
            transport_cost = singleRequest.IT_Transport_Cost__c;
            flg_transport_cost_presence = singleRequest.IT_Transport_Cost_Presence__c;
            no_cost_reason = singleRequest.IT_No_Cost_Reason__c;
            editing_reason = singleRequest.IT_Editing_Reason__c;
            contract_number = singleRequest.IT_Contract_Number__c;
            attendance_type = singleRequest.IT_Attendance_Type__c;
            contract_type = singleRequest.IT_Contract_Type__c;
            expiration_contract_date = singleRequest.IT_Expiration_Contract_Date__c;
            contract_renewal_type = singleRequest.IT_Contract_Renewal_Type__c;
            applicant_user = singleRequest.IT_Applicant_User__c;
            authorization_date = singleRequest.IT_Authorization_Date__c;
            acceptance_user = singleRequest.IT_Acceptance_User__c;
            registration_date = singleRequest.IT_Registration_Date__c;
            registration_user = singleRequest.IT_Registration_User__c;
            flg_printed_contract = singleRequest.IT_Printed_Contract__c;
            flg_signed_contract = singleRequest.IT_Signed_Contract__c;
            flg_forcing = singleRequest.IT_Forcing__c;
            contractual_particularities = singleRequest.IT_Contractual_Particularities__c;
            flg_no_massive_print = singleRequest.IT_No_Massive_Print__c;
            reopening_date = singleRequest.IT_Reopening_Date__c;
            opening = singleRequest.IT_Opening_Outcome__c;
            opening_outcome = singleRequest.IT_Opening__c;
            if(singleRequest.IT_Employee_Number__c != null)
                employee_number = Integer.valueOf(singleRequest.IT_Employee_Number__c);
            order_frequence_type = singleRequest.IT_Order_Frequence_Type__c;
            concurrency = singleRequest.IT_Concurrency__c;
            flg_no_exclusivity = singleRequest.IT_No_Exclusivity__c;
            flg_extradiscount = singleRequest.IT_Extradiscount__c;
            flg_multidiscount = singleRequest.IT_Multidiscount__c;
            extradiscount_percentage = singleRequest.IT_Extradiscount_Percentage__c;
            extradiscount_type = singleRequest.IT_Type_Extradiscount__c;
            flg_date_presence = singleRequest.IT_Date_presence__c;
            flg_sdd_payment = singleRequest.IT_SDD_Payment__c;
            flg_no_date_presence = singleRequest.IT_No_Date_presence__c;
            cig = singleRequest.IT_CIG__c;
            discount_percentage_2 = singleRequest.IT_Discount_Percentage_2__c;
            discount_validity_date_2 = singleRequest.IT_Discount_Validity_Date_2__c;
            discount_percentage_3  = singleRequest.IT_Discount_Percentage_3__c;
            discount_validity_date_3 = singleRequest.IT_Discount_Validity_Date_3__c;
            flg_penal_presence = singleRequest.IT_Penal_Presence__c;
            delivery_date_bond = singleRequest.IT_Delivery_Date_Bond__c;
            if(singleRequest.IT_Delivery_Term__c != null)
                delivery_term = Integer.valueOf(singleRequest.IT_Delivery_Term__c);
            term_type = singleRequest.IT_Term_Type__c;
            if(singleRequest.IT_Delivery_Fixed_Day__c != null)
                delivery_fixed_day = Integer.valueOf(singleRequest.IT_Delivery_Fixed_Day__c);
            fixed_day_type = singleRequest.IT_Fixed_Day_Type__c;
            if(singleRequest.IT_Order_Reception_Term__c != null)
                order_reception_term = Integer.valueOf(singleRequest.IT_Order_Reception_Term__c);
            order_reception_term_type = singleRequest.IT_Order_Reception_Term_Type__c;
            sdd_payment_code = singleRequest.IT_SDD_Payment_Code__c;
            cin = singleRequest.IT_CIN__c;
            country = singleRequest.IT_Country__c;
            check_iban = singleRequest.IT_Check_Iban__c;
            sdd_contract_code = singleRequest.IT_SDD_Contract_Code__c;
            sdd_fiscal_code = singleRequest.IT_SDD_Fiscal_Code__c;
            authorized = singleRequest.IT_SDD_Authorized__c;
            sdd_subscription_date = singleRequest.IT_SDD_Subscription_Date__c;
            if(singleRequest.IT_Contract_Progressive__c != null)
                contract_progressive = Integer.valueOf(singleRequest.IT_Contract_Progressive__c);
            flg_not_send_contract = singleRequest.IT_Not_Send_Contract__c;
            flg_company_name_change = singleRequest.IT_Company_Name_Change__c;
            if(!String.isBlank(singleRequest.IT_Billing_Company_Name_R3__c))
                billing_company_name = singleRequest.IT_Billing_Company_Name_R1__c+' '+singleRequest.IT_Billing_Company_Name_R2__c+' '+singleRequest.IT_Billing_Company_Name_R3__c;
            else if(!String.isBlank(singleRequest.IT_Billing_Company_Name_R2__c))
                billing_company_name = singleRequest.IT_Billing_Company_Name_R1__c+' '+singleRequest.IT_Billing_Company_Name_R2__c;
            else 
                billing_company_name = singleRequest.IT_Billing_Company_Name_R1__c;
                
            short_company_name = singleRequest.IT_Short_Company_Name__c;
            extended_company_name = singleRequest.IT_Extended_Company_Name__c;
            province = singleRequest.IT_Province__c;
            toponym = singleRequest.IT_Toponym__c;
            address = singleRequest.IT_Street__c;
            short_address = singleRequest.IT_Short_Address__c;
            street_number = singleRequest.IT_Street_Number__c;
            city = singleRequest.IT_City__c;
            additional_locality = singleRequest.IT_Additional_Locality__c;
            postal_code = singleRequest.IT_Postal_Code__c;
            if(singleRequest.IT_Municipality_Code__c != null)
                municipality_ref = Long.valueOf(String.valueOf(singleRequest.IT_Municipality_Code__c));
            if(singleRequest.IT_Hamlet_Code__c != null)    
                hamlet_ref = Long.valueOf(String.valueOf(singleRequest.IT_Hamlet_Code__c));
            hamlet = singleRequest.IT_Hamlet__c;
            if(singleRequest.IT_Sestiere_Code__c != null)
                district_ref = Long.valueOf(String.valueOf(singleRequest.IT_Sestiere_Code__c));
            if(singleRequest.IT_Street_Code__c != null)    
                street_ref = long.valueOf(String.valueOf(singleRequest.IT_Street_Code__c));
            if(singleRequest.IT_Road_Arch_Code__c != null)    
                road_arch_ref = Long.valueOf(String.valueOf(singleRequest.IT_Road_Arch_Code__c));
            flg_no_sign_activation_authorization = singleRequest.IT_No_Sign_Activation_Authorization__c;
            flg_address_change = singleRequest.IT_Address_Change__c;
            fax = singleRequest.IT_Fax__c;
            head_framework_ref = singleRequest.IT_Framework_Head_Code__c;
            opportunity_code = singleRequest.IT_Opportunity_Code__c;
            new_client = singleRequest.IT_New_Client__c;
            new_service = singleRequest.IT_New_Service__c;
            campaign_start_date = singleRequest.IT_Campaign_Start_Date__c;
            campaign_end_date = singleRequest.IT_Campaign_End_Date__c;
            flg_only_client_copy = singleRequest.IT_Only_Client_Copy__c;
            card_cost = singleRequest.IT_Card_Cost__c;
            flg_standard_master_data = singleRequest.IT_Framework_Warrant__c;
            flg_supply_conditions = singleRequest.IT_Supply_Conditions__c;
            flg_framework_warrant = singleRequest.IT_Framework_Warrant__c;
            extra_urban_specifications = singleRequest.IT_Extra_Urban_Specifications__c;
            if(singleRequest.IT_UTA_Vehicles_Number__c != null)
                uta_vehicles_number = Integer.valueOf(singleRequest.IT_UTA_Vehicles_Number__c);
            uta_monthly_limit = singleRequest.IT_UTA_Monthly_Limit__c;
            uta_offer_type = singleRequest.IT_UTA_Offer_Type__c;
            flexben_startup_cost = singleRequest.IT_Flexben_Startup_Cost__c;
            flexben_fee_cost = singleRequest.IT_Flexben_Fee_Cost__c;
            flexben_fee_frequency = singleRequest.IT_Flexben_Fee_Frequency__c;
            billing_frequency = singleRequest.IT_Card_Cost_Billing_Frequency__c;
            if(singleRequest.IT_Bond__c != null)
                bond = Integer.valueOf(singleRequest.IT_Bond__c);
            beneficiary_type = singleRequest.IT_Beneficiary_Type__c;
            user = user_AC;
            new_vat_number = singleRequest.IT_New_VAT_Number__c;
            new_fiscal_code = singleRequest.IT_New_Fiscal_Code__c;
            new_legal_name = singleRequest.IT_New_Legal_Name__c;
            new_legal_form = singleRequest.IT_New_Legal_Form__c;
            new_local_client_segmentation = singleRequest.IT_New_Local_Client_Segmentation__c;
            flg_new_split_payment = singleRequest.IT_New_Split_Payment__c;
            new_unique_office_code = singleRequest.IT_New_Unique_Office_Code__c;
            new_sdi = singleRequest.IT_New_SDI__c;
            if(singleRequest.IT_New_Employees_Number__c != null)
                new_employees_number = Integer.valueOf(singleRequest.IT_New_Employees_Number__c);
            if(singleRequest.IT_New_Signatures_Number__c != null)    
                new_signatures_number = Integer.valueOf(singleRequest.IT_New_Signatures_Number__c);
            new_beneficiary_type = singleRequest.IT_New_Beneficiary_Type__c;
            new_zone = singleRequest.IT_New_Zone__c;
            new_sales_manager = singleRequest.IT_New_Sales_Manager__c;
            flg_new_institution = singleRequest.IT_New_Institution_Flag__c;
            new_industry = singleRequest.IT_New_Industry__c;
            new_province = singleRequest.IT_New_State__c;
            new_city = singleRequest.IT_New_City__c;
            new_additional_locality = singleRequest.IT_New_Additional_Locality__c;
            new_toponym = singleRequest.IT_New_Toponym__c;
            new_address = singleRequest.IT_New_Street__c;
            new_street_number = singleRequest.IT_New_Street_Number__c;
            new_postal_code = singleRequest.IT_New_Postal_Code__c;
            new_opening_type = singleRequest.IT_New_Opening_Type__c;
            new_concurrency = singleRequest.IT_New_Concurrency__c;
            new_phone = singleRequest.IT_New_Phone__c;
            new_fax = singleRequest.IT_New_Fax__c;
            new_mail = singleRequest.IT_New_Mail__c;
            new_pec_mail = singleRequest.IT_New_PEC_Mail__c;
            new_billing_pec_mail = singleRequest.IT_New_Billing_PEC_Mail__c;   
        }
    }

    public class contacts{
        public String code {get;set;}
        public String last_name {get;set;}
        public String first_name {get;set;}
        public String phone {get;set;}
        public String fax {get;set;}
        public String email {get;set;}
        public String pec {get;set;}
        public String type {get;set;}
        public Boolean flg_makes_orders {get;set;}
        public Boolean flg_receipts_ticket {get;set;}
        public Boolean flg_recepits_client_billing {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public Integer contact_progressive {get;set;}
        public contacts(){
        }
        public contacts(Contact sinContactAss, String user_AC){            
            code = sinContactAss.IT_Code__c;
            last_name = sinContactAss.LastName;
            first_name = sinContactAss.FirstName;
            phone = sinContactAss.Phone;
            fax = sinContactAss.Fax;
            email = sinContactAss.Email;
            pec = sinContactAss.IT_PEC__c;
            type = sinContactAss.IT_Type__c;
            flg_makes_orders = sinContactAss.IT_Order_Making__c;
            flg_receipts_ticket = sinContactAss.IT_Ticket_Receipts__c;
            flg_recepits_client_billing = sinContactAss.IT_Client_Billing_Recepits__c;
            user = user_AC;
            //start_date = sinContactAss.IT_Validity_Start_Date__c;
            start_date = System.today();
            end_date = sinContactAss.IT_Validity_End_Date__c;
            if(sinContactAss.IT_Referent_Progressive__c != null)
                contact_progressive = Integer.valueOf(sinContactAss.IT_Referent_Progressive__c);   
        }
        public contacts(IT_Contact_Association__c sinAss, String user_AC){
            if(!String.isBlank(sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Type__c) && sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Type__c == 'Soc'){
                code = 'AC'+sinAss.IT_Client_Code__c;
                type = 'Cli';
            }else{
                code = sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Code__c;
                type = sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Type__c;
            }    
            last_name = sinAss.IT_Contact_Detail__r.IT_Contact__r.LastName;
            first_name = sinAss.IT_Contact_Detail__r.IT_Contact__r.FirstName;
            phone = sinAss.IT_Contact_Detail__r.IT_Contact__r.Phone;
            fax = sinAss.IT_Contact_Detail__r.IT_Contact__r.Fax;
            email = sinAss.IT_Contact_Detail__r.IT_Contact__r.Email;
            pec = sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_PEC__c;
            flg_makes_orders = sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Order_Making__c;
            flg_receipts_ticket = sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Ticket_Receipts__c;
            flg_recepits_client_billing = sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Client_Billing_Recepits__c;
            user = user_AC;
            //start_date = sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Validity_Start_Date__c;
            start_date = System.today();
            end_date = sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Validity_End_Date__c;
            if(sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Referent_Progressive__c != null)
                contact_progressive = Integer.valueOf(sinAss.IT_Contact_Detail__r.IT_Contact__r.IT_Referent_Progressive__c);    
        }
    }

    public class additional_expenses{
        public Integer progressive {get;set;}
        public String client_ref {get;set;}
        public String code {get;set;}
        public Decimal amount {get;set;}
        public String calculation_type {get;set;}
        public String user {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public additional_expenses(){
        }
        public additional_expenses(IT_Additional_Expenses__c sinAddExp, String user_AC){
            if(sinAddExp.IT_Progressive__c != null)
                progressive = Integer.valueOf(sinAddExp.IT_Progressive__c);
            else {
                List<ER_Financial_Center__c> fcList = [Select Id, (Select Id, IT_Progressive__c From Additional_Expenses__r Order by IT_Progressive__c desc NULLS LAST) From ER_Financial_Center__c Where Id =: sinAddExp.IT_Financial_Center__c];    
                System.debug('fcList:: '+fcList);
                if(fcList != null && fcList.size() > 0 && fcList[0].Additional_Expenses__r != null && fcList[0].Additional_Expenses__r.size() > 1)
                    progressive = Integer.valueOf(fcList[0].Additional_Expenses__r[0].IT_Progressive__c) + 1;
                else
                    progressive = 1;

                APIT11_Utilities.updateAddExp(sinAddExp.Id, progressive);    
            }    
            client_ref = sinAddExp.IT_Financial_Center__r.IT_Financial_Center__c;
            code = sinAddExp.IT_Code__c;
            amount = sinAddExp.IT_Amount__c;
            calculation_type = sinAddExp.IT_Calculation_Type__c; 
            user = user_AC; 
            start_date = System.today();
            end_date = sinAddExp.IT_Validity_End_Date__c;   
        }
    }

    public class notes{
        public Integer progressive {get;set;}
        public String client_ref {get;set;}
        public String ac_activity {get;set;}
        public String sf_activity {get;set;}
        public Integer ac_delivery {get;set;}
        public Integer sf_delivery {get;set;}
        public String note_type {get;set;}
        public String title {get;set;}
        public String text_notes {get;set;}
        public Date start_date {get;set;}
        public Date end_date {get;set;}
        public String user {get;set;}
        public notes(){
        }
        public notes(IT_Note__c sinNote, String user_AC){
            if(sinNote.IT_Progressive__c != null)
                progressive = Integer.valueOf(sinNote.IT_Progressive__c);
            else {
                List<ER_Financial_Center__c> fcList = [Select Id, (Select Id, IT_Progressive__c From Note__r Order by IT_Progressive__c desc NULLS LAST) From ER_Financial_Center__c Where IT_Financial_Center__c =: sinNote.IT_Delivery_Site__r.IT_Client_Code__c];    
                System.debug('fcList:: '+fcList);
                if(fcList[0].Note__r != null && fcList[0].Note__r.size() > 1)
                    progressive = Integer.valueOf(fcList[0].Note__r[0].IT_Progressive__c) + 1;
                else
                    progressive = 1;

                APIT11_Utilities.updateNote(sinNote.Id, progressive, fcList[0].Id);    
            }    
            if(sinNote.IT_Financial_Center__c != null)    
                client_ref = sinNote.IT_Financial_Center__r.IT_Financial_Center__c;
            else if(sinNote.IT_Delivery_Site__c != null)
                client_ref = sinNote.IT_Delivery_Site__r.IT_Client_Code__c;    
            ac_activity = sinNote.IT_AC_Activity__c;
            sf_activity = sinNote.IT_SF_Activity__c;
            if(sinNote.IT_Delivery_Site__r.IT_Delivery_AC__c != null)    
                ac_delivery = Integer.valueOf(sinNote.IT_Delivery_Site__r.IT_Delivery_AC__c); 
            if(sinNote.IT_Delivery_Site__r.IT_Delivery_SF__c != null)    
                sf_delivery = Integer.valueOf(sinNote.IT_Delivery_Site__r.IT_Delivery_SF__c);
            note_type = sinNote.IT_Note_Type__c;
            title = sinNote.Name; 
            text_notes = sinNote.IT_Text_Notes__c; 
            start_date = System.today();
            end_date = sinNote.IT_Validity_End_Date__c;
            user = user_AC;   
        }
    }   
    
    @InvocableMethod(label='Call Distribution Point Request' description='Calls the APIT12 method callDistPointRequest')
    public static void callDistPointRequest (list<flowVars> flvrs){
        //screateRequestDistributionPoint(flvrs[0].flowDistPoints , flvrs[0].flowDelSites, 'Insert', null);
        System.debug('flvrs::: '+flvrs);
        if(flvrs[0].flowString != null)
            createRequestDistributionPoint(flvrs[0].flowDistPoints , flvrs[0].flowDelSites , flvrs[0].flowString[0], 'Insert', null);
        else
            createRequestDistributionPoint(flvrs[0].flowDistPoints , flvrs[0].flowDelSites , null, 'Insert', null);
    }
    
    global class flowVars{
        @invocablevariable
        global List<ER_Delivery_Site__c> flowDelSites;
        @invocablevariable
        global List<ER_Distribution_Point__c> flowDistPoints; 
        @invocablevariable
        global List<String> flowString;
    }
        
    
}