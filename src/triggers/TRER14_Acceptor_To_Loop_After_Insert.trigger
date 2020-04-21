trigger TRER14_Acceptor_To_Loop_After_Insert on ER_Acceptor_to_Loop__c (After insert, After update) {
    
    if (APER10_User_Management.canTrigger) 
    {
        System.debug('###:TRER14_Acceptor_To_Loop_After_Insert  Start');
        APER22_AcceptorToLoopManagement.CheckAcceptorToLoop(trigger.new);
        System.debug('###:TRER14_Acceptor_To_Loop_After_Insert  Finish');
    }

}