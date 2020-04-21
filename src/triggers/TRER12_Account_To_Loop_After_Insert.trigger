trigger TRER12_Account_To_Loop_After_Insert on ER_Account_to_Loop__c (After insert, After Update) {
    
    if (APER10_User_Management.canTrigger) 
    {
        System.debug('###:TRER12_Account_To_Loop_After_Insert  Start');
        APER21_StoreToLoopManagement.ManageStoreToLoop(trigger.new);
        System.debug('###:TRER12_Account_To_Loop_After_Insert  Finish');
    }
 
}