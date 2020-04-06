@isTest
public class APIT15_CaseTriggerHandler_Test {
    @isTest (seeAllData = true)
    static void TestCaseContactLink() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        List<Case> caseList = new List<Case>();
        User testUser = APIT14_DataFactory.create_User();
        Account testAcco2 = APIT14_DataFactory.create_PersonAccount();
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        accountTest.ER_Segment__c = 'S';
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
        insert FinancialTest;
        Entitlement EntitlementTest = APIT14_DataFactory.create_Entitlement(accountTest.Id);
        insert EntitlementTest;
        Case caseTest = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest.Subject = '123456';
        caseTest.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Welfare_Provisioning_Case_RT').getRecordTypeId();
        //insert caseTest;
        caseList.add(caseTest);
        Case caseTest2 = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest2.Subject = '123456';
        caseTest2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Support_Case_RT').getRecordTypeId();
        caseTest2.SuppliedEmail = 'test@test.test';
        //insert casetest2;
        caseList.add(caseTest2);

        Case caseTest3 = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest3.Subject = '7890';
        caseTest3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Support_Case_RT').getRecordTypeId();
        //insert casetest3;
        caseList.add(caseTest3);
        Case caseTest4 = APIT14_DataFactory.create_Case(accountTest.Id);
        casetest4.Accountid = null;
        casetest4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Support_Case_RT').getRecordTypeId();
        //insert casetest4;
        caseList.add(caseTest4);
        Case caseTest5 = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest5.Subject = '12345678901';
        casetest5.IT_Financial_Center__c = FinancialTest.id;
        //casetest5.IT_Product__c = 'Flexbenefit';
        casetest5.IT_Circuit__c = null;
        casetest5.Origin = 'Email';
        casetest5.EntitlementId = EntitlementTest.id;
        casetest5.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Support_Case_RT').getRecordTypeId();
        //insert casetest5;
        caseList.add(caseTest5);
        insert caseList;
        
        casetest2.status = 'In_Progress';
        casetest2.SlaStartDate = system.now() - 1;
        update casetest2; 
        system.debug('case5 ' +casetest5);
        List<Case> caseObj = [select id, casenumber from case where id = : casetest4.id];
        EmailMessage testMail = APIT14_DataFactory.create_Emailmessage(casetest5.id);
        //TestMail.fromAddress = 'moreno.bonini@ellysse.it';
        //TestMail.toAddress = 'assistenza.test-it@edenred.com';
        Testmail.Subject = '[JIRA] (2345678) '+caseObj[0].CaseNumber+'-Test email broken alpha beta gamma';
        TestMail.TextBody = 'alpha beta gamma';
        system.debug('EMAIL SUBJECT:: ' +Testmail.Subject);
        insert testMail;
        MilestoneType[] mtLst = [SELECT Id, Name FROM MilestoneType LIMIT 1]; 
        APIT06_MilestoneTimeCalculator calculator = new APIT06_MilestoneTimeCalculator();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new CTIMock());
        
        Integer actualTriggerTime = calculator.calculateMilestoneTriggerTime(casetest5.Id, mtLst[0].Id);
        Integer actualTriggerTime2 = calculator.calculateMilestoneTriggerTime(casetest3.Id, mtLst[0].Id);
        APIT15_CaseTriggerHandler.CTICallout(JSON.serialize(casetest5));
        APIT15_CaseTriggerHandler.isfirsttime = true;
        APIT15_CaseTriggerHandler.CTICalloutClosedCase(JSON.serialize(casetest5));
        
        test.stopTest();
    }    
    


    public class CTIMock implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}');
            response.setStatusCode(200);
            return response; 
        }
    }
}