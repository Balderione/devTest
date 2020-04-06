/*
----------------------------------------------------------------------
-- - Name          : APER12_Contract_Management_Test
-- - Author        : OLA
-- - Description   : TEST for Contract Management class
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Feb-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
@isTest
public class APER12_Contract_Management_Test {

	@testSetup
	static void testSetup() {

		Account newMerchantAccount = APER07_UtilityTestMethod.getCompany('testCompany');
		insert newMerchantAccount;

		PriceBook2 newPriceBook = APER07_UtilityTestMethod.getpriceBook();
		//update newPriceBook;

		Product2 newSolution = APER07_UtilityTestMethod.getsolution('testSolution');
		insert newSolution;

		Product2 newService = APER07_UtilityTestMethod.getservice('testService', newSolution.id);
		insert newService;

		PriceBookEntry newPriceBookEntry = APER07_UtilityTestMethod.getpriceBookEntry(newPriceBook.id, newService.id);
		insert newPriceBookEntry;

		Opportunity newOpportunity = APER07_UtilityTestMethod.getOpportunity('ER_Merchant_Opportunity', 'APER12_Contract_Management_Test');
		newOpportunity.AccountId = newMerchantAccount.Id;
		insert newOpportunity;

		OpportunityLineItem  newOpportunityProduct = APER07_UtilityTestMethod.getOpportunityLineItem(newOpportunity.id, newPriceBookEntry.id);
		insert newOpportunityProduct;

		Quote merchantQuote = APER07_UtilityTestMethod.getQuote('ER_Merchant_Quote', 'APER12_Contract_Management_Test', newOpportunity.id, newPriceBook.id);
		insert merchantQuote;

		QuoteLineItem qli = APER07_UtilityTestMethod.getQuoteLineItem(merchantQuote.id, newPriceBookEntry.id);
		insert qli;
	}

	static testMethod void acceptQuote() {
        
        List<Quote> quoteList = [Select id From Quote where Name = 'APER12_Contract_Management_Test'];
        
        if (!quoteList.isEmpty()) {
            Quote quoteInst = quoteList[0];
            quoteInst.Status = Label.LABS_SF_Quote_Status_Accepted;
            update quoteInst;
        }
    }

    static testMethod void denyQuote() {
        
         List<Quote> quoteList = [Select id From Quote where Name = 'APER12_Contract_Management_Test'];
        
        if (!quoteList.isEmpty()) {
            Quote quoteInst = quoteList[0];
            quoteInst.Status = Label.LABS_SF_Quote_Status_Accepted;
            update quoteInst;

            quoteInst.Status = Label.LABS_SF_Quote_Status_Denied;
            update quoteInst;
        }
    }

	static testMethod void testActivateContractAndAmendment() {

		APER12_Contract_Management_Test.acceptQuote();

		List<Contract> contractList = [Select id From Contract where status = : Label.LABS_SF_Contract_Status_Draft limit 1];

		if (!contractList.isEmpty()) {

			contractList = APER12_Contract_Management.getContract(contractList[0].id);
			if (!contractList.isEmpty()) {

				APER12_Contract_Management.activateContractController(contractList[0], contractList[0].ER_OpportunityId__c);
				Opportunity amendedOpportunity = APER12_Contract_Management.contractAmendment(contractList[0].id, contractList[0].ER_OpportunityId__c);
				
				if(amendedOpportunity != null){
					APER04_Opportunity_Management.discardAmendement(amendedOpportunity.Id);	
				}

				APER12_Contract_Management.contractAmendment(contractList[0].id, '');
			}
		}
	}
}