public with sharing class APIT00_InternalApplications extends APIT00_Behaviour {

	public class CustomException extends Exception{}
	public class CustomResponse extends APIT00_AuraResponse{
		@AuraEnabled public List<IT_Internal_Applications__mdt> configs;
	}

	public static final Map<String,String> customLabels = new Map<String, String>{
		'LABS_IT_Portals' 							=> System.Label.LABS_IT_Portals,
		'LABS_IT_Customer_Portal' 					=> System.Label.LABS_IT_Customer_Portal,
		'LABS_IT_Beneficiary_Portal' 				=> System.Label.LABS_IT_Beneficiary_Portal,
		'LABS_IT_Internal_Applications' 			=> System.Label.LABS_IT_Internal_Applications,
		'LABS_IT_Electronic_Orders_Management' 		=> System.Label.LABS_IT_Electronic_Orders_Management,
		'LABS_IT_Paper_Orders_Management' 			=> System.Label.LABS_IT_Paper_Orders_Management,
		'LABS_IT_Billing_System' 					=> System.Label.LABS_IT_Billing_System
	};

	/**
	 * Aura Method to get Init Context
	 * @param  sObjectName sObject Name
	 * @param  recordId    sObject Record Id
	 * @return             Current Context
	 */
	@AuraEnabled
	public static CustomResponse initData(String sObjectName, String recordId, Map<String,String> options){
		DebugStart('APIT00_InternalApplications', 'initData');
		CustomResponse response = new CustomResponse();

		try{

			/**
			 * Retrive current User
			 */
            User currentUser = [
                SELECT Email, Profile.Name
                FROM User
                WHERE Id =: Userinfo.getUserId()
            ];

            String profileName = currentUser.Profile.Name;

            /**
             * Retrieve Record Type
             */
			String recordTypeId = APIT00_InternalApplications.getRecordTypeId(sObjectName, recordId);
			String recordTypeName = Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfosById().get(recordTypeId).getDeveloperName();
			DebugJson('recordTypeName', recordTypeName);

			/**
			 * Retrieve Configs
			 */
			List<IT_Internal_Applications__mdt> configs = APIT00_InternalApplications.getConfigs(
				sObjectName,
				profileName,
				recordTypeName
		 	);

			/**
			 * Retrive Fields
			 */
			Map<String,Set<String>> mapFields = APIT00_InternalApplications.getParams(configs);

			/**
			 * Retrive SObjects
			 */
			Map<String,SObject> mapSObjects = new Map<String,SObject>();
			if(sObjectName == 'Case'){
				mapSObjects = APIT00_InternalApplicationsCase.retriveSObjects(mapFields, recordId, options);
			}else if(sObjectName == 'Account'){
				mapSObjects = APIT00_InternalApplicationsAccount.retriveSObjects(mapFields, recordId, options);
			}

			DebugJson('mapSObjects', mapSObjects);

			/**
			 * Apply Params to QueryString
			 */
			APIT00_InternalApplications.applyParams(sObjectName, configs, mapFields, mapSObjects);

			response.configs = configs;
            response.isSuccess = true;
        }catch(CustomException ex){
            Debug('Exception', ex.getStackTraceString());
            response.errorMessage = ex.getMessage();
        }catch(Exception ex){
            Debug('Exception', ex.getStackTraceString());
            response.errorMessage = ex.getMessage();
        }

		Debug('response', response);
		DebugEnd();
		return response;
	}

	/**
	 * Apply sObjects Field to queryString field
	 * @param context     sObject Name
	 * @param configs     Configs Retrived
	 * @param mapFields   Extrated fields to configs
	 * @param mapSObjects Retrive sObjects Data
	 */
	public static void applyParams(String context, List<IT_Internal_Applications__mdt> configs, Map<String,Set<String>> mapFields, Map<String,SObject> mapSObjects){
		DebugStart('APIT00_InternalApplications', 'applyParams');

		Map<String, String> values = new Map<String,String>();
		for(String sObjectName : mapFields.keySet()){
			for(String field : mapFields.get(sObjectName)){
				SObject sobjectInstance = mapSObjects.get(sObjectName);
				if(sobjectInstance != null){

					String value = (String)sobjectInstance.get(field);
					if(value == null) value = '--DELETE--';

					values.put(sObjectName + '.' + field, value);
				}else{
					values.put(sObjectName + '.' + field, '--DELETE--');
				}
			}

		}

		/**
		 * Mangage Custom contexts
		 */
		if(context == 'Case'){
			APIT00_InternalApplicationsCase.applyParams(values, (ER_Financial_Center__c)mapSObjects.get('ER_Financial_Center__c'));
		}else if(context == 'Account'){
			APIT00_InternalApplicationsAccount.applyParams(values, (ER_Financial_Center__c)mapSObjects.get('ER_Financial_Center__c'));

		}

		Debug('values', values);

		for(IT_Internal_Applications__mdt config : configs){
			if(String.isNotBlank(config.QueryString__c)){
				String queryString = config.QueryString__c;

				queryString = APIT00_CalloutClient.applyParamenters(queryString, values);
				queryString = queryString.replaceAll('([\\w\\-]+=\\-\\-DELETE\\-\\-)', '');
				queryString = queryString.removeEnd('&');
				Debug('QueryString__c', queryString);

				config.QueryString__c = queryString;
			}
		}

		DebugEnd();
	}

	/**
	 * Retrieve Congis
	 * @param  sObjectName    sObject Name
	 * @param  profileName    Profile Name
	 * @param  recordTypeName Current RecordType
	 * @return                List Configs
	 */
	public static List<IT_Internal_Applications__mdt> getConfigs(String sObjectName, String profileName, String recordTypeName){
		DebugStart('APIT00_InternalApplications', 'getConfigs');

		List<IT_Internal_Applications__mdt> configs = [
			SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, 
				QualifiedApiName, SObject__c, Profile__c, RecordType__c, Index__c, GroupIndex__c,
				Label__c, CalledSystem__c, QueryString__c, IsIframe__c, Group__c 
			FROM IT_Internal_Applications__mdt
			WHERE SObject__c = :sObjectName
			AND (Profile__c = :profileName OR Profile__c = '*')
			AND (RecordType__c = :recordTypeName OR RecordType__c = '*')
		];

		/**
		 * Apply Custom Label
		 */
		for(IT_Internal_Applications__mdt config : configs){
			String groupName = config.Group__c;

			if(APIT00_InternalApplications.customLabels.get(groupName) != null){
				config.Group__c = APIT00_InternalApplications.customLabels.get(groupName);
			}

			String labelName = config.Label__c;

			if(APIT00_InternalApplications.customLabels.get(labelName) != null){
				config.Label__c = APIT00_InternalApplications.customLabels.get(labelName);
			}
		}

		DebugJson('configs', configs);
		DebugEnd();

		return configs;
	}

	/**
	 * Extract params from Configs
	 * @param  configs Configs to extract params
	 * @return         Map params
	 */
	public static Map<String,Set<String>> getParams(List<IT_Internal_Applications__mdt> configs){
		DebugStart('APIT00_InternalApplications', 'getParams');

		Map<String,Set<String>> mapFields = new Map<String,Set<String>>();

		for(IT_Internal_Applications__mdt config : configs){
			APIT00_InternalApplications.searchParams(mapFields, config.QueryString__c);
		}

		Debug('mapFields', mapFields);
		DebugEnd();
		return mapFields;
	}

	/**
	 * Search Params to QueryString
	 * @param  mapFields Actual Extracted params
	 * @param  value     QueryString to search Params
	 * @return           Map params to Config
	 */
	public static Map<String,Set<String>> searchParams(Map<String,Set<String>> mapFields, String value){
		if(String.isBlank(value)) return mapFields;

		String regex = '\\{([\\w\\_\\.]+)\\}';

		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher(value);

		while (matcher.find()) {
			String findParam = matcher.group(1);		    

			Map<String,Set<String>> sobjectFields = APIT00_InternalApplications.findSObjectParams(findParam);

			if(sobjectFields.size() > 0){
				for(String sObjectName : sobjectFields.keySet()){
					Set<String> fields = sobjectFields.get(sObjectName);

					Set<String> fieldsAll = mapFields.get(sObjectName);
					if(fieldsAll == null) fieldsAll = new Set<String>();

					fieldsAll.addAll(fields);
					mapFields.put(sObjectName, fieldsAll);
				}
			}else{
				Set<String> fieldsAll = mapFields.get('_apex');
				if(fieldsAll == null) fieldsAll = new Set<String>();

				fieldsAll.add(findParam);
				mapFields.put('_apex', fieldsAll);
			}

		}

		return mapFields;
	}

	/**
	 * Search sObject Fields
	 * @param  value Field to check
	 * @return       Map params to config
	 */
	public static Map<String,Set<String>> findSObjectParams(String value){
		String regex = '([\\w\\_]+)\\.([\\w\\_]+)';

		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher(value);

		Map<String,Set<String>> result = new Map<String,Set<String>>();
		while (matcher.find()) {
			String sObjectName = matcher.group(1);
			String fieldName = matcher.group(2);
		    
		    Set<String> params = result.get(sObjectName);
		    if(params == null) params = new Set<String>{'Id'};

		    params.add(fieldName);
			result.put(sObjectName, params);
		}

		return result;
	}

	/**
	 * Retrieve RecordTypeId from current sObject
	 * @param  sObjectName sObject Name
	 * @param  recordId    Record Id sObject
	 * @return             RecordType Id
	 */
	public static String getRecordTypeId(String sObjectName, String recordId){
		DebugStart('APIT00_InternalApplications', 'getRecordTypeId');

		Set<String> fieldsSet = new Set <String>{
		    'Id', 'RecordTypeId'
		};

		Set<String> andCondition = new Set <String>{
		    APIT00_SObjectTable.whereField('Id', recordId)
		};

		String query = APIT00_SObjectTable.getTableQuery(fieldsSet, sObjectName, andCondition, null, null, 1, null);

		List<SObject> listRecordTypes = Database.query(query);

		String recordTypeName;
		if(listRecordTypes.size() == 1) recordTypeName = (String)listRecordTypes[0].get('RecordTypeId');

		DebugEnd();
		return recordTypeName;
	}
}