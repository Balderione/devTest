trigger Zuora_Account_Sync on Account ( after update ) 
{
  if ( Trigger.isUpdate && Trigger.isAfter )
  {
        Map<Id,Account> accountMap = trigger.newMap;
        
        for (Account acc : accountMap.values()) {
            Account oldAccount = Trigger.oldMap.get(acc.ID);  
            if (acc.Name != oldAccount.Name||acc.IT_Special_Account__c != oldAccount.IT_Special_Account__c) {
                String V_NewName = 'na';
                Decimal V_NewSpecial_Account  =-1;
                
                if (acc.Name != oldAccount.Name) {
                    V_NewName = acc.Name;
                } 
                
                if (acc.IT_Special_Account__c != oldAccount.IT_Special_Account__c) {
                    V_NewSpecial_Account = acc.IT_Special_Account__c;
                }               
                
                
                for(Zuora__CustomerAccount__c ca : [select Zuora__Zuora_Id__c from Zuora__CustomerAccount__c where Zuora__Account__c in:accountMap.keySet() ]){
        
                    Callout_Zuora.updateaccount(ca.Zuora__Zuora_Id__c, V_NewName, V_NewSpecial_Account);
                }                
                
            }      
        }
        


        
        

  }
}