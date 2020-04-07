@isTest
public class APIT03_Addresses_Getter_Test {
    
    static testMethod void testAddress (){ 
        //TESTCOMMENT
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        User testUser = APIT14_DataFactory.create_User();
        Account testAcco2 = APIT14_DataFactory.create_PersonAccount();
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        insert accountTest;
        Contact contactTest = APIT14_DataFactory.create_Contact(accountTest.Id);
        insert contactTest;
        ER_Financial_Center__c FinancialTest = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest.ER_Type__c = 'Client'; 
        insert FinancialTest;
        ER_Delivery_Site__c delsiteTest = APIT14_DataFactory.create_DeliverySite(FinancialTest.id ,accountTest.Id);
        insert delsiteTest;
        ER_Distribution_Point__c distPointTest = APIT14_DataFactory.create_DistributionPoint(FinancialTest.id ,delsiteTest.Id);
        insert distPointTest;
        Case caseTest = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest.Subject = '123456';
        caseTest.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Welfare_Provisioning_Case_RT').getRecordTypeId();
        insert caseTest;
        
        
        
        
        
        
        APIT03_Addresses_Getter.fetchAddress(accountTest.id , 'Account');
        APIT03_Addresses_Getter.fetchAddress(delsiteTest.id , 'ER_Delivery_Site__c');
        
        APIT03_Addresses_Getter.associateAddress(accountTest.id + ';' +FinancialTest.id + ';' + delsiteTest.id + ';' + distPointTest.id , '26843' , 'Lodi', '38000000022', 'Codogno', '38000000022', 'Via Mulito, 1', 'Cambonino' , '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0');
        APIT03_Addresses_Getter.insertAndAssociateAddress(accountTest);
        
        
    }
    
    static testMethod void testCallout (){ 
        
        /*MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(
            'https://salesforce.dev.it.edenred.io/v1/referential/addresses/provinces', 'mockResponse');
        multimock.setStaticResource(
            'https://salesforce.dev.it.edenred.io/v1/referential/addresses/provinces//municipalities', 'mockResponse2');
        multimock.setStaticResource(
            'https://salesforce.dev.it.edenred.io/v1/referential/addresses/normalize', 'mockResponse3');
        multimock.setStaticResource(
            'https://salesforce.dev.it.edenred.io/v1/referential/addresses/municipalities//hamlets', 'mockResponse4');
        multimock.setStaticResource(
            'https://salesforce.dev.it.edenred.io/v1/referential/addresses/municipalities//*', 'mockResponse5');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);*/
        

        Test.setMock(HttpCalloutMock.class, new StradarioMock());
        
        APIT03_Addresses_Getter.getProvincesStradario();
        APIT03_Addresses_Getter.getMunicipalitiesStradario('38000000022');
        APIT03_Addresses_Getter.callAutocomplete('provincia');
        APIT03_Addresses_Getter.fetchHamlets('street');
        APIT03_Addresses_Getter.getSuggestions('input' , 'inputs');
        APIT03_Addresses_Getter.callNormalize('json');
    }
    
    public class StradarioMock implements HttpCalloutMock {
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