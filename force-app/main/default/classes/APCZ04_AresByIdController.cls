/*
----------------------------------------------------------------------
-- - Name          : APCZ04_AresByIdController
-- - Author        : XXX
-- - Description   : The controller of the page APCZ04_AresByIdController
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  XXX            XXX                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
public with sharing class APCZ04_AresByIdController 
{
   @AuraEnabled
    public static String getDarvBasWS(String sId)
    {
        HttpResponse res = new HttpResponse(); 
        APCZ03_AresCallout_ById ac = new APCZ03_AresCallout_ById();
        res = ac.getDarvBas(sId);
        System.debug('### getDarvBasWS ARES RESPONSE : '+res.getBody());
        APCZ02_AresXmlReader axr = new APCZ02_AresXmlReader();
        return axr.ReadDarvBasXml(res);
    }
    
    @AuraEnabled
    public static String getDarvResWS(String sId, String sExistingNace)
    {
        HttpResponse res = new HttpResponse(); 
        APCZ03_AresCallout_ById ac = new APCZ03_AresCallout_ById();
        res = ac.getDarvRes(sId);  
        System.debug('### getDarvResWS ARES RESPONSE : '+res.getBody());
        APCZ02_AresXmlReader axr = new APCZ02_AresXmlReader();
        return axr.ReadDarvResXml(res, sExistingNace);  
    }
    
    @AuraEnabled
    public static WSSK01_GetFinstat.Finstat getFinStatWS(String sId)
    {
        WSSK01_GetFinstat.Finstat response = WSSK01_GetFinstat.GetFinstatInfos(sId);
        System.debug('APCZ04_AresByIdController getFinStatWS : '+response);
        return response;
    }
    
   @AuraEnabled
    public static Account getAccountWS(Id objId) {
        return [SELECT ER_Registration_Number__c, ER_NaceList__c FROM Account WHERE Id = :objId];
    }
    
    @AuraEnabled
    public static Lead getLeadWS(Id objId) {
        return [SELECT ER_Registration_Number__c, ER_NaceList__c FROM Lead WHERE Id = :objId];
    }
    
    @AuraEnabled 
    public static user fetchUser(){
     // query current user information  
         return [select ER_Business_Unit__c FROM User Where id =: userInfo.getUserId()];
    }
    
    @AuraEnabled
    public static Account updateAccountWS(String sJson, String sJsonNace) {   
               
        APCZ01_AresEntity.AresPopUp oPopUp = (APCZ01_AresEntity.AresPopUp)JSON.deserialize(sJson, APCZ01_AresEntity.AresPopUp.class);
        
        List<Account> oList = [SELECT Id, Name, BillingStreet, BillingPostalCode, BillingCity, ER_NaceList__c, ER_NaceNameList__c,ER_VAT_Number__c FROM Account WHERE Id = :oPopUp.oId];
        try{
            if (oPopUp.bGetName == true) {
                oList[0].Name = oPopUp.sName;
            }

            if (oPopUp.bGetStreet == true) {
                oList[0].BillingStreet = oPopUp.sStreet;
            }

            if (oPopUp.bGetZipCode == true) {
                oList[0].BillingPostalCode = oPopUp.sPostalCode;
            }

            if (oPopUp.bGetCity == true) {
                oList[0].BillingCity = oPopUp.sCity;
            }
            if (oPopUp.bGetVatNumber == true) {
                oList[0].ER_VAT_Number__c = oPopUp.sVatNumber;
            }
            if (oPopUp.bGetOtherFiscalId == true) {
                oList[0].ER_Other_Fiscal_ID__c = oPopUp.sOtherFiscalId;
            }


            oList[0].ER_NaceList__c = oPopUp.sNaceList;


            List<APCZ01_AresEntity.AresNace> listAllNace = (List<APCZ01_AresEntity.AresNace>)JSON.deserialize(sJsonNace, List<APCZ01_AresEntity.AresNace>.class);


            List<String> lstExistingNace;

            if (oPopUp.sNaceList != null) {
                //system.debug('oPopUp.sNaceList : '+oPopUp.sNaceList);
                lstExistingNace = oPopUp.sNaceList.split(',');
                //system.debug('KHAAAAAAAAAAD'+lstExistingNace);
            }

            List<String> lstNaceNames = new List<String>();

            for (String rowNace : lstExistingNace) {
                for (APCZ01_AresEntity.AresNace oAresNace : listAllNace) {
                    //system.debug('oAresNace.n04_NACE'+oAresNace.n04_NACE+'Rownace'+rowNace);
                    if (oAresNace.n04_NACE == rowNace) {
                        lstNaceNames.add('[' + oAresNace.n04_NACE + ' - '  + oAresNace.n04_Nazev + ']');
                    }
                }//looking for a name
            }

            //system.debug('ListNames=' + lstNaceNames);

            String sNaceNames = String.join(lstNaceNames, ',\r\n');

            oList[0].ER_NaceNameList__c = sNaceNames;

            update oList;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return oList[0];
    }
    
     @AuraEnabled
    public static Lead updateLeadWS(String sJson, String sJsonNace) {   
        
        APCZ01_AresEntity.AresPopUp oPopUp = (APCZ01_AresEntity.AresPopUp)JSON.deserialize(sJson, APCZ01_AresEntity.AresPopUp.class);

        //System.debug('***Get_oNace=' + sJsonNace);
        
        List<Lead> oList = [SELECT Id, Name, Street, PostalCode, City, ER_NaceList__c,ER_VAT_Number__c FROM Lead WHERE Id = :oPopUp.oId];
        
       // System.debug('***GetName=' + oPopUp.bGetName);
        try{
            if (oPopUp.bGetName == true) {
                oList[0].Company = oPopUp.sName;
            }

            if (oPopUp.bGetStreet == true) {
                oList[0].ER_Legal_Street__c = oPopUp.sStreet;
            }

            if (oPopUp.bGetZipCode == true) {
                oList[0].ER_Legal_Zip_Code__c = oPopUp.sPostalCode;
            }

            if (oPopUp.bGetCity == true) {
                oList[0].ER_Legal_City__c = oPopUp.sCity;
            }
            if (oPopUp.bGetVatNumber == true) {
                oList[0].ER_VAT_Number__c = oPopUp.sVatNumber;
            }
            if (oPopUp.bGetOtherFiscalId == true) {
                oList[0].ER_Other_Fiscal_ID__c = oPopUp.sOtherFiscalId;
            }

            oList[0].ER_NaceList__c = oPopUp.sNaceList;

            List<APCZ01_AresEntity.AresNace> listAllNace = (List<APCZ01_AresEntity.AresNace>)JSON.deserialize(sJsonNace, List<APCZ01_AresEntity.AresNace>.class);


            List<String> lstExistingNace;

            if (oPopUp.sNaceList != null) {
                lstExistingNace = oPopUp.sNaceList.split(',');
            }

            List<String> lstNaceNames = new List<String>();

            for (String rowNace : lstExistingNace) {
                for (APCZ01_AresEntity.AresNace oAresNace : listAllNace) {
                    if (oAresNace.n04_NACE == rowNace) {
                        lstNaceNames.add('[' + oAresNace.n04_NACE + ' - '  + oAresNace.n04_Nazev + ']');
                    }
                }//looking for a name
            }

            String sNaceNames = String.join(lstNaceNames, ',\r\n');

            oList[0].ER_NaceNameList__c = sNaceNames;

            update oList;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return oList[0];
    }
    
    
}