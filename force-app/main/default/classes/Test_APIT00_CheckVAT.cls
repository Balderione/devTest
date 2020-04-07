@isTest
public class Test_APIT00_CheckVAT {
    
     @isTest static void realVAT(){
        System.assertEquals(APIT00_CheckVAT.ValidatePartitaIVA('09429840151'), true);
     }  
    
      @isTest static void invalidMaxLenghtVAT(){
        System.assertEquals(APIT00_CheckVAT.ValidatePartitaIVA('123456789014675775'), false);
     }     
     

     @isTest static void invalidMinLenghtVAT(){
        System.assertEquals(APIT00_CheckVAT.ValidatePartitaIVA('123456'), false);
     }       
   
      @isTest static void invalidAlphanumericVAT(){
        System.assertEquals(APIT00_CheckVAT.ValidatePartitaIVA('IT123456789'), false);
     }   
    
    @isTest static void fakeVAT(){
        System.assertEquals(APIT00_CheckVAT.ValidatePartitaIVA('99999999999'), false);
     }  

      @isTest static void fakelVAT2(){
        System.assertEquals(APIT00_CheckVAT.ValidatePartitaIVA('12345678901'), false);
     }  
}