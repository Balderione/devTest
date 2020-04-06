/**
* @author Oussama LASFAR
* @date 15/03/2019 (dd/mm/yyyy)
* @description TEST Batch to Synchronize Terminated Contract
*/
@isTest
public class BAHU01_ManageTerminatedContract_Test {

	@testSetup
	static void setup() {

		Account newMerchantAccount = APER07_UtilityTestMethod.getCompany('BAHU01_ManageTerminatedContract_Test');
		insert newMerchantAccount;

		PriceBook2 newPriceBook = APER07_UtilityTestMethod.getpriceBook();
		//update newPriceBook;

		Contract contractInst = APER07_UtilityTestMethod.getContract(newMerchantAccount.Id, Date.today(), Label.LABS_SF_Contract_Status_Draft, newPriceBook.Id);
		insert contractInst;
	}

	static testmethod void testBatchMigration() {

		Test.startTest();

		BAHU01_ManageTerminatedContract terminatedContractBatch = new BAHU01_ManageTerminatedContract(); 
        Database.executeBatch(terminatedContractBatch , Integer.valueOf(Label.LABS_SF_BAHU01_ManageTerminatedContract_batchSize)); 
		
		Test.stopTest();
	}
}