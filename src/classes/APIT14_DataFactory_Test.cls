@isTest
public class APIT14_DataFactory_Test {
    static testMethod void callObjectMethod() {

        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;

        User userTest = APIT14_DataFactory.create_User();
        Account personAccountTest = APIT14_DataFactory.create_PersonAccount();
        Account businessAccountTest = APIT14_DataFactory.create_BusinessAccount();
        insert businessAccountTest;
        Contact contactTest = APIT14_DataFactory.create_Contact(businessAccountTest.Id);
        insert contactTest;
        IT_Contact_Detail__c contactDetailTest = APIT14_DataFactory.create_Contact_Detail(contactTest.Id);
        insert contactDetailTest;
        Case caseTest = APIT14_DataFactory.create_Case(businessAccountTest.Id);
        insert caseTest;
        Contract contractTest = APIT14_DataFactory.create_Contract(businessAccountTest.Id);
        ER_Financial_Center__c financialCenterTest = APIT14_DataFactory.create_FinancialCenter(businessAccountTest.Id, contactTest.Id);
        insert financialCenterTest;
        IT_Circuit__c circuitTest = APIT14_DataFactory.create_Circuit(businessAccountTest.Id);
        Entitlement entitlementTest = APIT14_DataFactory.create_Entitlement(businessAccountTest.Id);

        IT_Welfare_Project__c welProjectTest = APIT14_DataFactory.create_WelfareProject();
        insert welProjectTest;
        IT_Plan__c planTest = APIT14_DataFactory.create_Plan(welProjectTest.Id);
        Emailmessage emailMessageTest = APIT14_DataFactory.create_Emailmessage(caseTest.Id);

        ER_Delivery_Site__c deliverySiteTest = APIT14_DataFactory.create_DeliverySite(financialCenterTest.Id, businessAccountTest.Id);
        insert deliverySiteTest;
        ER_Distribution_Point__c distributionPointTest = APIT14_DataFactory.create_DistributionPoint(financialCenterTest.Id, deliverySiteTest.Id);
        insert distributionPointTest;
        ER_Bank_Account__c bankAccountTest = APIT14_DataFactory.create_BankAccount(financialCenterTest.Id);
        insert bankAccountTest;
        IT_Request__c requestTest = APIT14_DataFactory.create_Request(financialCenterTest.Id);
        insert requestTest;
        IT_Group_Code__c groupCodeTest = APIT14_DataFactory.create_GroupCode(financialCenterTest.Id);
        insert groupCodeTest;

        ER_ContractLineItem__c contractLineItemTest = APIT14_DataFactory.create_ContractLineItem(contractTest.Id);
        insert contractLineItemTest;
        IT_Contact_Association__c contactASSTest = APIT14_DataFactory.create_ContactASS(contactDetailTest.Id, financialCenterTest.Id);
        insert contactASSTest;
        IT_Intent_Declaration__c intentDeclarationTest = APIT14_DataFactory.create_IntentDeclaration(businessAccountTest.Id);
        insert intentDeclarationTest;
        IT_Group__c groupTest = APIT14_DataFactory.create_Group(financialCenterTest.Id);
        insert groupTest;
        
        Product2 testProduct = APIT14_DataFactory.create_Product();
        insert testProduct;

        IT_Note__c testNote = APIT14_DataFactory.create_Note(financialCenterTest.Id, deliverySiteTest.Id);
        insert testNote;
        IT_Additional_Expenses__c testPAddExp = APIT14_DataFactory.create_AddExp(financialCenterTest.Id);
        insert testPAddExp;
        
    }
    
    static testMethod void callObjectMethod2() {

        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = false;
        insert settings;

        User userTest = APIT14_DataFactory.create_User();
        Account personAccountTest = APIT14_DataFactory.create_PersonAccount();
        Account businessAccountTest = APIT14_DataFactory.create_BusinessAccount();
        insert businessAccountTest;
        Contact contactTest = APIT14_DataFactory.create_Contact(businessAccountTest.Id);
        insert contactTest;
        IT_Contact_Detail__c contactDetailTest = APIT14_DataFactory.create_Contact_Detail(contactTest.Id);
        insert contactDetailTest;
        Case caseTest = APIT14_DataFactory.create_Case(businessAccountTest.Id);
        insert caseTest;
        ER_Financial_Center__c financialCenterTest = APIT14_DataFactory.create_FinancialCenter(businessAccountTest.Id, contactTest.Id);
        financialCenterTest.IT_Financial_Center__c = '445566';
        insert financialCenterTest;
        ER_Delivery_Site__c deliverySiteTest = APIT14_DataFactory.create_DeliverySite(financialCenterTest.Id, businessAccountTest.Id);
        insert deliverySiteTest;
        
        Contract contractTest = APIT14_DataFactory.create_Contract(businessAccountTest.Id); 
        contractTest.IT_Financial_center__c = financialCenterTest.Id; 
        contractTest.IT_Contract_Progressive__c = '1';
        insert contractTest;
        ER_Bank_Account__c bankAccountTest = APIT14_DataFactory.create_BankAccount(financialCenterTest.Id);
        insert bankAccountTest; 
        financialCenterTest.ER_Bank_Account__c = bankAccountTest.Id;
        financialCenterTest.IT_Contract__c = contractTest.Id; 
        update financialCenterTest;
        IT_Request__c requestTest = APIT14_DataFactory.create_Request(financialCenterTest.Id);
        requestTest.IT_Client_Code__c = '445566';
        requestTest.IT_Request_Status__c = '3';
        requestTest.IT_Contract_Progressive__c = '2';  
        insert requestTest;
        requestTest.IT_Request_Status__c = '5';
        update requestTest;
        requestTest.IT_Client_Code__c = '445566';
        requestTest.IT_Request_Status__c = '4';
        update requestTest;

        IT_Request__c requestTest2 = APIT14_DataFactory.create_Request(financialCenterTest.Id); 
        requestTest2.IT_Client_Code__c = '445566';
        requestTest2.IT_Request_Status__c = '3';
        requestTest2.IT_Contract_Progressive__c = '2';
        insert requestTest2;
        requestTest2.IT_Request_Status__c = '5';
        requestTest2.IT_Contract_Start_Date__c = System.today() + 1;
        update requestTest2;
        requestTest2.IT_Client_Code__c = '445566';
        requestTest2.IT_Request_Status__c = '4';
        update requestTest2;
        
        List<IT_Request__c> listReq = new List<IT_Request__c>();
        List<ER_Financial_Center__c> listFC = new List<ER_Financial_Center__c>();

        listReq.add(requestTest);
        listFC.add(financialCenterTest);

        String requestActivation = APIT12_CallOutbound.createRequestFinancialCenterActivation(listFC);
        APIT12_CallOutbound.createRequestCustomFlow(listReq, contractTest, financialCenterTest);
        APIT12_CallOutbound.createRequestCustomFlow(listReq, contractTest, financialCenterTest); 
        
        requestTest.IT_Request_Status__c = '3';
        update requestTest;
        requestTest.IT_Contract_Start_Date__c = System.today();
        requestTest.IT_Request_Status__c = '4';
        update requestTest;

        contractTest.IT_Transport_Cost__c = '05';
        update contractTest;

        IT_Note__c testNote = APIT14_DataFactory.create_Note(financialCenterTest.Id, deliverySiteTest.Id);
        insert testNote;
        IT_Additional_Expenses__c testPAddExp = APIT14_DataFactory.create_AddExp(financialCenterTest.Id);
        insert testPAddExp;
        
    }
    
}