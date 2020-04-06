/*
----------------------------------------------------------------------
-- - Name          : VFCER04_Opportunity_Product_Test
-- - Author        : OLA
-- - Description   : test class of VFCER04_Opportunity_Product
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Dec-2018       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
@isTest
public class VFCER04_Opportunity_Product_Test {

	static VFCER04_Opportunity_Product controller;

	@testSetup
	static void testSetup() {

		Opportunity newOpportunity = APER07_UtilityTestMethod.getOpportunity('ER_Merchant_Opportunity','VFCER04_Opportunity_Product_Test');
		insert newOpportunity;

		PriceBook2 newPriceBook = APER07_UtilityTestMethod.getpriceBook();
		//update newPriceBook;

		Product2 newSolution = APER07_UtilityTestMethod.getsolution('testSolution');
		insert newSolution;

		Product2 newService = APER07_UtilityTestMethod.getservice('testService', newSolution.id);
		insert newService;

		PriceBookEntry newPriceBookEntry = APER07_UtilityTestMethod.getpriceBookEntry(newPriceBook.id, newService.id);
		insert newPriceBookEntry;
		
		OpportunityLineItem  newOpportunityProduct = APER07_UtilityTestMethod.getOpportunityLineItem(newOpportunity.id, newPriceBookEntry.id);
		insert newOpportunityProduct;
	}

	static testMethod void test() {

		Opportunity testOpp = [select id, ER_Approved__c, ER_NeedApproval__c from Opportunity where name = 'VFCER04_Opportunity_Product_Test' limit 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
		controller = new  VFCER04_Opportunity_Product(sc);
	}

	static testMethod void testEditPrice() {

		Opportunity testOpp = [select id, ER_Approved__c, ER_NeedApproval__c from Opportunity where name = 'VFCER04_Opportunity_Product_Test' limit 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
		controller = new  VFCER04_Opportunity_Product(sc);
		controller.EditPrice();
	}

	static testMethod void testGetOpportunityProducts() {

		Opportunity testOpp = [select id, ER_Approved__c, ER_NeedApproval__c from Opportunity where name = 'VFCER04_Opportunity_Product_Test' limit 1];
		VFCER04_Opportunity_Product.getOpportunityProducts(testOpp.id);
	}

	static testMethod void testSaveAsQuote() {

		Opportunity testOpp = [select id, ER_Approved__c, ER_NeedApproval__c from Opportunity where name = 'VFCER04_Opportunity_Product_Test' limit 1];
		VFCER04_Opportunity_Product.saveAsQuote(testOpp.id);
	}

	static testMethod void testUpdateOpportunity() {

		Opportunity testOpp = [select id, ER_Approved__c, ER_NeedApproval__c from Opportunity where name = 'VFCER04_Opportunity_Product_Test' limit 1];
		VFCER04_Opportunity_Product.updateOpportunity(testOpp.id,'Comment TEST');
	}	

	static testMethod void testApprovalProcess() {

		Opportunity testOpp = [select id, ER_Approved__c, ER_NeedApproval__c from Opportunity where name = 'VFCER04_Opportunity_Product_Test' limit 1];
		testOpp.ER_Approved__c = true;
		update testOpp;
	}	
}