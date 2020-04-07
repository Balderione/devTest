public class VFCIT00_Installment_Controller {
     
    public String[] SelectedUsageIDs{get;set;}
    public String ID_Sub {get;set;}
    
    public VFCIT00_Installment_Controller(ApexPages.StandardSetController listcontroller){
        SelectedUsageIDs = new String[]{};
        for(IT_Usage__c itUsa : (IT_Usage__c[])listcontroller.getSelected()){
            SelectedUsageIDs.add(itUsa.Id);
        } 
       
        System.debug('SelectedUsageIDs:  '+SelectedUsageIDs);
        
        ID_Sub=([SELECT Subscription_Product_Charge__c
                 FROM IT_Usage__c
                 WHERE id in: SelectedUsageIDs LIMIT 1].Subscription_Product_Charge__c);
                 System.debug('ID_Sub'+ ID_Sub); 
    }
    
    //Flow.Interview.IT00_InstallmentUsage myflow = new Flow.Interview.IT00_InstallmentUsage() ;
     //    Flow.Interview.IT00_InstallmentUsage myflow { get; set; }

    	// public String getVarValue() {
        //	if (myflow == null) {
          // 	 System.debug('myflow'+myflow);
        //	    return 'Home';
       	// 	}
        //	else {
         //   	System.debug('VarValue ');
          // 		return (String)myflow.ID_For_Page;
        //	}    
   		//}
 
}