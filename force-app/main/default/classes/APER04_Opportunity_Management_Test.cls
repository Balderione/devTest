/*
----------------------------------------------------------------------
-- - Name          : APER04_Opportunity_Management_Test
-- - Author        : OLA
-- - Description   : Test Class for APER04_Opportunity_Management
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  JAN-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
@isTest
public class APER04_Opportunity_Management_Test {

	@testSetup
	static void testSetup() {

		Account newMerchantAccount = APER07_UtilityTestMethod.getCompany('testCompany');
		insert newMerchantAccount;

		Opportunity newOpportunity = APER07_UtilityTestMethod.getOpportunity('ER_Merchant_Opportunity', 'APER04_Opportunity_Management_Test');
		newOpportunity.AccountId = newMerchantAccount.Id;
		insert newOpportunity;
	}

	static testMethod void getOpportunityRecordTest() {

        List<Opportunity> opportunityList = [select id from Opportunity where Name='APER04_Opportunity_Management_Test'];
        if(!opportunityList.isEmpty()){
        	APER04_Opportunity_Management.getOpportunityRecord(opportunityList[0].id);
        }
    }
}