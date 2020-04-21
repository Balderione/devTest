/*
----------------------------------------------------------------------
-- - Name          : APER14_Store_Management
-- - Author        : OLA
-- - Description   : Store Management, This class is used to group all the functionnality linked to the object Store
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Jun-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
public class APER14_Store_Management {

	public static void disableStores(List<ER_Store__c> storeList) {

		for (ER_Store__c store : storeList) {

			store.ER_Status__c = Label.LABS_SF_Store_Inactive;
			store.ER_Closure_Date__c = Date.today();
			store.ER_Closure_Reason__c = Label.LABS_SF_Store_DoesntAcceptAnySolution;
		}

	}

	public static void enableStores(List<ER_Store__c> storeList) {

		for (ER_Store__c store : storeList) {

			store.ER_Status__c = Label.LABS_SF_Store_Active;
			store.ER_Closure_Date__c = null;
			store.ER_Closure_Reason__c = '';
			store.ER_Start_date__c = Date.today();
		}

	}

	public static void deleteStoreLineItemsForAccount(Set<String> solutions, String companyId) {

		delete [select id from ER_Store_Line_Item__c where ER_Store__r.ER_Financial_Center__r.ER_Account_Name__c = : companyId and ER_Solution__c IN : solutions];
	}

	public static void manageSLIFromContract(String companyId) {

		System.debug('manageSLIFromContract START');

		ER_Store_Line_Item__c sli;
		Set<String> storeSolutions = new Set<String>();
		Set<String> allActiveSolutions = new Set<String>();
		List<ER_Store_Line_Item__c> sliListToInsert = new List<ER_Store_Line_Item__c>();
		Set<String> solutionSetToDelete = new Set<String>();
		Map<Id, ER_ContractLineItem__c> allcliList = APER12_Contract_Management.getAllActiveContractLineItems(new Set<String> {companyId}); //get All active solution for a company.

		for (ER_ContractLineItem__c cli : allcliList.values()) {

			allActiveSolutions.add(cli.ER_Product2__r.ER_Solution__c);
		}

		for (ER_Store__c store : [select Id, Name, (select id, ER_Solution__c from Store_line_Items__r)  from ER_Store__c where ER_Financial_Center__r.ER_Account_Name__c = : companyId]) {

			storeSolutions = new Set<String>();
			//Build a set of store's solutions
			for (ER_Store_Line_Item__c sli2 : store.Store_line_Items__r) {

				storeSolutions.add(sli2.ER_Solution__c);
			}

			//check if the store has all company's solutions
			for (String activeSolution : allActiveSolutions) {

				if (!storeSolutions.contains(activeSolution)) {
					sli = new ER_Store_Line_Item__c();
					sli.ER_Solution__c = activeSolution;
					sli.ER_Status__c = Label.LABS_SF_StoreLineItem_Accept;
					sli.ER_Store__c = store.Id;

					sliListToInsert.add(sli);
				}
			}
			//get all solutions to be deleted from store
			storeSolutions.removeAll(allActiveSolutions);
			solutionSetToDelete.addAll(storeSolutions);
		}

		if (!sliListToInsert.isEmpty()) {

			System.debug('sliList to insert : ' + sliListToInsert);
			insert sliListToInsert;
		}
		if (!solutionSetToDelete.isEmpty()) {

			System.debug('solutionSetToDelete : ' + solutionSetToDelete);
			deleteStoreLineItemsForAccount(solutionSetToDelete, companyId);
		}

		System.debug('manageSLIFromContract END');
	}

	public static void manageSLIForNewStore(Map<Id, ER_Store__c> storeMap) {

		System.debug('manageSLIForNewStore START');

		//ER_Financial_Center__r.ER_Account_Name__c is null from trigger ==> need to query to retreive this information.
		List<ER_Store__c> insertedStores = [select id, Name, ER_Financial_Center__r.ER_Account_Name__c  from ER_Store__c where id IN : storeMap.keySet()];
		ER_Store_Line_Item__c sli;
		Set<String> allActiveSolutions = new Set<String>();
		Map<String, Set<String>> mapAccountActiveSolutions = new Map<String, Set<String>>();
		Set<String> accountSolutions = new Set<String>();
		List<ER_Store_Line_Item__c> sliListToInsert = new List<ER_Store_Line_Item__c>();
		Set<String> companySet = new Set<String>();

		for (ER_Store__c store : insertedStores) {

			companySet.add(store.ER_Financial_Center__r.ER_Account_Name__c);
		}

		Map<Id, ER_ContractLineItem__c> allcliList = APER12_Contract_Management.getAllActiveContractLineItems(companySet); //get All active solution for a company.

		//Loop to build Map Companies to solutions
		for (ER_ContractLineItem__c cli : allcliList.values()) {

			allActiveSolutions = new Set<String>();

			if (!mapAccountActiveSolutions.containsKey(cli.ER_Contract__r.accountId)) {

				allActiveSolutions.add(cli.ER_Product2__r.ER_Solution__c);
				mapAccountActiveSolutions.put(cli.ER_Contract__r.accountId, allActiveSolutions);
			} else {

				allActiveSolutions = mapAccountActiveSolutions.get(cli.ER_Contract__r.accountId);
				allActiveSolutions.add(cli.ER_Product2__r.ER_Solution__c);
				mapAccountActiveSolutions.put(cli.ER_Contract__r.accountId, allActiveSolutions);
			}
		}

		if (!mapAccountActiveSolutions.isEmpty()) {
			for (ER_Store__c store : insertedStores) {

				allActiveSolutions = mapAccountActiveSolutions.get(store.ER_Financial_Center__r.ER_Account_Name__c);

				//check if the store has all company's solutions
				for (String activeSolution : allActiveSolutions) {

					sli = new ER_Store_Line_Item__c();
					sli.ER_Solution__c = activeSolution;
					sli.ER_Status__c = Label.LABS_SF_StoreLineItem_Accept;
					sli.ER_Store__c = store.Id;

					sliListToInsert.add(sli);
				}
			}

			if (!sliListToInsert.isEmpty()) {

				System.debug('sliList to insert : ' + sliListToInsert);
				insert sliListToInsert;
			}
		}

		System.debug('manageSLIForNewStore END');
	}
}