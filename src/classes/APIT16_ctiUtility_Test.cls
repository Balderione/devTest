@isTest
public class APIT16_ctiUtility_Test {
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
        FinancialTest.IT_Financial_Center__c = '445566';
        insert FinancialTest;
        Case caseTest = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest.Subject = '445566';
        caseTest.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Welfare_Provisioning_Case_RT').getRecordTypeId();
        insert caseTest;
        id userId = APIT16_ctiUtility.getCurrentUser();
        APIT16_ctiUtility.changeOwner('MEDIAID' , caseTest.id , userId , 'CT7AGENTID', 'callId' );
        APIT16_ctiUtility.logCall(caseTest.id , '12', '913420800', '913420800', 'Hello', true);
        APIT16_ctiUtility.createCase ('MEDIAID' ,accountTest.id , '1' , '1' , '1', 'DNIS', '445566', 'ANI', 'UUID', 'CALLID', 'CT7AGENTID' );
        
    }
}