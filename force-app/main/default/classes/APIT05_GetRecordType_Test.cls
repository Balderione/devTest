@isTest 
public class APIT05_GetRecordType_Test {
 @isTest 
    static void TestCaseContactLink() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        User testUser = APIT14_DataFactory.create_User();
        Account testAcco2 = APIT14_DataFactory.create_PersonAccount();
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        insert accountTest;
        
        Contact contactTest = APIT14_DataFactory.create_Contact(accountTest.Id);
        insert contactTest;
        Contract contractTest = APIT14_DataFactory.create_Contract(accountTest.Id);
        contractTest.ER_Contract_External_ID__c = 'Tes2w';
        insert contractTest;
        IT_Circuit__c circuitTest = APIT14_DataFactory.create_Circuit(accountTest.Id);
        insert circuitTest;
        ER_Financial_Center__c FinancialTest = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest.ER_Type__c = 'Client';
        FinancialTest.IT_Service__c = '1X';
        insert FinancialTest;
                ER_Financial_Center__c FinancialTest2 = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest2.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest2.ER_Type__c = 'Client';
        FinancialTest2.IT_Service__c = '1W';
        FinancialTest2.IT_Financial_Center__c = '476574';
        insert FinancialTest2;
                ER_Financial_Center__c FinancialTest3 = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest3.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest3.ER_Type__c = 'Client';
        FinancialTest3.IT_Service__c = '1V';
        insert FinancialTest3;
                ER_Financial_Center__c FinancialTest4 = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest4.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest4.ER_Type__c = 'Client';
        FinancialTest4.IT_Service__c = '1G';
        insert FinancialTest4;
        Entitlement EntitlementTest = APIT14_DataFactory.create_Entitlement(accountTest.Id);
        insert EntitlementTest;
        Case caseTest = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest.Subject = '123456';
        caseTest.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Welfare_Provisioning_Case_RT').getRecordTypeId();
        casetest.IT_Financial_Center__c = FinancialTest.id;
        insert caseTest;
        Case caseTest2 = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest2.Subject = '123456';
        caseTest2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Welfare_Provisioning_Case_RT').getRecordTypeId();
        casetest2.IT_Financial_Center__c = FinancialTest2.id;
        insert caseTest2;
        Case caseTest3 = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest3.Subject = '123456';
        caseTest3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Welfare_Provisioning_Case_RT').getRecordTypeId();
        casetest3.IT_Financial_Center__c = FinancialTest3.id;
        insert caseTest3;
        Case caseTest4 = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest4.Subject = '123456';
        caseTest4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Welfare_Provisioning_Case_RT').getRecordTypeId();
        casetest4.IT_Financial_Center__c = FinancialTest4.id;
        insert caseTest4;
        EmailMessage mail = new EmailMessage();
        mail.Subject = 'R: 123456 piu\'';
        mail.parentid = casetest2.id;
        insert mail;
        EmailMessage mail2 = new EmailMessage();
        mail2.Subject = 'I: 123456 piu\'';
        mail2.parentid = casetest3.id;
        insert mail2;
        
        Test.setMock(HttpCalloutMock.class, new InvoicesMock());
        Test.startTest();
        APIT05_GetRecordType.getRecordType(caseTest.id);
        APIT05_GetRecordType.getRecordType(caseTest2.id);
        APIT05_GetRecordType.getRecordType(caseTest3.id);
        APIT05_GetRecordType.getRecordType(caseTest4.id);
        APIT05_GetRecordType.getCaseInfo(caseTest4.id);
        //APIT05_GetRecordType.getStatementsGHOST(caseTest2.id);
        Test.stopTest();
    }
    

    
    
    
    
    
    
        public class InvoicesMock implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ "meta": { "messages": [], "status": "succeeded" }, "data": [ { "document_number": "DOC12345", "document_type": "some type", "document_date": "2018-12-17", "expiry_date": "2018-12-17", "amount_due": 123.1 }, { "document_number": "DOC12346", "document_type": "some type", "document_date": "2018-12-17", "expiry_date": "2018-12-17", "amount_due": 123.1 } ] }');
        response.setStatusCode(200);
        return response; 
    }
    }

}