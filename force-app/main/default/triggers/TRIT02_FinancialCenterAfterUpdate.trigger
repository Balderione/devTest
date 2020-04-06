trigger TRIT02_FinancialCenterAfterUpdate on ER_Financial_Center__c (after update) {
    IT_ControlUpdateTrigger__c mhc = IT_ControlUpdateTrigger__c.getInstance();
    Boolean AcoidControlTrigger = mhc.IT_ControlTreiggerUpdate__c;
    if(!AcoidControlTrigger){
        if(trigger.new[0].IT_Change_Address__c)
            APIT12_CallOutbound.createRequestAddress(trigger.new, 'ER_Financial_Center__c');
        else{
            
            Set<id>finCenterIds = trigger.newMap.keyset();
            SObjectType finCenterType = Schema.getGlobalDescribe().get('ER_Financial_Center__c');
            Map<String,Schema.SObjectField> finCenterFields = finCenterType.getDescribe().fields.getMap();
            String query = 'SELECT ';
            for(String field : finCenterFields.keySet()) {
                query+=field+',';
            }
            SObjectType bankAccountType = Schema.getGlobalDescribe().get('ER_Bank_Account__c');
            Map<String,Schema.SObjectField> bankAccountFields = bankAccountType.getDescribe().fields.getMap();
            for(String field : bankAccountFields.keySet()) {
                query+='ER_Bank_Account__r.'+field+',';
            }
            SObjectType fcType = Schema.getGlobalDescribe().get('Contract');
            Map<String,Schema.SObjectField> fcFields = fcType.getDescribe().fields.getMap(); 
            for(String field : fcFields.keySet()) {
                query+='IT_Contract__r.'+field+',';
            }
            query = query.removeEnd(',');
            
            System.debug(query);
            query += ' FROM ER_Financial_Center__c WHERE Id IN: finCenterIds';
            List<ER_Financial_Center__c> finCentList = Database.query(query);
            Map< id , ER_Financial_Center__c> listEconomicConditions = new map <id , ER_Financial_Center__c>(finCentList);
            
            List<ER_Financial_Center__c> DualFincentList = new List<ER_Financial_Center__c>();
            List<ER_Financial_Center__c> EconomicCondList = new List<ER_Financial_Center__c>();
            List<ER_Financial_Center__c> JustFinCentList = new List<ER_Financial_Center__c>();
            List<ER_Financial_Center__c> financialCenterActive = new List<ER_Financial_Center__c>();
            List<ER_Financial_Center__c> changeRequest = new List<ER_Financial_Center__c>();

            //AD - Delete FC and Childs with client status equals 10
            List<String> idFcForDelete = new List<String>();
            List<ER_Financial_Center__c> listFcForDelete = new List<ER_Financial_Center__c>();
            for(string singleId : listEconomicConditions.Keyset()){
                Boolean EconomicCondChanged = false;
                Boolean FinCentChanged = false;
                Boolean activeFC = false;
                Boolean changeRequestBool = false;
                if(trigger.newMap.get(singleId).IT_Confirm_Flow__c != trigger.oldMap.get(singleId).IT_Confirm_Flow__c){
                    changeRequestBool = true;
                }else if((trigger.newMap.get(singleId).IT_Client_Status__c != trigger.oldMap.get(singleId).IT_Client_Status__c && trigger.oldMap.get(singleId).IT_Client_Status__c == '01' && (trigger.newMap.get(singleId).IT_Client_Status__c == '02') || trigger.newMap.get(singleId).IT_Client_Status__c == '05')){
                    activeFC = true;
                }else if(trigger.newMap.get(singleId).IT_SkipActivation__c == trigger.newMap.get(singleId).IT_SkipActivation__c){    
                    //Condizioni Economiche
                    if(trigger.newMap.get(singleId).IT_Special_Billing_Type__c != trigger.oldMap.get(singleId).IT_Special_Billing_Type__c || 
                    trigger.newMap.get(singleId).IT_Invoice_Detraction__c != trigger.oldMap.get(singleId).IT_Invoice_Detraction__c || 
                    trigger.newMap.get(singleId).IT_Send_SUT_Printout__c != trigger.oldMap.get(singleId).IT_Send_SUT_Printout__c || 
                    trigger.newMap.get(singleId).IT_Accepts_New_Billing_System_PA__c != trigger.oldMap.get(singleId).IT_Accepts_New_Billing_System_PA__c || 
                    trigger.newMap.get(singleId).IT_Office_Code__c != trigger.oldMap.get(singleId).IT_Office_Code__c || 
                    trigger.newMap.get(singleId).IT_CUP_Code__c != trigger.oldMap.get(singleId).IT_CUP_Code__c || 
                    trigger.newMap.get(singleId).IT_Order_Code__c != trigger.oldMap.get(singleId).IT_Order_Code__c || 
                    trigger.newMap.get(singleId).IT_EORI_Code__c != trigger.oldMap.get(singleId).IT_EORI_Code__c || 
                    trigger.newMap.get(singleId).IT_Accepts_New_Billing_System__c != trigger.oldMap.get(singleId).IT_Accepts_New_Billing_System__c || 
                    trigger.newMap.get(singleId).IT_SDI__c != trigger.oldMap.get(singleId).IT_SDI__c || 
                    trigger.newMap.get(singleId).IT_PEC_Mail__c != trigger.oldMap.get(singleId).IT_PEC_Mail__c || 
                    trigger.newMap.get(singleId).IT_Don_t_Send_Debt_Note__c != trigger.oldMap.get(singleId).IT_Don_t_Send_Debt_Note__c || 
                    trigger.newMap.get(singleId).IT_Particularities_Progressive_Number__c != trigger.oldMap.get(singleId).IT_Particularities_Progressive_Number__c ||
                    trigger.newMap.get(singleId).IT_Contractual_Particularities__c != trigger.oldMap.get(singleId).IT_Contractual_Particularities__c ){
                        //Economic Condition Changed
                        EconomicCondChanged = true;
                    }
                    //Solo financial Center
                    if(trigger.newMap.get(singleId).IT_Financial_Center__c != trigger.oldMap.get(singleId).IT_Financial_Center__c || 
                    trigger.newMap.get(singleId).IT_Service__c != trigger.oldMap.get(singleId).IT_Service__c || 
                    trigger.newMap.get(singleId).IT_Client_Status__c != trigger.oldMap.get(singleId).IT_Client_Status__c || 
                    trigger.newMap.get(singleId).IT_VAT_Number__c != trigger.oldMap.get(singleId).IT_VAT_Number__c || 
                    trigger.newMap.get(singleId).IT_Employee_Number__c != trigger.oldMap.get(singleId).IT_Employee_Number__c || 
                    trigger.newMap.get(singleId).IT_Single_Client_Multiactivity__c != trigger.oldMap.get(singleId).IT_Single_Client_Multiactivity__c || 
                    trigger.newMap.get(singleId).IT_Client_Situation__c != trigger.oldMap.get(singleId).IT_Client_Situation__c || 
                    trigger.newMap.get(singleId).IT_Opening_Outcome__c != trigger.oldMap.get(singleId).IT_Opening_Outcome__c || 
                    trigger.newMap.get(singleId).IT_Concurrency__c != trigger.oldMap.get(singleId).IT_Concurrency__c || 
                    trigger.newMap.get(singleId).IT_Beneficiary_Type__c != trigger.oldMap.get(singleId).IT_Beneficiary_Type__c || 
                    trigger.newMap.get(singleId).IT_Previous_Code__c != trigger.oldMap.get(singleId).IT_Previous_Code__c || 
                    trigger.newMap.get(singleId).IT_Fused_Client__c != trigger.oldMap.get(singleId).IT_Fused_Client__c || 
                    trigger.newMap.get(singleId).IT_New_Code__c != trigger.oldMap.get(singleId).IT_New_Code__c || 
                    trigger.newMap.get(singleId).IT_Associated_Client__c != trigger.oldMap.get(singleId).IT_Associated_Client__c || 
                    trigger.newMap.get(singleId).IT_Billing_Company_Name_R1__c != trigger.oldMap.get(singleId).IT_Billing_Company_Name_R1__c || 
                    trigger.newMap.get(singleId).IT_Billing_Company_Name_R2__c != trigger.oldMap.get(singleId).IT_Billing_Company_Name_R2__c || 
                    trigger.newMap.get(singleId).IT_Billing_Company_Name_R3__c != trigger.oldMap.get(singleId).IT_Billing_Company_Name_R3__c || 
                    trigger.newMap.get(singleId).IT_Short_name__c != trigger.oldMap.get(singleId).IT_Short_name__c || 
                    trigger.newMap.get(singleId).IT_Extended_Company_Name__c != trigger.oldMap.get(singleId).IT_Extended_Company_Name__c || 
                    trigger.newMap.get(singleId).IT_CIG__c != trigger.oldMap.get(singleId).IT_CIG__c || 
                    trigger.newMap.get(singleId).IT_Derived_CIG__c != trigger.oldMap.get(singleId).IT_Derived_CIG__c || 
                    trigger.newMap.get(singleId).IT_Circuit_Code__c != trigger.oldMap.get(singleId).IT_Circuit_Code__c || 
                    trigger.newMap.get(singleId).IT_Client_Type__c != trigger.oldMap.get(singleId).IT_Client_Type__c || 
                    trigger.newMap.get(singleId).IT_Contact_Code__c != trigger.oldMap.get(singleId).IT_Contact_Code__c || 
                    trigger.newMap.get(singleId).IT_Admin_Data_AC_User__c != trigger.oldMap.get(singleId).IT_Admin_Data_AC_User__c || 
                    trigger.newMap.get(singleId).IT_Admin_Data_Validity_Start_Date__c != trigger.oldMap.get(singleId).IT_Admin_Data_Validity_Start_Date__c ||
                    trigger.newMap.get(singleId).IT_Admin_Data_Validity_End_Date__c != trigger.oldMap.get(singleId).IT_Admin_Data_Validity_End_Date__c){
                        //Financial Center Changed
                        FinCentChanged = true;
                        //AD - Delete FC and Childs with client status equals 10
                        if(trigger.newMap.get(singleId).IT_Client_Status__c != trigger.oldMap.get(singleId).IT_Client_Status__c && trigger.newMap.get(singleId).IT_Client_Status__c == '10')
                            idFcForDelete.add(singleId);  
                    }
                } 

                System.debug('FinCentChanged::: '+FinCentChanged);
                System.debug('EconomicCondChanged::: '+EconomicCondChanged); 
                System.debug('activeFC::: '+activeFC); 
                System.debug('changeRequestBool::: '+changeRequestBool);      
                
                if(FinCentChanged && EconomicCondChanged && !activeFC && !changeRequestBool){
                    DualFincentList.add(listEconomicConditions.get(singleId));
                }
                else if(FinCentChanged && !activeFC && !changeRequestBool){
                    JustFinCentList.add(listEconomicConditions.get(singleId));
                }
                else if(EconomicCondChanged && !activeFC && !changeRequestBool){
                    EconomicCondList.add(listEconomicConditions.get(singleId));
                }
                else if(activeFC && !changeRequestBool){
                    financialCenterActive.add(listEconomicConditions.get(singleId));
                }
                else if(changeRequestBool){
                    changeRequest.add(listEconomicConditions.get(singleId));
                }
                
            }

            if(changeRequest == null || changeRequest.size() == 0){
                if(financialCenterActive != null && financialCenterActive.size() > 0){
                    APIT12_CallOutbound.createRequestFinancialCenterActivation(financialCenterActive);
                }else{

                    Map <String , List<ER_Financial_Center__c>> triggerMap = new Map <String , List<ER_Financial_Center__c>>();
                    if(DualFincentList != null && DualFincentList.size() > 0){
                        triggerMap.put('Dual' , DualFincentList );
                        //Call method with DUAL
                    }
                    if(JustFinCentList != null && JustFinCentList.size() > 0){
                        triggerMap.put('ER_Financial_Center__c' , JustFinCentList );   
                        //Call method with FINANCIAL CENTER
                    }
                    if(EconomicCondList != null && EconomicCondList.size() > 0){
                        triggerMap.put('EconomicCondition' , EconomicCondList );
                        //Call method with ECONOMIC CONDITIONS 
                    }
                    
                    if(triggerMap != null && triggerMap.size() > 0)
                        APIT12_CallOutbound.createRequestFinancialCenter(triggerMap);
                }
            }
            //AD - Delete FC and Childs with client status equals 10
            if(idFcForDelete != null && idFcForDelete.size() > 0){
                listFcForDelete = [Select Id, (Select Id From Contract_Line_Items__r), (Select Id From Delivery_Sites__r), (Select Id From Distribution_Points__r), (Select Id From Groups_Code__r), (Select Id From Note__r), (Select Id From Additional_Expenses__r), (Select Id From Bank_Accounts__r), (Select Id From Contracts__r), (Select Id From Contact_Association__r) From ER_Financial_Center__c Where Id IN: idFcForDelete];        
                delete listFcForDelete; 
            }        
        }        
    }        
}