trigger TRIT05_ContractAfterUpdate on Contract (after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean ControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    List<String> idContract = new List<String>();
    List<Contract> listEconomicConditions = new List<Contract>();
    if(!ControlTrigger && trigger.newMap.get(trigger.new[0].Id).IT_SkipActivation__c == trigger.oldMap.get(trigger.new[0].Id).IT_SkipActivation__c){
        System.debug('Contract - EC: '+trigger.new[0].IT_Change_Economic_Conditions__c);
        System.debug('Contract - Document: '+trigger.new[0].IT_Change_Document__c);
        if( trigger.newMap.get(trigger.new[0].Id).IT_Commission_Type__c != trigger.oldMap.get(trigger.new[0].Id).IT_Commission_Type__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Commission_Percentage__c != trigger.oldMap.get(trigger.new[0].Id).IT_Commission_Percentage__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Discount_Type__c != trigger.oldMap.get(trigger.new[0].Id).IT_Discount_Type__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Discount_Percentage__c != trigger.oldMap.get(trigger.new[0].Id).IT_Discount_Percentage__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Fine_Interest_Type__c != trigger.oldMap.get(trigger.new[0].Id).IT_Fine_Interest_Type__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Not_Standard_VAT__c != trigger.oldMap.get(trigger.new[0].Id).IT_Not_Standard_VAT__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Transport_Cost__c != trigger.oldMap.get(trigger.new[0].Id).IT_Transport_Cost__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_No_Cost_Reason__c != trigger.oldMap.get(trigger.new[0].Id).IT_No_Cost_Reason__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Promo_Code__c != trigger.oldMap.get(trigger.new[0].Id).IT_Promo_Code__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Invoice_Detail__c != trigger.oldMap.get(trigger.new[0].Id).IT_Invoice_Detail__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Debt_Notes__c != trigger.oldMap.get(trigger.new[0].Id).IT_Debt_Notes__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Debt_Notes_Effective_Date__c != trigger.oldMap.get(trigger.new[0].Id).IT_Debt_Notes_Effective_Date__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Debt_Notes_Percentage__c != trigger.oldMap.get(trigger.new[0].Id).IT_Debt_Notes_Percentage__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Debt_Notes_Locale_Type__c != trigger.oldMap.get(trigger.new[0].Id).IT_Debt_Notes_Locale_Type__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Expendia_Startup_Cost__c != trigger.oldMap.get(trigger.new[0].Id).IT_Expendia_Startup_Cost__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Number_of_Expendia_cards__c != trigger.oldMap.get(trigger.new[0].Id).IT_Number_of_Expendia_cards__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Expendia_Monthly_Fee__c != trigger.oldMap.get(trigger.new[0].Id).IT_Expendia_Monthly_Fee__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Expendia_Card_Amount__c != trigger.oldMap.get(trigger.new[0].Id).IT_Expendia_Card_Amount__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Flexben_Startup_Cost__c != trigger.oldMap.get(trigger.new[0].Id).IT_Flexben_Startup_Cost__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Flexben_Startup_Date__c != trigger.oldMap.get(trigger.new[0].Id).IT_Flexben_Startup_Date__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Flexben_Fee_Cost__c != trigger.oldMap.get(trigger.new[0].Id).IT_Flexben_Fee_Cost__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Flexben_Start_Fee_Date__c != trigger.oldMap.get(trigger.new[0].Id).IT_Flexben_Start_Fee_Date__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Flexben_Fee_Frequency__c != trigger.oldMap.get(trigger.new[0].Id).IT_Flexben_Fee_Frequency__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Billing_Frequency_UTA__c != trigger.oldMap.get(trigger.new[0].Id).IT_Billing_Frequency_UTA__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Bond_UTA__c != trigger.oldMap.get(trigger.new[0].Id).IT_Bond_UTA__c){
        
            for(Contract singleContract : trigger.new){
                idContract.add(singleContract.Id);
            }
            SObjectType contractType = Schema.getGlobalDescribe().get('Contract');
            Map<String,Schema.SObjectField> contractFields = contractType.getDescribe().fields.getMap();
            String query = 'SELECT ';
            for(String field : contractFields.keySet()) {
                query+=field+',';
            }
            SObjectType bankAccountType = Schema.getGlobalDescribe().get('ER_Bank_Account__c');
            Map<String,Schema.SObjectField> bankAccountFields = bankAccountType.getDescribe().fields.getMap();
            for(String field : bankAccountFields.keySet()) {
                query+='IT_Financial_Center__r.ER_Bank_Account__r.'+field+',';
            }
            SObjectType fcType = Schema.getGlobalDescribe().get('ER_Financial_Center__c');
            Map<String,Schema.SObjectField> fcFields = fcType.getDescribe().fields.getMap(); 
            for(String field : fcFields.keySet()) {
                query+='IT_Financial_Center__r.'+field+',';
            }
            query = query.removeEnd(',');

            System.debug(query);
            query += ' FROM Contract WHERE Id IN: idContract';
            listEconomicConditions = Database.query(query);

            if(listEconomicConditions != null && listEconomicConditions.size() > 0)
                APIT12_CallOutbound.createRequestContract(listEconomicConditions, 'EconomicConditions');

            
        }else if( trigger.newMap.get(trigger.new[0].Id).IT_Document_Protocol__c != trigger.oldMap.get(trigger.new[0].Id).IT_Document_Protocol__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Document_Progressive__c != trigger.oldMap.get(trigger.new[0].Id).IT_Document_Progressive__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Document_Type__c != trigger.oldMap.get(trigger.new[0].Id).IT_Document_Type__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Registration_Date__c != trigger.oldMap.get(trigger.new[0].Id).IT_Registration_Date__c ||   
            trigger.newMap.get(trigger.new[0].Id).IT_Scan_Date__c != trigger.oldMap.get(trigger.new[0].Id).IT_Scan_Date__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Barcode__c != trigger.oldMap.get(trigger.new[0].Id).IT_Barcode__c || 
            trigger.newMap.get(trigger.new[0].Id).IT_Framework_Barcode__c != trigger.oldMap.get(trigger.new[0].Id).IT_Framework_Barcode__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Send_Email__c != trigger.oldMap.get(trigger.new[0].Id).IT_Send_Email__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Email__c != trigger.oldMap.get(trigger.new[0].Id).IT_Email__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Email_Sending_Date__c != trigger.oldMap.get(trigger.new[0].Id).IT_Email_Sending_Date__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Barcode_Warrant__c != trigger.oldMap.get(trigger.new[0].Id).IT_Barcode_Warrant__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Service__c != trigger.oldMap.get(trigger.new[0].Id).IT_Service__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Service_2__c != trigger.oldMap.get(trigger.new[0].Id).IT_Service_2__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Barcode_2__c != trigger.oldMap.get(trigger.new[0].Id).IT_Barcode_2__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Service_3__c != trigger.oldMap.get(trigger.new[0].Id).IT_Service_3__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_Barcode_3__c != trigger.oldMap.get(trigger.new[0].Id).IT_Barcode_3__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_136_Send_Email__c != trigger.oldMap.get(trigger.new[0].Id).IT_136_Send_Email__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_136_Email_Address__c != trigger.oldMap.get(trigger.new[0].Id).IT_136_Email_Address__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_136_Email_Sending_Data__c != trigger.oldMap.get(trigger.new[0].Id).IT_136_Email_Sending_Data__c ||
            trigger.newMap.get(trigger.new[0].Id).IT_136_User_Sender__c != trigger.oldMap.get(trigger.new[0].Id).IT_136_User_Sender__c)
            APIT12_CallOutbound.createRequestContract(trigger.new, 'Document');
        else
            APIT12_CallOutbound.createRequestContract(trigger.new, 'Contract');
       
    }
}