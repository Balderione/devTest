trigger TRIT06_BankAccountAfterUpdate on ER_Bank_Account__c (After Update, Before Update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!ControlTrigger){
        if(Trigger.isBefore){
            Set<String> setAbiCab = new Set<String>();
            List<IT_ABI_CAB__c> listAbiCabObj = new List<IT_ABI_CAB__c>();
            Map<String, IT_Abi_Cab__c> mapAbiCabForBank = new Map<String, IT_Abi_Cab__c>();
            for(ER_Bank_Account__c singleItemcontrol : trigger.new){
                System.debug('singleItemcontrol:: '+singleItemcontrol);
                if(!String.isBlank(singleItemcontrol.IT_Abi__c) && !String.isBlank(singleItemcontrol.IT_Cab__c))
                    setAbiCab.add(singleItemcontrol.IT_Abi__c+singleItemcontrol.IT_Cab__c);
            }
            if(setAbiCab != null && setAbiCab.size() > 0)
                listAbiCabObj = [Select Id, Name, IT_AbiCab__c, IT_Bank__c, IT_CAB__c, IT_ABI__c From IT_Abi_Cab__c Where IT_AbiCab__c IN: setAbiCab];
            System.debug('listAbiCabObj:: '+listAbiCabObj);
            if(listAbiCabObj != null && listAbiCabObj.size() > 0){
                for(IT_Abi_Cab__c singleAbiCab : listAbiCabObj){
                    mapAbiCabForBank.put(singleAbiCab.IT_AbiCab__c, singleAbiCab);
                }
                System.debug('mapAbiCabForBank:: '+mapAbiCabForBank);
                for(ER_Bank_Account__c singleItem : trigger.new){
                    if((trigger.newMap.get(singleItem.Id).IT_ABI__c != trigger.oldMap.get(singleItem.Id).IT_ABI__c || trigger.newMap.get(singleItem.Id).IT_CAB__c != trigger.oldMap.get(singleItem.Id).IT_CAB__c) &&
                    mapAbiCabForBank != null && mapAbiCabForBank.size() > 0 && mapAbiCabForBank.keyset().contains(singleItem.IT_ABI__c+singleItem.IT_CAB__c))
                        singleItem.Name = mapAbiCabForBank.get(singleItem.IT_ABI__c+singleItem.IT_CAB__c).IT_Bank__c;   
                }
            }    
        }    

        if(Trigger.isAfter){
            List<String> idnackAcc = new List<String>();
            List<ER_Bank_Account__c> listEconomicConditions = new List<ER_Bank_Account__c>();
            for(ER_Bank_Account__c singleBA : trigger.new){
                if(trigger.newMap.get(singleBA.Id).IT_SkipActivation__c == trigger.oldMap.get(singleBA.Id).IT_SkipActivation__c)
                    idnackAcc.add(singleBA.Id);
            }
            SObjectType contractType = Schema.getGlobalDescribe().get('ER_Bank_Account__c');
            Map<String,Schema.SObjectField> contractFields = contractType.getDescribe().fields.getMap();
            String query = 'SELECT ';
            for(String field : contractFields.keySet()) {
                query+=field+',';
            }
            SObjectType bankAccountType = Schema.getGlobalDescribe().get('Contract');
            Map<String,Schema.SObjectField> bankAccountFields = bankAccountType.getDescribe().fields.getMap();
            for(String field : bankAccountFields.keySet()) {
                query+='ER_Financial_Center__r.IT_Contract__r.'+field+',';
            }
            SObjectType fcType = Schema.getGlobalDescribe().get('ER_Financial_Center__c');
            Map<String,Schema.SObjectField> fcFields = fcType.getDescribe().fields.getMap(); 
            for(String field : fcFields.keySet()) {
                query+='ER_Financial_Center__r.'+field+',';
            }
            query = query.removeEnd(',');

            System.debug(query);
            query += ' FROM ER_Bank_Account__c WHERE Id IN: idnackAcc';
            listEconomicConditions = Database.query(query);
            if(listEconomicConditions != null && listEconomicConditions.size() > 0)
                APIT12_CallOutbound.createRequestBankAccount(listEconomicConditions); 
        }
    }        
}