@isTest
public class TRER03_LeadAfterUpdate_Test {
/*
----------------------------------------------------------------------
-- - Name          : TRER03_LeadAfterUpdate_Test
-- - Author        : AAB
-- - Description   : Test class related to the Apex classes cited below
					- TRER03_LeadAfterUpdate
					- APER03_Lead_CreateFinancialCenter
-- Maintenance History:
--
-- Date         Name  				Version  	Remarks 
-- -----------  ----------- 		--------  	---------------------------------------
-- 17-JUL-2018  AAB    				1.0      	Initial version 
---------------------------------------------------------------------------------------
*/
    
    
    static map<String, map<String, RecordType>> recordTypeMap;
    static List<Lead> merchantLeadList;
    static List<Account> merchantAcctList;
    
    static void init(){
		
		/** RecordTypes **/
        recordTypeMap = getRecordTypesBySObject(new List<String>{
                'Lead'
            });
        
        
        /* Merchant lead */
        merchantLeadList = new List<Lead>();
        merchantLeadList.addAll(APER03_Lead_CreateFinancialCenter_Test.createLeadsStandard(1, recordTypeMap.get('Lead').get('ER_Merchant_Lead_RT').Id, '123456789', true));

	}
    
    /** Return the record types by objet **/
    public static map<String, map<String, RecordType>> getRecordTypesBySObject(List<String> sObjectName){
        map<String, map<String, RecordType>> result = new map<String, map<String, RecordType>>();
        
        List<RecordType> recordTypeList = [
            SELECT Id, Name, DeveloperName, SobjectType
            FROM RecordType
            WHERE SobjectType IN :sObjectName
        ];
        
        for(RecordType aRecordType : recordTypeList){
            
            if(!result.containsKey(aRecordType.SobjectType)){
                result.put(aRecordType.SobjectType, new map<String, RecordType>());
            }
            
            result.get(aRecordType.SobjectType).put(aRecordType.DeveloperName, aRecordType);
        }
        
        return result;
    }
    
    
    static testMethod void TestLeadAfterUpdate() {
            
            // Test data setup
            init();
        
            Test.startTest();
        
        	Database.LeadConvert lc = new database.LeadConvert();
        	lc.setLeadId(merchantLeadList[0].Id);
        
        	LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
			lc.setConvertedStatus(convertStatus.MasterLabel);
        
			Database.LeadConvertResult lcr = Database.convertLead(lc);
    
            Test.stopTest();
            
            // Check the results (assert)
            System.assert(lcr.isSuccess());
        
        	List<ER_Financial_Center__c> result = [Select id from ER_Financial_Center__c];
            System.assertEquals(1, result.size(), 'the related financial center had been successfully created');
        
        	List<ER_Store__c> result1 = [Select id, ER_Financial_Center__c from ER_Store__c];
            System.assertEquals(1, result1.size(), 'the related store had been successfully created');
        }
    }