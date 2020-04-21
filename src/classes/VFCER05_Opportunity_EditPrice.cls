/*
----------------------------------------------------------------------
-- - Name          : VFCER05_Opportunity_EditPrice
-- - Author        : OLA
-- - Description   : The controller of the page VFER05_Opportunity_EditPrice
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Dec-2018       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/

global class VFCER05_Opportunity_EditPrice {

	//public String opportunityId;
	public Opportunity opportunityRecord {get; set;}
	public String priceBookName {get; set;}
	public List<String> opportunityFields;

	public VFCER05_Opportunity_EditPrice(ApexPages.StandardController controller) {

		priceBookName = '';
		//opportunityId = ApexPages.currentPage().getParameters().get('id');

		//opportunityRecord = (Opportunity) controller.getRecord();
		opportunityRecord = new Opportunity();

		if (String.isNotBlank(controller.getId())) {
			opportunityFields = new List<String>();
			opportunityFields.add('Pricebook2.name');
			opportunityFields.add('Pricebook2id');
			opportunityFields.add('AccountId');
			opportunityFields.add('ER_IsAmended__c');
			opportunityFields.add('ER_AmendedFromOpportunity__r.ContractId');
			opportunityFields.add('ER_AmendedFromContract__c');
			opportunityFields.add('ER_BU_Picklist__c');
			
			if (!Test.isRunningTest()) controller.addFields(opportunityFields);

			opportunityRecord = (Opportunity) controller.getRecord();
			//opportunityRecord = [select id, Pricebook2.name, Pricebook2id  from Opportunity where id = : opportunityId];
			if (String.isNotBlank(opportunityRecord.Pricebook2id)) {
				priceBookName = opportunityRecord.Pricebook2.name;
			}
		}
	}

	/**
	* @author Oussama LASFAR
	* @date 19/02/2019 (dd/mm/yyyy)
	* @description getServices : check if the selected solutions are already in an active contract for the linked account
	*/
	public static void checkExistingContract(Map<String,String> solutionMap, String accountId, String contractId) {
		String errorMessage;
		for (Contract contractInst : [Select id, contractNumber, (Select id, ER_solution__c, ER_Product2__r.ER_solution__c, ER_Product2__r.ER_solution__r.Name From ER_contractLineitems__r )
		                              From Contract
		                              Where AccountId = : accountId and Status = 'Activated' and Id !=: contractId]) { //if not amendement contractId is null
			for (ER_ContractLineItem__c cli : contractInst.ER_contractLineitems__r) {
				if (solutionMap.containsKey(cli.ER_solution__c) && String.isNotBlank(cli.ER_Product2__r.ER_solution__c)) {

					//throw new VisualforceException('<span id="' + cli.ER_Product2__r.ER_solution__c + '"><b>' + cli.ER_Product2__r.ER_solution__r.Name + '</b> already in <a href="/' + contractInst.id + '">' + contractInst.contractNumber + '</a></span>');
					errorMessage = Label.LABS_SF_Opp_Price_ProductExistInContract;
					errorMessage = errorMessage.replace('{0}', solutionMap.get(cli.ER_solution__c)).replace('{1}', cli.ER_solution__c).replace('{2}', '/' + contractInst.id).replace('{3}', contractInst.contractNumber);
					
					throw new VisualforceException(errorMessage);
				}
			}
		}
	}

	/**
	* @author Oussama LASFAR
	* @date 27/12/2018 (dd/mm/yyyy)
	* @description getServices : get services linked to the selected solutions in Phase 1
	*/
	@RemoteAction
	global static List<pricebookentry> getServices(List<String> productList, String priceBook2Id, String accountId, Boolean isAmendedOpportunity, String contractId) {

		List<pricebookentry> serviceList;

		if (!productList.isEmpty()) {

			Set<String> productSet = new Set<String>();//Set of selected solutions
			System.debug('productList : ' + productList);
			for (Id productid : productList) {
				productSet.add(productid);
			}

			System.debug('productSet : ' + productSet);
			serviceList = [select id, Name, ER_Configuration__c, UnitPrice, ER_Approval_Trigger_Value__c, product2.Description, product2.ER_solution__c, product2.ER_solution__r.Name, product2.ER_Solution_Code__c, pricebook2.ER_Business_Unit__c, ER_Percentage__c,  isactive, CurrencyIsoCode, product2.ER_Minimum_Fee__c
			               from pricebookentry
			               where product2.ER_solution__c IN : productSet and product2.ER_Type__c = 'service' and pricebook2Id = : priceBook2Id and isactive = true
			                       order by product2.ER_solution__r.ER_Line_Order__c, product2.ER_Line_Order__c asc];

			// Map solution Code and SOlution ID
			Map<String,String> solutionMap = new Map<String,String>();

			for (pricebookentry pbe : serviceList) {
				if(String.isNotBlank(pbe.product2.ER_Solution_Code__c)){

					solutionMap.put(pbe.product2.ER_Solution_Code__c, pbe.product2.ER_solution__c);
				}
			}

			//Check if there is already a contract linked to the solutions selected
			//OLA Update 02042019 check also the CLI Solution Code
			checkExistingContract(solutionMap, accountId, contractId);
		}

		return serviceList;
	}

	/**
	* @author Oussama LASFAR
	* @date 27/12/2018 (dd/mm/yyyy)
	* @description getSolutions : get All Opportunity's pricebook solutions
	*/
	public List<PricebookEntry> getSolutions  {
		get{
			if (opportunityRecord.Id != null) {
				List<PricebookEntry> solutionList = [select id, Name, Pricebook2id, Pricebook2.name, Pricebook2.ER_Business_Unit__c, Product2.id, Product2.ER_Type__c, isactive
				from pricebookentry
				where Product2.ER_Type__c = 'Solution' and Pricebook2id = : opportunityRecord.pricebook2Id and Pricebook2.isactive=true and isactive = true
				order by product2.ER_Line_Order__c, Name asc];
				System.debug('###getSolutions : ' + solutionList);
				return solutionList;
			}

			return new List<PricebookEntry>();
		}
		set {}
	}

    /**
    * @author Oussama LASFAR
    * @date 15/10/2019 (dd/mm/yyyy)
    * @description getProductDependencies : get Products dependencies
    */
    @RemoteAction
    public static Map<Id, ER_Product_Dependency__c> getProductDependencies(String oppBusinessUnit) {
        
        Map<Id, ER_Product_Dependency__c> mapProductDependencies = new Map<Id, ER_Product_Dependency__c>([SELECT id, ER_Controlling_Product__c, ER_Controlling_Product__r.Name, ER_Controlling_Product__r.ER_Solution__c, ER_Dependent_Product__c, ER_Dependent_Product__r.Name, ER_Dependent_Product__r.ER_Solution__c, ER_Configuration__c
                                                 FROM ER_Product_Dependency__c
                                                 WHERE ER_Controlling_Product__r.ER_Business_Unit__c =: oppBusinessUnit AND ER_Dependent_Product__r.ER_Business_Unit__c =: oppBusinessUnit
                                                 AND ER_Controlling_Product__r.IsActive = true AND ER_Dependent_Product__r.IsActive = true]);

        return mapProductDependencies;
    }    

	/**
	* @author Oussama LASFAR
	* @date 27/12/2018 (dd/mm/yyyy)
	* @description saveOpportunityProducts : save selected opportunity line items and update current opportunity fields : ER_NeedApproval__c & ER_Approved__c
	*/
	@RemoteAction
	global static Id saveOpportunityProducts(List<OpportunityLineItem> lineItemsToSave, String opportunityId) {

		Set<Id> setOli = new Set<Id>();
		for (OpportunityLineItem oli : lineItemsToSave) {
			setOli.add(oli.Id);
		}
		System.debug('lineItemsToSave :' + lineItemsToSave);

		delete [select id from OpportunityLineItem where opportunityId = : opportunityId AND id NOT IN : setOli];

		upsert lineItemsToSave;

		Opportunity currentOpportunity = new Opportunity();
		currentOpportunity.id = opportunityId;
		currentOpportunity.ER_NeedApproval__c = false;
		currentOpportunity.ER_Approved__c = false;

		update currentOpportunity;

		return null;
	}

	/**
	* @author Oussama LASFAR
	* @date 27/12/2018 (dd/mm/yyyy)
	* @description getOpportunityProduct : get Products linked to the current Opportunity
	*/
	@RemoteAction
	global static Map<String, OpportunityLineItem> getOpportunityProduct(String opportunityId) {

		Map<String, OpportunityLineItem> mapProductOli = new Map<String, OpportunityLineItem>();
		List<OpportunityLineItem> oliList = [select id, OpportunityId, Product2Id, Product2.ER_Solution__c, ER_Percentage__c, UnitPrice,
		                                     ListPrice, Quantity, ER_Minimum_Fee__c, Discount
		                                     from OpportunityLineItem
		                                     where opportunityid = : opportunityId];

		System.debug('###oliList : ' + oliList);

		for (OpportunityLineItem oli : oliList) {

			mapProductOli.put(oli.Product2Id, oli);
		}

		return mapProductOli;
	}
    
    

	public class VisualforceException extends Exception {}
}