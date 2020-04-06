/**
* @author Oussama LASFAR
* @date 26/09/2018 (dd/mm/yyyy)
* @description test class to cover the case trigger before update
*/
@isTest
public class APER08_Case_Management_Test {
    @testSetup
    static void testSetup() {
        Account newCompany = APER07_UtilityTestMethod.getCompany('VFCER01_Asset_Transactions_Balance_Test');
        insert newCompany;
        
        ER_Employee__c newEmployee = APER07_UtilityTestMethod.getEmployee();
        newEmployee.ER_Client__c = newCompany.id;
        insert newEmployee;
        
        Product2 newProduct = APER07_UtilityTestMethod.getProduct('TSC_P');
        insert newProduct;
        
        Asset newAsset = APER07_UtilityTestMethod.getAsset('2801001840','ER_Asset_Record_Type',Label.LAB_SF_ASSET_Type);
        newAsset.ER_Employee__c = newEmployee.id;
        newAsset.AccountId = newCompany.id;
        newAsset.Product2Id = newProduct.id;
        insert newAsset;
        
        Entitlement ent = new Entitlement();
        ent.Name = 'TestEntitlement';
        ent.AccountId = newCompany.id;
        List<SlaProcess> slaInst = [SELECT Id,name,isactive From SlaProcess limit 1];
        if(!slaInst.isEmpty()){
            
            ent.SlaProcessId = [SELECT Id,name,isactive From SlaProcess limit 1].id;
        }
        insert ent;
        
        Case testCase = new Case();
        testCase.Origin = Label.LABS_SF_Case_Origin_Web;
        testCase.Status= Label.LAB_SF_Case_inProgress;
        testCase.ER_Card_Number__c= '2801001840';
        testCase.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ER_User_Case_RT').getRecordTypeId();
        insert testCase;        
    }
    static testMethod void completeMilestone() {
        List<Case> caseinst = [select id from Case limit 1];
        if(!caseinst.isEmpty()){
            caseinst[0].Status=Label.LAB_SF_Case_resolved;
            update caseinst[0];
            caseinst[0].Status=Label.LAB_SF_Case_feedbackSent;
            update caseinst[0];
        }
    }
    
}