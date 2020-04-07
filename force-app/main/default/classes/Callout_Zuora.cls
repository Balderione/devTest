public class Callout_Zuora {
    
    @future (callout=true)
    public static void updateaccount(String ZuoraId, String V_NewName, Decimal V_NewSpecial_Account) {  
      
		Zuora.zApi zApiInstance = new Zuora.zApi();
        try {
            /*@future (callout=true) */
            zApiInstance.setEndpoint('https://sandbox.eu.zuora.com/apps/services/a/88.0');
            zApiInstance.zlogin('michele.trotta_zuora@tengroup.it', '7s4!v4yFU8U6uig');
        } catch (Zuora.zRemoteException ex) {
            if ('INVALID_LOGIN' == ex.code) {
            // The login credentials are invalid.
            System.Debug('Messaggio 0 - INVALID_LOGIN');
            }
        //more exception handling code here...
        } catch (Zuora.zAPIException ex) {
            ex.getMessage();
            System.Debug('Messaggio 1 - Zuora.zAPIException ' + ex.Message );
        //more exception handling code here...
        } catch (Zuora.zForceException ex) {
        //more exception handling code here...
            System.Debug('Messaggio 2 - more exception handling');
        }

        
        try {
           System.Debug('Inizio Update');
           Zuora.zObject acc = new Zuora.zObject('Account');
           
           acc.setValue('Id',ZuoraId); //an existing account
            if (V_NewName != 'na') {
                acc.setValue('Name',V_NewName);
            }            
            if (V_NewSpecial_Account != -1) {
                acc.setValue('IT_Special_Account__c',V_NewSpecial_Account);
            }             
           
           List<Zuora.zObject> objs = new List<Zuora.zObject> {acc};
           List<Zuora.zApi.SaveResult> results = zApiInstance.zupdate(objs);
           
           for (Zuora.zApi.SaveResult result : results) {
              if (result.Success){
                 //get the updated id
                 String updatedId = result.Id;
              } else {
                 //failure
                 //get the errors
                 Zuora.zObject[] errors = result.errors;
                 for (Zuora.zObject error : errors) {
                    String errorCode = (String)error.getValue('Code');
                    String message = (String)error.getValue('Message');
                    System.Debug('Messaggio 3 - errorCode ' + errorCode + message );
                 }
              }
           }
        } catch (Zuora.zRemoteException ex) {
           if ('INVALID_FIELD' == ex.code) {
               System.Debug('Messaggio 4 - INVALID_FIELD');
              // An invalid field was specified
              //more code here...
           } else {
              //more code here...
              System.Debug('Messaggio 5 - more code here..');
           }
        } catch (Zuora.zAPIException ex) {
           ex.getMessage();
           //more code here...
           System.Debug('Messaggio 6 - ex.Message ' + ex.Message + ' ex.code ' + ex.code);
        } catch (Zuora.zForceException ex) {
           //more code here...
           System.Debug('Messaggio 7 - Zuora.zForceException' + ex.Message);
        } 
      
        /*Do the callout here*/  
      
    }
}