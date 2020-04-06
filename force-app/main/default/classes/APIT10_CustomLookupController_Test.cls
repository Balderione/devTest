@isTest
public class APIT10_CustomLookupController_Test {
    @isTest
    static void lookupControllerTest(){
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        insert accountTest;
        Contact contactTest = APIT14_DataFactory.create_Contact(accountTest.Id);
        insert contactTest;
        IT_Circuit__c circuitTest = APIT14_DataFactory.create_Circuit(accountTest.Id);
        insert circuitTest;
        ER_Financial_Center__c FinancialTest = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest.ER_Type__c = 'Client'; 
        insert FinancialTest;
        Case caseTest = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest.Subject = '123456';
        caseTest.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Welfare_Provisioning_Case_RT').getRecordTypeId();
        insert caseTest;
        APIT10_CustomLookupController.populateValues(caseTest.id) ;
        APIT10_CustomLookupController.lookUp('T' , 'Account') ;
        APIT10_CustomLookupController.lookUp2('7' , 'Account' , accountTest.Id)  ;
        APIT10_CustomLookupController.lookUp3 ('T' , 'Account' , accountTest.Id , caseTest.RecordTypeId) ;
        APIT10_CustomLookupController.lookUp3 ('T' , 'Account' , circuittest.Id , caseTest.RecordTypeId) ;
        APIT10_CustomLookupController.saveRecord (accountTest.Id , financialTest.Id , circuittest.Id, caseTest.id);
        APIT05_GetRecordType.getRecordType(caseTest.id);
        APIT05_GetRecordType.getCaseInfo(caseTest.id);
        APIT10_CustomLookupController.verifyMatch(caseTest.id);
        
    }

}