@istest
public class WSIT05_ACContact_Test {
    @isTest static void ContactUpsertError() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri = '/services/apexrest/ac_contact/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ "IT_Contact":[ { "IT_Code":"", "LastName":"StringString", "FirstName":"StringString", "Phone":"StringString", "Fax":"StringString", "Email":"test.test@testtest.it", "IT_PEC":"test.test@testtest.it", "IT_Type":"Cli", "IT_Order_Making":true, "IT_Ticket_Receipts":true, "IT_Client_Billing_Recepits":true, "IT_AC_User":"StringString", "IT_Validity_Start_Date":"2019-01-01", "IT_Validity_End_Date":"2019-01-01", "IT_Contact_Association":[ { "IT_Code":"", "IT_Client_Code":"", "IT_Type":"Test1", "IT_Activity_AC":"lkjhg", "IT_Activity_SF":"test", "IT_Delivery_AC":"555666", "IT_Delivery_SF":32, "IT_Contact_Progressive":"15", "IT_Contact_Info":"", "IT_Apparatus_Type":"001DD", "IT_Order_Confirm_Address":true, "IT_Billing_Confirm_Address":true, "IT_Sut":true, "IT_Notifications":true, "IT_AC_User":"StringString" } ] } ] }');
        RestContext.request = request;
        RestContext.response= res;
        WSIT05_ACContact.AnagraficaClientiUpsert();  
    }
    @isTest static void ContactUpsert() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;

        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        insert accountTest;
        Contact contactTest2 = APIT14_DataFactory.create_Contact(accountTest.Id);
        contactTest2.IT_Code__c = 'StringSoc2';
        contactTest2.IT_Type__c = 'Soc';
        insert contactTest2;
        Contact contactTest = APIT14_DataFactory.create_Contact(accountTest.Id);
        contactTest.IT_Code__c = 'StringString';
        insert contactTest;
        IT_Contact_Detail__c contactDetailTest = APIT14_DataFactory.create_Contact_Detail(contactTest.Id);
        contactDetailTest.IT_Code__c = 'StringString';
        insert contactDetailTest;
        ER_Financial_Center__c FinancialTest = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest.ER_Type__c = 'Client'; 
        FinancialTest.IT_Financial_Center__c = '454256';
        insert FinancialTest;
        ER_Delivery_Site__c deliverysiteTest = APIT14_DataFactory.create_DeliverySite(FinancialTest.Id, accountTest.Id);
        deliverysiteTest.IT_Delivery_AC__c = '555666';
        insert deliverysiteTest;
        ER_Distribution_Point__c distributionPointTest = APIT14_DataFactory.create_DistributionPoint(FinancialTest.Id, deliverysiteTest.Id);
        distributionPointTest.IT_AC_Activity__c = 'lkjhg';
        insert distributionPointTest;

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri = '/services/apexrest/ac_contact/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ "IT_Contact":[ { "IT_Code":"StringString", "LastName":"StringString", "FirstName":"StringString", "Phone":"StringString", "Fax":"StringString", "Email":"test.test@testtest.it", "IT_PEC":"test.test@testtest.it", "IT_Type":"Cli", "IT_Order_Making":true, "IT_Ticket_Receipts":true, "IT_Client_Billing_Recepits":true, "IT_AC_User":"StringString", "IT_Validity_Start_Date":"2019-01-01", "IT_Validity_End_Date":"2019-01-01", "IT_Contact_Association":[ { "IT_Code":"StringString", "IT_Client_Code":"454256", "IT_Type":"Test1", "IT_Activity_AC":"lkjhg", "IT_Activity_SF":"test", "IT_Delivery_AC":"555666", "IT_Delivery_SF":32, "IT_Contact_Progressive":"16", "IT_Contact_Info":"StringString", "IT_Apparatus_Type":"001", "IT_Order_Confirm_Address":true, "IT_Billing_Confirm_Address":true, "IT_Sut":true, "IT_Notifications":true, "IT_AC_User":"StringString" } ] } ] }');
        RestContext.request = request;
        RestContext.response= res;
        WSIT05_ACContact.AnagraficaClientiUpsert();  
    }
    @isTest static void ContactUpsertErrorField() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;

        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        insert accountTest;
        Contact contactTest = APIT14_DataFactory.create_Contact(accountTest.Id);
        insert contactTest;
        ER_Financial_Center__c FinancialTest = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest.ER_Type__c = 'Client'; 
        FinancialTest.IT_Financial_Center__c = '454256';
        insert FinancialTest;
        ER_Delivery_Site__c deliverysiteTest = APIT14_DataFactory.create_DeliverySite(FinancialTest.Id, accountTest.Id);
        deliverysiteTest.IT_Delivery_AC__c = '555666';
        insert deliverysiteTest;
        ER_Distribution_Point__c distributionPointTest = APIT14_DataFactory.create_DistributionPoint(FinancialTest.Id, deliverysiteTest.Id);
        distributionPointTest.IT_AC_Activity__c = 'lkjhg';
        insert distributionPointTest;

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri = '/services/apexrest/ac_contact/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ "IT_Contact":[ { "IT_Code":"StringString", "LastName":"StringString", "FirstName":"StringString", "Phone":"StringString", "Fax":"StringString", "Email":"test.test@testtest.it", "IT_PEC":"test.test@testtest.it", "IT_Type":"Cli", "IT_Order_Making":true, "IT_Ticket_Receipts":true, "IT_Client_Billing_Recepits":true, "IT_AC_User":"StringString", "IT_Validity_Start_Date":"2019-01-01", "IT_Validity_End_Date":"2019-01-01", "IT_Contact_Association":[ { "IT_Code":"StringString", "IT_Client_Code":"454256", "IT_Type":"Test1", "IT_Activity_AC":"lkjhg", "IT_Activity_SF":"test", "IT_Delivery_AC":"555666", "IT_Delivery_SF":32, "IT_Contact_Progressive":"18", "IT_Contact_Info":"StringString", "IT_Apparatus_Type":"001M", "IT_Order_Confirm_Address":true, "IT_Billing_Confirm_Address":true, "IT_Sut":true, "IT_Notifications":true, "IT_AC_User":"StringString" } ] } ] }');
        RestContext.request = request;
        RestContext.response= res;
        WSIT05_ACContact.AnagraficaClientiUpsert();  
    }
}