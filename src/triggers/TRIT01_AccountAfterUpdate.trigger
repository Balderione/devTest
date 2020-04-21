trigger TRIT01_AccountAfterUpdate on Account (after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean AcoidControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!AcoidControlTrigger && APIT12_CallOutbound.firstTrigger){
        List<Account> accountTriggerNew = new List<Account>();
        List<String> idTriggerNew = new List<String>();
        for(Account singleAcc : trigger.new){
            idTriggerNew.add(singleAcc.Id);
        }
        
        accountTriggerNew = [Select Id, IT_Send_Client_Billing_SDI__c, (Select Id, IT_SDI__c, IT_Client_Status__c From Financial_Centers__r) From Account Where Id IN: idTriggerNew];

        for(Account singleAcc : trigger.new){
            System.debug('singleAcc:: '+singleAcc.IT_Send_Client_Billing_SDI__c); 
            System.debug('singleAcc.Financial_Centers__r:: '+accountTriggerNew[0].Financial_Centers__r); 
            Boolean fcControl = false;
            if(accountTriggerNew[0].Id == singleAcc.Id && accountTriggerNew[0].Financial_Centers__r != null && accountTriggerNew[0].Financial_Centers__r.size() > 0 && singleAcc.IT_Send_Client_Billing_SDI__c == true){
                for(ER_Financial_Center__c singleFc : accountTriggerNew[0].Financial_Centers__r){ 
                    System.debug('singleFc:: '+singleFc);
                    if(String.isBlank(singleFc.IT_SDI__c) && (singleFc.IT_Client_Status__c == '02' || singleFc.IT_Client_Status__c == '05')){
                        fcControl = true;
                        break;    
                    }
                }
            }
            System.debug('fcControl:: '+fcControl);
            if(fcControl == true){
                singleAcc.addError('Inserire lo SDI a livello di tutti i Financial Center Correlati'); 
            }else{
                if(trigger.newMap.get(singleAcc.Id).IT_Group_VAT_Number__c != trigger.oldMap.get(singleAcc.Id).IT_Group_VAT_Number__c && String.isblank(trigger.oldMap.get(singleAcc.Id).IT_Group_VAT_Number__c)){
                    APIT12_CallOutbound.createRequestAccount(trigger.new, 'VatGroupAccount');
                }else if(trigger.newMap.get(singleAcc.Id).IT_Group_VAT_Number__c != trigger.oldMap.get(singleAcc.Id).IT_Group_VAT_Number__c || 
                trigger.newMap.get(singleAcc.Id).IT_VAT_Group_Naming__c != trigger.oldMap.get(singleAcc.Id).IT_VAT_Group_Naming__c || 
                trigger.newMap.get(singleAcc.Id).IT_VAT_Group_PEC__c != trigger.oldMap.get(singleAcc.Id).IT_VAT_Group_PEC__c ||
                trigger.newMap.get(singleAcc.Id).IT_VAT_Group_SDI__c != trigger.oldMap.get(singleAcc.Id).IT_VAT_Group_SDI__c ||
                trigger.newMap.get(singleAcc.Id).IT_Display_VAT_Group__c != trigger.oldMap.get(singleAcc.Id).IT_Display_VAT_Group__c){ 
                    APIT12_CallOutbound.createRequestAccount(trigger.new, 'VatGroup');
                }else{
                    APIT12_CallOutbound.createRequestAccount(trigger.new, 'Account');
                }
            }    
        }        
    }   
}