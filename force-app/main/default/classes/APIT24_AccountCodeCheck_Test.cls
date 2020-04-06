@isTest
public with sharing class APIT24_AccountCodeCheck_Test {

  @isTest
  public static void checkSuccess(){
    String accountCode = '324165';

    APIT24_AccountCodeCheck.EncryptModel encryptIstance = new APIT24_AccountCodeCheck.EncryptModel(accountCode);
    String codeEncrypted = encryptIstance.encrypt();
    System.debug(codeEncrypted);


    APIT24_AccountCodeCheck.DecryptModel decryptIstance = new APIT24_AccountCodeCheck.DecryptModel();
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

    APIT24_AccountCodeCheck.EncryptModel encryptIstance = new APIT24_AccountCodeCheck.EncryptModel(accountCode);
    String codeEncrypted = encryptIstance.encrypt();
    System.debug(codeEncrypted);


    APIT24_AccountCodeCheck.DecryptModel decryptIstance = new APIT24_AccountCodeCheck.DecryptModel();
    String codeDecrypt = decryptIstance.decrypt(codeEncrypted);
    System.debug(codeDecrypt);

    Boolean isValid = decryptIstance.isValid('12345');
    Boolean checksum = decryptIstance.checkSum(accountCode, '12345');

    System.assert(!isValid);
    System.assert(!checksum);
  } 
}