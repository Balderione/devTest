@isTest
public class APIT12_CallOutbound_Test {
    @isTest
    static void CallOutbound(){
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        accountTest.ER_VAT_Number__c = '02554698475';
        insert accountTest;
        Contact contactTest = APIT14_DataFactory.create_Contact(accountTest.Id);
        contactTest.IT_Code__c = 'StringString';
        insert contactTest;
        IT_Contact_Detail__c contactDetailTest = APIT14_DataFactory.create_Contact_Detail(contactTest.Id);
        contactDetailTest.IT_Code__c = 'StringString';
        insert contactDetailTest;
        ER_Financial_Center__c FinancialTest = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest.ER_Type__c = 'Client'; 
        FinancialTest.IT_Financial_Center__c = '445566';
        insert FinancialTest;
        ER_Delivery_Site__c deliverysiteTest = APIT14_DataFactory.create_DeliverySite(FinancialTest.Id, accountTest.Id);
        deliverysiteTest.IT_Delivery_AC__c = '555666';
        insert deliverysiteTest;
        ER_Distribution_Point__c distributionPointTest = APIT14_DataFactory.create_DistributionPoint(FinancialTest.Id, deliverysiteTest.Id);
        distributionPointTest.IT_AC_Activity__c = 'lkjhg';
        insert distributionPointTest;
        ER_Bank_Account__c bankAccountTest = APIT14_DataFactory.create_BankAccount(FinancialTest.Id);
        bankAccountTest.IT_Client_Code__c = '445566';
        insert bankAccountTest;

        IT_Group_Code__c groupCodeTest = APIT14_DataFactory.create_GroupCode(FinancialTest.Id);
        groupCodeTest.IT_Client_Code__c = '445566';
        insert groupCodeTest;
        Contract contractTest = APIT14_DataFactory.create_Contract(accountTest.Id);
        insert contractTest;
        ER_ContractLineItem__c contractLineItemTest = APIT14_DataFactory.create_ContractLineItem(contractTest.Id);
        insert contractLineItemTest;
        IT_Contact_Association__c contactASSTest = APIT14_DataFactory.create_ContactASS(contactDetailTest.Id, FinancialTest.Id);
        insert contactASSTest;
        IT_Intent_Declaration__c intentDeclarationTest = APIT14_DataFactory.create_IntentDeclaration(accountTest.Id);
        insert intentDeclarationTest;
        IT_Group__c groupTest = APIT14_DataFactory.create_Group(FinancialTest.Id);
        insert groupTest;
        
        update contactTest;
        update contactDetailTest;
        FinancialTest.IT_Send_SUT_Printout__c = true;
        update FinancialTest;
        FinancialTest.IT_Opening_Outcome__c = '001';
        update FinancialTest;
        FinancialTest.IT_Change_Address__c = true;
        update FinancialTest;
        update deliverysiteTest;
        deliverysiteTest.IT_Change_Address__c = true;
        update deliverysiteTest;
        update distributionPointTest;
        distributionPointTest.IT_Change_Address__c = true;
        update distributionPointTest;
        update bankAccountTest;
        update groupCodeTest;
        update contractLineItemTest;
        update contactASSTest;
        update contractTest;
        contractTest.IT_Change_Document__c = true;
        update contractTest;
        contractTest.IT_Change_Economic_Conditions__c = true;
        update contractTest;
        update intentDeclarationTest;
        update groupTest;

        IT_Request__c reqTest = APIT14_DataFactory.create_Request(FinancialTest.Id);
        reqTest.IT_Client_Code__c = '445566';
        insert reqTest;

    }
    
    @isTest
    static void CallOutboundAccount(){
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        accountTest.ER_VAT_Number__c = '02554698475';
        insert accountTest;
        update accountTest;

    }  
}