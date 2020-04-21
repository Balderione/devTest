@istest public class APIT02_InvoicesListController_Test {
    @isTest static void testInvoicesList() {
        date dataDa = date.today();
        date DataA = date.today();
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        insert accountTest;
        Case caseTest = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest.Subject = '123456';
        caseTest.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Welfare_Provisioning_Case_RT').getRecordTypeId();
        insert caseTest;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InvoicesMock());
        APIT02_InvoicesListController.callCase(caseTest.id);
        APIT02_InvoicesListController.listInvoices(dataDa, dataA, caseTest.Id , '123456');
        APIT02_InvoicesListController.data tot = new APIT02_InvoicesListController.data();
		tot.document_number = '';
        tot.document_type = '';
        tot.document_date = date.today();
        tot.expiry_date = date.today();
        tot.e_invoice_status_description = '';
        tot.amount_due = 4;
        tot.e_invoice_status = '';
        tot.detailURL = '';
        Test.stopTest();
    }
    
    public class InvoicesMock implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ "meta": { "messages": [], "status": "succeeded" }, "data": [ { "document_number": "DOC12345", "document_type": "some type", "document_date": "2018-12-17", "e_invoice_status_description": "Test", "expiry_date": "2018-12-17", "amount_due": 123.1 }, { "document_number": "DOC12346", "document_type": "some type", "document_date": "2018-12-17", "e_invoice_status_description": "Test", "expiry_date": "2018-12-17", "amount_due": 123.1 } ] }');
        response.setStatusCode(200);
        return response; 
    }
    }
}