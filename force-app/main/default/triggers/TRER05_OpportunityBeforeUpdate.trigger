/*
----------------------------------------------------------------------
-- - Name          : TRER05_OpportunityBeforeUpdate
-- - Author        : OLA
-- - Description   : Trigger on Opportunity Before Update
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  JAN-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
trigger TRER05_OpportunityBeforeUpdate on Opportunity (before update) {

	if (APER10_User_Management.canTrigger) {

		System.debug('###:TRER05_OpportunityBeforeUpdate before Update Start');

		Map<id, Opportunity> newOppMap = trigger.newMap;
		Map<id, Opportunity> oldOppMap = trigger.oldMap;
		List<Opportunity> syncOpportunityList = new List<Opportunity>();

		for (Opportunity opp : newOppMap.values()) {
			if (opp.ER_Approved__c && opp.ER_Approved__c != oldOppMap.get(opp.id).ER_Approved__c) {
				
				System.debug('###:Opportunity : '+opp.Id+' Approved');
				opp.StageName = Label.LABS_SF_Opp_Status_Proposal;
				syncOpportunityList.add(opp);
			}
		}

	/**
	* @author Oussama LASFAR
	* @date 18/01/2019 (dd/mm/yyyy)
	* @description if the Opportunity is approved (Merchant_sales_approval approval process) we need to create quote and clone the opportunity products
	*/
		if (!syncOpportunityList.isEmpty()) {

			APER11_Quote_Management.createdSyncQuote(syncOpportunityList);
		}
		System.debug('###:TRER05_OpportunityBeforeUpdate before Update End');
	}
}