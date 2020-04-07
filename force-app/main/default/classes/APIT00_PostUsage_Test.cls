@isTest private class APIT00_PostUsage_Test {
   static testMethod void createRecord() { 
      RecordType personAccountRecordType =  [SELECT Id FROM RecordType where SobjectType='Account' and Developername='PersonAccount' Limit 1];
        
        Account result = new Account(
            IT_Company_Type__c = 'Institution',
            IT_Legal_Form__c = 'SPA',
            FirstName = 'TestName',
            LastName = 'TestSurname',
            PersonEmail =  'personalEmail@gmail.com',
            Phone = '12345679',
            PersonMobilePhone = '16844838',
            RecordTypeId = personAccountRecordType.Id,
            ER_VAT_Number__c ='03183450232'
        );
       insert result;
       
       Zuora__CustomerAccount__c cuAccTest = new Zuora__CustomerAccount__c(Zuora__AccountNumber__c='100000',
                                                                          Zuora__Account__c=result.id,
                                                                          Name='Bill1',
                                                                          Zuora__Zuora_Id__c='123456789testttttt');
       insert cuAccTest;
       Zuora__Subscription__c subTest= new Zuora__Subscription__c(Name = 'TestSub',
                                                                 Zuora__CustomerAccount__c=cuAccTest.id);
                                                                  //,Zuora__SubscriptionNumber__c='A-S00000000');
       insert subTest;
       Zuora__UnitOfMeasure__c uomTest = new Zuora__UnitOfMeasure__c(Name='<abc>Day');
       insert uomTest;
       Zuora__SubscriptionProductCharge__c subProChaTest = new Zuora__SubscriptionProductCharge__c(Zuora__Subscription__c=subTest.id,
                                                                                                  Zuora__ChargeNumber__c='C-00000000',
                                                                                                  Zuora__UOM__c='Day',
                                                                                                  Zuora__UnitOfMeasure__c=uomTest.id);
       insert subProChaTest;
       IT_Usage__c usageTest = new IT_Usage__c (Subscription_Product_Charge__c=subProChaTest.Id,
                                                IT_Used_Quantity__c=1,
                                                IT_Date__c= System.today(),
                                                IT_Description__c='TestApex');
       insert usageTest;
       
       List<IT_Usage__c> itUsa= new List<IT_Usage__c>();
       itUsa.add(usageTest);
       
       APIT00_PostUsage.newUsage(itUsa);
       
       String ZuoraID ='123456789abcdef';
       String id_usa=usageTest.id;
       APIT00_PostUsage.saveID(ZuoraID,id_usa);
       
       delete usageTest;
   }
  
}