public class APIT00_RunTimeSegment {
    @AuraEnabled
public static String CheckSegment(string AccountId)
{ 
    string SalesName=USERINFO.getLastName()+' '+userinfo.getFirstName();
    List <String> Result= new  List <String>() ;
    String myLine= [Select IT_Line_Type__c From User Where Id = :UserInfo.getUserId()][0].IT_Line_Type__c;
   list <ER_Financial_Center__c>  FCs= [SELECT ID,IT_Client_Status__c,IT_Product2__r.IT_Line_Type__c,IT_Sales_Manager_txt__c FROM ER_Financial_Center__c
                                         WHERE IT_Account_Active__c=:AccountId or IT_Account_Closed__c=:AccountId or IT_Account_Provisioning__c=:AccountId] ;
    IF  (FCs !=null) {
    for (ER_Financial_Center__c  fc : FCs) {
        
           system.debug(fc.IT_Sales_Manager_txt__c+'-'+SalesName);
           if (fc.IT_Sales_Manager_txt__c==SalesName){
            
               if(fc.IT_Client_Status__c=='02'){
                   Result.add('My Customer');
               }
           }else {
               if(fc.IT_Product2__r.IT_Line_Type__c==myLine){
                  if(fc.IT_Client_Status__c=='02'){
                   Result.add('Customer');
                       }else{
                           Result.add('Inactive');
                       }
               }else{
                    Result.add('Prospect');
               }
                   
           }
       }
    
    IF (RESULT.contains('My Customer')) {
        return 'My Customer';
    }else{
        IF (RESULT.contains('Customer')){
            return 'Customer';
        }else{
            IF (RESULT.contains('Inactive')){
              return 'Inactive';  
            }else{
                return'Prospect';
            }
        }
    }
       
    }
    return '';
      
}
}