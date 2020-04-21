/*
----------------------------------------------------------------------
-- - Name          : APHU12_Contract_Management
-- - Author        : OLA
-- - Description   : Contract Management, This class is used to group all the functionnality linked to the object Contract
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  FEB-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
public class APHU12_Contract_Management {

	public static List<Contract> createContractFromQuote(Map<id, Quote> acceptedQuoteMap) {

		return APER12_Contract_Management.createContractFromQuote(acceptedQuoteMap);
	}

	public static Void createCLIAndUpdateOpportunity(Map<id, Quote> acceptedQuoteMap) {

		APER12_Contract_Management.createCLIAndUpdateOpportunity(acceptedQuoteMap);
	}

	@Future
	public static void deleteContractFromQuote(Set<id> deniedQuoteContractids) {

		APER12_Contract_Management.deleteContractFromQuote(deniedQuoteContractids);
	}

	@AuraEnabled
	public static List<Contract> getContract(String contractId) {

		return APER12_Contract_Management.getContract(contractId);
	}


	public static Map<Id,ER_ContractLineItem__c> getContractLineItems(String contractId) {

		return APER12_Contract_Management.getContractLineItems(contractId);
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

		return APER12_Contract_Management.contractAmendment(contractId, opportunityId);
	}

	@AuraEnabled
	public static void activateContractController(Contract contract, String opportunityId) {

		APER12_Contract_Management.activateContractController(contract, opportunityId);
	}

	/*
	* LASFAR
	* 27/03/2019
	* terminateContract : For batch process, update status to Terminated when WS status is succeeded.
	*/
	public static void terminateContract(Contract contract) {

		APER12_Contract_Management.terminateContract(contract);
	}

	/*
	* LASFAR
	* 14/02/2019
	* deleteCLIFromContract : For each deleted contract delete linked contract line items (no Master detail RelationShip)
	*/
	public static void deleteCLIFromContract(Map<id, Contract> contractMap) {

		APER12_Contract_Management.deleteCLIFromContract(contractMap);
	}

	/*
	*
	*/
	@AuraEnabled
	public static Account getAccountWS(Id accId) {

		return APHU11_EdgSyncCallout.getAccountWS(accId);
	}

	@AuraEnabled
	public static String beforeEdgWS(Id merchantId) {

		return APHU11_EdgSyncCallout.beforeEdgWS(merchantId);
	}

	@AuraEnabled
	public static String[] saveEdgWS(Id merchantId) {

		return APHU11_EdgSyncCallout.saveEdgWS(merchantId);
	}

	public static String checkExistingSolutionsContract(Contract contractInst) {

		Set<String> solutionSetToCheck = new Set<String>();
		Map<String,String> mapContractSolutionToCheck = new Map<String,String>();
		Set<String> currentsolutionSet = new Set<String>();
		Map<String,String> mapContractCurrentSolution = new Map<String,String>();
		String amendedFrom = '';

		if (contractInst.ER_OpportunityId__r.ER_IsAmended__c) {

			amendedFrom = String.isNotBlank(contractInst.ER_OpportunityId__r.ER_AmendedFromContract__c) ? contractInst.ER_OpportunityId__r.ER_AmendedFromContract__c : contractInst.ER_OpportunityId__r.ER_AmendedFromOpportunity__r.ContractId;
		}

		for (Contract contrat : [select id, Status, ContractNumber, (select id, ER_Contract__c, ER_Solution__c from ER_ContractLineItems__r)  from Contract where AccountId = : contractInst.AccountId and status != : Label.LABS_SF_Contract_Status_Terminated and id != : amendedFrom]) {
			for (ER_ContractLineItem__c cli : contrat.ER_ContractLineItems__r) {
				if (contrat.Id == contractInst.Id) {

					currentsolutionSet.add(cli.ER_Solution__c);
					mapContractCurrentSolution.put(cli.ER_Solution__c,contrat.ContractNumber);
				} else if(contrat.Status == Label.LABS_SF_Contract_Status_Activated) {

					solutionSetToCheck.add(cli.ER_Solution__c);
					mapContractSolutionToCheck.put(cli.ER_Solution__c,contrat.ContractNumber);
				}
			}
		}
		System.debug('### checkExistingSolutionsContract');
		System.debug('### currentsolutionSet : '+currentsolutionSet);
		System.debug('### solutionSetToCheck : '+solutionSetToCheck);
		for (String newSolutions : mapContractCurrentSolution.keySet()) {
			if (mapContractSolutionToCheck.containsKey(newSolutions)) {

				System.debug('### mapContractSolutionToCheck.get(newSolutions) : '+newSolutions +' '+ mapContractSolutionToCheck.get(newSolutions));
				return newSolutions+':'+mapContractSolutionToCheck.get(newSolutions);
			}
		}
		return '';
	}

	@AuraEnabled
	public static String[] saveContractEdgWS(Contract contractInst,String action) {

		List<String> responseToshow =  new List<String>();
		WSHU04_ContractTemplateWS.ContractResponse contractWSResponse;
		HttpResponse res;
		String responseErrorStatusMessage;
		String messageToDisplay = '';
		Boolean isUpdate = false;

		// Get linked contract line items
		Map<String, List<ER_ContractLineItem__c>> mapSolutionCliToInsert= new Map<String, List<ER_ContractLineItem__c>>();
		Map<String, List<ER_ContractLineItem__c>> mapSolutionCliToUpdate= new Map<String, List<ER_ContractLineItem__c>>();
		List<ER_ContractLineItem__c> cliListToMap = new List<ER_ContractLineItem__c>();
		List<ER_ContractLineItem__c> cliList = [Select id, ER_IsActive__c, Name, ER_Contract__r.StartDate, ER_Contract__r.EndDate, ER_ProductCode__c, ER_Solution__c, ER_Product2__r.ER_Do_Not_Synchronize__c, ER_UnitPrice__c, ER_Percentage__c, CurrencyIsoCode, ER_Creation_date_in_OS__c, ER_End_Date__c, ER_Minimum_Fee__c  from ER_ContractLineItem__c where ER_Contract__c = : contractInst.Id];
		Map<String, ER_ContractLineItem__c> mapProductSolCodeToCLI = new Map<String, ER_ContractLineItem__c>();
		Map<String, ER_ContractLineItem__c> mapProductCodeToCLI = new Map<String, ER_ContractLineItem__c>();

		List<Contract> allAcountContracts = [Select id, ER_Creation_date_in_OS__c, ER_Last_date_of_Sync__c  from Contract where AccountId = : contractInst.AccountId];
		String checkResult = '';

		if(action != 'Termination'){//exclude batch processes
			
			checkResult = checkExistingSolutionsContract(contractInst);
		}

		if(String.isNotBlank(checkResult)){

			responseToshow.add('failed');
			responseToshow.add(Label.LABS_SF_ActivateContract_SolutionExist+checkResult);
			return responseToshow;
		}

		for (Contract contract : allAcountContracts) {
			if(contract.ER_Creation_date_in_OS__c != null || contract.ER_Last_date_of_Sync__c != null){
				//update
				isUpdate = true;
			}
		}
		
		if (isUpdate) {
			
			for (ER_ContractLineItem__c cli : cliList) {
				cli.ER_IsActive__c = true;
				if (mapSolutionCliToUpdate.get(cli.ER_Solution__c) != null) {

					cliListToMap = mapSolutionCliToUpdate.get(cli.ER_Solution__c);
					cliListToMap.add(cli);
					mapSolutionCliToUpdate.put(cli.ER_Solution__c, cliListToMap);
				} else {

					cliListToMap = new List<ER_ContractLineItem__c>();
					cliListToMap.add(cli);
					mapSolutionCliToUpdate.put(cli.ER_Solution__c, cliListToMap);
				}
				mapProductCodeToCLI.put(cli.ER_ProductCode__c, cli);
				mapProductSolCodeToCLI.put(cli.ER_Solution__c, cli);
				
			}
			//Check Disabled Services
			if (contractInst.ER_OpportunityId__r.ER_IsAmended__c && action != 'Termination') {

				String amendedFrom = String.isNotBlank(contractInst.ER_OpportunityId__r.ER_AmendedFromContract__c) ? contractInst.ER_OpportunityId__r.ER_AmendedFromContract__c : contractInst.ER_OpportunityId__r.ER_AmendedFromOpportunity__r.ContractId;
				List<ER_ContractLineItem__c> oldCliList = [Select id, ER_IsActive__c, Name, ER_Contract__r.StartDate, ER_Contract__r.EndDate, ER_ProductCode__c, ER_Solution__c, ER_Product2__r.ER_Do_Not_Synchronize__c, ER_UnitPrice__c, ER_Percentage__c, CurrencyIsoCode, ER_Creation_date_in_OS__c, ER_End_Date__c, ER_Minimum_Fee__c  from ER_ContractLineItem__c where ER_Contract__c = : amendedFrom];
				Boolean serviceExist = false;
				List<ER_ContractLineItem__c> cliToDisable = new List<ER_ContractLineItem__c>();
				for (ER_ContractLineItem__c cli : oldCliList) {
					cliToDisable = new List<ER_ContractLineItem__c>();
					if (!mapProductSolCodeToCLI.containsKey(cli.ER_Solution__c) && !cli.ER_Product2__r.ER_Do_Not_Synchronize__c) {

						//cli.ER_end_Date__c = Date.today();
						//cliToDisable.add(cli);
						System.debug('Solution GONE : '+cli.ER_Solution__c+' Service GONE : '+cli.ER_ProductCode__c);
						cli.ER_end_Date__c = Date.today();
						cli.ER_IsActive__c = false;
						if(mapSolutionCliToUpdate.containsKey(cli.ER_Solution__c)){

							cliToDisable = mapSolutionCliToUpdate.get(cli.ER_Solution__c);
						}
						cliToDisable.add(cli);
						mapSolutionCliToUpdate.put(cli.ER_Solution__c, cliToDisable);
						//mapProductCodeToCLI.put(cli.ER_Solution__c, cli);
					}
					else if(!mapProductCodeToCLI.containsKey(cli.ER_ProductCode__c) && !cli.ER_Product2__r.ER_Do_Not_Synchronize__c){
						System.debug('Service GONE : '+cli.ER_ProductCode__c);	
						cli.ER_IsActive__c = false;
						cliToDisable = mapSolutionCliToUpdate.get(cli.ER_Solution__c);
						cliToDisable.add(cli);
						mapSolutionCliToUpdate.put(cli.ER_Solution__c, cliToDisable);
					}
				}
			}
		} else{
			for (ER_ContractLineItem__c cli : cliList) {
				cli.ER_IsActive__c = true;
				if (mapSolutionCliToInsert.get(cli.ER_Solution__c) != null) {

					cliListToMap = mapSolutionCliToInsert.get(cli.ER_Solution__c);
					cliListToMap.add(cli);
					mapSolutionCliToInsert.put(cli.ER_Solution__c, cliListToMap);
				} else {

					cliListToMap = new List<ER_ContractLineItem__c>();
					cliListToMap.add(cli);
					mapSolutionCliToInsert.put(cli.ER_Solution__c, cliListToMap);
				}
			}
		}
		
		System.debug('### mapSolutionCliToInsert : '+mapSolutionCliToInsert);
		System.debug('### mapSolutionCliToUpdate : '+mapSolutionCliToUpdate);
		if (!mapSolutionCliToInsert.isEmpty() || !mapSolutionCliToUpdate.isEmpty()) {
			try {
				
				if(!mapSolutionCliToUpdate.isEmpty()){

					contractWSResponse = WSHU05_SynchronizeContractWS.callContractWS(contractInst, mapSolutionCliToUpdate, true);
				}
				else if(!mapSolutionCliToInsert.isEmpty()){

					contractWSResponse = WSHU05_SynchronizeContractWS.callContractWS(contractInst, mapSolutionCliToInsert, false);
				}
				System.debug('### contractWSResponse : ' + contractWSResponse);

				System.debug('### contractWSResponse.meta.messages : ' + contractWSResponse.meta.messages);

				for (WSHU04_ContractTemplateWS.Message message : contractWSResponse.meta.messages) {
					
					String productRef = String.isNotBlank(message.product_ref)?' : '+message.product_ref:' ';
					messageToDisplay += message.code + productRef;
				}

				Map<String, String> mapSolutionsCMOid = new Map<String, String>();
				if (contractWSResponse.data != null && contractWSResponse.data.contractsProducts != null) {
					System.debug('### IN contractWSResponse.data : ' + contractWSResponse.data);
					for (WSHU04_ContractTemplateWS.ContractsProduct contProduct : contractWSResponse.data.contractsProducts) {
						if (contProduct.product != null && String.isNotBlank(contProduct.product.product_ref)) {
							if (!mapSolutionsCMOid.containsKey(contProduct.product.product_ref)) {
								if (contProduct.refs != null && String.isNotBlank(contProduct.refs.reference)) {

									mapSolutionsCMOid.put(contProduct.product.product_ref, contProduct.refs.reference);
								} else {

									mapSolutionsCMOid.put(contProduct.product.product_ref, '');
								}
							}
						}
					}
				}
				System.debug('### contractWSResponse.meta.status : ' + contractWSResponse.meta.status);
				responseErrorStatusMessage = contractWSResponse.meta.status;
				if (responseErrorStatusMessage == 'failed' && !mapSolutionsCMOid.isEmpty()) {

					responseErrorStatusMessage = 'warning';
				}
				System.debug('responseErrorStatusMessage: ' + responseErrorStatusMessage);
				responseToshow.add(responseErrorStatusMessage);
				responseToshow.add(messageToDisplay);

				if (!mapSolutionsCMOid.isEmpty()) {
					if(responseErrorStatusMessage=='warning'){

						contractInst.ER_WS_StatusCode__c = '3';
						contractInst.ER_WS_Message__c = messageToDisplay;
						updateContractLineItemsFromWS(mapSolutionsCMOid, contractInst, true, action);
					}
					else{
						contractInst.ER_WS_StatusCode__c = '1';
						contractInst.ER_WS_Message__c = responseErrorStatusMessage;
						updateContractLineItemsFromWS(mapSolutionsCMOid, contractInst, false, action);
					}
				}
				else{
					contractInst.ER_WS_StatusCode__c = '2';
					contractInst.ER_WS_Message__c = messageToDisplay;
					//contractInst.ER_Last_date_of_Sync__c = Datetime.now();
					update contractInst;
				}

			} catch (Exception e) {

				System.debug('### Error message : ' + e.getMessage());
				responseToshow.add('failed');
				//responseToshow.add('Unable to parse the server message.');
				responseToshow.add(e.getMessage());
				contractInst.ER_WS_StatusCode__c = '2';
				contractInst.ER_WS_Message__c = e.getMessage();
				//contractInst.ER_Last_date_of_Sync__c = Datetime.now();
				update contractInst;
				return responseToshow;
			}
		}
		

		return responseToshow;
	}

	public static void updateContractWsInfos(Contract contractInst, Boolean hasError, String action) {

		if (contractInst.ER_Creation_date_in_OS__c == null) {

			contractInst.ER_Creation_date_in_OS__c = Datetime.now();
		}

		contractInst.ER_Last_date_of_Sync__c = Datetime.now();
		//If Contract was totally synchronized ==> Activate contract
		if(!hasError){
			if(action == 'Activation'){ // Hardcoded technical variable. it come from Aura Activation component & Termination Batch.

				activateContractController(contractInst, contractInst.ER_OpportunityId__c);
			}
			else if(action == 'Termination'){

				contractInst.ER_TerminationReason__c = Label.LAB_SF_Contract_Amendment;
				contractInst.ER_Termination_date_in_OS__c = Datetime.now();
				contractInst.ER_Terminated_Date__c  = Datetime.now();
				terminateContract(contractInst);
			}
			
		}
		else{
		//If Contract was partially synchronized ==> Update Sync Dates fields on Contract object
			update contractInst;
		}
		
	}

	public static void updateContractLineItemsFromWS(Map<String, String> mapSolutionsCMOid, Contract contractInst, Boolean hasError, String action) {

		List<Sobject> cliList = new List<Sobject>();
		List<ER_ContractLineItem__c> cliQuery = [select Id, Name, ER_Solution__c, ER_Card_Operational_System_ID__c, ER_Creation_date_in_OS__c from ER_ContractLineItem__c where ER_Contract__c =: contractInst.Id AND ER_Solution__c IN : mapSolutionsCMOid.keySet()];
		System.debug('mapSolutionsCMOid : '+mapSolutionsCMOid);
		System.debug('cliQuery : '+cliQuery);
		for (ER_ContractLineItem__c cli : cliQuery) {

			if (cli.ER_Card_Operational_System_ID__c == null) {
				
				cli.ER_Card_Operational_System_ID__c = mapSolutionsCMOid.get(cli.ER_Solution__c);
			}
			if (cli.ER_Creation_date_in_OS__c == null) {

				cli.ER_Creation_date_in_OS__c = Datetime.now();
			}
			cli.ER_Last_date_of_Sync__c = Datetime.now();
			cliList.add(cli);
		}
		if (!cliList.isEmpty()) {

			update cliList;
			updateContractWsInfos(contractInst, hasError, action);
		}
	}
}