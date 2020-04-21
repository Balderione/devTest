@isTest
public class TRIT28_QuoteOnDemandSyncTrigger_Test {
    static testMethod void createRecord() {
        RecordType quoteRecordType =  [SELECT Id FROM RecordType where SobjectType='zqu__Quote__c' and Developername='Amendment' Limit 1];
      	zqu__Quote__c quoTest = new zqu__Quote__c(RecordTypeId = quoteRecordType.Id,
                                                  name='testQuote',
                                                  IT_Cod_Cli_Padre__c='33333',
                                               	  IT_Recurring_Start_Date__c=System.today());
        insert quoTest;

        quoTest.IT_Recurring_Start_Date__c=System.today()+3;
        update quoTest;
        
        delete quoTest;
    }
    
}