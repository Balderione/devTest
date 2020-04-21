/*
----------------------------------------------------------------------
-- - Name          : TRER09_ER_ContractLineItemBeforeDelete
-- - Author        : OLA
-- - Description   :
    1 - Check if the parent contract is Draft before Deleting contract line Item
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Mar-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
trigger TRER09_ER_ContractLineItemBeforeDelete on ER_ContractLineItem__c (before delete) {

    Map<id, ER_ContractLineItem__c> cliMap = trigger.oldMap;

    if (APER10_User_Management.canTrigger) {

        System.debug('###:TRER09_ER_ContractLineItemBeforeDelete before delete Start');

        for (ER_ContractLineItem__c cliInst : cliMap.values()) {
            if (cliInst.ER_Contract_Status__c != Label.LABS_SF_Contract_Status_Draft) {

                cliInst.addError(Label.LABS_SF_ER_ContractLineItem_CannotBeDeleted);
            }
        }

        System.debug('###:TRER09_ER_ContractLineItemBeforeDelete before delete End');
    }
}