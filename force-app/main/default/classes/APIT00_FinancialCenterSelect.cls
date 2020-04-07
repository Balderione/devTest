public with sharing class APIT00_FinancialCenterSelect extends APIT00_Behaviour{

    public class FinancialCenterException extends Exception{}
    public class FinacialCenterResponse extends APIT00_AuraResponse{
        @AuraEnabled public List<ER_Financial_Center__c> listData;
    }
   
	@AuraEnabled
	public static FinacialCenterResponse getFinancialCenter(String accountId){
	    DebugStart('APIT00_FinancialCenterSelect', 'getFinancialCenter');
	    Debug('accountId', accountId);

	    FinacialCenterResponse response = new FinacialCenterResponse();

	    try{
	        response.listData = [
	            SELECT Name, IT_Financial_Center__c 
	            FROM ER_Financial_Center__c 
	            WHERE ER_Account_Name__c = :accountId
	        ];

	        response.isSuccess = true;
	    }catch(FinancialCenterException ex){
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

}