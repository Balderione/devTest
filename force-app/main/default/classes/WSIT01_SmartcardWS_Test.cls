@istest
public class WSIT01_SmartcardWS_Test {
    @isTest static void testUpsertCircuitError() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri =
            '/services/apexrest/smartcard/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ "IT_Circuit":[ { "IT_Circuit_Code":"6235", "Name":"nomecircuito", "IT_Receipt_Circuit_Name":"nomescontrino", "IT_Start_Connection_Date":"23-05-2018", "IT_End_Connection_Date":"06-09-2019", "IT_Agreement_Type":"Accordo1", "IT_Meal_Day":"23", "IT_Level":[ { "IT_Circuit_Code":"", "IT_Level_1":"", "IT_Level_1_Description":"Azienda1Descrizione", "IT_Level_2":"", "IT_Level_2_Description":"Azienda2Descrizione", "IT_Level_3":"", "IT_Employee_Type":"555", "IT_Client_Code":"872635", "IT_Particular_Client_Code":"726453", "IT_Service":"Servizio1", "IT_Circuit_Type":"Tipo1", "IT_Service_Type":"" } ], "IT_Circuit_Product":[ { "IT_Circuit_Code":"", "IT_Service":"ServizioTP1", "IT_Service_Type":"Servizio1", "IT_Circuit_Type":"Tipo1", "IT_Invoice_Type":"TipoFatt1", "IT_Management_Type":"Gestione", "IT_Circularity":"Aperta" }, { "IT_Circuit_Code":"6235", "IT_Service":"ServizioTP1", "IT_Service_Type":"", "IT_Circuit_Type":"Tipo1", "IT_Invoice_Type":"TipoFatt1", "IT_Management_Type":"Gestione", "IT_Circularity":"Aperta" } ] } ] }');
        RestContext.request = request;
        RestContext.response= res;
        WSIT01_SmartcardWS.SmartCardUpsert();  
    }
    @isTest static void testUpsertCircuit() {
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
        FinancialTest.IT_Financial_Center__c = '872635';
        insert FinancialTest;
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri =
            '/services/apexrest/smartcard/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ "IT_Circuit":[ { "IT_Circuit_Code":"6235", "Name":"nomecircuito", "IT_Receipt_Circuit_Name":"nomescontrino", "IT_Start_Connection_Date":"2018-09-08", "IT_End_Connection_Date":"2019-09-08", "IT_Agreement_Type":"Accordo1", "IT_Meal_Day":"23", "IT_Level":[ { "IT_Circuit_Code":"6235", "IT_Level_1":"Azi1", "IT_Level_1_Description":"Azienda1Descrizione", "IT_Level_2":"Azi2", "IT_Level_2_Description":"Azienda2Descrizione", "IT_Level_3":"Azi3", "IT_Employee_Type":"555", "IT_Client_Code":"872635", "IT_Particular_Client_Code":"726453", "IT_Service":"Servizio1", "IT_Circuit_Type":"Tipo1", "IT_Service_Type":"T1" } ], "IT_Circuit_Product":[ { "IT_Circuit_Code":"6235", "IT_Service":"ServizioTP1", "IT_Service_Type":"1T", "IT_Circuit_Type":"Tipo1", "IT_Invoice_Type":"TipoFatt1", "IT_Management_Type":"Gestione", "IT_Circularity":"Aperta" }, { "IT_Circuit_Code":"6235", "IT_Service":"ServizioTP1", "IT_Service_Type":"1T", "IT_Circuit_Type":"Tipo1", "IT_Invoice_Type":"TipoFatt1", "IT_Management_Type":"Gestione", "IT_Circularity":"Aperta" } ] } ] }');
        RestContext.request = request;
        RestContext.response= res;
        WSIT01_SmartcardWS.SmartCardUpsert();  
    }
}