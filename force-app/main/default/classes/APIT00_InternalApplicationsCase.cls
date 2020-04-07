public with sharing class APIT00_InternalApplicationsCase extends APIT00_Behaviour {

	/**
	 * Retrive sObject from Case
	 * @param  mapFields Map fields to configs
	 * @param  recordId  Current Record Id
	 * @return           Map sObjects
	 */
	public static Map<String,SObject> retriveSObjects(Map<String,Set<String>> mapFields, String recordId, Map<String, String> options){
		DebugStart('APIT00_InternalApplicationsCase', 'retriveSObjects');
		
		Set<String> caseFields 						= new Set<String>{'IT_Financial_Center__c', 'IT_Circuit__c'};
		Set<String> financialCenterFields 			= new Set<String>{'IT_Service__c'};
		Set<String> circuitFields 					= new Set<String>();

		if(mapFields.get('Case') != null) caseFields.addAll(mapFields.get('Case'));
		if(mapFields.get('ER_Financial_Center__c') != null) financialCenterFields.addAll(mapFields.get('ER_Financial_Center__c'));
		if(mapFields.get('IT_Circuit__c') != null) circuitFields.addAll(mapFields.get('IT_Circuit__c'));

		Case caseData;
		ER_Financial_Center__c financialCenter;
		IT_Circuit__c circuit;

		if(String.isNotBlank(recordId)){
			caseData = APIT00_InternalApplicationsCase.getCase(recordId, caseFields);

			if(String.isNotBlank(caseData.IT_Financial_Center__c)){
				financialCenter = APIT00_InternalApplicationsCase.getFinancialCenter(caseData.IT_Financial_Center__c, financialCenterFields);
			}

			if(String.isNotBlank(caseData.IT_Circuit__c)){
				circuit = APIT00_InternalApplicationsCase.getCircuit(caseData.IT_Circuit__c, circuitFields);
			}
		}

		DebugEnd();
		return new Map<String,SObject>{
			'Case' => caseData,
			'ER_Financial_Center__c' => financialCenter,
			'IT_Circuit__c' => circuit
		};
	}

	/**
	 * Manage Custom Context
	 * @param values          Current Values extrated
	 * @param financialCenter Finacial Center sObject
	 */
	public static void applyParams(Map<String, String> values, ER_Financial_Center__c financialCenter){
		DebugStart('APIT00_InternalApplicationsCase', 'applyParams');

		List<String> manageAccount 		= new List<String>{'1X', '2X'};
		List<String> managePlan 		= new List<String>{'1W', '1L', '1M', '1N', '1O', '1Y', '1B'};
		List<String> manageCards 		= new List<String>{'1V', '1R', 'R', 'C'};
		List<String> manageTicket 		= new List<String>{'1G', '1F', '0D', 'H', '0G', '0F', '0H', '2F', '2G', '0J', '1E', '2K', '1H', '2J', '0K'};

		String service = financialCenter.IT_Service__c;
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
	 * Retrieve current Case
	 * @param  recordId  Case Id
	 * @param  fieldsSet Field Retrieve
	 * @return           Case sObject
	 */
	public static Case getCase(String recordId, Set<String> fieldsSet){
		DebugStart('APIT00_InternalApplicationsCase', 'getCase');

		fieldsSet.add('Id');

		Set<String> andCondition = new Set <String>{
		    APIT00_SObjectTable.whereField('Id', recordId)
		};

		String query = APIT00_SObjectTable.getTableQuery(fieldsSet, 'Case', andCondition, null, null, 1, null);

		List<Case> listCases = Database.query(query);

		Case caseData = null;
		if(listCases.size() == 1) caseData = listCases[0];

		Debug('caseData', caseData);
		DebugEnd();
		return caseData;
	}

	/**
	 * Retrieve current Financial Center
	 * @param  recordId  Financial Center Id
	 * @param  fieldsSet Field Retrieve
	 * @return           Financial Center sObject
	 */
	public static ER_Financial_Center__c getFinancialCenter(String recordId, Set<String> fieldsSet){
		DebugStart('APIT00_InternalApplicationsCase', 'getFinancialCenter');

		fieldsSet.add('Id');

		Set<String> andCondition = new Set <String>{
		    APIT00_SObjectTable.whereField('Id', recordId)
		};

		String query = APIT00_SObjectTable.getTableQuery(fieldsSet, 'ER_Financial_Center__c', andCondition, null, null, 1, null);

		List<ER_Financial_Center__c> listFinancialCenters = Database.query(query);

		ER_Financial_Center__c financialCenter = null;
		if(listFinancialCenters.size() == 1) financialCenter = listFinancialCenters[0];

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
		DebugStart('APIT00_InternalApplicationsCase', 'getCircuit');
		
		Set<String> andCondition = new Set <String>{
		    APIT00_SObjectTable.whereField('Id', recordId)
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