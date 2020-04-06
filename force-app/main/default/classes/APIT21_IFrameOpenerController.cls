public class APIT21_IFrameOpenerController {
    @AuraEnabled
    public static CMIT07_Legacy_Systems__mdt callLegacyLink() {
        CMIT07_Legacy_Systems__mdt environmentMD = new CMIT07_Legacy_Systems__mdt();
        Boolean orgType = [Select isSandbox From Organization limit 1].isSandbox;
        List<CMIT07_Legacy_Systems__mdt> listMetadata = new List<CMIT07_Legacy_Systems__mdt>();
        listMetadata = [Select MasterLabel, IT_CTI__c, IT_SsoBridge__c, IT_Apex__c, IT_GestCred__c, IT_JIRACreate__c, IT_JIRAIssue__c, IT_Kiwi__c, IT_MYDHL__c, IT_MYTNT__c, IT_Operations__c, IT_PortaleBeneficiari__c, IT_PortaleIntesa__c, IT_PortaliClienti__c, IT_SgopSgoc__c From CMIT07_Legacy_Systems__mdt];
        System.debug('orgType:::: '+orgType);
        if(orgType){
            if(listMetadata != null && listMetadata.size() > 0){
                for(CMIT07_Legacy_Systems__mdt item : listMetadata){
                    if(item.MasterLabel == 'Sandbox')
                        environmentMD = item;
                }
            }    
        }else{
            if(listMetadata != null && listMetadata.size() > 0){
                for(CMIT07_Legacy_Systems__mdt item : listMetadata){
                    if(item.MasterLabel == 'Production')
                        environmentMD = item;
                }
            }
        }
        return environmentMD;   
    }    
    
}