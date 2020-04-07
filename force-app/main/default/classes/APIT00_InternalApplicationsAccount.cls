public with sharing class APIT00_InternalApplicationsAccount extends APIT00_Behaviour {
	
	/**
	 * Retrive sObject from Account
	 * @param  mapFields Map fields to configs
	 * @param  recordId  Current Record Id
	 * @return           Map sObjects
	 */
	public static Map<String,SObject> retriveSObjects(Map<String,Set<String>> mapFields, String recordId, Map<String,String> options){
		DebugStart('APIT00_InternalApplicationsAccount', 'retriveSObjects');
		
		Set<String> accountFields 					= new Set<String>{'Id', 'Name'};
		Set<String> financialCenterFields 			= new Set<String>{'IT_Service__c'};
		Set<String> circuitFields 					= new Set<String>();

		if(mapFields.get('Account') != null) accountFields.addAll(mapFields.get('Account'));
		if(mapFields.get('ER_Financial_Center__c') != null) financialCenterFields.addAll(mapFields.get('ER_Financial_Center__c'));
		if(mapFields.get('IT_Circuit__c') != null) circuitFields.addAll(mapFields.get('IT_Circuit__c'));

		Account account;
		ER_Financial_Center__c financialCenter;
		IT_Circuit__c circuit;

		if(String.isNotBlank(recordId)){
			account = APIT00_InternalApplicationsAccount.getAccount(recordId, accountFields);

			if(options != null){
				String  financialCenterCode = options.get('financialCenter');

				if(String.isNotBlank(financialCenterCode)){
					financialCenter = APIT00_InternalApplicationsAccount.getFinancialCenter(recordId, financialCenterCode, financialCenterFields);
				}

				circuit = APIT00_InternalApplicationsAccount.getCircuit(recordId, circuitFields);
			}
		}

		DebugEnd();
		return new Map<String,SObject>{
			'Account' => account,
			'ER_Financial_Center__c' => financialCenter,
			'IT_Circuit__c' => circuit
		};
	}

	/**
	 * Manage Custom Context
	 * @param values          Current Values extrated
	 * @param financialCenter Finacial Center sObject
	 */
	public static void applyParams(Map<String, String> values, ER_Financial_Center__c finantialCenter){
		DebugStart('APIT00_InternalApplicationsAccount', 'applyParams');

		List<String> manageAccount 		= new List<String>{'1X', '2X'};
		List<String> managePlan 		= new List<String>{'1W', '1L', '1M', '1N', '1O', '1Y', '1B'};
		List<String> manageCards 		= new List<String>{'1V', '1R', 'R', 'C'};
		List<String> manageTicket 		= new List<String>{'1G', '1F', '0D', 'H', '0G', '0F', '0H', '2F', '2G', '0J', '1E', '2K', '1H', '2J', '0K'};

		String service = finantialCenter.IT_Service__c;
		String paramValue = 'home';

		if(manageAccount.contains(service)){
			paramValue = 'gestione-conto';
		}else if(managePlan.contains(service)){
			paramValue = 'gestione-piano';
		}else if(manageCards.contains(service)){
			paramValue = 'gestione-carte';
		}else if(manageTicket.contains(service)){
			paramValue = 'ordine-ticket';
		}

		values.put('Page', paramValue);
		DebugEnd();
	}

	/**
	 * Retrieve current Account
	 * @param  recordId  Account Id
	 * @param  fieldsSet Field Retrieve
	 * @return           Account sObject
	 */
	public static Account getAccount(String recordId, Set<String> fieldsSet){
		DebugStart('APIT00_InternalApplicationsAccount', 'getAccount');

		Set<String> andCondition = new Set <String>{
		    APIT00_SObjectTable.whereField('Id', recordId)
		};

		String query = APIT00_SObjectTable.getTableQuery(fieldsSet, 'Account', andCondition, null, null, 1, null);

		List<Account> listAccounts = Database.query(query);

		Account account = null;
		if(listAccounts.size() == 1) account = listAccounts[0];

		Debug('account', account);
		DebugEnd();
		return account;
	}

	/**
	 * Retrieve current Financial Center
	 * @param  recordId  Financial Center Id
	 * @param  fieldsSet Field Retrieve
	 * @return           Financial Center sObject
	 */
	public static ER_Financial_Center__c getFinancialCenter(String recordId, String financialCenterCode, Set<String> fieldsSet){
		DebugStart('APIT00_InternalApplicationsAccount', 'getFinancialCenter');
		
		fieldsSet.add('Id');

		Set<String> andCondition = new Set <String>{
		    APIT00_SObjectTable.whereField('ER_Account_Name__c', recordId),
		    APIT00_SObjectTable.whereField('IT_Financial_Center__c', financialCenterCode)
		};

		String query = APIT00_SObjectTable.getTableQuery(fieldsSet, 'ER_Financial_Center__c', andCondition, null, null, 1, null);

		List<ER_Financial_Center__c> listfinancialCenters = Database.query(query);

		ER_Financial_Center__c financialCenter = null;
		if(listfinancialCenters.size() == 1) financialCenter = listfinancialCenters[0];

		Debug('financialCenter', financialCenter);
		DebugEnd();
		return financialCenter;
	}

	/**
	 * Retrieve current Circuit
	 * @param  recordId  Circuit Id
	 * @param  fieldsSet Field Retrieve
	 * @return           Circuit sObject
	 */
	public static IT_Circuit__c getCircuit(String recordId, Set<String> fieldsSet){
		DebugStart('APIT00_InternalApplicationsAccount', 'getCircuit');
		
		fieldsSet.add('Id');

		Set<String> andCondition = new Set <String>{
		    APIT00_SObjectTable.whereField('IT_Account__c', recordId)
		};

		String query = APIT00_SObjectTable.getTableQuery(fieldsSet, 'IT_Circuit__c', andCondition, null, null, 1, null);

		List<IT_Circuit__c> listCircuits = Database.query(query);

		IT_Circuit__c circuit = null;
		if(listCircuits.size() == 1) circuit = listCircuits[0];

		Debug('circuit', circuit);
		DebugEnd();
		return circuit;
	}
}