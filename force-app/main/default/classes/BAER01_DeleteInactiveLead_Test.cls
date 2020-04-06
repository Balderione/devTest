@isTest
private class BAER01_DeleteInactiveLead_Test {
    /*
----------------------------------------------------------------------
-- - Name          : BAER01_DeleteInactiveLead_Test
-- - Author        : AAB
-- - Description   : Test class related to the batch cited below
					- BAER01_DeleteInactiveLead
					- 
-- Maintenance History:
--
-- Date         Name  				Version  	Remarks 
-- -----------  ----------- 		--------  	---------------------------------------
-- 12-APR-2018  AAB    				1.0      	Initial version 
---------------------------------------------------------------------------------------
*/
static testMethod void TestBAER01_DeleteInactiveLead() {
        // Test data setup
        List<Lead> ldList = new List<Lead>();
    
    	// Create leads
    	ldList = APER02_Lead_InactiveLead_Test.createLeadsStandard(3, true);
            
        Datetime inactiveDate = Datetime.now().addMonths(-6);
        Test.setCreatedDate(ldList[0].Id, inactiveDate);
    
    	// set the status to rejected
    	ldList[1].Status = 'Rejected';
    
    	update ldList;
    
        Test.startTest();
        System.debug('## >>> Perform test  <<< ');

    	BAER01_DeleteInactiveLead_Schedul sh1 = new BAER01_DeleteInactiveLead_Schedul();     
     	String sch = '0  00 1 3 * ?';
       	system.schedule('Test', sch, sh1);
    
    	// Call the batch
    	BAER01_DeleteInactiveLead myBatch = new BAER01_DeleteInactiveLead();
        Database.executeBatch(myBatch);
    
    
        System.debug('## >>> Perform test  <<< ');
        
        Test.stopTest();

    	// Check the results (assert)
        List<Lead> result = [Select id from Lead];
		System.assertEquals(2, result.size(), 'One of the lead has been deleted by the batch.');
    }
}