@istest
public class WSIT07_AC_Condition_Change_Test { 
    @isTest static void ConditiontUpsertError() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri = '/services/apexrest/ac_conditionchange/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ "IT_Condition_Change":[ { "IT_Reason":"String", "IT_User_Authorization_Code":"String", "IT_Request_Status":"String", "IT_Request_Date":"2019-01-01", "IT_Accepted_Request_Date":"2019-01-01", "IT_Editing_Reason":"String", "IT_Applicant_User":"String", "IT_Authorization_Date":"2019-01-01", "IT_Acceptance_User":"String", "IT_Registration_Date":"2019-01-01", "IT_Registration_User":"String", "IT_Company_Name_Change":true, "IT_Address_Change":true, "IT_Administrative_Group":"String", "IT_Statistic_Group":"String", "IT_Transport_Cost_Presence":true, "IT_Reopening_Date":"2019-01-01", "IT_Extradiscount_Percentage":10.22, "IT_Extradiscount_Type":"String", "IT_Discount_Percentage_2":10.22, "IT_Discount_Validity_Date_2":"2019-01-01", "IT_Discount_Percentage_3":10.22, "IT_Discount_Validity_Date_3":"2019-01-01", "IT_Not_Send_Contract":true, "IT_Standard_Master_Data":true, "IT_Bond":11, "IT_Opening":"String", "IT_Printed_Contract":true, "IT_Payment_Progressive_Number":11, "IT_Signed_Contract":true, "IT_Client_Code":"String", "IT_Contractual_Particularities":"String", "IT_Beneficiary_Type":"String", "IT_Employee_Number":11, "IT_Concurrency":"String", "IT_CIG":"String", "IT_Opening_Outcome":"String", "IT_Billing_Company_Name":"String", "IT_Short_Company_Name":"String", "IT_Extended_Company_Name":"String", "IT_Commission_Type":"String", "IT_Commission_Percentage":10.22, "IT_Discount_Type":"String", "IT_Discount_Percentage":10.22, "StartDate":"2019-01-01", "IT_Transport_Cost":"String", "IT_No_Cost_Reason":"String", "IT_Contract_Number":"String", "IT_Attendance_Type":"String", "IT_Contract_Type":"String", "IT_Expiration_Contract_Date":"2019-01-01", "IT_Contract_Renewal_Type":"String", "IT_No_Massive_Print":true, "IT_No_Exclusivity":true, "IT_Extradiscount":true, "IT_Multidiscount":true, "IT_Date_presence":true, "IT_SDD_Payment":true, "IT_No_Date_Presence":true, "IT_Penal_Presence":true, "IT_Delivery_Date_Bond":"String", "IT_Delivery_Term":11, "IT_Term_Type":"String", "IT_Delivery_Fixed_Day":11, "IT_Fixed_Day_Type":"String", "IT_Order_Reception_Term":11, "IT_Order_Reception_Term_Type":"String", "IT_Contract_Progressive":"String", "IT_No_Sign_Activation_Authorization":true, "IT_Head_Framework_Code":"String", "IT_Opportunity_Code":"String", "IT_Campaign_Start_Date":"2019-01-01", "IT_Campaign_End_Date":"2019-01-01", "IT_Only_Client_Copy":true, "IT_Card_Cost":10.22, "IT_Supply_Conditions":true, "IT_Framework_Warrant":true, "IT_UTA_Vehicles_Number":10.22, "IT_UTA_Monthly_Limit":10.22, "IT_UTA_Offer_Type":"String", "IT_Flexben_Startup_Cost":10.22, "IT_Flexben_Fee_Cost":10.22, "IT_Flexben_Fee_Frequency":"String", "IT_Billing_Frequency":"String", "IT_Forcing":true, "IT_Payment_Code":"String", "IT_SDD_Payment_Code":"String", "IT_CIN":"String", "IT_Country":"String", "IT_Check_Iban":"String", "IT_SDD_Contract_Code":"String", "IT_SDD_Fiscal_Code":"String", "IT_Authorized":true, "IT_SDD_Subscription_Date":"2019-01-01", "IT_CC":"String", "IT_Bank_Account_Code":"String", "IT_ABI":"String", "IT_CAB":"String", "IT_Order_Frequence_Type":"String", "IT_Fax":"String", "IT_Province":"String", "IT_Toponym":"String", "IT_Address":"String", "IT_Short_Address":"String", "IT_Street_Number":"String", "IT_City":"String", "IT_Additional_Locality":"String", "IT_Postal_Code":"String", "IT_Municipality_Code":11, "IT_Hamlet_Code":11, "IT_Hamlet":"String", "IT_Sestiere_Code":11, "IT_Street_Code":11, "IT_Road_Arch_Code":11, "IT_Extra_Urban_Specifications":"String", "IT_Sales_Manager":"String", "IT_New_Client":"String", "IT_New_Service":"String", "IT_New_VAT_Number":"String", "IT_New_Fiscal_Code":"String", "IT_New_Legal_Name":"String", "IT_New_Legal_Form":"String", "IT_New_Local_Client_Segmentation":"String", "IT_New_Split_Payment":true, "IT_New_Unique_Office_Code":"String", "IT_New_SDI":"String", "IT_New_Employees_Number":11, "IT_New_Signatures_Number":11, "IT_New_Beneficiary_Type":"String", "IT_New_Zone":"String", "IT_New_Sales_Manager":"String", "IT_New_Institution_Flag":true, "IT_New_Industry":"String", "IT_New_State":"String", "IT_New_City":"String", "IT_New_Additional_Locality":"String", "IT_New_Toponym":"String", "IT_New_Street":"String", "IT_New_Street_Number":"String", "IT_New_Postal_Code":"String", "IT_New_Opening_Type":"String", "IT_New_Concurrency":"String", "IT_New_Phone":"String", "IT_New_Fax":"String", "IT_New_Mail":"String", "IT_New_PEC_Mail":"String", "IT_New_Billing_PEC_Mail":"String", "IT_AC_User":"String"  } ] }');
        RestContext.request = request;
        RestContext.response= res;
        WSIT07_AC_Condition_Change.ConditionChangeUpsert(); 
    }
    @isTest static void ConditiontUpsert() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        accountTest.ER_VAT_Number__c = '02554698475';
        insert accountTest;
        Contact contactTest = APIT14_DataFactory.create_Contact(accountTest.Id);
        contactTest.IT_Code__c = 'StringString';
        insert contactTest;
        IT_Contact_Detail__c contactDetailTest = APIT14_DataFactory.create_Contact_Detail(contactTest.Id);
        contactDetailTest.IT_Code__c = 'StringString';
        insert contactDetailTest;
        ER_Financial_Center__c FinancialTest = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest.ER_Type__c = 'Client'; 
        FinancialTest.IT_Financial_Center__c = '445566';
        insert FinancialTest;

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri = '/services/apexrest/ac_conditionchange/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ "IT_Condition_Change":[ { "IT_Reason":"", "IT_User_Authorization_Code":"", "IT_Request_Status":"2", "IT_Request_Date":"2019-01-01", "IT_Accepted_Request_Date":"2019-01-01", "IT_Editing_Reason":"", "IT_Applicant_User":"", "IT_Authorization_Date":"2019-01-01", "IT_Acceptance_User":"", "IT_Registration_Date":"2019-01-01", "IT_Registration_User":"", "IT_Company_Name_Change":true, "IT_Address_Change":true, "IT_Administrative_Group":"", "IT_Statistic_Group":"", "IT_Transport_Cost_Presence":true, "IT_Reopening_Date":"2019-01-01", "IT_Extradiscount_Percentage":10.22, "IT_Extradiscount_Type":"", "IT_Discount_Percentage_2":10.22, "IT_Discount_Validity_Date_2":"2019-01-01", "IT_Discount_Percentage_3":10.22, "IT_Discount_Validity_Date_3":"2019-01-01", "IT_Not_Send_Contract":true, "IT_Standard_Master_Data":true, "IT_Bond":11, "IT_Opening":"", "IT_Printed_Contract":true, "IT_Payment_Progressive_Number":11, "IT_Signed_Contract":true, "IT_Client_Code":"445566", "IT_Contractual_Particularities":"", "IT_Beneficiary_Type":"", "IT_Employee_Number":11, "IT_Concurrency":"", "IT_CIG":"", "IT_Opening_Outcome":"", "IT_Billing_Company_Name":"", "IT_Short_Company_Name":"", "IT_Extended_Company_Name":"", "IT_Commission_Type":"", "IT_Commission_Percentage":10.22, "IT_Discount_Type":"", "IT_Discount_Percentage":10.22, "StartDate":"2019-01-01", "IT_Transport_Cost":"", "IT_No_Cost_Reason":"", "IT_Contract_Number":"", "IT_Attendance_Type":"", "IT_Contract_Type":"", "IT_Expiration_Contract_Date":"2019-01-01", "IT_Contract_Renewal_Type":"", "IT_No_Massive_Print":true, "IT_No_Exclusivity":true, "IT_Extradiscount":true, "IT_Multidiscount":true, "IT_Date_presence":true, "IT_SDD_Payment":true, "IT_No_Date_Presence":true, "IT_Penal_Presence":true, "IT_Delivery_Date_Bond":"", "IT_Delivery_Term":11, "IT_Term_Type":"", "IT_Delivery_Fixed_Day":11, "IT_Fixed_Day_Type":"", "IT_Order_Reception_Term":11, "IT_Order_Reception_Term_Type":"", "IT_Contract_Progressive":"", "IT_No_Sign_Activation_Authorization":true, "IT_Head_Framework_Code":"", "IT_Opportunity_Code":"", "IT_Campaign_Start_Date":"2019-01-01", "IT_Campaign_End_Date":"2019-01-01", "IT_Only_Client_Copy":true, "IT_Card_Cost":10.22, "IT_Supply_Conditions":true, "IT_Framework_Warrant":true, "IT_UTA_Vehicles_Number":10.22, "IT_UTA_Monthly_Limit":10.22, "IT_UTA_Offer_Type":"", "IT_Flexben_Startup_Cost":10.22, "IT_Flexben_Fee_Cost":10.22, "IT_Flexben_Fee_Frequency":"", "IT_Billing_Frequency":"", "IT_Forcing":true, "IT_Payment_Code":"", "IT_SDD_Payment_Code":"", "IT_CIN":"", "IT_Country":"", "IT_Check_Iban":"", "IT_SDD_Contract_Code":"", "IT_SDD_Fiscal_Code":"", "IT_Authorized":true, "IT_SDD_Subscription_Date":"2019-01-01", "IT_CC":"", "IT_Bank_Account_Code":"", "IT_ABI":"", "IT_CAB":"", "IT_Order_Frequence_Type":"", "IT_Fax":"", "IT_Province":"", "IT_Toponym":"", "IT_Address":"", "IT_Short_Address":"", "IT_Street_Number":"", "IT_City":"", "IT_Additional_Locality":"", "IT_Postal_Code":"", "IT_Municipality_Code":11, "IT_Hamlet_Code":11, "IT_Hamlet":"", "IT_Sestiere_Code":11, "IT_Street_Code":11, "IT_Road_Arch_Code":11, "IT_Extra_Urban_Specifications":"", "IT_Sales_Manager":"", "IT_New_Client":"", "IT_New_Service":"", "IT_New_VAT_Number":"", "IT_New_Fiscal_Code":"", "IT_New_Legal_Name":"", "IT_New_Legal_Form":"", "IT_New_Local_Client_Segmentation":"", "IT_New_Split_Payment":true, "IT_New_Unique_Office_Code":"", "IT_New_SDI":"", "IT_New_Employees_Number":11, "IT_New_Signatures_Number":11, "IT_New_Beneficiary_Type":"", "IT_New_Zone":"", "IT_New_Sales_Manager":"", "IT_New_Institution_Flag":true, "IT_New_Industry":"", "IT_New_State":"", "IT_New_City":"", "IT_New_Additional_Locality":"", "IT_New_Toponym":"", "IT_New_Street":"", "IT_New_Street_Number":"", "IT_New_Postal_Code":"", "IT_New_Opening_Type":"", "IT_New_Concurrency":"", "IT_New_Phone":"", "IT_New_Fax":"", "IT_New_Mail":"", "IT_New_PEC_Mail":"", "IT_New_Billing_PEC_Mail":"", "IT_AC_User":""  } ] }');
        RestContext.request = request;
        RestContext.response= res;
        WSIT07_AC_Condition_Change.ConditionChangeUpsert(); 
    }
}