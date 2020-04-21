/*
----------------------------------------------------------------------
-- - Name          : APER14_Store_Management_Test
-- - Author        : OLA
-- - Description   : TEST for Store Management class
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Jun-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
@isTest
public class APER14_Store_Management_Test {
    
    @testSetup
    static void testSetup() {
        
        Account merchantAccount = APER07_UtilityTestMethod.getCompany('APER14_Store_Management_Test');
        insert merchantAccount;
        
        ER_Financial_Center__c testFinancialCenter = APER07_UtilityTestMethod.getFinancialCenter('APER14_Store_Management_Test',merchantAccount.id, Label.LABS_SF_FinancialCenter_Merchant,'Test','Test','Test','Test');
        insert testFinancialCenter;
        
        PriceBook2 newPriceBook = APER07_UtilityTestMethod.getpriceBook();
        
        List<Product2> solutionListToInsert = new List<Product2>();
        List<Product2> serviceListToInsert = new List<Product2>();
        List<PriceBookEntry> pbeListToInsert = new List<PriceBookEntry>();
        List<ER_ContractLineItem__c> cliListToInsert = new List<ER_ContractLineItem__c>();

        Product2 newSolution = APER07_UtilityTestMethod.getsolution('testSolution');
        solutionListToInsert.add(newSolution);

        Product2 newSolution2 = APER07_UtilityTestMethod.getsolution('testSolution2');
        solutionListToInsert.add(newSolution2);

        Product2 testSolution3 = APER07_UtilityTestMethod.getsolution('testSolution3');
        solutionListToInsert.add(testSolution3);

        Product2 testSolution4 = APER07_UtilityTestMethod.getsolution('testSolution4');
        solutionListToInsert.add(testSolution4);

        insert solutionListToInsert;
        
        Product2 newService = APER07_UtilityTestMethod.getservice('testservice', newSolution.id);
        serviceListToInsert.add(newService);

        Product2 newService3 = APER07_UtilityTestMethod.getservice('testservice3', testSolution3.id);
        serviceListToInsert.add(newService3);

        Product2 newService4 = APER07_UtilityTestMethod.getservice('testservice4', testSolution4.id);
        serviceListToInsert.add(newService4);

        insert serviceListToInsert;
        
        PriceBookEntry newPriceBookEntry = APER07_UtilityTestMethod.getpriceBookEntry(newPriceBook.id, newService.id);
        pbeListToInsert.add(newPriceBookEntry);

        PriceBookEntry newPriceBookEntry3 = APER07_UtilityTestMethod.getpriceBookEntry(newPriceBook.id, newService3.id);
        pbeListToInsert.add(newPriceBookEntry3);

        PriceBookEntry newPriceBookEntry4 = APER07_UtilityTestMethod.getpriceBookEntry(newPriceBook.id, newService4.id);
        pbeListToInsert.add(newPriceBookEntry4);

        insert pbeListToInsert;
        
        Contract testContract = APER07_UtilityTestMethod.getContract(merchantAccount.id, Date.today(),Label.LABS_SF_Contract_Status_Draft,newPriceBook.Id);
        insert testContract;

        ER_ContractLineItem__c testContractLineItem = APER07_UtilityTestMethod.getContractLineItem(testContract.id, newService.id,newPriceBookEntry.id, 1, 1);
        cliListToInsert.add(testContractLineItem);

        ER_ContractLineItem__c testContractLineItem3 = APER07_UtilityTestMethod.getContractLineItem(testContract.id, newService3.id,newPriceBookEntry3.id, 1, 1);
        cliListToInsert.add(testContractLineItem3);

        insert cliListToInsert;

        testContract.status = Label.LABS_SF_Contract_Status_Activated; 
        update testContract;

        ER_Store__c testStore = APER07_UtilityTestMethod.getStore('APER14_Store_Management_Test',merchantAccount.id, testFinancialCenter.id, Date.today(),'Test','Test','Test','Test');
        insert testStore;

        ER_Store_Line_Item__c testStoreLineItem = APER07_UtilityTestMethod.getStoreLineItem(testStore.id, Label.LABS_SF_StoreLineItem_Decline, newSolution2.id);
        insert testStoreLineItem;

        ER_ContractLineItem__c testContractLineItem4 = APER07_UtilityTestMethod.getContractLineItem(testContract.id, newService4.id,newPriceBookEntry3.id, 1, 1);
        insert testContractLineItem4;

    }
    
    static testMethod void disableStores() {
        
        List<ER_Store_Line_Item__c> sliToUpdate = new List<ER_Store_Line_Item__c>();
        for(ER_Store__c store : [select id, ER_Merchant__c, (select id, ER_Solution__c from Store_line_Items__r) from ER_Store__c where Name='APER14_Store_Management_Test']){
            for(ER_Store_Line_Item__c sli :store.Store_line_Items__r){
                
                sli.ER_status__c = Label.LABS_SF_StoreLineItem_Decline;
                sliToUpdate.add(sli);
            }
        }      
        if(!sliToUpdate.isEmpty()){
            
            System.debug('sliToUpdate : '+sliToUpdate);
            update sliToUpdate;
        }
    }
    
    static testMethod void manageSLIFromContract() {
        
        List<Contract> contractList = [select id, AccountId from Contract where Status=: Label.LABS_SF_Contract_Status_Activated];
        if(!contractList.isEmpty()){
            
            APER14_Store_Management.manageSLIFromContract(contractList[0].AccountId);
        }
    }
}