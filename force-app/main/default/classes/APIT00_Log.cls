public without sharing class APIT00_Log extends APIT00_Behaviour{
	
	public class LogInput{
		public String method;
		public Object request;
		public Object response;
		public String message;
		public String transactionId;
		public String type;
		public String status;
		public String debug;
	}
	/* 
	* List to collect all the Logs to insert
	* All the methods below create an Integration Log record and add it to the list
	*/
	private static List<IT_Log__c> logToInsert =  new List<IT_Log__c>();

	/*
	* This method must be called at the of the process to insert all the Integration Log records
	*/
	public static void insertLogs(){
		DebugStart('APIT00_Log', 'insertLogs');

		try{
			if(APIT00_Log.isActive()){
				if(logToInsert != null && !logToInsert.isEmpty()) insert logToInsert;
			}
		}catch(Exception ex){
			Debug('exception', ex.getMessage());
			Debug('getStackTraceString', ex.getStackTraceString());
		}

		DebugEnd();
	}

	/*
	* This method can be called to create a "Debug" type Integration Log
	* @param function --> String, it is the name of the function to debug
	* @param debug --> String, it is a debug text
	* @param transaction --> String, it is the Id of an Object
	*/
	public static void createDebugLog(LogInput logInput){
		DebugStart('APIT00_Log', 'createDebugLog');
		Debug('logInput', logInput);

		try{
			IT_Log__c newLog = new IT_Log__c(
				IT_Method__c	 	= logInput.method,
				IT_Transaction__c 	= logInput.transactionId,
				IT_Type__c 			= 'Debug',
				IT_Status__c 		= logInput.status,
				IT_Message__c 		= logInput.message
			);

			logToInsert.add(newLog);
		}catch(Exception ex){
			Debug('exception', ex.getMessage());
			Debug('getStackTraceString', ex.getStackTraceString());
		}

		DebugEnd();
	}

	/*
	* This method can be called to create a "Callout" type Integration Log
	* @param function --> String, it is the name of the function to debug
	* @param request --> String, it is the request, may be a JSON
	* @param response --> String, it is the response, may be a JSON
	* @param transaction --> String, it is the Id of an Object
	*/
	public static void callOut(LogInput logInput){
		DebugStart('APIT00_Log', 'callOut');
		Debug('logInput', logInput);

		try{
			IT_Log__c newLog = new IT_Log__c(
				IT_Method__c	 	= logInput.method,
				IT_Transaction__c 	= logInput.transactionId,
				IT_Type__c 			= 'CallOut',
				IT_Status__c 		= logInput.status,
				IT_Message__c 		= logInput.message,
				IT_Request__c 		= JSON.serialize(logInput.request),
				IT_Response__c 		= JSON.serialize(logInput.response),
				IT_Debug__c			= APIT00_Behaviour.getLog()
			);

			logToInsert.add(newLog);

		}catch(Exception ex){
			Debug('exception', ex.getMessage());
			Debug('getStackTraceString', ex.getStackTraceString());
		}

		DebugEnd();
	}

	public static void callOutSave(LogInput logInput){
		APIT00_Log.callOut(logInput);
		APIT00_Log.insertLogs();
	}

	/*
	* This method can be called to create a "Callout" type Integration Log
	* @param function --> String, it is the name of the function to debug
	* @param request --> String, it is the request, may be a JSON
	* @param response --> String, it is the response, may be a JSON
	* @param transaction --> String, it is the Id of an Object
	*/

	public static void callIn(LogInput logInput){
		DebugStart('APIT00_Log', 'callIn');
		Debug('logInput', logInput);

		try{
			IT_Log__c newLog = new IT_Log__c(
				IT_Method__c	 	= logInput.method,
				IT_Transaction__c 	= logInput.transactionId,
				IT_Type__c 			= 'CallIn',
				IT_Status__c 		= logInput.status,
				IT_Message__c 		= logInput.message,
				IT_Request__c 		= JSON.serialize(logInput.request),
				IT_Response__c 		= JSON.serialize(logInput.response),
				IT_Debug__c			= APIT00_Behaviour.getLog()
			);


			logToInsert.add(newLog);

		}catch(Exception ex){
			Debug('exception', ex.getMessage());
			Debug('getStackTraceString', ex.getStackTraceString());
		}

		DebugEnd();
	}

	public static void callInSave(LogInput logInput){
		APIT00_Log.callIn(logInput);
		APIT00_Log.insertLogs();
	}

	/*
	* This method can be called to create an "Error" type Integration Log
	* @param function --> String, it is the name of the function to debug
	* @param error --> String, it is an error text
	* @param transaction --> String, it is the Id of an Object
	*/
	public static void createErrorLog(LogInput logInput){
		DebugStart('APIT00_Log', 'insertLogs');
		Debug('logInput', logInput);

		try{
			IT_Log__c newLog = new IT_Log__c(
				IT_Method__c	 	= logInput.method,
				IT_Transaction__c 	= logInput.transactionId,
				IT_Type__c 			= 'Error',
				IT_Status__c 		= 'Failed',
				IT_Message__c 		= logInput.message
			);


			logToInsert.add(newLog);

		}catch(Exception ex){
			Debug('exception', ex.getMessage());
			Debug('getStackTraceString', ex.getStackTraceString());
		}

		DebugEnd();
	}

	/*
	* This method can be called to create a Generic Integration Log
	* @param function --> String, it is the name of the function to debug
	* @param request --> String, it is the request, may be a JSON
	* @param response --> String, it is the response, may be a JSON
	* @param message --> String, it is a debug text
	* @param transaction --> String, it is the Id of an Object
	* @param message --> String, it define the type of the log
	* @param message --> String, it define the log status
	*/
	public static void createLog(LogInput logInput){

		DebugStart('APIT00_Log', 'createLog');

		try{
			IT_Log__c newLog = new IT_Log__c(
				IT_Method__c	 	= logInput.method,
				IT_Request__c 		= JSON.serialize(logInput.request),
				IT_Response__c 		= JSON.serialize(logInput.response),
				IT_Message__c 		= logInput.message,
				IT_Transaction__c 	= logInput.transactionId,
				IT_Type__c 			= logInput.type,
				IT_Status__c 		= logInput.status
			);


			logToInsert.add(newLog);

		}catch(Exception ex){
			Debug('exception', ex.getMessage());
			Debug('getStackTraceString', ex.getStackTraceString());
		}

		DebugEnd();
	}

}