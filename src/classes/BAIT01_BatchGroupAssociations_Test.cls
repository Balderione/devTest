@isTest
public class BAIT01_BatchGroupAssociations_Test {
    @isTest
    static void batchGroupAssociations(){
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        accountTest.ER_VAT_Number__c = '02554698475';
        insert accountTest;
        Contact contactTest = APIT14_DataFactory.create_Contact(accountTest.Id);
        contactTest.IT_Code__c = 'StringString';
        insert contactTest;
        ER_Financial_Center__c FinancialTest = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest.ER_Type__c = 'Client'; 
        FinancialTest.IT_Financial_Center__c = '445566';
        insert FinancialTest;
        IT_Group_Code__c groupCodeTest = APIT14_DataFactory.create_GroupCode(FinancialTest.Id);
        groupCodeTest.IT_Client_Code__c = '445566';
        insert groupCodeTest;
        IT_Group__c groupTest = APIT14_DataFactory.create_Group(FinancialTest.Id);
        insert groupTest;
        
        BAIT01_BatchGroupAssociations batchRun = new BAIT01_BatchGroupAssociations();
        database.executebatch(batchRun,10);

    }
}