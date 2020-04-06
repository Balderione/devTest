/**
 * Manage Crypt and Encrypt Account Data
 */
public class APIT24_AccountCodeCheck { 

    public class AccountCodeCheckException extends Exception{}
  
    /**
     * Model to manage Encrypt Account Code
     */
    public class EncryptModel{
    private final String CRYPTO_CODE = '353535';
        private String accountCode;
        public Integer cin;
        public String code;
        
        public EncryptModel(String accountCode){
            this.accountCode = accountCode;
        }
        
        /**
         * Encrypt Account Code
         * @return Value Encrypted
         */
        public String encrypt(){
            if(String.isBlank(this.accountCode)) throw new AccountCodeCheckException('Account Code not Valid');
            
            String[] arrayCryptCode = this.CRYPTO_CODE.split('');
            String[] arrayCode = this.accountCode.split('');
            
            String encryptedCode = '';
            
            Integer sumTotal = 0;
            for(Integer index = 0; index < arrayCode.size(); index++){
                String charCode = arrayCode[index];
                String charCrypt = arrayCryptCode[index];
                
                Integer product = Integer.valueOf(charCode) * Integer.valueOf(charCrypt);
                sumTotal += product;
                
                String codeEncrypted = String.valueOf(product);
                if(product < 10){
                    codeEncrypted = '0' + product;
                }
                encryptedCode += codeEncrypted; 
            }
            
            Integer moduleSum = Math.mod(SumTotal, 10);
            Integer cin = 10 - moduleSum;
            if(cin == 10) cin = 0;
            
            this.code = encryptedCode;
            this.cin = cin;
            
      return encryptedCode + String.valueOf(cin);
        }
    }
    
    /**
     * Model to manage Decrypt e Verify Account Code
     */
    public class DecryptModel{
    private final String CRYPTO_CODE = '353535';
        
        /**
         * Decrypt Account code
         * @param  code Account Code
         * @return      Account Code Decrypted
         */
        public String decrypt(String code){
      String[] arrayCryptCode = this.CRYPTO_CODE.split('');
            String[] arrayDecript = code.substring(0, code.length()-1).split('');
            String cin = code.substring(code.length()-1, code.length());
            String concatValue;
            String decryptResult = '';
            
            for(Integer index = 0; index < arrayDecript.size(); index ++){
                String value = arrayDecript[index];
                Integer modIndex = Math.mod(index, 2);
                if(modIndex == 0){
                    concatValue = '';
                }
                
                concatValue += value;
                
                if(modIndex > 0){
                    Integer valueInt = Integer.valueOf(concatValue);
                    Integer charIndex = Integer.valueOf(index / 2);
                    Integer key = Integer.valueOf(arrayCryptCode[charIndex]);
                    Integer decriptValue = valueInt / key;
                    
                    decryptResult += decriptValue;
                }
            }
            
            
            return decryptResult;
        }
        
        /**
         * Verify if Account code is Valid
         * @param  code Account code
         * @return      True or False
         */
        public Boolean isValid(String code){
      String cin = code.substring(code.length()-1, code.length());
            String decryptValue = this.decrypt(code);
            
            EncryptModel encrypt = new EncryptModel(decryptValue);
            encrypt.encrypt();
              
            return encrypt.cin == Integer.valueOf(cin);
        }
        
        /**
         * Verify AccounCode with Account Code Encrypted
         * @param  accountCode Account Code
         * @param  code        Account Code Encrypted
         * @return             True or False
         */
        public boolean checkSum(String accountCode, String code){
            if(!this.isValid(code)) return false;

      String decryptValue = this.decrypt(code);
            
            EncryptModel encrypt = new EncryptModel(decryptValue);
            String encryptValue = encrypt.encrypt();
            
            return encryptValue == code;
        }
    }
   
}