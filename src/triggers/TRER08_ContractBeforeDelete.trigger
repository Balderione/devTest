/*
----------------------------------------------------------------------
-- - Name          : TRER08_ContractBeforeDelete
-- - Author        : OLA
-- - Description   : Contract Management:
    1 - Delete Contract line Items after deleting contract
    2 - Before deleting a contract, check if the status is Draft.
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Feb-2019       OLA                 1.0         Initial version (1)
--  Mar-2019       OLA                 1.1         Update (2)
---------------------------------------------------------------------------------------
*/
trigger TRER08_ContractBeforeDelete on Contract (before delete) {

    Map<id, Contract> contractMap = trigger.oldMap;

    if (APER10_User_Management.canTrigger) {

        System.debug('###:TRER08_ContractBeforeDelete before delete Start');

        for(Contract contractInst : contractMap.values()){
            if(contractInst.status != Label.LABS_SF_Contract_Status_Draft){

                contractInst.addError(Label.LABS_SF_Contract_CannotBeDeleted);
            }
        }
        APER12_Contract_Management.deleteCLIFromContract(contractMap);

        System.debug('###:TRER08_ContractBeforeDelete before delete End');
    }
}