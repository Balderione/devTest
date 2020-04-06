public class APIT22_CardInterfaceController {
    @AuraEnabled
    public static string fetchDPData(id recordId){
        List<ER_Distribution_point__c> objectToReturn = [SELECT id , IT_Data_To_Display_2__c,Name,IT_Data_To_Display_3__c ,IT_Data_To_Display_4__c ,IT_Data_Type_to_Display_3__c ,IT_Data_Type_to_Display_4__c ,ER_City__c,ER_Street__c,IT_Ticket_Naming__c,IT_Validity_Start_Date__c ,IT_Hamlet__c, IT_Distribution_Point_Address__c,IT_Address_to_Display__c,IT_Data_to_Display__c,IT_Data_Type_to_Display__c,IT_Free_Description_to_Display__c,IT_Locality_to_Display__c,IT_Naming_to_Display__c,IT_Raw_Number_for_Display__c, IT_Financial_Center__r.IT_Single_Client_Multiactivity__c,IT_Financial_Center__r.IT_Service__c,IT_Financial_Center__r.ER_Account_Name__r.Name, IT_Financial_Center__r.IT_Short_Name__c FROM ER_Distribution_Point__c WHERE Id =:recordId];
        return JSON.serializePretty(objectToReturn[0]);
    }
    @AuraEnabled
    public static string fetchDataType(id recordId , string service){
        List<IT_Control__c> objectToReturn = [SELECT id , Name, IT_CLN_Ticket_exposure_Code__c, IT_CLN_Ticket_exposure_type__c, IT_CLN_Exposure_code_type__c, IT_CLN_Line_number__c  FROM IT_Control__c WHERE IT_CLN_Service__c =:service AND IT_CLN_Ticket_exposure_Code__c != null AND IT_CLN_Ticket_exposure_Code__c != ''];
        system.debug('SIZECONTROL:: '+objectToReturn.size());    
        return JSON.serializePretty(objectToReturn);
    }
    
    @AuraEnabled
    public static void updateRecord( ER_Distribution_Point__c distPoint ){
        //List<ER_Distribution_Point__c> distPointList = [SELECT id , IT_Data_To_Display_3__c, IT_Data_To_Display_4__c, IT_Data_Type_to_Display_3__c, IT_Data_Type_to_Display_4__c FROM ER_Distribution_Point__c WHERE Id =:distPoint.Id];
        if(distPoint.IT_Data_To_Display_2__c != null || distPoint.IT_Data_To_Display_3__c != null || distPoint.IT_Data_Type_to_Display_3__c != null || distPoint.IT_Data_To_Display_4__c != null || distPoint.IT_Data_Type_to_Display_4__c != null ){
            if(distPoint.IT_Data_To_Display_2__c != null){
                distPoint.IT_Raw_Number_for_Display__c = 2;
                distPoint.IT_Data_To_Display__c = distPoint.IT_Data_To_Display_2__c;
                update distPoint;
            }
            if(distPoint.IT_Data_To_Display_3__c != null || distPoint.IT_Data_Type_to_Display_3__c != null){
                distPoint.IT_Raw_Number_for_Display__c = 3;
                distPoint.IT_Data_To_Display__c = distPoint.IT_Data_To_Display_3__c;
                distPoint.IT_Data_Type_to_Display__c = distPoint.IT_Data_Type_to_Display_3__c;
                update distPoint;
            }
            if(distPoint.IT_Data_To_Display_4__c != null || distPoint.IT_Data_Type_to_Display_4__c != null){
                distPoint.IT_Raw_Number_for_Display__c = 4;
                distPoint.IT_Data_To_Display__c = distPoint.IT_Data_To_Display_4__c;
                distPoint.IT_Data_Type_to_Display__c = distPoint.IT_Data_Type_to_Display_4__c;
                update distPoint;
            }
        }
        else{
            update distPoint;
        }
    }
    
}