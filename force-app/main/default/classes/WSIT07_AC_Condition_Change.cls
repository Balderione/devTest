@RestResource(urlMapping='/ac_conditionchange/*') 
global with sharing class  WSIT07_AC_Condition_Change {
    @HttpPut
    global static List<response> ConditionChangeUpsert() {
        List<response> respList = new List<response>();
        Map<String, response> mapError = new Map<String, response>();
        Map<String, ER_Financial_Center__c> mapFinancialCenterSF =  new Map<String, ER_Financial_Center__c>(); 
        List<String> clientCodeList = new List<String>();
        List<String> VATNumberList = new List<String>();
        List<String> productCodeList = new List<String>();
        List<ER_Financial_Center__c> financialCenterList = new List<ER_Financial_Center__c>();
        List<Account> accountList = new List<Account>();
        List<Product2> product2List = new List<Product2>();
        Map<String, Account> mapAccountSF =  new Map<String, Account>();
        Map<String, Product2> mapProduct2SF =  new Map<String, Product2>();
        String body = System.RestContext.request.requestBody.toString();
        Request req = (Request) JSON.deserializeStrict(body, Request.class);
        system.debug('req::: '+req); 

        for(IT_Condition_Change singleConditionQuery : req.IT_Condition_Change){
            clientCodeList.add(singleConditionQuery.IT_Client_Code);
            VATNumberList.add(singleConditionQuery.IT_New_VAT_Number);
            productCodeList.add(singleConditionQuery.IT_New_Service);
            
        }

        Map<String, String> pickListValuesMap= new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = IT_Request__c.IT_Editing_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesMap.put(pickListVal.getValue(), pickListVal.getLabel());
        }     
        System.debug('pickListValuesMap::: '+pickListValuesMap);

        if(clientCodeList != null && clientCodeList.size() > 0){
            financialCenterList = [Select Id, ER_Account_Name__c, IT_Financial_Center__c, IT_Contractual_Particularities__c, IT_Beneficiary_Type__c, IT_Employee_Number__c, IT_Concurrency__c, IT_CIG__c, IT_Opening_Outcome__c, IT_Billing_Company_Name_R1__c, IT_Billing_Company_Name_R2__c, IT_Billing_Company_Name_R3__c, IT_Short_Name__c, IT_Extended_Company_Name__c, IT_Province__c, IT_Toponym__c, IT_Short_Address__c, ER_City__c, IT_Additional_Locality__c, ER_Zip_Code__c, IT_City_Code__c, IT_Hamlet_Code__c, IT_Hamlet__c, IT_Sestiere_Code__c, IT_Street_Code__c, IT_Road_Arch_Code__c, IT_Extra_Urban_Specifications__c, IT_Contact_Code__c, IT_New_Code__c, IT_Office_Code__c, IT_SDI__c,IT_Contract__c, ER_Bank_Account__c, 
            (Select Id, IT_Reason__c, IT_User_Authorization_Code__c, IT_Request_Status__c, IT_Request_Date__c, IT_Accepted_Request_Date__c, IT_Editing_Reason__c, IT_Applicant_User__c, IT_Authorization_Date__c, IT_Acceptance_User__c, IT_Registration_Date__c, IT_Registration_User__c, IT_Company_Name_Change__c, IT_Address_Change__c, IT_Administrative_Group__c, IT_Statistic_Group__c, IT_Transport_Cost_Presence__c, IT_Reopening_Date__c, IT_Extradiscount_Percentage__c, IT_Extradiscount_Type__c, IT_Discount_Percentage_2__c, IT_Discount_Validity_Date_2__c, IT_Discount_Percentage_3__c, IT_Discount_Validity_Date_3__c, IT_Not_Send_Contract__c, IT_Standard_Master_Data__c, IT_Bond__c, IT_Opening__c, IT_Printed_Contract__c, IT_Payment_Progressive_Number__c, IT_Signed_Contract__c From Requests__r Where IT_Request_Status__c != '3' Or IT_Request_Status__c != '5'),
            (Select Id From Contacts__r),
            (Select Id, IT_Order_Frequence_Type__c From Contract_Line_Items__r), 
            (Select Id, IT_Commission_Type__c, IT_Commission_Percentage__c, IT_Discount_Type__c, IT_Discount_Percentage__c, StartDate, IT_Transport_Cost__c, IT_No_Cost_Reason__c, IT_Contract_Number__c, IT_Attendance_Type__c, IT_Contract_Type__c, IT_Expiration_Contract_Date__c, IT_Contract_Renewal_Type__c, IT_No_Massive_Print__c, IT_No_Exclusivity__c, IT_Extradiscount__c, IT_Multidiscount__c, IT_Date_presence__c, IT_SDD_Payment__c, IT_No_Date_Presence__c, IT_Penal_Presence__c, IT_Delivery_Date_Bond__c, IT_Delivery_Term__c, IT_Term_Type__c, IT_Delivery_Fixed_Day__c, IT_Fixed_Day_Type__c, IT_Order_Reception_Term__c, IT_Order_Reception_Term_Type__c, IT_Contract_Progressive__c, IT_Framework_Head_Code__c, IT_Opportunity_Code__c, IT_Campaign_Start_Date__c, IT_Campaign_End_Date__c, IT_Only_Client_Copy__c, IT_Card_Cost__c, IT_Supply_Conditions__c, IT_Framework_Warrant__c, IT_UTA_Vehicles_Number__c, IT_UTA_Monthly_Limit__c, IT_UTA_Offer_Type__c, IT_Flexben_Startup_Cost__c, IT_Flexben_Fee_Cost__c, IT_Flexben_Fee_Frequency__c, IT_Card_Cost_Billing_Frequency__c, IT_No_Sign_Activation_Authorization__c From Contracts__r), 
            (Select Id, IT_Payment_Code__c, IT_SDD_Payment_Code__c, IT_CIN__c, ER_Country__c, IT_Check_Iban__c, IT_SDD_Contract_Code__c, IT_SDD_Fiscal_Code__c, IT_Authorized__c, IT_SDD_Subscription_Date__c, IT_CC__c, IT_Bank_Account_Code__c, IT_ABI__c, IT_CAB__c From Bank_Accounts__r) 
            From ER_Financial_Center__c Where IT_Financial_Center__c IN : clientCodeList];  
            
            if(VATNumberList != null && VATNumberList.size() > 0)
                accountList = [Select Id, ER_VAT_Number__c, IT_Fiscal_Code__c, ER_Legal_Name__c, IT_Legal_Form__c, ER_Segment__c, IT_Split_Payment__c, NumberOfEmployees, IT_Private_work_for_Institution__c, IT_Industry__c From Account Where ER_VAT_Number__c IN : VATNumberList];

            if(productCodeList != null && productCodeList.size() > 0)
                product2List = [Select Id, ProductCode From Product2 Where ProductCode IN : productCodeList];

        }

        if(financialCenterList != null && financialCenterList.size() > 0){
            for(ER_Financial_Center__c singleSfFC : financialCenterList){
                mapFinancialCenterSF.put(singleSfFC.IT_Financial_Center__c, singleSfFC);
            }
        }
        if(accountList != null && accountList.size() > 0){
            for(Account singleSfAccount : accountList){
                mapAccountSF.put(singleSfAccount.ER_VAT_Number__c, singleSfAccount);
            }
        }
        if(product2List != null && product2List.size() > 0){
            for(Product2 singleSfProduct : product2List){
                mapProduct2SF.put(singleSfProduct.ProductCode, singleSfProduct);  
            }    
        }


        for(IT_Condition_Change singleConditionChange : req.IT_Condition_Change){
            Savepoint sp = Database.setSavepoint();
            try{
                if(String.isblank(singleConditionChange.IT_Client_Code)){
                    response responseService = new response();
                    responseService = populateResponseError(singleConditionChange.IT_Client_Code, 'Required Field Missing IT_Client_Code'); 
                    if(!mapError.Keyset().contains(singleConditionChange.IT_Client_Code))
                        mapError.put(singleConditionChange.IT_Client_Code, responseService);  
                }
                else if(mapFinancialCenterSF != null && !mapFinancialCenterSF.keyset().contains(singleConditionChange.IT_Client_Code)){
                    response responseService = new response();
                    responseService = populateResponseError(singleConditionChange.IT_Client_Code, 'Client Code '+singleConditionChange.IT_Client_Code+' not registered in the system'); 
                    if(!mapError.Keyset().contains(singleConditionChange.IT_Client_Code))
                        mapError.put(singleConditionChange.IT_Client_Code, responseService);  
                }
                if(String.isblank(singleConditionChange.IT_Request_Status)){
                    response responseService = new response();
                    responseService = populateResponseError(singleConditionChange.IT_Client_Code, 'Required Field Missing IT_Request_Status'); 
                    if(!mapError.Keyset().contains(singleConditionChange.IT_Client_Code))
                        mapError.put(singleConditionChange.IT_Client_Code, responseService);  
                }

                if(!mapError.Keyset().contains(singleConditionChange.IT_Client_Code)){
                    IT_Request__c upsertRequestFC = new IT_Request__c();
                    ER_Financial_Center__c finCenControl = new ER_Financial_Center__c();
                    if(mapFinancialCenterSF.Keyset().contains(singleConditionChange.IT_Client_Code)){
                        finCenControl = mapFinancialCenterSF.get(singleConditionChange.IT_Client_Code);   
                    }
                    upsertRequestFC = populateFinancialCenter(finCenControl, singleConditionChange, pickListValuesMap);
                    system.debug('upsertRequestFCComplete::: '+upsertRequestFC);
                    if(upsertRequestFC != null)
                        upsert upsertRequestFC;

                    response responseService = new response(); 
                    responseService.statusCode = '200';   
                    responseService.errorDescription = '';
                    responseService.condition_change_CD = upsertRequestFC.IT_Client_Code__c;
                    responseService.sfdc_ID = upsertRequestFC.Id;
                    respList.add(responseService);   

                }else{
                    response responseServiceErr = new response(); 
                    responseServiceErr = mapError.get(singleConditionChange.IT_Client_Code); 
                    respList.add(responseServiceErr);        
                }

            }catch(Exception ecc){
                System.debug('Error WSIT07_AC_Condition_Change: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                Integer singleResponse = 0;
                while (singleResponse < respList.size()){
                    if(respList.get(singleResponse).condition_change_CD == singleConditionChange.IT_Client_Code){
                        respList.remove(singleResponse);
                    }else{
                        singleResponse++;
                    }
                }

                response responseServiceCatch = new response(); 
                responseServiceCatch.statusCode = '400';   
                responseServiceCatch.errorDescription = ecc.getMessage();
                responseServiceCatch.condition_change_CD = singleConditionChange.IT_Client_Code;
                responseServiceCatch.sfdc_ID = '';
                respList.add(responseServiceCatch);

                Database.rollback(sp);
            }
        }

        return respList;       
    }

    private static response populateResponseError(String codeFinCent, String errorField){
        response responseService = new response(); 
        responseService.statusCode = '400'; 
        responseService.condition_change_CD = codeFinCent;
        responseService.sfdc_ID = '';
        responseService.ErrorDescription = errorField;
        return responseService;
    }

    private static IT_Request__c populateFinancialCenter(ER_Financial_Center__c financialCenterObj, IT_Condition_Change singleCondition, Map<String, String> pickListMap){
        IT_Request__c upsertFCRequestMethod = new IT_Request__c();

        if(financialCenterObj != null && financialCenterObj.Requests__r != null && financialCenterObj.Requests__r.size() > 0){
            upsertFCRequestMethod = new IT_Request__c(Id = financialCenterObj.Requests__r[0].Id);
        }else{
            upsertFCRequestMethod.IT_Financial_Center__c = financialCenterObj.Id;
            //Populate Lookup
            upsertFCRequestMethod.IT_Financial_Center_Action__c = financialCenterObj.Id;
            upsertFCRequestMethod.IT_Bank_Account__c = financialCenterObj.ER_Bank_Account__c;
            upsertFCRequestMethod.IT_Contract__c = financialCenterObj.IT_Contract__c;
        }    
        
        if(pickListMap != null && pickListMap.size() > 0 && pickListMap.Keyset().contains(singleCondition.IT_Editing_Reason))
            upsertFCRequestMethod.Name = singleCondition.IT_Client_Code + ' - ' + pickListMap.get(singleCondition.IT_Editing_Reason);
        else 
            upsertFCRequestMethod.Name = singleCondition.IT_Client_Code;
        upsertFCRequestMethod.IT_Reason__c = singleCondition.IT_Reason;
        upsertFCRequestMethod.IT_User_Authorization_Code__c = singleCondition.IT_User_Authorization_Code;
        upsertFCRequestMethod.IT_Request_Status__c = singleCondition.IT_Request_Status;
        upsertFCRequestMethod.IT_Request_Date__c = singleCondition.IT_Request_Date;
        upsertFCRequestMethod.IT_Accepted_Request_Date__c = singleCondition.IT_Accepted_Request_Date;
        upsertFCRequestMethod.IT_Editing_Reason__c = singleCondition.IT_Editing_Reason;
        upsertFCRequestMethod.IT_Applicant_User__c = singleCondition.IT_Applicant_User;
        upsertFCRequestMethod.IT_Authorization_Date__c = singleCondition.IT_Authorization_Date;
        upsertFCRequestMethod.IT_Acceptance_User__c = singleCondition.IT_Acceptance_User;
        upsertFCRequestMethod.IT_Registration_Date__c = singleCondition.IT_Registration_Date;
        upsertFCRequestMethod.IT_Registration_User__c = singleCondition.IT_Registration_User;
        if(singleCondition.IT_Company_Name_Change != null)
            upsertFCRequestMethod.IT_Company_Name_Change__c = singleCondition.IT_Company_Name_Change;
        if(singleCondition.IT_Address_Change != null)    
            upsertFCRequestMethod.IT_Address_Change__c = singleCondition.IT_Address_Change;
        upsertFCRequestMethod.IT_Administrative_Group__c = singleCondition.IT_Administrative_Group;
        upsertFCRequestMethod.IT_Statistic_Group__c = singleCondition.IT_Statistic_Group;
        if(singleCondition.IT_Transport_Cost_Presence != null)
            upsertFCRequestMethod.IT_Transport_Cost_Presence__c = singleCondition.IT_Transport_Cost_Presence;
        upsertFCRequestMethod.IT_Reopening_Date__c = singleCondition.IT_Reopening_Date;
        upsertFCRequestMethod.IT_Extradiscount_Percentage__c = singleCondition.IT_Extradiscount_Percentage;
        upsertFCRequestMethod.IT_Extradiscount_Type__c = singleCondition.IT_Extradiscount_Type;
        upsertFCRequestMethod.IT_Discount_Percentage_2__c = singleCondition.IT_Discount_Percentage_2;
        upsertFCRequestMethod.IT_Discount_Validity_Date_2__c = singleCondition.IT_Discount_Validity_Date_2;
        upsertFCRequestMethod.IT_Discount_Percentage_3__c = singleCondition.IT_Discount_Percentage_3;
        upsertFCRequestMethod.IT_Discount_Validity_Date_3__c = singleCondition.IT_Discount_Validity_Date_3;
        if(singleCondition.IT_Not_Send_Contract != null)
            upsertFCRequestMethod.IT_Not_Send_Contract__c = singleCondition.IT_Not_Send_Contract;
        if(singleCondition.IT_Standard_Master_Data != null)    
            upsertFCRequestMethod.IT_Standard_Master_Data__c = singleCondition.IT_Standard_Master_Data;
        upsertFCRequestMethod.IT_Bond__c = singleCondition.IT_Bond;
        upsertFCRequestMethod.IT_Opening__c = singleCondition.IT_Opening_Outcome;
        if(singleCondition.IT_Printed_Contract != null) 
            upsertFCRequestMethod.IT_Printed_Contract__c = singleCondition.IT_Printed_Contract;
        upsertFCRequestMethod.IT_Payment_Progressive_Number__c = singleCondition.IT_Payment_Progressive_Number;
        if(singleCondition.IT_Signed_Contract != null)
            upsertFCRequestMethod.IT_Signed_Contract__c = singleCondition.IT_Signed_Contract;
        upsertFCRequestMethod.IT_Client_Code__c = singleCondition.IT_Client_Code;
        upsertFCRequestMethod.IT_Contractual_Particularities__c = singleCondition.IT_Contractual_Particularities;
        upsertFCRequestMethod.IT_Beneficiary_Type__c = singleCondition.IT_Beneficiary_Type;
        upsertFCRequestMethod.IT_Employee_Number__c = singleCondition.IT_Employee_Number;
        upsertFCRequestMethod.IT_Concurrency__c = singleCondition.IT_Concurrency;
        upsertFCRequestMethod.IT_CIG__c = singleCondition.IT_CIG;
        upsertFCRequestMethod.IT_Opening_Outcome__c = singleCondition.IT_Opening;
        upsertFCRequestMethod.IT_Short_Company_Name__c = singleCondition.IT_Short_Company_Name;
        upsertFCRequestMethod.IT_Extended_Company_Name__c = singleCondition.IT_Extended_Company_Name;
        upsertFCRequestMethod.IT_Province__c = singleCondition.IT_Province;
        upsertFCRequestMethod.IT_Toponym__c = singleCondition.IT_Toponym;
        upsertFCRequestMethod.IT_Short_Address__c = singleCondition.IT_Short_Address;
        upsertFCRequestMethod.IT_Street__c = singleCondition.IT_New_Street;
        upsertFCRequestMethod.IT_Street_Number__c = singleCondition.IT_Street_Number;
        upsertFCRequestMethod.IT_City__c = singleCondition.IT_City;
        upsertFCRequestMethod.IT_Additional_Locality__c = singleCondition.IT_Additional_Locality;
        upsertFCRequestMethod.IT_Postal_Code__c = singleCondition.IT_Postal_Code;
        upsertFCRequestMethod.IT_Municipality_Code__c = singleCondition.IT_Municipality_Code;
        upsertFCRequestMethod.IT_Hamlet_Code__c = singleCondition.IT_Hamlet_Code;
        upsertFCRequestMethod.IT_Hamlet__c = singleCondition.IT_Hamlet;
        upsertFCRequestMethod.IT_Sestiere_Code__c = singleCondition.IT_Sestiere_Code;
        upsertFCRequestMethod.IT_Street_Code__c = singleCondition.IT_Street_Code;
        upsertFCRequestMethod.IT_Road_Arch_Code__c = singleCondition.IT_Road_Arch_Code;
        upsertFCRequestMethod.IT_Extra_Urban_Specifications__c = singleCondition.IT_Extra_Urban_Specifications;
        upsertFCRequestMethod.IT_Sales_Manager__c = singleCondition.IT_Sales_Manager;

        //Field change in Financial Center for change product or change vat number
        upsertFCRequestMethod.IT_New_Client__c = singleCondition.IT_New_Client;
        upsertFCRequestMethod.IT_New_Unique_Office_Code__c = singleCondition.IT_New_Unique_Office_Code;
        upsertFCRequestMethod.IT_New_SDI__c = singleCondition.IT_New_SDI;
        upsertFCRequestMethod.IT_New_Signatures_Number__c = singleCondition.IT_New_Signatures_Number;
        upsertFCRequestMethod.IT_New_Beneficiary_Type__c = singleCondition.IT_New_Beneficiary_Type;
        upsertFCRequestMethod.IT_New_Zone__c = singleCondition.IT_New_Zone;
        upsertFCRequestMethod.IT_New_Sales_Manager__c = singleCondition.IT_New_Sales_Manager;
        upsertFCRequestMethod.IT_New_State__c = singleCondition.IT_New_State;
        upsertFCRequestMethod.IT_New_City__c = singleCondition.IT_New_City;
        upsertFCRequestMethod.IT_New_Additional_Locality__c = singleCondition.IT_New_Additional_Locality;
        upsertFCRequestMethod.IT_New_Toponym__c = singleCondition.IT_New_Toponym;
        upsertFCRequestMethod.IT_New_Street_Number__c = singleCondition.IT_New_Street_Number;
        upsertFCRequestMethod.IT_New_Postal_Code__c = singleCondition.IT_New_Postal_Code;
        upsertFCRequestMethod.IT_New_Opening_Type__c = singleCondition.IT_New_Opening_Type;
        upsertFCRequestMethod.IT_New_Concurrency__c = singleCondition.IT_New_Concurrency;

        //Economic Condition for Contract - Start
        upsertFCRequestMethod.IT_Commission_Type__c = singleCondition.IT_Commission_Type;
        upsertFCRequestMethod.IT_Commission_Percentage__c = singleCondition.IT_Commission_Percentage;
        upsertFCRequestMethod.IT_Discount_Type__c = singleCondition.IT_Discount_Type;
        upsertFCRequestMethod.IT_Discount_Percentage__c = singleCondition.IT_Discount_Percentage;
        upsertFCRequestMethod.IT_Contract_Start_Date__c = singleCondition.StartDate;
        upsertFCRequestMethod.IT_Transport_Cost__c = singleCondition.IT_Transport_Cost; 
        upsertFCRequestMethod.IT_No_Cost_Reason__c = singleCondition.IT_No_Cost_Reason;
        upsertFCRequestMethod.IT_Contract_Number__c = singleCondition.IT_Contract_Number;
        upsertFCRequestMethod.IT_Attendance_Type__c = singleCondition.IT_Attendance_Type;
        upsertFCRequestMethod.IT_Contract_Type__c = singleCondition.IT_Contract_Type;
        upsertFCRequestMethod.IT_Expiration_Contract_Date__c = singleCondition.IT_Expiration_Contract_Date;
        upsertFCRequestMethod.IT_Contract_Renewal_Type__c = singleCondition.IT_Contract_Renewal_Type;
        if(singleCondition.IT_No_Massive_Print != null)
            upsertFCRequestMethod.IT_No_Massive_Print__c = singleCondition.IT_No_Massive_Print;
        if(singleCondition.IT_No_Exclusivity != null)    
            upsertFCRequestMethod.IT_No_Exclusivity__c = singleCondition.IT_No_Exclusivity;
        if(singleCondition.IT_Extradiscount != null)    
            upsertFCRequestMethod.IT_Extradiscount__c = singleCondition.IT_Extradiscount;
        if(singleCondition.IT_Multidiscount != null)
            upsertFCRequestMethod.IT_Multidiscount__c = singleCondition.IT_Multidiscount;
        if(singleCondition.IT_Date_presence != null)
            upsertFCRequestMethod.IT_Date_presence__c = singleCondition.IT_Date_presence;
        if(singleCondition.IT_SDD_Payment != null)    
            upsertFCRequestMethod.IT_SDD_Payment__c = singleCondition.IT_SDD_Payment;
        if(singleCondition.IT_No_Date_Presence != null)    
            upsertFCRequestMethod.IT_No_Date_Presence__c = singleCondition.IT_No_Date_Presence;
        upsertFCRequestMethod.IT_Penal_Presence__c = singleCondition.IT_Penal_Presence;
        upsertFCRequestMethod.IT_Delivery_Date_Bond__c = singleCondition.IT_Delivery_Date_Bond;
        upsertFCRequestMethod.IT_Delivery_Term__c = singleCondition.IT_Delivery_Term;
        upsertFCRequestMethod.IT_Term_Type__c = singleCondition.IT_Term_Type;
        upsertFCRequestMethod.IT_Delivery_Fixed_Day__c = singleCondition.IT_Delivery_Fixed_Day;
        upsertFCRequestMethod.IT_Fixed_Day_Type__c = singleCondition.IT_Fixed_Day_Type;
        upsertFCRequestMethod.IT_Order_Reception_Term__c = singleCondition.IT_Order_Reception_Term;
        upsertFCRequestMethod.IT_Order_Reception_Term_Type__c = singleCondition.IT_Order_Reception_Term_Type;
        upsertFCRequestMethod.IT_Contract_Progressive__c = singleCondition.IT_Contract_Progressive;
        upsertFCRequestMethod.IT_Framework_Head_Code__c = singleCondition.IT_Head_Framework_Code;
        upsertFCRequestMethod.IT_Opportunity_Code__c = singleCondition.IT_Opportunity_Code;
        upsertFCRequestMethod.IT_Campaign_Start_Date__c = singleCondition.IT_Campaign_Start_Date;
        upsertFCRequestMethod.IT_Campaign_End_Date__c = singleCondition.IT_Campaign_End_Date;
        if(singleCondition.IT_Only_Client_Copy != null)
            upsertFCRequestMethod.IT_Only_Client_Copy__c = singleCondition.IT_Only_Client_Copy;
        upsertFCRequestMethod.IT_Card_Cost__c = singleCondition.IT_Card_Cost;
        if(singleCondition.IT_Supply_Conditions != null)
            upsertFCRequestMethod.IT_Supply_Conditions__c = singleCondition.IT_Supply_Conditions;
        if(singleCondition.IT_Framework_Warrant != null)    
            upsertFCRequestMethod.IT_Framework_Warrant__c = singleCondition.IT_Framework_Warrant;
        upsertFCRequestMethod.IT_UTA_Vehicles_Number__c = singleCondition.IT_UTA_Vehicles_Number;
        upsertFCRequestMethod.IT_UTA_Monthly_Limit__c = singleCondition.IT_UTA_Monthly_Limit;
        upsertFCRequestMethod.IT_UTA_Offer_Type__c = singleCondition.IT_UTA_Offer_Type;
        upsertFCRequestMethod.IT_Flexben_Startup_Cost__c = singleCondition.IT_Flexben_Startup_Cost;
        upsertFCRequestMethod.IT_Flexben_Fee_Cost__c = singleCondition.IT_Flexben_Fee_Cost;
        upsertFCRequestMethod.IT_Flexben_Fee_Frequency__c = singleCondition.IT_Flexben_Fee_Frequency;
        upsertFCRequestMethod.IT_Card_Cost_Billing_Frequency__c = singleCondition.IT_Billing_Frequency;
        if(singleCondition.IT_No_Sign_Activation_Authorization != null)
            upsertFCRequestMethod.IT_No_Sign_Activation_Authorization__c = singleCondition.IT_No_Sign_Activation_Authorization;
        //Economic Condition for Contract - End
        
        //Economic Condition for Bank Account - Start
        upsertFCRequestMethod.IT_Payment_Code__c = singleCondition.IT_Payment_Code;
        upsertFCRequestMethod.IT_SDD_Payment_Code__c = singleCondition.IT_SDD_Payment_Code;
        upsertFCRequestMethod.IT_CIN__c = singleCondition.IT_CIN;
        upsertFCRequestMethod.IT_Country__c = singleCondition.IT_Country;
        upsertFCRequestMethod.IT_Check_Iban__c = singleCondition.IT_Check_Iban;
        upsertFCRequestMethod.IT_SDD_Contract_Code__c = singleCondition.IT_SDD_Contract_Code;
        upsertFCRequestMethod.IT_SDD_Fiscal_Code__c = singleCondition.IT_SDD_Fiscal_Code;
        upsertFCRequestMethod.IT_SDD_Authorized__c = singleCondition.IT_Authorized;
        upsertFCRequestMethod.IT_SDD_Subscription_Date__c = singleCondition.IT_SDD_Subscription_Date;
        upsertFCRequestMethod.IT_CC__c = singleCondition.IT_CC;
        upsertFCRequestMethod.IT_Bank_Account_Code__c = singleCondition.IT_Bank_Account_Code;
        upsertFCRequestMethod.IT_ABI__c = singleCondition.IT_ABI;
        upsertFCRequestMethod.IT_CAB__c = singleCondition.IT_CAB;
        //Economic Condition for Bank Account - End

        upsertFCRequestMethod.IT_Forcing__c = singleCondition.IT_Forcing;
        upsertFCRequestMethod.IT_Fax__c = singleCondition.IT_Fax;
        upsertFCRequestMethod.IT_Street__c = singleCondition.IT_Address;
        if(!String.isBlank(singleCondition.IT_Billing_Company_Name) && singleCondition.IT_Billing_Company_Name.length() <= 30){
            upsertFCRequestMethod.IT_Billing_Company_Name_R1__c = singleCondition.IT_Billing_Company_Name;
        }else if(!String.isBlank(singleCondition.IT_Billing_Company_Name) && singleCondition.IT_Billing_Company_Name.length() > 30 && singleCondition.IT_Billing_Company_Name.length() <= 50){
            upsertFCRequestMethod.IT_Billing_Company_Name_R1__c = singleCondition.IT_Billing_Company_Name.substring(0, 29);
            upsertFCRequestMethod.IT_Billing_Company_Name_R2__c = singleCondition.IT_Billing_Company_Name.substring(30, singleCondition.IT_Billing_Company_Name.length()); 
        }else if(!String.isBlank(singleCondition.IT_Billing_Company_Name) && singleCondition.IT_Billing_Company_Name.length() > 50 && singleCondition.IT_Billing_Company_Name.length() <= 80){
            upsertFCRequestMethod.IT_Billing_Company_Name_R1__c = singleCondition.IT_Billing_Company_Name.substring(0, 29);
            upsertFCRequestMethod.IT_Billing_Company_Name_R2__c = singleCondition.IT_Billing_Company_Name.substring(30, 49);
            upsertFCRequestMethod.IT_Billing_Company_Name_R3__c = singleCondition.IT_Billing_Company_Name.substring(50, singleCondition.IT_Billing_Company_Name.length()); 
        }
            
        return upsertFCRequestMethod;
    }

    private static String populateObjects(IT_Request__c requestObj){
        return null;
    }  
    
    public class Request{
        public list<IT_Condition_Change> IT_Condition_Change;    
    }
    
    global class response {
        public String statusCode;
        public String condition_change_CD; 
        public String sfdc_ID;
        public String errorDescription;    
    }
    
    public class IT_Condition_Change{
        public String IT_Reason;
        public String IT_User_Authorization_Code;
        public String IT_Request_Status;
        public Date IT_Request_Date;
        public Date IT_Accepted_Request_Date;
        public String IT_Editing_Reason;
        public String IT_Applicant_User;
        public Date IT_Authorization_Date;
        public String IT_Acceptance_User;
        public Date IT_Registration_Date;
        public String IT_Registration_User;
        public Boolean IT_Company_Name_Change;
        public Boolean IT_Address_Change;
        public String IT_Administrative_Group;
        public String IT_Statistic_Group;
        public Boolean IT_Transport_Cost_Presence;
        public Date IT_Reopening_Date;
        public Decimal IT_Extradiscount_Percentage;
        public String IT_Extradiscount_Type;
        public Decimal IT_Discount_Percentage_2;
        public Date IT_Discount_Validity_Date_2;
        public Decimal IT_Discount_Percentage_3;
        public Date IT_Discount_Validity_Date_3;
        public Boolean IT_Not_Send_Contract;
        public Boolean IT_Standard_Master_Data;
        public Integer IT_Bond;
        public String IT_Opening;
        public Boolean IT_Printed_Contract;
        public Integer IT_Payment_Progressive_Number;
        public Boolean IT_Signed_Contract;
        public String IT_Client_Code;
        public String IT_Contractual_Particularities;
        public String IT_Beneficiary_Type;
        public Integer IT_Employee_Number;
        public String IT_Concurrency;
        public String IT_CIG;
        public String IT_Opening_Outcome;
        public String IT_Billing_Company_Name;
        public String IT_Short_Company_Name;
        public String IT_Extended_Company_Name;
        public String IT_Commission_Type;
        public Decimal IT_Commission_Percentage;
        public String IT_Discount_Type;
        public Decimal IT_Discount_Percentage;
        public Date StartDate;   
        public String IT_Transport_Cost;
        public String IT_No_Cost_Reason;
        public String IT_Contract_Number;
        public String IT_Attendance_Type;
        public String IT_Contract_Type;
        public Date IT_Expiration_Contract_Date;
        public String IT_Contract_Renewal_Type;
        public Boolean IT_No_Massive_Print;
        public Boolean IT_No_Exclusivity;
        public Boolean IT_Extradiscount;
        public Boolean IT_Multidiscount;
        public Boolean IT_Date_presence;
        public Boolean IT_SDD_Payment;
        public Boolean IT_No_Date_Presence;
        public Boolean IT_Penal_Presence;
        public String IT_Delivery_Date_Bond;
        public Integer IT_Delivery_Term;
        public String IT_Term_Type;
        public Integer IT_Delivery_Fixed_Day;
        public String IT_Fixed_Day_Type;
        public Integer IT_Order_Reception_Term;
        public String IT_Order_Reception_Term_Type;
        public String IT_Contract_Progressive;
        public Boolean IT_No_Sign_Activation_Authorization;
        public String IT_Head_Framework_Code;
        public String IT_Opportunity_Code;
        public Date IT_Campaign_Start_Date;
        public Date IT_Campaign_End_Date;
        public Boolean IT_Only_Client_Copy;
        public Decimal IT_Card_Cost;
        public Boolean IT_Supply_Conditions;
        public Boolean IT_Framework_Warrant;
        public Decimal IT_UTA_Vehicles_Number;
        public Decimal IT_UTA_Monthly_Limit;
        public String IT_UTA_Offer_Type;
        public Decimal IT_Flexben_Startup_Cost;
        public Decimal IT_Flexben_Fee_Cost;
        public String IT_Flexben_Fee_Frequency;
        public String IT_Billing_Frequency;
        public Boolean IT_Forcing;
        public String IT_Payment_Code;
        public String IT_SDD_Payment_Code;
        public String IT_CIN;
        public String IT_Country;
        public String IT_Check_Iban;
        public String IT_SDD_Contract_Code;
        public String IT_SDD_Fiscal_Code;
        public String IT_Authorized;
        public Date IT_SDD_Subscription_Date;
        public String IT_CC;
        public String IT_Bank_Account_Code;
        public String IT_ABI;
        public String IT_CAB;
        public String IT_Order_Frequence_Type;
        public String IT_Fax;
        public String IT_Province;
        public String IT_Toponym;
        public String IT_Address;
        public String IT_Short_Address;
        public String IT_Street_Number;
        public String IT_City;
        public String IT_Additional_Locality;
        public String IT_Postal_Code;
        public Long IT_Municipality_Code;
        public long IT_Hamlet_Code;
        public String IT_Hamlet;
        public Integer IT_Sestiere_Code;
        public Long IT_Street_Code;
        public Integer IT_Road_Arch_Code;
        public String IT_Extra_Urban_Specifications;
        public String IT_Sales_Manager;
        public String IT_New_Client;
        public String IT_New_Service;
        public String IT_New_VAT_Number;
        public String IT_New_Fiscal_Code;
        public String IT_New_Legal_Name;
        public String IT_New_Legal_Form;
        public String IT_New_Local_Client_Segmentation;
        public Boolean IT_New_Split_Payment;
        public String IT_New_Unique_Office_Code;
        public String IT_New_SDI;
        public Integer IT_New_Employees_Number;
        public Integer IT_New_Signatures_Number;
        public String IT_New_Beneficiary_Type;
        public String IT_New_Zone;
        public String IT_New_Sales_Manager;
        public Boolean IT_New_Institution_Flag;
        //public Boolean IT_New_Private_work_for_Institution_Flag;
        public String IT_New_Industry;
        public String IT_New_State;
        public String IT_New_City;
        public String IT_New_Additional_Locality;
        public String IT_New_Toponym;
        public String IT_New_Street;
        public String IT_New_Street_Number;
        public String IT_New_Postal_Code;
        public String IT_New_Opening_Type;
        public String IT_New_Concurrency;
        public String IT_New_Phone;
        public String IT_New_Fax;
        public String IT_New_Mail;
        public String IT_New_PEC_Mail;
        public String IT_New_Billing_PEC_Mail;
        public String IT_AC_User;
    }
    
    
}