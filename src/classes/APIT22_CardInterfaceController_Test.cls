@isTest
public class APIT22_CardInterfaceController_Test {
    @isTest static void linkController() {
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
        ER_Delivery_Site__c delSite = APIT14_DataFactory.create_DeliverySite(FinancialTest.id , accountTest.Id);
        insert delSite;
        ER_Distribution_point__c distPoint = APIT14_DataFactory.create_DistributionPoint(FinancialTest.id, delSite.id);
        insert DistPoint;
        IT_Control__c contr = new IT_Control__c(IT_CLN_Service__c = '3');
        insert contr;
        APIT22_CardInterfaceController.fetchDPData(distPoint.id);
        APIT22_CardInterfaceController.fetchDataType(distpoint.id, '3');
    }
}