public without sharing class APIT11_Utilities {

    public static String saveAttachmentContract(Map<String, String> bodyAttachment, String ObjectId, String clientCode, Set<String> namesAttachment){ 
        try{
            List<Attachment> newListAtt = new List<Attachment>();
            for(String singleBody : bodyAttachment.keyset()){
                Blob attachmentBody = encodingUtil.base64Decode(bodyAttachment.get(singleBody));
                Attachment attachment = new Attachment();
                attachment.Body = attachmentBody;
                attachment.Name = singleBody+'.pdf';
                attachment.ParentId = ObjectId;
                attachment.ContentType = 'application/pdf';
                if(!namesAttachment.contains(singleBody+'.pdf')) 
                    newListAtt.add(attachment);    
            }
            if(newListAtt != null && newListAtt.size() > 0) 
                insert newListAtt; 

            return 'Insert OK';
        }catch(Exception ecc){
            System.debug('saveAttachmentContract: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            return clientCode + ecc.getMessage();
        }           
    }

    public static Sobject FutureChange (Map<Id, SObject> listSobj,  String typeObjMethod, String updateNameField){
        List<SObject> sObjectsToUpdate = new List<SObject>();
        SObject futureUpdate = null;
        for (Id toUpdate : listSobj.Keyset()) {
            futureUpdate = listSobj.get(toUpdate);
            System.debug('futureUpdate::::::: '+futureUpdate);
            Map<String, Object> fieldsToValue = futureUpdate.getPopulatedFieldsAsMap();
            string fields = '';

            for(string singleField : fieldsToValue.keyset()){
                if(singleField != updateNameField){
                    if(null != futureUpdate.get(singleField)){
                        fields += singleField + ' : ' + fieldsToValue.get(singleField) + '\n'; 
                    }    
                }    
            }
            futureUpdate.put(updateNameField, fields);
        } 
        return futureUpdate;
    }
    
    public static String saveChangeCondition(List<IT_Request__c> listRequest, Map<String, ER_Financial_Center__c> listFC, Map<String, List<Contract>> mapContractOld){
        ER_Financial_Center__c upsertFC = new ER_Financial_Center__c();
        ER_Financial_Center__c upsertFCControl = new ER_Financial_Center__c();
        String returnConditionChange = 'StartConditionChange'; 
        try{
            for(IT_Request__c singleRequest : listRequest){
                if(!String.isBlank(singleRequest.IT_New_Service__c) || !String.isBlank(singleRequest.IT_New_VAT_Number__c)){
                    upsertFC = populateFinancialCenter(listFC, singleRequest, false, null);       
                }else{
                    if(singleRequest.IT_Contract_Start_Date__c <= System.today()){
                        upsertFC = populateFinancialCenter(listFC, singleRequest, true, mapContractOld);
                        if(upsertFC != null && upsertFC != upsertFCControl) 
                            returnConditionChange = 'ConditionChangeOK';
                    }else{ 
                        populateFinancialCenterFuture(listFC, singleRequest, mapContractOld); 
                        returnConditionChange = 'ConditionChangeOK';
                    }          
                }    
            }
             
            return returnConditionChange;   
        }catch(Exception ecc){
            System.debug('Error saveChangeCondition: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            returnConditionChange = 'ConditionChangeKO';
            return returnConditionChange;
        }
    }

    @Future(callout = true)
    public static void catchRequest (String idErrorRequest){
        list<IT_Request__c> requestError = [Select Id, IT_Request_Status__c From IT_Request__c Where Id =: idErrorRequest];
        if(requestError != null && requestError.size() > 0){
            IT_Request__c updateRequest = new IT_Request__c(Id = requestError[0].Id);
            updateRequest.IT_Request_Status__c = '2';
            update updateRequest;
        }
    }

    private static ER_Financial_Center__c populateFinancialCenter(Map<String, ER_Financial_Center__c> mapFinCen, IT_Request__c requestObj, Boolean updateBool, Map<String, List<Contract>> mapOldContract){
        ER_Financial_Center__c upsertFCMethod = new ER_Financial_Center__c();
        ER_Bank_Account__c upsertBAMethod = new ER_Bank_Account__c();
        Contract upsertContractMethod = new Contract();
        List<Contract> sendContractOld = new List<Contract>();

        Contract upsertContractError = new Contract();
        upsertContractError = mapOldContract.get(requestObj.IT_Client_Code__c)[0];
        List<Contract> upsertContractErrorList = new List<Contract>();
        upsertContractErrorList.add(upsertContractError);
        System.debug('upsertContractErrorList::: '+upsertContractErrorList);

        Savepoint sp = Database.setSavepoint();
        System.debug('mapFinCen::: '+mapFinCen);
        try{
            if(mapFinCen != null && mapFinCen.size() > 0 && mapFinCen.Keyset().contains(requestObj.IT_Client_Code__c) && updateBool){
                upsertFCMethod = new ER_Financial_Center__c(Id = mapFinCen.get(requestObj.IT_Client_Code__c).Id);

                upsertFCMethod.IT_Contractual_Particularities__c = requestObj.IT_Contractual_Particularities__c;   
                upsertFCMethod.IT_Beneficiary_Type__c = requestObj.IT_Beneficiary_Type__c;
                upsertFCMethod.IT_Employee_Number__c = requestObj.IT_Employee_Number__c;
                upsertFCMethod.IT_Concurrency__c = requestObj.IT_Concurrency__c;
                upsertFCMethod.IT_CIG__c = requestObj.IT_CIG__c;
                upsertFCMethod.IT_Opening_Outcome__c = requestObj.IT_Opening_Outcome__c;
                upsertFCMethod.IT_Short_Name__c = requestObj.IT_Short_Company_Name__c;
                upsertFCMethod.IT_Extended_Company_Name__c = requestObj.IT_Extended_Company_Name__c;
                upsertFCMethod.IT_Province__c = requestObj.IT_Province__c;
                upsertFCMethod.IT_Toponym__c = requestObj.IT_Toponym__c;
                upsertFCMethod.IT_Short_Address__c = requestObj.IT_Short_Address__c;
                upsertFCMethod.ER_Street__c = requestObj.IT_Street__c;
                upsertFCMethod.ER_City__c = requestObj.IT_City__c;
                upsertFCMethod.IT_Additional_Locality__c = requestObj.IT_Additional_Locality__c;
                upsertFCMethod.ER_Zip_Code__c = requestObj.IT_Postal_Code__c;
                if(requestObj.IT_Municipality_Code__c != null)
                    upsertFCMethod.IT_City_Code__c = String.valueOf(requestObj.IT_Municipality_Code__c);
                if(requestObj.IT_Hamlet_Code__c != null)
                    upsertFCMethod.IT_Hamlet_Code__c = String.valueOf(requestObj.IT_Hamlet_Code__c);    
                upsertFCMethod.IT_Hamlet__c = requestObj.IT_Hamlet__c;
                if(requestObj.IT_Sestiere_Code__c != null)
                    upsertFCMethod.IT_Sestiere_Code__c = String.valueOf(requestObj.IT_Sestiere_Code__c);
                if(requestObj.IT_Street_Code__c != null)    
                    upsertFCMethod.IT_Street_Code__c = String.valueOf(requestObj.IT_Street_Code__c);
                if(requestObj.IT_Road_Arch_Code__c != null)    
                    upsertFCMethod.IT_Road_Arch_Code__c = String.valueOf(requestObj.IT_Road_Arch_Code__c);
                upsertFCMethod.IT_Extra_Urban_Specifications__c = requestObj.IT_Extra_Urban_Specifications__c;
                upsertFCMethod.IT_Contact_Code__c = requestObj.IT_Sales_Manager__c;

                //Skip
                if(mapFinCen.get(requestObj.IT_Client_Code__c).IT_SkipActivation__c)
                    upsertFCMethod.IT_SkipActivation__c = false;
                else
                    upsertFCMethod.IT_SkipActivation__c = true; 

                //Skip
                if(mapFinCen.get(requestObj.IT_Client_Code__c).IT_Confirm_Flow__c)
                    upsertFCMethod.IT_Confirm_Flow__c = false;
                else
                    upsertFCMethod.IT_Confirm_Flow__c = true;        

                System.debug('mapFinCen.get(requestObj.IT_Client_Code__c).ER_Bank_Account__c::: '+mapFinCen.get(requestObj.IT_Client_Code__c).ER_Bank_Account__c);

                if(!String.isBlank(mapFinCen.get(requestObj.IT_Client_Code__c).ER_Bank_Account__c)){
                    upsertBAMethod = new ER_Bank_Account__c (Id = mapFinCen.get(requestObj.IT_Client_Code__c).ER_Bank_Account__c);
                    upsertBAMethod.IT_Payment_Code__c =  requestObj.IT_Payment_Code__c;
                    upsertBAMethod.IT_SDD_Payment_Code__c =  requestObj.IT_SDD_Payment_Code__c;
                    upsertBAMethod.IT_CIN__c = requestObj.IT_CIN__c;
                    upsertBAMethod.ER_Country__c = requestObj.IT_Country__c;
                    upsertBAMethod.IT_Check_Iban__c  = requestObj.IT_Check_Iban__c ;
                    upsertBAMethod.IT_SDD_Contract_Code__c = requestObj.IT_SDD_Contract_Code__c;
                    upsertBAMethod.IT_SDD_Fiscal_Code__c = requestObj.IT_SDD_Fiscal_Code__c;
                    //upsertBAMethod.IT_Authorized__c = requestObj.IT_Authorized__c;
                    upsertBAMethod.IT_SDD_Authorized__c = requestObj.IT_SDD_Authorized__c;
                    upsertBAMethod.IT_SDD_Subscription_Date__c = requestObj.IT_SDD_Subscription_Date__c;
                    upsertBAMethod.IT_CC__c = requestObj.IT_CC__c;
                    upsertBAMethod.IT_Bank_Account_Code__c = requestObj.IT_Bank_Account_Code__c;
                    upsertBAMethod.IT_ABI__c = requestObj.IT_ABI__c;
                    upsertBAMethod.IT_CAB__c = requestObj.IT_CAB__c;

                    //Skip
                    if(mapFinCen.get(requestObj.IT_Client_Code__c).IT_SkipActivation__c)
                        upsertBAMethod.IT_SkipActivation__c = false;
                    else
                        upsertBAMethod.IT_SkipActivation__c = true;

                    System.debug('upsertBAMethod::: '+upsertBAMethod);
                    update upsertBAMethod;
                }

                System.debug('mapFinCen.get(requestObj.IT_Client_Code__c).IT_Contract__c::: '+mapFinCen.get(requestObj.IT_Client_Code__c).IT_Contract__c);

                //Contract
                upsertContractMethod.IT_Commission_Type__c = requestObj.IT_Commission_Type__c;
                upsertContractMethod.IT_Commission_Percentage__c = requestObj.IT_Commission_Percentage__c;
                upsertContractMethod.IT_Discount_Type__c = requestObj.IT_Discount_Type__c;
                upsertContractMethod.IT_Discount_Percentage__c = requestObj.IT_Discount_Percentage__c ;
                upsertContractMethod.IT_Validity_Start_Date_EC__c = requestObj.IT_Contract_Start_Date__c;
                upsertContractMethod.StartDate = requestObj.IT_Contract_Start_Date__c;
                upsertContractMethod.IT_No_Cost_Reason__c = requestObj.IT_No_Cost_Reason__c;
                upsertContractMethod.IT_Fixed_Day_Type__c = requestObj.IT_Fixed_Day_Type__c;
                upsertContractMethod.IT_Order_Reception_Term_Type__c = requestObj.IT_Order_Reception_Term_Type__c;

                //EconomicicCondidicon
                upsertContractMethod.IT_Transport_Cost__c = requestObj.IT_Transport_Cost__c;
                upsertContractMethod.IT_Contract_Number__c = requestObj.IT_Contract_Number__c;
                upsertContractMethod.IT_Attendance_Type__c = requestObj.IT_Attendance_Type__c;
                upsertContractMethod.IT_Contract_Type__c = requestObj.IT_Contract_Type__c;
                upsertContractMethod.IT_Expiration_Contract_Date__c = requestObj.IT_Expiration_Contract_Date__c;
                upsertContractMethod.IT_Contract_Renewal_Type__c = requestObj.IT_Contract_Renewal_Type__c;
                upsertContractMethod.IT_No_Massive_Print__c = requestObj.IT_No_Massive_Print__c;
                upsertContractMethod.IT_No_Exclusivity__c = requestObj.IT_No_Exclusivity__c;
                upsertContractMethod.IT_Extradiscount__c = requestObj.IT_Extradiscount__c;
                upsertContractMethod.IT_Multidiscount__c = requestObj.IT_Multidiscount__c;
                upsertContractMethod.IT_Date_presence__c = requestObj.IT_Date_presence__c;
                upsertContractMethod.IT_Payment_Code__c =  requestObj.IT_Payment_Code__c;
                upsertContractMethod.IT_SDD_Payment__c = requestObj.IT_SDD_Payment__c;
                upsertContractMethod.IT_No_Date_Presence__c = requestObj.IT_No_Date_Presence__c;
                upsertContractMethod.IT_Penal_Presence__c = requestObj.IT_Penal_Presence__c;
                upsertContractMethod.IT_Delivery_Date_Bond__c = requestObj.IT_Delivery_Date_Bond__c;
                upsertContractMethod.IT_Delivery_Term__c = requestObj.IT_Delivery_Term__c;
                upsertContractMethod.IT_Term_Type__c = requestObj.IT_Term_Type__c;
                upsertContractMethod.IT_Delivery_Fixed_Day__c = requestObj.IT_Delivery_Fixed_Day__c;
                upsertContractMethod.IT_Order_Reception_Term__c = requestObj.IT_Order_Reception_Term__c;
                upsertContractMethod.IT_Contract_Progressive__c = requestObj.IT_Contract_Progressive__c;
                upsertContractMethod.IT_Framework_Head_Code__c = requestObj.IT_Framework_Head_Code__c;
                upsertContractMethod.IT_Opportunity_Code__c = requestObj.IT_Opportunity_Code__c;
                upsertContractMethod.IT_Campaign_Start_Date__c = requestObj.IT_Campaign_Start_Date__c;   
                upsertContractMethod.IT_Campaign_End_Date__c = requestObj.IT_Campaign_End_Date__c;
                upsertContractMethod.IT_Only_Client_Copy__c = requestObj.IT_Only_Client_Copy__c;
                upsertContractMethod.IT_Card_Cost__c = requestObj.IT_Card_Cost__c;
                upsertContractMethod.IT_Supply_Conditions__c = requestObj.IT_Supply_Conditions__c;
                upsertContractMethod.IT_Framework_Warrant__c = requestObj.IT_Framework_Warrant__c;
                upsertContractMethod.IT_UTA_Vehicles_Number__c = requestObj.IT_UTA_Vehicles_Number__c;
                upsertContractMethod.IT_UTA_Monthly_Limit__c = requestObj.IT_UTA_Monthly_Limit__c;
                upsertContractMethod.IT_UTA_Offer_Type__c = requestObj.IT_UTA_Offer_Type__c;
                upsertContractMethod.IT_Card_Cost_Billing_Frequency__c = requestObj.IT_Card_Cost_Billing_Frequency__c;
                upsertContractMethod.IT_No_Sign_Activation_Authorization__c = requestObj.IT_No_Sign_Activation_Authorization__c; 

                System.debug('mapOldContract: '+mapOldContract);
                if(mapOldContract != null && mapOldContract.size() > 0 && mapOldContract.keySet().contains(requestObj.IT_Client_Code__c)){

                    upsertContractMethod.IT_Flexben_Startup_Cost__c =  mapOldContract.get(requestObj.IT_Client_Code__c)[0].IT_Flexben_Startup_Cost__c;
                    upsertContractMethod.IT_Flexben_Startup_Date__c  = mapOldContract.get(requestObj.IT_Client_Code__c)[0].IT_Flexben_Startup_Date__c;
                    upsertContractMethod.IT_Flexben_Fee_Cost__c = mapOldContract.get(requestObj.IT_Client_Code__c)[0].IT_Flexben_Fee_Cost__c;
                    upsertContractMethod.IT_Flexben_Start_Fee_Date__c = mapOldContract.get(requestObj.IT_Client_Code__c)[0].IT_Flexben_Start_Fee_Date__c;
                    upsertContractMethod.IT_Flexben_Fee_Frequency__c = mapOldContract.get(requestObj.IT_Client_Code__c)[0].IT_Flexben_Fee_Frequency__c;
                    if(requestObj.IT_Contract_Sign_Date__c == null && requestObj.IT_Sign_Sending_Date__c == null){
                        upsertContractMethod.IT_Contract_Status__c = '01';
                    }else if(requestObj.IT_Contract_Sign_Date__c != null && requestObj.IT_Sign_Sending_Date__c == null){
                        upsertContractMethod.IT_Contract_Status__c = '02';
                    }else if(requestObj.IT_Contract_Sign_Date__c != null && requestObj.IT_Sign_Sending_Date__c != null){
                        upsertContractMethod.IT_Contract_Status__c = '04';
                    }

                    upsertContractMethod.IT_Sign_Sending_Date__c = requestObj.IT_Sign_Sending_Date__c;
                    upsertContractMethod.IT_Contract_Sign_Date__c = requestObj.IT_Contract_Sign_Date__c;
                    if(mapOldContract.get(requestObj.IT_Client_Code__c)[0].IT_Annual_Potential__c != null)
                        upsertContractMethod.IT_Annual_Potential__c = mapOldContract.get(requestObj.IT_Client_Code__c)[0].IT_Annual_Potential__c;

                    upsertContractMethod.IT_Renewal_Reason__c = mapOldContract.get(requestObj.IT_Client_Code__c)[0].IT_Renewal_Reason__c;
                    upsertContractMethod.IT_Client_Code__c = mapOldContract.get(requestObj.IT_Client_Code__c)[0].IT_Client_Code__c;

                    upsertContractMethod.AccountId = mapOldContract.get(requestObj.IT_Client_Code__c)[0].AccountId;
                    upsertContractMethod.IT_Financial_Center__c = mapFinCen.get(requestObj.IT_Client_Code__c).Id;
                    /*Contract sendOldContr = new Contract();
                    List<Contract> sendOldContrList = new List<Contract>();
                    sendOldContr = mapOldContract.get(requestObj.IT_Client_Code__c)[0];
                    sendOldContr.EndDate = System.today() - 1;
                    sendOldContr.IT_Contract_Closing_Type__c = '017';
                    sendOldContr.IT_Contract_Status__c = '03';
                    sendOldContrList.add(sendOldContr);*/
                    //APIT12_CallOutbound.createRequestContract(sendOldContrList, 'Contract');
                }
                //Skip
                if(mapFinCen.get(requestObj.IT_Client_Code__c).IT_SkipActivation__c)
                    upsertContractMethod.IT_SkipActivation__c = false;
                else
                    upsertContractMethod.IT_SkipActivation__c = true;

                insert upsertContractMethod;

                //Change condition modify 10122019 - Start
                List<Contract> newContractList = new List<Contract>();
                newContractList.add(upsertContractMethod);
                APIT12_CallOutbound.createRequestContract(newContractList, 'Contract');
                //Change condition modify 10122019 - End

                upsertFCMethod.IT_Contract__c = upsertContractMethod.Id;
                update upsertFCMethod;


            }else if(mapFinCen != null && mapFinCen.size() > 0 && mapFinCen.Keyset().contains(requestObj.IT_Client_Code__c) && !updateBool){
                
            }   

        }catch(Exception ecc){
            System.debug('populateFinancialCenter: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            Database.rollback(sp);
            catchRequest(requestObj.Id);
            System.debug('upsertContractErrorListCatch::: '+upsertContractErrorList);
            APIT12_CallOutbound.createRequestContract(upsertContractErrorList, 'Contract');
            return null;
        }
        return upsertFCMethod;        
    }

    private static void populateFinancialCenterFuture(Map<String, ER_Financial_Center__c> mapFinCen, IT_Request__c requestObj, Map<String, List<Contract>> mapOldContract){
        System.debug('mapOldContract::: '+mapOldContract);
        try{
            ER_Financial_Center__c upsertFCMethod = new ER_Financial_Center__c();
            ER_Bank_Account__c upsertBAMethod = new ER_Bank_Account__c();
            Contract upsertContractMethod = new Contract();
            Contract upsertContractMethodCR = new Contract();
            Contract upsertContractMethodEC = new Contract();
            if(mapFinCen != null && mapFinCen.size() > 0 && mapFinCen.Keyset().contains(requestObj.IT_Client_Code__c)){ 
                upsertFCMethod = new ER_Financial_Center__c(Id = mapFinCen.get(requestObj.IT_Client_Code__c).Id);
                upsertFCMethod.IT_Contractual_Particularities__c = requestObj.IT_Contractual_Particularities__c;
                Map<Id, SObject> newMapFC = new Map<Id, SObject>();
                SObject updateFCen = (SObject) upsertFCMethod;
                newMapFC.put(upsertFCMethod.Id, updateFCen);
                updateFCen = APIT11_Utilities.FutureChange(newMapFC, 'IT_Financial_Center__c', 'IT_Future_Change_Economic_Conditions__c');
                upsertFCMethod = (ER_Financial_Center__c) updateFCen;

                //Skip
                if(mapFinCen.get(requestObj.IT_Client_Code__c).IT_SkipActivation__c)
                    upsertFCMethod.IT_SkipActivation__c = false;
                else
                    upsertFCMethod.IT_SkipActivation__c = true;

                update upsertFCMethod;    

                if(!String.isBlank(mapFinCen.get(requestObj.IT_Client_Code__c).ER_Bank_Account__c)){
                    upsertBAMethod = new ER_Bank_Account__c (Id = mapFinCen.get(requestObj.IT_Client_Code__c).ER_Bank_Account__c);
                    upsertBAMethod.IT_Payment_Code__c =  requestObj.IT_Payment_Code__c;
                    upsertBAMethod.IT_SDD_Payment_Code__c =  requestObj.IT_SDD_Payment_Code__c;
                    upsertBAMethod.IT_CIN__c = requestObj.IT_CIN__c;
                    upsertBAMethod.ER_Country__c = requestObj.IT_Country__c;
                    upsertBAMethod.IT_Check_Iban__c  = requestObj.IT_Check_Iban__c ;
                    upsertBAMethod.IT_SDD_Contract_Code__c = requestObj.IT_SDD_Contract_Code__c;
                    upsertBAMethod.IT_SDD_Fiscal_Code__c = requestObj.IT_SDD_Fiscal_Code__c;
                    //upsertBAMethod.IT_Authorized__c = requestObj.IT_Authorized__c;
                    upsertBAMethod.IT_SDD_Authorized__c = requestObj.IT_SDD_Authorized__c;
                    upsertBAMethod.IT_SDD_Subscription_Date__c = requestObj.IT_SDD_Subscription_Date__c;
                    upsertBAMethod.IT_CC__c = requestObj.IT_CC__c;
                    upsertBAMethod.IT_Bank_Account_Code__c = requestObj.IT_Bank_Account_Code__c;
                    upsertBAMethod.IT_ABI__c = requestObj.IT_ABI__c;
                    upsertBAMethod.IT_CAB__c = requestObj.IT_CAB__c;

                    //Skip
                    if(mapFinCen.get(requestObj.IT_Client_Code__c).IT_SkipActivation__c)
                        upsertBAMethod.IT_SkipActivation__c = false;
                    else
                        upsertBAMethod.IT_SkipActivation__c = true;

                    Map<Id, SObject> newMapBA = new Map<Id, SObject>();
                    SObject updateBankAccount = (SObject) upsertBAMethod;
                    newMapBA.put(upsertBAMethod.Id, updateBankAccount);
                    updateBankAccount = APIT11_Utilities.FutureChange(newMapBA, 'ER_Bank_Account__c', 'IT_Future_Change_Bank_Account__c');
                    upsertBAMethod = new ER_Bank_Account__c();
                    upsertBAMethod = (ER_Bank_Account__c) updateBankAccount;

                    update upsertBAMethod;
                }

                if(!String.isBlank(mapFinCen.get(requestObj.IT_Client_Code__c).IT_Contract__c)){
                    upsertContractMethod = new Contract (Id = mapFinCen.get(requestObj.IT_Client_Code__c).IT_Contract__c);
                    upsertContractMethodCR = new Contract (Id = mapFinCen.get(requestObj.IT_Client_Code__c).IT_Contract__c);
                    upsertContractMethodEC = new Contract (Id = mapFinCen.get(requestObj.IT_Client_Code__c).IT_Contract__c);

                    //Contract
                    upsertContractMethodCR.IT_Commission_Type__c = requestObj.IT_Commission_Type__c;
                    upsertContractMethodCR.IT_Commission_Percentage__c = requestObj.IT_Commission_Percentage__c;
                    upsertContractMethodCR.IT_Discount_Type__c = requestObj.IT_Discount_Type__c;
                    upsertContractMethodCR.IT_Discount_Percentage__c = requestObj.IT_Discount_Percentage__c ;
                    upsertContractMethodCR.IT_Validity_Start_Date_EC__c = requestObj.IT_Contract_Start_Date__c;
                    upsertContractMethodCR.StartDate = requestObj.IT_Contract_Start_Date__c;
                    upsertContractMethodCR.IT_No_Cost_Reason__c = requestObj.IT_No_Cost_Reason__c;
                    upsertContractMethodCR.IT_Fixed_Day_Type__c = requestObj.IT_Fixed_Day_Type__c;
                    upsertContractMethodCR.IT_Order_Reception_Term_Type__c = requestObj.IT_Order_Reception_Term_Type__c;
                    
                    upsertContractMethodCR.IT_Sign_Sending_Date__c = requestObj.IT_Sign_Sending_Date__c;
                    upsertContractMethodCR.IT_Contract_Sign_Date__c = requestObj.IT_Contract_Sign_Date__c;

                    //EconomicicCondidicon
                    upsertContractMethodEC.IT_Transport_Cost__c = requestObj.IT_Transport_Cost__c;
                    upsertContractMethodEC.IT_Contract_Number__c = requestObj.IT_Contract_Number__c;
                    upsertContractMethodEC.IT_Attendance_Type__c = requestObj.IT_Attendance_Type__c;
                    upsertContractMethodEC.IT_Contract_Type__c = requestObj.IT_Contract_Type__c;
                    upsertContractMethodEC.IT_Expiration_Contract_Date__c = requestObj.IT_Expiration_Contract_Date__c;
                    upsertContractMethodEC.IT_Contract_Renewal_Type__c = requestObj.IT_Contract_Renewal_Type__c;
                    upsertContractMethodEC.IT_No_Massive_Print__c = requestObj.IT_No_Massive_Print__c;
                    upsertContractMethodEC.IT_No_Exclusivity__c = requestObj.IT_No_Exclusivity__c;
                    upsertContractMethodEC.IT_Extradiscount__c = requestObj.IT_Extradiscount__c;
                    upsertContractMethodEC.IT_Multidiscount__c = requestObj.IT_Multidiscount__c;
                    upsertContractMethodEC.IT_Date_presence__c = requestObj.IT_Date_presence__c;
                    upsertContractMethodEC.IT_Payment_Code__c =  requestObj.IT_Payment_Code__c;
                    upsertContractMethodEC.IT_SDD_Payment__c = requestObj.IT_SDD_Payment__c;
                    upsertContractMethodEC.IT_No_Date_Presence__c = requestObj.IT_No_Date_Presence__c;
                    upsertContractMethodEC.IT_Penal_Presence__c = requestObj.IT_Penal_Presence__c;
                    upsertContractMethodEC.IT_Delivery_Date_Bond__c = requestObj.IT_Delivery_Date_Bond__c;
                    upsertContractMethodEC.IT_Delivery_Term__c = requestObj.IT_Delivery_Term__c;
                    upsertContractMethodEC.IT_Term_Type__c = requestObj.IT_Term_Type__c;
                    upsertContractMethodEC.IT_Delivery_Fixed_Day__c = requestObj.IT_Delivery_Fixed_Day__c;
                    upsertContractMethodEC.IT_Order_Reception_Term__c = requestObj.IT_Order_Reception_Term__c;
                    upsertContractMethodEC.IT_Contract_Progressive__c = requestObj.IT_Contract_Progressive__c;
                    upsertContractMethodEC.IT_Framework_Head_Code__c = requestObj.IT_Framework_Head_Code__c;
                    upsertContractMethodEC.IT_Opportunity_Code__c = requestObj.IT_Opportunity_Code__c;
                    upsertContractMethodEC.IT_Campaign_Start_Date__c = requestObj.IT_Campaign_Start_Date__c;
                    upsertContractMethodEC.IT_Campaign_End_Date__c = requestObj.IT_Campaign_End_Date__c;
                    upsertContractMethodEC.IT_Only_Client_Copy__c = requestObj.IT_Only_Client_Copy__c;
                    upsertContractMethodEC.IT_Card_Cost__c = requestObj.IT_Card_Cost__c;
                    upsertContractMethodEC.IT_Supply_Conditions__c = requestObj.IT_Supply_Conditions__c;
                    upsertContractMethodEC.IT_Framework_Warrant__c = requestObj.IT_Framework_Warrant__c;
                    upsertContractMethodEC.IT_UTA_Vehicles_Number__c = requestObj.IT_UTA_Vehicles_Number__c;
                    upsertContractMethodEC.IT_UTA_Monthly_Limit__c = requestObj.IT_UTA_Monthly_Limit__c;
                    upsertContractMethodEC.IT_UTA_Offer_Type__c = requestObj.IT_UTA_Offer_Type__c;
                    upsertContractMethodEC.IT_Card_Cost_Billing_Frequency__c = requestObj.IT_Card_Cost_Billing_Frequency__c;
                    upsertContractMethodEC.IT_No_Sign_Activation_Authorization__c = requestObj.IT_No_Sign_Activation_Authorization__c;

                    //Skip
                    if(mapFinCen.get(requestObj.IT_Client_Code__c).IT_SkipActivation__c)
                        upsertContractMethod.IT_SkipActivation__c = false;
                    else
                        upsertContractMethod.IT_SkipActivation__c = true;
                    
                    Map<Id, SObject> newMapCR = new Map<Id, SObject>();
                    SObject updateContractContract = (SObject) upsertContractMethodCR;
                    newMapCR.put(upsertContractMethodCR.Id, updateContractContract);
                    updateContractContract = APIT11_Utilities.FutureChange(newMapCR, 'Contract', 'IT_Future_Change_Contract__c');
                    upsertContractMethodCR = new Contract();
                    upsertContractMethodCR = (Contract) updateContractContract;  

                    Map<Id, SObject> newMapCREC = new Map<Id, SObject>();
                    SObject updateContractEC = (SObject) upsertContractMethodEC;
                    newMapCREC.put(upsertContractMethodEC.Id, updateContractEC);
                    updateContractEC = APIT11_Utilities.FutureChange(newMapCREC, 'Contract', 'IT_Future_Change_Economic_Conditions__c');
                    upsertContractMethodEC = new Contract();
                    upsertContractMethodEC = (Contract) updateContractEC; 

                    upsertContractMethod.IT_Future_Change_Contract__c = upsertContractMethodCR.IT_Future_Change_Contract__c;
                    upsertContractMethod.IT_Future_Change_Economic_Conditions__c = upsertContractMethodEC.IT_Future_Change_Economic_Conditions__c; 

                    update upsertContractMethod;  
                }      

            }

            if(mapOldContract != null && mapOldContract.size() > 0 && mapOldContract.keySet().contains(requestObj.IT_Client_Code__c)){ 
                Contract sendOldContr = new Contract();
                List<Contract> sendOldContrList = new List<Contract>();
                sendOldContr = mapOldContract.get(requestObj.IT_Client_Code__c)[0];
                sendOldContr.EndDate = requestObj.IT_Contract_Start_Date__c - 1;   
                sendOldContr.IT_Contract_Closing_Type__c = '017';
                sendOldContr.IT_Contract_Status__c = '03';
                sendOldContrList.add(sendOldContr);
                //APIT12_CallOutbound.createRequestContract(mapOldContract.get(requestObj.IT_Client_Code__c), 'Contract');
                List<IT_Request__c> requestFuture = new List<IT_Request__c>();
                requestFuture.add(requestObj);
                /*APIT12_CallOutbound.createRequestCustomFlow(requestFuture, mapOldContract.get(requestObj.IT_Client_Code__c)[0], null, 1);
                Integer start = System.Now().millisecond();
                while(System.Now().millisecond()< start+150){ 
                }*/
                APIT12_CallOutbound.createRequestCustomFlow(requestFuture, mapOldContract.get(requestObj.IT_Client_Code__c)[0], mapFinCen.get(requestObj.IT_Client_Code__c), 0); 
            }  

        }catch(Exception ecc){
            System.debug('populateFinancialCenterFuture: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }      
    }   

    @Future(callout = true)
    public static void postRequest (String urlParam, String jsonPost){
        String responseBody = '';
        try{
            Http callHttp = new Http();
            HttpRequest req = APER06_WebserviceUtility.getHttpRequest( '/'+urlParam, 'POST', jsonPost, null);
            HttpResponse res = callHttp.send(req);
            responseBody = res.getbody();
            Response resp;
            if(responseBody != null && responseBody != ''){
                System.debug('responseBody::: '+responseBody);
                resp = (Response) JSON.deserializeStrict(responseBody, Response.class);
            }    
            system.debug('Status::: '+resp.meta.status);
            system.debug('ListError::: '+resp.meta.messages);
            if((resp != null && resp.meta.status != 'succeeded') || resp == null){  
                List<String> toAddresses = new List<String>();
                List<CMIT11_Mail_Error__mdt> mailingList = new List<CMIT11_Mail_Error__mdt>();
                mailingList = [Select MasterLabel, 	IT_Mail_Address__c, IT_Active__c From CMIT11_Mail_Error__mdt Where IT_Active__c = true];
                for(CMIT11_Mail_Error__mdt singleMail : mailingList){
                    toAddresses.add(singleMail.IT_Mail_address__c);
                }
                system.debug('toAddresses' + toAddresses);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                mail.setSubject('Errore Allineamento Anagrafica Clienti');
                if(resp != null)
                    mail.sethtmlBody('Con la seguente chiamata: <br>' + jsonPost + '<br> è stato riscontrato il seguente errore: <br> '+ resp.meta.messages);
                else
                    mail.sethtmlBody('Con la seguente chiamata: <br>' + jsonPost + '<br> è stato riscontrato il seguente errore: <br> The call to EDG was not successful'); 
                        
                mail.setToAddresses(toAddresses);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }    
        }catch(Exception ecc){
            System.debug('Error postRequest: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
    }

    @Future
    public static void pupulateBankAccountLookup (String idFC, String idBA){
        ER_Financial_Center__c updateFC = new ER_Financial_Center__c();
        try{
            if(!String.isBlank(idFC) && !String.isBlank(idBA)){
                updateFC = new ER_Financial_Center__c(Id = idFC);
                updateFC.ER_Bank_Account__c = idBA;
                update updateFC;
            }
        }catch(Exception ecc){
            System.debug('Error pupulateBankAccountLookup: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }        
        
    }

    public class Response{
        public meta meta;
        public data data;
    }
    
    public class meta{
        List<messages> messages;
        String status;
    }

    public class data{
        String application;  
        String id_proc;  
        String start_date;  
        String end_date;  
        String request_id;    
    }

    public class messages{
        String code; 
        String text; 
        String level; 
        String ref;    
    }
}