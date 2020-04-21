@isTest
public class BAIT02_BatchFinancialCenterChilds_Test {
    @isTest
    static void batchFinancialCenterChilds(){
        List<ER_Financial_Center__c> FCList = new List<ER_Financial_Center__c>();
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
        FinancialTest.IT_Circuit_Code__c = 'CI5566';
        FinancialTest.IT_Service__c = '1B';
        FCList.add(FinancialTest);
        ER_Financial_Center__c FinancialTest2 = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest2.ER_Card_Operational_System_ID__c = 'Tes3w';
        FinancialTest2.ER_Type__c = 'Client'; 
        FinancialTest2.IT_Financial_Center__c = '445568';
        FinancialTest2.IT_Circuit_Code__c = 'CI5566';
        FinancialTest2.IT_Service__c = '2X';
        FCList.add(FinancialTest2);
        insert FCList;
        
        BAIT02_BatchFinancialCenterChilds batchRun = new BAIT02_BatchFinancialCenterChilds();
        database.executebatch(batchRun,200);

    }
}