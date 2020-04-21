/*
----------------------------------------------------------------------
-- - Name          : APER11_Quote_Management
-- - Author        : OLA
-- - Description   : Quote Management, This class is used to group all the functionnality linked to the object Quote
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Jan-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
public class APER11_Quote_Management {

	/**
	* @author Oussama LASFAR
	* @date 14/01/2019 (dd/mm/yyyy)
	* @description createdSyncQuote : Create Quote automatically after Opportunity Approval. Sync Opportunity Line Items & Quote Line Items
	*/
	public static void createdSyncQuote(List<Opportunity> syncOpportunityList) {
		System.debug('##APER11_Quote_Management createdSyncQuote : ' + syncOpportunityList);
		Set<Id> oppIdset = new Set<Id>();
		Quote newQuote;
		List<Quote> newQuoteList = new List<Quote>();
		Map<String, String> mapOpportunityQuote = new Map<String, String>();
		Map<String, OpportunityContactRole> mapOpportunityPrimaryContact = new Map<String, OpportunityContactRole>();

		for (Opportunity opp : syncOpportunityList) {
			oppIdset.add(opp.id);
		}

		List<OpportunityContactRole> ocrList = [Select OpportunityId, role, contactId, isprimary, contact.Email, contact.Phone
		                                        From OpportunityContactRole
		                                        where OpportunityId IN : oppIdset and isprimary = true];

		if(!ocrList.isEmpty()){
			mapOpportunityPrimaryContact.put(ocrList[0].OpportunityId, ocrList[0]);
		}

		for (Opportunity opp : syncOpportunityList) {
			//oppIdset.add(opp.id);

			newQuote = new Quote();
			if(!mapOpportunityPrimaryContact.isEmpty()){
				newQuote.ContactId = mapOpportunityPrimaryContact.get(opp.id).contactId;
				newQuote.Email = mapOpportunityPrimaryContact.get(opp.id).contact.Email;
				newQuote.Phone = mapOpportunityPrimaryContact.get(opp.id).contact.Phone;
			}
			newQuote.OwnerId = opp.OwnerId;
			newQuote.Name = Datetime.now().format('yyyy-MM-dd')+'-'+opp.Name;
			newQuote.OpportunityId = opp.id;
			newQuote.Pricebook2Id = opp.pricebook2Id;
			if (opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ER_Merchant_Opportunity').getRecordTypeId()) {
				newQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('ER_Merchant_Quote').getRecordTypeId();
			} else if (opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ER_Client_Opportunity_RT').getRecordTypeId()) {
				newQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('ER_Client_Quote').getRecordTypeId();
			}
			newQuote.ExpirationDate = Date.today().addMonths(1);
			newQuoteList.add(newQuote);
		}
		if (!newQuoteList.isEmpty()) {

			insert newQuoteList;

			for (Quote quot : newQuoteList) {
				mapOpportunityQuote.put(quot.OpportunityId, quot.id);
			}
			List<OpportunityLineItem> oliList = [Select id, Name, UnitPrice, Discount, ER_Percentage__c, Quantity, PricebookEntryId, OpportunityId, Opportunity.pricebook2Id, PricebookEntry.Name, Product2.Description, Product2.ER_Solution__r.Name, ListPrice, CurrencyIsoCode, ER_Card_Operational_System_ID__c, ER_Creation_date_in_OS__c, ER_Minimum_Fee__c
			                                     From OpportunityLineItem
			                                     Where OpportunityId IN :oppIdset];
			QuoteLineItem qli;
			List<QuoteLineItem> qliList = new List<QuoteLineItem>();

			for (OpportunityLineItem oli : oliList) {

				qli = new QuoteLineItem();
				qli.UnitPrice = oli.UnitPrice;
				qli.ER_Percentage__c = oli.ER_Percentage__c;
				qli.QuoteId = mapOpportunityQuote.get(oli.OpportunityId);
				qli.Quantity = oli.Quantity;
				qli.PricebookEntryId = oli.PricebookEntryId;
				qli.ER_Card_Operational_System_ID__c = oli.ER_Card_Operational_System_ID__c;
				qli.ER_Creation_date_in_OS__c = oli.ER_Creation_date_in_OS__c;
				qli.ER_Minimum_Fee__c = oli.ER_Minimum_Fee__c;
				qli.Discount = oli.Discount;
				qliList.add(qli);
			}

			if (!qliList.isEmpty()) {
				insert qliList;
			}

			System.debug('#### createdSyncQuote oliList : ' + oliList);
		}
	}
	public static void updateQuoteStatus(List<Quote> quoteList) {

		List<Quote> quoteListToUpdate = new List<Quote>();
		Set<Id> opportunityIds = new Set<Id>();

		for (Quote quoteinst : quoteList) {
			quoteinst.status = Label.LABS_SF_Quote_Status_Presented;
			quoteListToUpdate.add(quoteinst);
			if (quoteinst.Opportunity.StageName != Label.LABS_SF_Opp_Status_Negotiation) {
				opportunityIds.add(quoteinst.OpportunityId);
			}
		}
		if (!quoteListToUpdate.isEmpty()) {
			update quoteListToUpdate;
		}
		if (!opportunityIds.isEmpty()) {
			APER04_Opportunity_Management.updateOpportunityStage(opportunityIds, Label.LABS_SF_Opp_Status_Negotiation);
		}
	}
	public static void checkRecentQuote(List<Quote> acceptedQuoteList) {

		Map<id, quote> mapOpportunitytoQuote = new Map<id, quote>();

		for (Quote quote : acceptedQuoteList) {
			mapOpportunitytoQuote.put(quote.OpportunityId, quote);

		}
		for (Opportunity opp : [Select id, (Select id, Status, CreatedDate From Quotes Order By createdDate Desc Limit 1)
		                        From Opportunity
		                        Where id IN : mapOpportunitytoQuote.keyset()]) {
			for (Quote quote : opp.Quotes) {
				System.debug('Opportunity :' + opp.Id + '   Quote :' + quote.Id + '   Quote createdDate:' + quote.CreatedDate);
				if (mapOpportunitytoQuote.get(opp.Id) != null && mapOpportunitytoQuote.get(opp.Id).id != quote.Id) {
					acceptedQuoteList[0].addError(Label.LABS_SF_Quote_NotLastAccepted + ' ' + quote.Id);
				}
			}
		}
	}
	/*
	public static void checkExistingAcceptedQuote(List<Quote> acceptedQuoteList) {

		Map<id, quote> mapOpportunitytoQuote = new Map<id, quote>();

		for (Quote quote : acceptedQuoteList) {
			mapOpportunitytoQuote.put(quote.OpportunityId, quote);

		}
		if (!mapOpportunitytoQuote.isEmpty()) {

			List<Quote> quoteList = [select id, OpportunityId from
			                         Quote
			                         where OpportunityId IN : mapOpportunitytoQuote.keySet()
			                         and Status = :Label.LABS_SF_Quote_Status_Accepted];
			if (!quoteList.isEmpty()) {

				mapOpportunitytoQuote.get(quoteList[0].OpportunityId).addError(Label.LABS_SF_Quote_AcceptedQuoteExist + ' ' + quoteList[0].id);
			}
		}
	}
	*/
}