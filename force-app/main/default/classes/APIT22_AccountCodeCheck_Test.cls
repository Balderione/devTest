@isTest
public with sharing class APIT22_AccountCodeCheck_Test {

	@isTest
	public static void checkSuccess(){
		String accountCode = '324165';

		APIT22_AccountCodeCheck.EncryptModel encryptIstance = new APIT22_AccountCodeCheck.EncryptModel(accountCode);
		String codeEncrypted = encryptIstance.encrypt();
		System.debug(codeEncrypted);


		APIT22_AccountCodeCheck.DecryptModel decryptIstance = new APIT22_AccountCodeCheck.DecryptModel();
		String codeDecrypt = decryptIstance.decrypt(codeEncrypted);
		System.debug(codeDecrypt);

		Boolean isValid = decryptIstance.isValid(codeEncrypted);
		Boolean checksum = decryptIstance.checkSum(accountCode, codeEncrypted);

		System.assert(isValid);
		System.assert(checksum);
	} 

	@isTest
	public static void checkFailed(){
		String accountCode = '324165';

		APIT22_AccountCodeCheck.EncryptModel encryptIstance = new APIT22_AccountCodeCheck.EncryptModel(accountCode);
		String codeEncrypted = encryptIstance.encrypt();
		System.debug(codeEncrypted);


		APIT22_AccountCodeCheck.DecryptModel decryptIstance = new APIT22_AccountCodeCheck.DecryptModel();
		String codeDecrypt = decryptIstance.decrypt(codeEncrypted);
		System.debug(codeDecrypt);

		Boolean isValid = decryptIstance.isValid('12345');
		Boolean checksum = decryptIstance.checkSum(accountCode, '12345');

		System.assert(!isValid);
		System.assert(!checksum);
	} 
}