/*
----------------------------------------------------------------------
-- - Name          : APER08_Case_Management
-- - Author        : OLA
-- - Description   : Case Management, This class is used to group all the functionnality linked to the object Case
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Nov-2018       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
public class APER08_Case_Management {
    
    public static void completeMilestone( Map<String,List<Id>> CaseMilestone, DateTime complDate) { 
        List<Id> caseIds = new List<Id>();
        for(List<Id> ids : CaseMilestone.values()){
            caseIds.addall(ids);
        }
        
        List<CaseMilestone> cmsToUpdate = [select Id, completionDate
                                           from CaseMilestone cm
                                           where caseId in : caseIds and cm.MilestoneType.Name IN :CaseMilestone.keyset() 
                                           and completionDate = null];
        
        if (!cmsToUpdate.isEmpty()){
            for (CaseMilestone cm : cmsToUpdate){ cm.completionDate = complDate; }
            
            update cmsToUpdate;
        }
    }
    
    /*
    *
    * OLA
    * Nov 2018
    * GetEmployeeCaseOptions: This method is used to get all the cases per Employee:
    *                         The purpose is to give the posibility to the User to link an activity to an existing Case
    *
    */

    Public Static List<SelectOption> GetEmployeeCaseOptions(String Employee){ 
        System.debug('GetEmployeeCaseOptions Employee : '+Employee);
        List<SelectOption> caseOptions = new List<SelectOption>();
        caseOptions.add(new SelectOption('','--'+Label.LAB_SF_None+'--'));
        
        if(String.isNotBlank(Employee)){
            List<Case> cases = GetEmployeeCases(Employee);
            System.debug('GetEmployeeCaseOptions cases : '+cases);
            if(!cases.isEmpty()){
                for(Case c:cases){
                    caseOptions.add(new SelectOption(c.Id+'',c.CaseNumber+ (String.isBlank(c.ER_Reason__c)? '' : ' - '+c.ER_Reason__c) )); 
                }
            }
        }
        
        return caseOptions;
    }
    
    /*
    *
    * OLA
    * Nov 2018
    * GetEmployeeCases: This method is used to get all the cases per Employee: 
    *                   The purpose is to give the posibility to the User to link an activity to an existing Case
    *
    */

    Public Static List<Case> GetEmployeeCases(String Employee){  
        System.debug('GetEmployeeCases Employee : '+Employee);
        if(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ER_User_Case_RT') != null){
            
            String RecordtypeId= Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ER_User_Case_RT').getRecordTypeId();
            string query ='SELECT Id,CaseNumber,toLabel(ER_Reason__c) '
                + ' FROM Case'
                + ' WHERE ER_Employee__c = \'' + Employee +'\''
                + ' AND isclosed= false and recordtypeid = \''+RecordtypeId+'\' order by CaseNumber desc';
            
            return (List<Case>)Database.query(query);
        }
        
        return new List<Case>();
    }
    
    /*
    *
    * OLA
    * Nov 2018
    * CreateCase : Quick case creation with case Reason and Case Detailed Reason
    *              Used to create case after an Asset Action: Block Card/Get Pin Reset
    *
    */
    

    Public Static Case CreateCase(String reason, String detailedReason, String assetID){
        
        Case newCase = new Case();
        newCase.AssetId = assetID;
        newCase.RecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ER_User_Case_RT').getRecordTypeId();
        newCase.ER_Reason__c = reason;
        newCase.ER_CaseReason2__c = detailedReason;
        insert newCase;
        
        return newCase;
    }

    /*
    *
    * OLA
    * JUN 2019
    * manageCasesFromWeb: This method is used to Linked inserted cases to Asset, Indivudual, Employee and entitlment
    *
    *
    */
    public static void manageCasesFromWeb(List<Case> caseList) {

        Map<String, Asset> assetMap = new Map<String, Asset>();
        Set<String> assetNumberSet = new Set<String>();

        for (Case caseInst : caseList) {
            if (caseInst.ER_Card_Number__c != null) {

                assetNumberSet.add(String.valueOf(caseInst.ER_Card_Number__c));
            }
        }
        for (Asset asset : [Select Name, SerialNumber, ER_Employee__c, ER_Individual__c from Asset where Name IN : assetNumberSet]) {

            assetMap.put(asset.Name, asset);
        }

        if (!assetMap.isEmpty()) {

            for (Case caseInst : caseList) {
                if (caseInst.ER_Card_Number__c != null && assetMap.containsKey(String.valueOf(caseInst.ER_Card_Number__c))) {

                    caseInst.ER_Employee__c  = assetMap.get(String.valueOf(caseInst.ER_Card_Number__c)).ER_Employee__c;
                    caseInst.ER_Individual__c  = assetMap.get(String.valueOf(caseInst.ER_Card_Number__c)).ER_Individual__c;
                    caseInst.AssetId  = assetMap.get(String.valueOf(caseInst.ER_Card_Number__c)).Id;
                }
            }
        }
    }

    /*
    *
    * OLA
    * JUN 2019
    * manageCasesEntitlment: This method is used to Link Entitlemnt to inserted cases
    *
    *
    */
    public static void manageCasesEntitlment(List<Case> caseList) {

        List<Entitlement> entls = [Select Id, StartDate, EndDate, AccountId, AssetId, ER_Business_Unit__c From Entitlement];
        Entitlement defaultEntitlemnt;
        for(Entitlement ent : entls){ // get the Core entitlement First
            if (String.isBlank(ent.ER_Business_Unit__c)) {
                defaultEntitlemnt = ent;
                break;
            }
        }
        for (Case c : caseList) {
            if(defaultEntitlemnt != null){
                c.EntitlementId = defaultEntitlemnt.id;//Core entitlement has no business Unit
            }
            
            for(Entitlement ent : entls){
                if (c.ER_BUPicklist__c == ent.ER_Business_Unit__c) {// Check if there is any specific entitlement.
                    
                    c.EntitlementId = ent.Id;
                }
            }
        }
    }
}