@isTest
public class APIT23_DetailListController_Test {
    @isTest static void testDetail() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        accountTest.ER_Segment__c = 'S';
        insert accountTest;
        Contact contactTest = APIT14_DataFactory.create_Contact(accountTest.Id);
        insert contactTest;
        ER_Financial_Center__c FinancialTest = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest.ER_Type__c = 'Client'; 
        insert FinancialTest;
        IT_Contact_Detail__c detailTest = APIT14_DataFactory.create_Contact_Detail(contactTest.id);
        insert detailTest;
        IT_Contact_Association__c assoTest = APIT14_DataFactory.create_ContactASS(detailTest.id , FinancialTest.id);
        insert assoTest;
        APIT23_DetailListController.getData(10, 1, 'Name', 'DESC', FinancialTest.id);
        assoTest.IT_Send_SUT__c = true;
        List<IT_Contact_Association__c> listToUpdate = new List<IT_Contact_Association__c>();
        listToUpdate.add(assoTest);
        APIT23_DetailListController.updateRecords(listToUpdate);
    }
}