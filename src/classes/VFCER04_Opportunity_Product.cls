/*
----------------------------------------------------------------------
-- - Name          : VFCER04_Opportunity_Product
-- - Author        : OLA
-- - Description   : The controller of the page VFER04_Opportunity_Product
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Dec-2018       OLA                 1.0         Initial version
--  MAY-2019       SDR                 1.1         SaveAsQuote method Update to match the CZ Requirement
---------------------------------------------------------------------------------------
*/

global class VFCER04_Opportunity_Product {

	public String opportunityId {get; set;}
	public Opportunity opportunityRecord {get; set;}
	public List<String> opportunityFields;

	public Boolean pendingApproval {get; set;}
	public Boolean approved {get; set;}
	public Boolean hasAcceptedQuote {get; set;}
	public List<ProcessInstanceWorkitem> approvalProcessList {get; set;}
	public List<Quote> currentOpportunityQuoteList;
	public Quote acceptedQuote {get; set;}

	public VFCER04_Opportunity_Product(ApexPages.StandardController controller) {

		opportunityId = controller.getId();
		opportunityFields = new List<String>();
		opportunityFields.add('ER_Approved__c');
		opportunityFields.add('ER_NeedApproval__c');

		if (!Test.isRunningTest()) controller.addFields(opportunityFields);

		opportunityRecord = (Opportunity) controller.getRecord();
		approved = opportunityRecord.ER_Approved__c;
		approvalProcessList = [select id, ProcessInstance.Status, ProcessInstance.TargetObjectId
		from ProcessInstanceWorkitem
		where ProcessInstance.TargetObjectId = : opportunityId];
		currentOpportunityQuoteList = [select id, QuoteNumber, Status
		from	Quote
		where opportunityId = : opportunityId and Status='Accepted' 
		order by createdDate desc];
		if(!currentOpportunityQuoteList.isEmpty()){
			acceptedQuote = currentOpportunityQuoteList[0];
			hasAcceptedQuote = true;
		}
		if (!approvalProcessList.isEmpty()) {
			pendingApproval = true;
		}
	}

	/**
	* @author Oussama LASFAR
	* @date 27/12/2018 (dd/mm/yyyy)
	* @description editPrice : redirect to VFER05_Opportunity_EditPrice Page.
	*/
	public PageReference editPrice() {

		PageReference pageRef = new PageReference('/apex/VFER05_Opportunity_EditPrice?id=' + opportunityId);
		pageRef.setRedirect(true);
		return pageRef;
	}

	/**
	* @author Oussama LASFAR
	* @date 27/12/2018 (dd/mm/yyyy)
	* @description getOpportunityProducts : display all the opportunity Products grouped by solutions.
	*/
	@RemoteAction
	global static List<opportunityLineItem> getOpportunityProducts(String opportunityId) {

		List<opportunityLineItem> oppProductList;
		oppProductList = [select id, Name, UnitPrice, ER_Percentage__c, ER_NeedApproval__c, PricebookEntry.Name, Product2.Description, Product2.ER_Solution__r.Name, ListPrice, CurrencyIsoCode, Opportunity.ER_NeedApproval__c, Opportunity.ER_Approved__c, ER_Minimum_Fee__c, Discount,  Opportunity.ER_Business_Unit__c
		from opportunityLineItem
		where opportunityId = : opportunityId
		order by product2.ER_solution__r.ER_Line_Order__c, product2.ER_Line_Order__c];

		return oppProductList;
	}

	/**
	* @author Oussama LASFAR
	* @date 27/12/2018 (dd/mm/yyyy)
	* @description saveAsQuote :
	* If an opportunity products need approval: launch automatically an approval process
	* else create quote and clone all the opportunity products + change opportunity stage to proposal
	*/
	@RemoteAction
	global static Quote saveAsQuote(String opportunityId) {

		Boolean opportunityNeedApproval = false;
		Boolean oliIsCardOrPaper = false;
		List<opportunityLineItem> oppProductList;
		List<quoteLineItem> qliList = new List<quoteLineItem>();
		Opportunity  currentOpportunity = new Opportunity();
		QuoteLineItem qli;
		List<OpportunityContactRole> ocrList;

		//get the list of the opportunity Product
		oppProductList = [select id, Name, UnitPrice, Discount, ER_Percentage__c, Quantity, ER_NeedApproval__c, Product2.ER_Solution_Type__c, Product2.ER_Type__c, Opportunity.RecordType.DeveloperName, Opportunity.Name, Opportunity.OwnerId, PricebookEntryId, Opportunity.pricebook2Id, PricebookEntry.Name, Product2.Description, Product2.ER_Solution__r.Name, Product2.ER_solution__r.ER_Type__c, Product2.ER_solution__r.ER_Solution_Type__c, ListPrice, CurrencyIsoCode, ER_Card_Operational_System_ID__c, ER_Creation_date_in_OS__c, Opportunity.ER_PaymentTerms__c, Opportunity.ER_InvoicingFrequency__c, Opportunity.ER_PaymentMethod__c, Opportunity.ER_ReimbursementTerm__c, Opportunity.ER_Business_Unit__c, ER_Minimum_Fee__c
		from opportunityLineItem
		where opportunityId = : opportunityId
		order by product2.ER_solution__r.ER_Line_Order__c, product2.ER_Line_Order__c];
		
		ocrList = [Select OpportunityId, role, contactId, isprimary, contact.Email, contact.Phone
		From OpportunityContactRole
		where OpportunityId = : opportunityId and isprimary = true];


		if (!oppProductList.isEmpty()) {

			//Initialise de Quote
			Savepoint sp = Database.setSavepoint();

			Quote newQuote = new Quote();
			if(!ocrList.isEmpty()){
				newQuote.ContactId = ocrList[0].ContactId; 
				newQuote.Email = ocrList[0].contact.Email; 
				newQuote.Phone = ocrList[0].contact.Phone; 
			}
			newQuote.Name = Datetime.now().format('yyyy-MM-dd')+'-'+oppProductList[0].Opportunity.name;
			newQuote.OwnerId = oppProductList[0].Opportunity.ownerId;
			newQuote.OpportunityId = opportunityId;
			newQuote.pricebook2Id = oppProductList[0].Opportunity.pricebook2Id;
			if(oppProductList[0].Opportunity.RecordType.DeveloperName == 'ER_Merchant_Opportunity'){
				newQuote.recordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('ER_Merchant_Quote').getRecordTypeId();
			}
			else if(oppProductList[0].Opportunity.RecordType.DeveloperName == 'ER_Client_Opportunity_RT'){
				newQuote.recordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('ER_Client_Quote').getRecordTypeId();
			}
			newQuote.expirationDate = Date.today().addMonths(1);
			insert newQuote;

			for (opportunityLineItem oli : oppProductList) {

				qli = new QuoteLineItem();
				qli.QuoteId = newQuote.id;
				qli.UnitPrice = oli.UnitPrice;
				qli.ER_Percentage__c = oli.ER_Percentage__c;
				qli.Quantity = oli.Quantity;
				qli.PricebookEntryId = oli.PricebookEntryId;
				qli.ER_Card_Operational_System_ID__c = oli.ER_Card_Operational_System_ID__c;
				qli.ER_Creation_date_in_OS__c = oli.ER_Creation_date_in_OS__c;	
				qli.ER_Minimum_Fee__c = oli.ER_Minimum_Fee__c;	
				qli.Discount = oli.Discount;				

				qliList.add(qli);
				if (oli.ER_NeedApproval__c) {

					opportunityNeedApproval = true;
					break;
				}

				if (oli.Opportunity.ER_Business_Unit__c == 'CZ' && oli.Product2.ER_solution__r.ER_Type__c == Label.LABS_SF_Product_Type_Solution  && oli.Opportunity.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ER_Merchant_Opportunity').getRecordTypeId() && (oli.Product2.ER_solution__r.ER_Solution_Type__c == Label.LABS_SF_Product_Card_Solution_Type && (oli.Opportunity.ER_PaymentTerms__c == null || oli.Opportunity.ER_InvoicingFrequency__c == null || oli.Opportunity.ER_PaymentMethod__c == null)) || (oli.Opportunity.ER_Business_Unit__c == 'CZ' && oli.Product2.ER_solution__r.ER_Solution_Type__c == Label.LABS_SF_Product_PaperVoucher_Solution_Type &&  oli.Opportunity.ER_ReimbursementTerm__c == null)) {

					oliIsCardOrPaper = true;
					System.debug('Boolean Part');
					break;
				}
			}

			if(oliIsCardOrPaper){

				Database.rollback( sp );
				throw new VisualforceException(Label.LABS_SF_Opp_Financial_Conditions_Error_Msg);//this value will be cought in vfp side. no need to use a custom label

			}
			if (opportunityNeedApproval) {
				Database.rollback( sp );
				throw new VisualforceException('Need Approval');//this value will be cought in vfp side. no need to use a custom label
				} else {

					insert qliList;

					currentOpportunity.id = opportunityId;
					currentOpportunity.StageName = Label.LABS_SF_Opp_Status_Proposal;
					update currentOpportunity;

					return newQuote;
				}
			}

			return null;
		}

	/**
	* @author Oussama LASFAR
	* @date 27/12/2018 (dd/mm/yyyy)
	* @description updateOpportunity : if at least one of the opportunity products need approval, then change the ER_NeedApproval__c field value to true.
	*/
	@RemoteAction
	global static boolean updateOpportunity(String opportunityId, String approvalComment) {

		Opportunity opp = new Opportunity();
		opp.id = opportunityId;
		opp.ER_NeedApproval__c = true;
		//upsert opp;
		Database.update(opp);

		return submitForApproval(opportunityId, approvalComment);
	}

	/**
	* @author Oussama LASFAR
	* @date 27/12/2018 (dd/mm/yyyy)
	* @description submitForApproval : launch approval process Merchant_sales_approval.
	*/
	@RemoteAction
	global static boolean submitForApproval(String opportunityId, String approvalComment) {

		Opportunity opp =[SELECT Id, ER_Business_Unit__c FROM Opportunity WHERE Id = :OpportunityId];

		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
		req1.setComments(approvalComment);
		req1.setObjectId(opportunityId);

		// Submit on behalf of a specific submitter
		req1.setSubmitterId(UserInfo.getUserId());

		if (opp.ER_Business_Unit__c == 'CZ'){

			req1.setProcessDefinitionNameOrId('ER_CZ_Opportunity_Approval_Process');

			}else if (opp.ER_Business_Unit__c == 'SK'){
              
              req1.setProcessDefinitionNameOrId('ER_SK_Opportunity_Approval_Process');

			}else{

				req1.setProcessDefinitionNameOrId('ER_Opp_SalesPrice_approval');

			}

		//req1.setSkipEntryCriteria(true);
		if (!Test.isRunningTest()) {
			// Submit the approval request for the account
			Approval.ProcessResult result = Approval.process(req1);
			if (result.isSuccess()) {
				System.debug('Submitted for approval successfully: ' + result.isSuccess());
				return true;
				} else {
					System.debug('Submitted for approval error : '+result.getErrors());
				}
			}
			return false;
		}

		public class VisualforceException extends Exception {}
	}