trigger TRIT12_EmailMessageTrigger on EmailMessage (after insert) {
    EmailMessage mailRecieved = trigger.new[0];
    if(mailrecieved.ParentId != NULL && mailRecieved.Incoming){
        if(mailRecieved.isClone() == false ){
            if(trigger.isAfter && APIT15_CasetriggerHandler.isfirsttime){
                APIT15_CasetriggerHandler.isfirsttime = false;
                //APIT15_CasetriggerHandler.emailSender(JSON.serialize(mailRecieved));
                APIT13_EmailMessageTriggerHandler.SemanticEngine(mailRecieved);
            }
            if(trigger.isAfter && APIT05_GetRecordType.isfirsttime){
                APIT05_GetRecordType.isfirsttime = false;
                //APIT05_GetRecordType.deleteAndLinkMailToCase(JSON.serialize(mailRecieved)); 
            }
        }
    }
}