trigger TRIT26_DeleteFromZuora on IT_Usage__c (before delete,after delete) {
    Boolean checkDelete = TRUE;
    List<String> idUsage = new List<String>();
   IF (Trigger.isBefore) {
   		FOR(IT_Usage__c singleUsa: Trigger.old){
    	    IF(((singleUsa.IT_Date__c.month() < System.today().month()) & (singleUsa.IT_Date__c.year() == System.today().year()))
                || (singleUsa.IT_Date__c.year() < System.today().year())){
        	     singleUsa.addError('You can\'t delete this record!');
       	 	}
        }
   }
   ELSE {
        FOR(IT_Usage__c singleUsage: Trigger.old){
        	     idUsage.add(singleUsage.IT_Zuora_ID__c);      
        	}
        APIT25_PostUsage.getToken(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, TRUE, idUsage);
    	}
    
}