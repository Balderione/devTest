@isTest
public class APIT31_UpdateAccount_Zuora_Test {
    static testMethod void createRecord() { 
        
    RecordType personAccountRecordType =  [SELECT Id FROM RecordType where SobjectType='Account' and Developername='PersonAccount' Limit 1];
        
        Account testAcc1 = new Account(
            IT_Company_Type__c = 'Institution',
            IT_Legal_Form__c = 'SPA',
            FirstName = 'TestName1',
            LastName = 'TestSurname1',
            PersonEmail =  'personal1Email@gmail.com',
            Phone = '12345679',
            PersonMobilePhone = '16844838',
            RecordTypeId = personAccountRecordType.Id,
            IT_Special_Account__c=1,
            IT_Tax_Region_c__c='TestTaxRegion'
        );
       insert testAcc1;
        
        Zuora__CustomerAccount__c testBill1 = new Zuora__CustomerAccount__c(Zuora__Zuora_Id__c='123456789abcdefghilmnopqrst',
                                                                          Zuora__Account__c=testAcc1.id,
                                                                           Name='TestBill1');
        insert testBill1;
        
        testAcc1.LastName='TestLast1';
        update testAcc1;
        
         Account testAcc2 = new Account(
            IT_Company_Type__c = 'Institution',
            IT_Legal_Form__c = 'SPA',
            FirstName = 'TestName2',
            LastName = 'TestLast2',
            PersonEmail =  'personal2Email@gmail.com',
            Phone = '123456789',
            PersonMobilePhone = '16844839',
            RecordTypeId = personAccountRecordType.Id,
            IT_Special_Account__c=1,
            IT_Tax_Region_c__c='TestTaxRegion2'
        );
        insert testAcc2;
        
        testAcc2.LastName='TestSurname2';
        
        Zuora__CustomerAccount__c testBill2 = new Zuora__CustomerAccount__c(Zuora__Zuora_Id__c='0123456789abcdefghilmnopqrst',
                                                                          Zuora__Account__c=testAcc2.id,
                                                                           Name='TestBill2');
        insert testBill2;
        
        testAcc2.LastName='TestSurname2';
        update testAcc2;
        
        List<String> idAcc = new List<String>();
        idAcc.add(testAcc1.id);
        idAcc.add(testAcc2.id);
        
        APIT31_UpdateAccount_Zuora.getToken(idAcc);
        
    }
    
}