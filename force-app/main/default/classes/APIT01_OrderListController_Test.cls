@istest public class APIT01_OrderListController_Test {
    @isTest static void testOrderList() {
        Test.setMock(HttpCalloutMock.class, new OrdersMock());
        date dataDa = date.today();
        date DataA = date.today();
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        insert accountTest;
        Case caseTest = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest.Subject = '123456';
        caseTest.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Welfare_Provisioning_Case_RT').getRecordTypeId();
        insert caseTest;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OrdersMock());
        APIT01_OrderListController.getPicklistValues('Case' , 'Status');
        APIT01_OrderListController.callCase(caseTest.id);
        APIT01_OrderListController.listOrder(dataDa, dataA, '6235', '872635', 'piva', 'ServizioTP1', true, 'rawHmac' , caseTest.id);
        APIT01_OrderListController.listOrder(dataDa, dataA, '6235', '872635', 'piva', 'ServizioTP1', false, 'rawHmac' , caseTest.id);
        string jsonstring = '{"isOutcomeKo":false, "errorCode":"OK", "errorDescription":"NO_ERRORS", "dettaglioOrdiniResponse":0, "applicazione":"SGOP", "codiceCircuito":"A001", "codiceSocieta":832, "codiceCliente":"540156", "annoOrdine":2019, "codiceOrdine":20665, "dataCaricamento":"2019-07-23", "descrServizio":"Ticket Compliments", "descrCanale":"Portale", "tipoOrdine":"Standard", "importoOrdine":1723.56, "numTotBuoni":1050, "descrPagamento":"Bonifico Anticipato", "dataConsegna":"2019-02-15", "descrStatoOrdine":"CONSEGNATO AL CLIENTE", "personalizzato":"D", "isOrdineModificabile":false},{"isOutcomeKo":false, "errorCode":"OK", "errorDescription":"NO_ERRORS", "dettaglioOrdiniResponse":0, "applicazione":"SGOP", "codiceCircuito":"A001", "codiceSocieta":832, "codiceCliente":"540156", "annoOrdine":2019, "codiceOrdine":50526, "dataCaricamento":"2019-07-19", "descrServizio":"Ticket Restaurant", "descrCanale":"Portale", "tipoOrdine":"Standard", "importoOrdine":1683.56, "numTotBuoni":1050, "descrPagamento":"Bonifico Anticipato", "dataConsegna":"2019-02-15", "descrStatoOrdine":"CONSEGNATO AL CLIENTE", "personalizzato":"D", "isOrdineModificabile":false}';
        APIT01_OrderListController.data listOrder = (APIT01_OrderListController.data) JSON.deserialize (jsonString, APIT01_OrderListController.data.class);
        
        listorder.application  = '';
        listorder.circuit_code  = '';
        listorder.company_ref  = '9';
        listorder.client_ref  = '';
        listorder.order_year  = '';
        listorder.order_ref  = '9';
        listorder.upload_date  = date.today();
        listorder.delivery_date  = date.today();
        listorder.service_description  = '';
        listorder.channel_description  = '';
        listorder.order_type  = '';
        listorder.order_amount  = 0;
        listorder.voucher_number  = 9;
        listorder.payment_description  = '';
        listorder.order_status_description  = '';
        listorder.customized  = '';
        listorder.is_modifiable  = true;
        Test.stopTest();
        
    }
    
    public class OrdersMock implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ "meta": { "messages": [], "status": "succeeded" }, "data": [ { "application": "SGOP", "circuit_code": "A001", "company_ref": 832, "client_ref": 540156, "order_year": "2019", "order_ref": 1, "upload_date": "2019-07-02", "delivery_date": "2019-07-02", "service_description": "Ticket Restaurant", "channel_description": "Portale", "order_type": "Standard", "order_amount": 1723.55, "voucher_number": 1050, "payment_description": "Portale", "order_status_description": "CONSEGNATO AL CLIENTE", "customized": "D", "is_modifiable": true } ] }');
        response.setStatusCode(200);
        return response; 
    }
    }
}