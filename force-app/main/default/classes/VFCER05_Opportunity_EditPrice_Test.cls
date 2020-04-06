/*
----------------------------------------------------------------------
-- - Name          : VFCER05_Opportunity_EditPrice_Test
-- - Author        : OLA
-- - Description   : test class of VFCER05_Opportunity_EditPrice
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Dec-2018       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
@isTest
public class VFCER05_Opportunity_EditPrice_Test {

	static VFCER05_Opportunity_EditPrice controller;

	@testSetup
	static void testSetup() {

		Account merchantAccount = APER07_UtilityTestMethod.getCompany('VFCER05_Opportunity_EditPrice_Test');
		insert merchantAccount;

		Opportunity newOpportunity = APER07_UtilityTestMethod.getOpportunity('ER_Merchant_Opportunity','VFCER05_Opportunity_EditPrice_Test');
		insert newOpportunity;

		PriceBook2 newPriceBook = APER07_UtilityTestMethod.getpriceBook();
        newPriceBook.IsActive=true;
		update newPriceBook;

		Product2 newSolution = APER07_UtilityTestMethod.getsolution('testSolution');
		insert newSolution;

		Product2 newService = APER07_UtilityTestMethod.getservice('testService', newSolution.id);
		insert newService;

		PriceBookEntry newPriceBookEntrySolution = APER07_UtilityTestMethod.getpriceBookEntry(newPriceBook.id, newSolution.id);
		PriceBookEntry newPriceBookEntryService = APER07_UtilityTestMethod.getpriceBookEntry(newPriceBook.id, newService.id);
		List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
		pbeList.add(newPriceBookEntryService);
		pbeList.add(newPriceBookEntrySolution);
		insert pbeList;
		
		OpportunityLineItem  newOpportunityProduct = APER07_UtilityTestMethod.getOpportunityLineItem(newOpportunity.id, newPriceBookEntryService.id);
		insert newOpportunityProduct;
	}

	static testMethod void test() {

		Opportunity testOpp = [select id, AccountId, Pricebook2.name, Pricebook2Id from Opportunity where name = 'VFCER05_Opportunity_EditPrice_Test' limit 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
		controller = new  VFCER05_Opportunity_EditPrice(sc);
	}

	static testMethod void testgetServices() {

		Opportunity testOpp = [select id, AccountId, Pricebook2.name, Pricebook2Id from Opportunity where name = 'VFCER05_Opportunity_EditPrice_Test' limit 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
		controller = new  VFCER05_Opportunity_EditPrice(sc);

		List<PricebookEntry> pbEntryList = controller.getsolutions;
		List<String> solutionsListIds = new List<String>();
		for(PricebookEntry pb : pbEntryList){
			solutionsListIds.add(pb.id);
		}
		VFCER05_Opportunity_EditPrice.getServices(solutionsListIds,testOpp.Pricebook2Id, testOpp.AccountId, false, null);
	}

	/*static testMethod void testgetSolutions() {

		Opportunity testOpp = [select id, Pricebook2.name, Pricebook2Id from Opportunity where name = 'VFCER05_Opportunity_EditPrice_Test' limit 1];
		//VFCER05_Opportunity_EditPrice.getSolutions();
	}*/

	static testMethod void testsaveOpportunityProducts() {

		Opportunity testOpp = [select id, Pricebook2.name, Pricebook2Id from Opportunity where name = 'VFCER05_Opportunity_EditPrice_Test' limit 1];

		OpportunityLineItem opportunityLineItemToSave = new OpportunityLineItem();
		List<OpportunityLineItem> opportunityLineItemToSaveList = new List<OpportunityLineItem>();

		Map<String, OpportunityLineItem> opportunityLineItemMap = VFCER05_Opportunity_EditPrice.getOpportunityProduct(testOpp.Id);
		if(!opportunityLineItemMap.isEmpty()){
			opportunityLineItemToSave.Product2Id = opportunityLineItemMap.values().get(0).Product2Id;
			opportunityLineItemToSave.UnitPrice = opportunityLineItemMap.values().get(0).UnitPrice;
			opportunityLineItemToSave.Quantity = opportunityLineItemMap.values().get(0).Quantity;
			opportunityLineItemToSave.OpportunityId = opportunityLineItemMap.values().get(0).OpportunityId;
			opportunityLineItemToSaveList.add(opportunityLineItemToSave);
		}

		VFCER05_Opportunity_EditPrice.saveOpportunityProducts(opportunityLineItemToSaveList,testOpp.Id);
	}

	static testMethod void testgetOpportunityProduct() {

		Opportunity testOpp = [select id, Pricebook2.name, Pricebook2Id from Opportunity where name = 'VFCER05_Opportunity_EditPrice_Test' limit 1];
		VFCER05_Opportunity_EditPrice.getOpportunityProduct(testOpp.Id);
	}

}