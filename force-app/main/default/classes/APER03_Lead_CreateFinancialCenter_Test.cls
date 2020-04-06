@isTest
public class APER03_Lead_CreateFinancialCenter_Test {
/*
----------------------------------------------------------------------
-- - Name          : APER03_Lead_CreateFinancialCenter_Test
-- - Author        : AAB
-- - Description   : Test class related to the Apex classes cited below
					- APER03_Lead_CreateFinancialCenter
-- Maintenance History:
--
-- Date         Name  				Version  	Remarks 
-- -----------  ----------- 		--------  	---------------------------------------
-- 17-JUL-2018  AAB    				1.0      	Initial version 
---------------------------------------------------------------------------------------
*/
     public static List<Lead> createLeadsStandard(Integer numlds, Id recordType, String vatNumber,  Boolean isToInsert) {
        List<Lead> leads = new List<Lead>();
        
         
         // Retrieve picklist values
        Schema.DescribeFieldResult fieldResult =
 				Lead.Status.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         
        for(Integer i=0;i<numlds;i++) {
            Lead ld = new Lead(
                ER_Store_Name__c = 'my store',
                LastName ='lastname' + i,
                FirstName ='firstname' + i,
                Status = ple[0].getValue(),
            	RecordTypeId = recordType,
            	ER_VAT_Number__c = vatNumber,
                Company = 'Edenred',
                Email = 'test@salesforce.com',
                Street = '178, boulevard Gabriel Péri ',
            	City = 'Malakoff',
                ER_Terminal__c = 'Yes',
                PostalCode = '92240',
                ER_Language__c = 'EN'
            	);
            leads.add(ld);
        }
         
         if (isToInsert) {
             insert leads;
         } 

        return leads;
    }
}