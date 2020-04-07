public class APIT00_TerritoryAssignment {
@AuraEnabled
public static list <IT_Territory_Assigment__c> getTerritory(String City, String ZipCode) {
    
list <IT_Territory_Assigment__c> t1= [SELECT IT_Email__c FROM IT_Territory_Assigment__c WHERE
              IT_City__c=:City and Zip_Code__c=:ZipCode and IT_Product__c <> 'PAPIER Telesales (0€ - 30.000€)'];
    
    system.debug('sono dentro1');
//string email= t1[0].IT_Email__c;    
    return t1;
}
    
public  static string AssignTerritory(string AccountId,list <IT_Territory_Assigment__c> Owners)  {
       
    Set<String> myEmails = new Set<String>();                                                      
    Set<String> myIds = new Set<String>(); 
    
     List<ObjectTerritory2Association> DeleteTerritory = [Select Id from ObjectTerritory2Association where OBJECTID=:AccountId];

delete DeleteTerritory;  
      for (IT_Territory_Assigment__c  Owner : Owners) {

               myEmails.add(Owner.IT_Email__c);

      } 
    system.debug('sono dentro2'+AccountId);
list <ObjectTerritory2Association> TerritoryAssociations= new list <ObjectTerritory2Association>() ;

  list <Territory2> Territories=[SELECT id from Territory2 where IT_Email__c in: myEmails];
        for (Territory2  Territory : Territories) {
                ObjectTerritory2Association TerritoryAssociation=new ObjectTerritory2Association();
        TerritoryAssociation.OBJECTID=AccountId;
       TerritoryAssociation.TERRITORY2ID= Territory.Id;
            TerritoryAssociation.ASSOCIATIONCAUSE='Territory2Manual';
           TerritoryAssociations.add(TerritoryAssociation);

      }   
    
    if(TerritoryAssociations !=null && TerritoryAssociations.size()>0){

     insert TerritoryAssociations ;

}
 
    return 'test';

 //       "OBJECTID","TERRITORY2ID","ASSOCIATIONCAUSE","SOBJECTTYPE","ISDELETED"
//"0011t000008LbLXAA0","0MI1t0000000Ti8GAE","Territory2Manual","Account","false"

    }
}