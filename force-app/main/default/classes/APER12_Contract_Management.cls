/*
----------------------------------------------------------------------
-- - Name          : APER12_Contract_Management
-- - Author        : OLA
-- - Description   : Contract Management, This class is used to group all the functionnality linked to the object Contract
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Jan-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
public class APER12_Contract_Management {

	public static List<Contract> createContractFromQuote(Map<id, Quote> acceptedQuoteMap) {

		List<Contract> contractToInsert = new List<Contract>();
		Contract newContract;

		List<Quote> quoteList = [Select id, OpportunityId, AccountId, Pricebook2Id, CurrencyIsoCode, recordtype.developerName, ER_Credit_Limit__c, 
        						 ER_Indexation_Index__c, ER_InvoicingFrequency__c, ER_PaymentMethod__c, ER_PaymentTerms__c,
        						 ER_ReimbursementTerm__c, SK_Credit_Note_Frequency__c, SK_Payment_Terms_Voucher__c, ER_Indexation__c
		                         From Quote
		                         Where id IN : acceptedQuoteMap.keyset()];
		for (Quote quote : quoteList) {
			System.debug('APER12_Contract_Management : createContractFromQuote : Account : ' + quote.AccountId);
            
			newContract = new Contract();
            if(quote.recordtype.developerName == 'ER_Client_Quote'){
                newContract.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('ER_Client_Contract_RT').getRecordTypeId();
            }
            else if(quote.recordtype.developerName == 'ER_Merchant_Quote'){
                newContract.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('ER_Merchant_Contract_RT').getRecordTypeId();
            }
			newContract.ER_QuoteId__c = quote.Id;
			newContract.ER_OpportunityId__c = quote.OpportunityId;
			newContract.AccountId = quote.AccountId;
			newContract.Pricebook2Id = quote.Pricebook2Id;
			newContract.CurrencyIsoCode = quote.CurrencyIsoCode;
			newContract.ER_Credit_Limit2__c = quote.ER_Credit_Limit__c;
			newContract.ER_Indexation_Index2__c = quote.ER_Indexation_Index__c;
			newContract.ER_InvoicingFrequency2__c = quote.ER_InvoicingFrequency__c;
			newContract.ER_PaymentMethod2__c = quote.ER_PaymentMethod__c;
			newContract.ER_PaymentTerms2__c = quote.ER_PaymentTerms__c;
			newContract.ER_ReimbursementTerm2__c = quote.ER_ReimbursementTerm__c;
			newContract.SK_Credit_Note_Frequency2__c = quote.SK_Credit_Note_Frequency__c;
			newContract.SK_Payment_Terms_Voucher2__c = quote.SK_Payment_Terms_Voucher__c;
			newContract.ER_OppIndexation2__c = quote.ER_Indexation__c;
			newContract.StartDate = Date.today();

			contractToInsert.add(newContract);
		}
		if (!contractToInsert.isEmpty()) {
			System.debug('contractToInsert : ' + contractToInsert);
			insert contractToInsert;
			for (Contract cntr : contractToInsert) {
				acceptedQuoteMap.get(cntr.ER_QuoteId__c).ContractId = cntr.Id;
				System.debug('acceptedQuoteMap : ' + acceptedQuoteMap);
			}
			createCLIAndUpdateOpportunity(acceptedQuoteMap);
		}
		return contractToInsert;
	}

	public static Void createCLIAndUpdateOpportunity(Map<id, Quote> acceptedQuoteMap) {

		ER_ContractLineItem__c cli;
		List<ER_ContractLineItem__c> cliToInsert = new List<ER_ContractLineItem__c>();
		List<Opportunity> opportunityToUpdate = new List<Opportunity>(); // update contract Id field
		Opportunity opportunityInst;

		for (Quote quoteInst : [Select id, OpportunityId, AccountId, Pricebook2Id, ContractId, (Select id, ListPrice, Discount, UnitPrice, CurrencyIsoCode, PricebookEntryId, Product2Id, Product2.Name, Quantity, ER_Percentage__c, ER_NeedApproval__c, ER_Creation_date_in_OS__c, ER_Card_Operational_System_ID__c, ER_Minimum_Fee__c
		                        From QuotelineItems)
		                        From Quote
		                        Where id IN : acceptedQuoteMap.keySet()]) {

			opportunityInst = new Opportunity(Id = quoteInst.OpportunityId,
			                                  ContractId = acceptedQuoteMap.get(quoteInst.id).ContractId);//(from trigger before update) ==> cannot get ContractId from Query Yet!

			opportunityToUpdate.add(opportunityInst);

			for (QuotelineItem qli : quoteInst.QuotelineItems) {

				cli = new ER_ContractLineItem__c();
				cli.Name = qli.Product2.Name;
				cli.ER_Contract__c = acceptedQuoteMap.get(quoteInst.id).ContractId;//(from trigger before update) ==> cannot get ContractId from Query Yet!
				cli.ER_Percentage__c = qli.ER_Percentage__c;
				cli.ER_Product2__c = qli.Product2Id;
				cli.ER_PricebookEntryId__c = qli.PricebookEntryId;
				cli.CurrencyIsoCode = qli.CurrencyIsoCode;
				cli.ER_UnitPrice__c = qli.UnitPrice;
				cli.ER_ListPrice__c = qli.ListPrice;
				cli.ER_Quantity__c = qli.Quantity;
				cli.ER_NeedApproval__c = qli.ER_NeedApproval__c;
				cli.ER_Minimum_Fee__c = qli.ER_Minimum_Fee__c;
				cli.ER_Card_Operational_System_ID__c = qli.ER_Card_Operational_System_ID__c;
				cli.ER_Creation_date_in_OS__c = qli.ER_Creation_date_in_OS__c;
				cli.ER_Discount__c = qli.Discount;
				cliToInsert.add(cli);
			}
		}
		if (!cliToInsert.isEmpty()) {

			System.debug('cliToInsert : ' + cliToInsert);
			insert cliToInsert;
		}
		if (!opportunityToUpdate.isEmpty()) {

			System.debug('opportunityToUpdate : ' + opportunityToUpdate);
			APER04_Opportunity_Management.updateOpportunityContract(opportunityToUpdate);
		}
	}

	@Future
	public static void deleteContractFromQuote(Set<id> deniedQuoteContractids) {

		List<Contract> contractListToDelete = new List<Contract>();
		Contract contractToDelete = new Contract();

		for (Id contractId : deniedQuoteContractids) {

			contractToDelete = new Contract(Id = contractId);
			contractListToDelete.add(contractToDelete);
		}
		if (!contractListToDelete.isEmpty()) {

			System.debug('contractListToDelete : ' + contractListToDelete);
			delete contractListToDelete;
		}
	}

	@AuraEnabled
	public static List<Contract> getContract(String contractId) {

		return [select id,ER_InvoicingFrequency2__c, ER_ReimbursementTerm2__c,CustomerSigned.Email,CustomerSignedId, Status,ER_Indexation__c, ER_PaymentTerms2__c,ER_PaymentMethod2__c , Account.ER_VIP__c , AccountId, Account.Name, StartDate, EndDate, ER_OpportunityId__c, ER_OpportunityId__r.ER_IsAmended__c, ER_OpportunityId__r.ER_AmendedFromContract__c, ER_OpportunityId__r.ER_AmendedFromOpportunity__r.ContractId, ContractNumber, ER_Creation_date_in_OS__c, CustomerSignedDate, (select id, Name, ER_Solution__c, ER_ProductCode__c, ER_Creation_date_in_OS__c from ER_ContractLineItems__r) from Contract where id = : contractId];
	}

	public static Map<Id,ER_ContractLineItem__c> getContractLineItems(String contractId) {

		return new Map<Id,ER_ContractLineItem__c>([select id, Name,ER_Contract__r.ER_PaymentTerms2__c,ER_Contract__r.ER_PaymentMethod2__c, ER_Solution__c, ER_ProductCode__c, ER_Creation_date_in_OS__c, ER_Minimum_Fee__c, ER_Product2__c, ER_Product2__r.ER_Solution__c, ER_Contract__r.accountId from ER_ContractLineItem__c where ER_Contract__c = : contractId]);
	}

	public static Map<Id,ER_ContractLineItem__c> getAllActiveContractLineItems(Set<String> companyIds) {

		return new Map<Id,ER_ContractLineItem__c>([select id, Name,ER_Contract__r.ER_PaymentTerms2__c,ER_Contract__r.ER_PaymentMethod2__c, ER_Solution__c, ER_ProductCode__c, ER_Creation_date_in_OS__c, ER_Minimum_Fee__c, ER_Product2__c, ER_Product2__r.ER_Solution__c, ER_Contract__r.accountId from ER_ContractLineItem__c where ER_Contract__r.status =: Label.LABS_SF_Contract_Status_Activated and ER_Contract__r.AccountId IN : companyIds]);
	}

	/*
	* LASFAR
	* 14/02/2019
	* contractAmendment : 2 cases:
				1- Clone the opportunity linked to the current contract
				2- Create new Opportunity from the current contract (contract came from data init)
	*/
	@AuraEnabled
	public static Opportunity contractAmendment(String contractId, String opportunityId) {

		/*if (String.isNotBlank(opportunityId)) {

			return APER04_Opportunity_Management.cloneOpportunity(opportunityId);
		}*/

		return APER04_Opportunity_Management.createOpportunityFromContract(contractId, opportunityId);
	}

	@AuraEnabled
	public static void activateContractController(Contract contract, String opportunityId) {

		if (contract != null) {

			List<Contract> contractToUpdate = new List<Contract>();
			contract.Status = Label.LABS_SF_Contract_Status_Activated;
			if (contract.ER_Creation_date_in_OS__c == null) {

				contract.ER_Creation_date_in_OS__c = Datetime.now();
			}
			contractToUpdate.add(contract);

			if (String.isNotBlank(contract.ER_OpportunityId__c) && contract.ER_OpportunityId__r.ER_IsAmended__c) {

				String contractId = String.isNotBlank(contract.ER_OpportunityId__r.ER_AmendedFromContract__c) ? contract.ER_OpportunityId__r.ER_AmendedFromContract__c : contract.ER_OpportunityId__r.ER_AmendedFromOpportunity__r.ContractId;
				Contract terminateContract = new Contract(Id = contractId);
				terminateContract.Status = Label.LABS_SF_Contract_Status_Terminated;
				terminateContract.ER_TerminationReason__c = Label.LAB_SF_Contract_Amendment;
				terminateContract.ER_Terminated_Date__c  = Datetime.now();
				terminateContract.EndDate = Date.today();
				contractToUpdate.add(terminateContract);
			}

			System.debug('## activateContractController update : ' + contractToUpdate);
			update contractToUpdate;

			//CloseWon the opportunity
			if (String.isNotBlank(opportunityId)) {

				Opportunity contractOpportunity = new Opportunity(Id = opportunityId);
				contractOpportunity.StageName = Label.LABS_SF_Opp_Status_ClosedWon;
				update contractOpportunity;
			}

			APER14_Store_Management.manageSLIFromContract(contract.AccountId);
		}
	}

	/*
	* LASFAR
	* 27/03/2019
	* terminateContract : For batch process, update status to Terminated when WS status is succeeded.
	*/
	public static void terminateContract(Contract contract) {

		contract.Status = Label.LABS_SF_Contract_Status_Terminated;
		update contract;
		APER14_Store_Management.manageSLIFromContract(contract.AccountId);
	}

	/*
	* LASFAR
	* 14/02/2019
	* deleteCLIFromContract : For each deleted contract delete linked contract line items (no Master detail RelationShip)
	*/
	public static void deleteCLIFromContract(Map<id, Contract> contractMap) {

		List<ER_ContractLineItem__c> cliToDelete = new List<ER_ContractLineItem__c>();

		for (Contract contractInst : [Select Id, (Select id From ER_ContractLineItems__r)
		                              From Contract
		                              Where id = :contractMap.keyset()]) {
			for (ER_ContractLineItem__c cliInst : contractInst.ER_ContractLineItems__r) {

				cliToDelete.add(cliInst);
			}
		}
		if (!cliToDelete.isEmpty()) {

			System.debug('#cliToDelete Size : ' + cliToDelete.size());
			delete cliToDelete;
		}
	}
}