trigger TRER13_Store_To_Loop_After_Insert on ER_Store_to_Loop__c (After insert, After update) {

    if (APER10_User_Management.canTrigger) 
    {
        System.debug('###:TRER13_Store_To_Loop_After_Insert  Start');
        APER22_AcceptorToLoopManagement.ManageAcceptorToLoop(trigger.new);
        System.debug('###:TRER13_Store_To_Loop_After_Insert  Finish');
    }
    
}