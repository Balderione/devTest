@isTest
public class BAIT03_BatchPopulateLookupAccount_Test {
    @isTest
    static void batchPopulateCorrectLookupAccount(){
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
        FinancialTest.IT_Client_Status__c = '10';

        FCList.add(FinancialTest);
        insert FCList;
        
        BAIT03_BatchPopulateCorrectLookupAccount batchRun = new BAIT03_BatchPopulateCorrectLookupAccount();
        database.executebatch(batchRun,200);

    }
}