public class VFCIT27_Installment_Controller {
     
    public String[] SelectedUsageIDs{get;set;}
    public String ID_Sub {get;set;}
    
    public VFCIT27_Installment_Controller(ApexPages.StandardSetController listcontroller){
        SelectedUsageIDs = new String[]{};
        for(IT_Usage__c itUsa : (IT_Usage__c[])listcontroller.getSelected()){
            SelectedUsageIDs.add(itUsa.Id);
        } 
       
        System.debug('SelectedUsageIDs:  '+SelectedUsageIDs);
        
        ID_Sub=([SELECT IT_Subscription_Product_Charge__c
                 FROM IT_Usage__c
                 WHERE id in: SelectedUsageIDs LIMIT 1].IT_Subscription_Product_Charge__c);
                 System.debug('ID_Sub'+ ID_Sub); 
    }
    
}