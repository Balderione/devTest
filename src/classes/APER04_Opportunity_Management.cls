/*
----------------------------------------------------------------------
-- - Name          : APER04_Opportunity_Management
-- - Author        : OLA
-- - Description   : User Management, This class is used to group all the functionnality linked to the object Opportunity()
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  JAN-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
public class APER04_Opportunity_Management {

	public static void updateOpportunityStage(Set<Id> opportunityIds, String stageName) {

		List<Opportunity> opportunityListToUpdate = new List<Opportunity>();
		Opportunity opportunityToUpdate = new Opportunity();

		for (Id opportunityId : opportunityIds) {

			opportunityToUpdate = new Opportunity(Id = opportunityId);
			opportunityToUpdate.StageName = stageName;
			opportunityListToUpdate.add(opportunityToUpdate);
		}
		if (!opportunityListToUpdate.isEmpty()) {

			System.debug('opportunityListToUpdate : ' + opportunityListToUpdate);
			update opportunityListToUpdate;
		}
	}

	public static void updateOpportunityContract(List<Opportunity> opportunityList) {

		update opportunityList;
	}

	@AuraEnabled
	public static List<Opportunity> getOpportunityRecord(String opportunityId) {

		List<Opportunity> opportunityList = [select Id, Name, AccountId, StageName, CloseDate, PriceBook2Id, CurrencyIsoCode, ER_IsAmended__c, ER_InvoicingFrequency__c, ER_PaymentTerms__c, ER_PaymentMethod__c, ER_ReimbursementTerm__c, ER_Reason__c from Opportunity where id = :opportunityId];
		return opportunityList;
	}

	@AuraEnabled
	public static void discardAmendement(String opportunityId) {

		delete [select id from Opportunity where id = :opportunityId];
	}

	/*
	* LASFAR
	* 14/02/2019
	* createOpportunityFromContract : Create new Opportunity from the current contract (contract came from data init)
	*/
	public static Opportunity createOpportunityFromContract(String contractId, String opportunityId) {

		Opportunity newOpp;
		OpportunityLineItem oli;
		List<OpportunityLineItem> oliToInsert = new List<OpportunityLineItem>();
		Boolean userCanAmend = false;

		try {
			for (Contract contractInst : [Select id, AccountId, Account.Name, Pricebook2Id, CurrencyIsoCode, ER_business_unit__c, (Select id, ER_NeedApproval__c, ER_ListPrice__c, ER_UnitPrice__c, CurrencyIsoCode, ER_PricebookEntryId__c, ER_Quantity__c, ER_Percentage__c, ER_Card_Operational_System_ID__c, ER_Creation_date_in_OS__c From ER_ContractLineItems__r)
			From Contract
			Where id = :contractId and ER_business_unit__c =: APER10_User_Management.userBU]) {

				userCanAmend = true;

				if(String.isNotBlank(opportunityId)){
					// CLone Existing Opportunity
					List<Opportunity> linkedOpportunity = APER04_Opportunity_Management.getOpportunityRecord(opportunityId);
					if(!linkedOpportunity.isEmpty()){
						newOpp = linkedOpportunity[0].clone(false, true, false, false);
						newOpp.Name = Datetime.now().format('YYYYMMdd')+' - '+linkedOpportunity[0].Name;
						newOpp.StageName = Label.LABS_SF_Opp_Status_Qualification;
						newOpp.CloseDate = Date.today().addMonths(1);
						newOpp.ER_AmendedFromContract__c = contractInst.id;
					}
				}
				if(newOpp == null){
					//create New Opportunity
					newOpp = new Opportunity();
					newOpp.Name = Datetime.now().format('YYYYMMdd')+' - '+contractInst.Account.Name;
					newOpp.AccountId = contractInst.AccountId;
					newOpp.ER_AmendedFromContract__c = contractInst.id;
					newOpp.Pricebook2Id = contractInst.Pricebook2Id;
					newOpp.StageName = Label.LABS_SF_Opp_Status_Qualification;
					newOpp.CloseDate = Date.today().addMonths(1);
					newOpp.CurrencyIsoCode = contractInst.CurrencyIsoCode;
				}
				

				insert newOpp; // inside loop but one instance maximum !

				for (ER_ContractLineItem__c cli : contractInst.ER_ContractLineItems__r) {

					oli = new OpportunityLineItem();
					oli.OpportunityId = newOpp.id;
					oli.UnitPrice = cli.ER_UnitPrice__c;
					oli.PricebookEntryId = cli.ER_PricebookEntryId__c;
					oli.Quantity = cli.ER_Quantity__c;
					oli.ER_Percentage__c = cli.ER_Percentage__c;
					oli.ER_NeedApproval__c = cli.ER_NeedApproval__c;
					oli.ER_Creation_date_in_OS__c = cli.ER_Creation_date_in_OS__c;
					oli.ER_Card_Operational_System_ID__c = cli.ER_Card_Operational_System_ID__c;
					oliToInsert.add(oli);
				}
			}

			if (!oliToInsert.isEmpty()) {

				System.debug('oliToInsert : ' + oliToInsert);
				insert oliToInsert;
			}
			else if(!userCanAmend){

				System.debug('User cannot Amend ! ');
				throw new APER04_Opportunity_Exception(Label.LABS_SF_AvoidAmendement);
			}
		} catch (Exception e) {

			throw new AuraHandledException(e.getMessage());
		}

		return newOpp;
	}

	public class APER04_Opportunity_Exception extends Exception {}
}