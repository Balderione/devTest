public class APIT00_RelatedListController {
   @AuraEnabled  
    public static RelatedListResult fetchRecs( String recId, String sObjName, String parentFldNam, String strCriteria,String AccountHierarchy,String field1,String field2,String field3,String field4 ) {  
          
        String strTitle = ' (';           
        List < sObject > listsObjects = new List < sObject >();  
        RelatedListResult obj = new RelatedListResult();  
        
        if(String.isEmpty(field1)) field1 = 'null';
        if(String.isEmpty(field2)) field2 = 'null';
        if(String.isEmpty(field3)) field3 = 'null';
        if(String.isEmpty(field4)) field4 = 'null';
        
        string strSOQL = 'SELECT Id,'+field1+','+field2+','+field3+','+field4+' FROM ' + sObjName + ' WHERE ' + parentFldNam + ' = \'' + recid + '\'';  
       
        System.debug('strSOQL' +  strSOQL);
        if (AccountHierarchy=='true'){
                    if (AccountHierarchy.equals('true')){
             list<Account> ParentIdS=[SELECT ParentId from Account where Id = :recid LIMIT 1];
        System.debug('ParentId ' +  ParentIdS[0].ParentId);
        System.debug('ParentIdS List Size ' +  ParentIdS.size());
            if (ParentIdS[0].ParentId!=null) {
         strSOQL = 'SELECT Id,'+field1+','+field2+','+field3+','+field4+' FROM ' + sObjName + ' WHERE ' + parentFldNam + ' in ( \'' + recid + '\','+'\''+ ParentIdS[0].ParentId + '\')'; 
         
        if(parentFldNam.containsIgnoreCase('__c'))strSOQL +=' OR '+parentFldNam.replace('__c', '__r')+'.ParentId = \'' + ParentIdS[0].ParentId + '\'';
                
                } else
                {
                       strSOQL = 'SELECT Id,'+field1+','+field2+','+field3+','+field4+' FROM ' + sObjName + ' WHERE ' + parentFldNam + ' = \'' + recid + '\'';   
        if(parentFldNam.containsIgnoreCase('__c'))strSOQL +=' OR '+parentFldNam.replace('__c', '__r')+'.ParentId = \'' + recid+ '\'';
                }
        System.debug('strSOQL Hierachy true' +  strSOQL);
        }
        }
       
        System.debug('strSOQL dopo if se true hirarchy' +  strSOQL);
        strSOQL =strSOQL.replace('null,','');
        strSOQL =strSOQL.replace('null','');
        if(field1.equals('null')  && field2.equals('null')  && field3.equals('null') && field4.equals('null') )  strSOQL =strSOQL.replace(',','');
        strSOQL =strSOQL.replace(', FROM',' FROM ');
        System.debug('strSOQL dopo if null ' +  strSOQL);
        
        if ( String.isNotBlank( strCriteria ) )  
            strSOQL += ' ' + strCriteria;  
        strSOQL += ' LIMIT 4';  
                System.debug('Query ' + strSOQL);
        listsObjects = Database.query( strSOQL );    
        Integer intCount = listsObjects.size();  
        System.debug('Query size: ' + listsObjects.size() );
         System.debug('Query size: ' + strSOQL );
        if ( intCount > 3 ) {  
              
            List < sObject > tempListsObjects = new List < sObject >();  
            for ( Integer i = 0; i <3; i++ )  
                tempListsObjects.add( listsObjects.get( i ) );  
              
            obj.listsObject = tempListsObjects;  
            strTitle += '3+';  
              
        } else {  
              
            obj.listsObject = listsObjects;  
            strTitle += String.valueOf( intCount );  
              
        }  
        strTitle += ')';        
        obj.strTitle = strTitle;  

        return obj;  
          
    }  
      
    public class RelatedListResult {  
          
        @AuraEnabled  
        public String strTitle;  
        @AuraEnabled  
        public List < sObject > listsObject;  
          
    }  
  
}