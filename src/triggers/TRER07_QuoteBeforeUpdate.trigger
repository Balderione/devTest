/*
----------------------------------------------------------------------
-- - Name          : TRER07_QuoteBeforeUpdate
-- - Author        : OLA
-- - Description   : 
    1 - If a quote is accepted check that it is the last one.
    2 - If a quote is accepted create a contract.
    3 - If status change to denied:
                                    3 - 1: if the linked contract is Draft ==> delete contract
                                    3 - 2: if the linked contract is Activated ==> add error
                                    3 - 3: if the linked contract is Deactivated ==> change the quote to denied but don't delete the contract
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Feb-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
trigger TRER07_QuoteBeforeUpdate on Quote (before update) {

    Map<id, Quote> oldQuoteMap = trigger.oldMap;
    Map<id, Quote> newQuoteMap = trigger.newMap;
    Map<id, Quote> acceptedQuoteMap = new Map<id, Quote>();
    Set<id> deniedQuoteContractids = new Set<id>();

    if (APER10_User_Management.canTrigger) {

        System.debug('###:TRER07_QuoteBeforeUpdate before update Start');

        for (Quote newquoteInst : newQuoteMap.values()) {

            if (newquoteInst.Status == Label.LABS_SF_Quote_Status_Accepted && oldQuoteMap.get(newquoteInst.Id).Status != Label.LABS_SF_Quote_Status_Accepted) {

                System.debug('####OLA Accepted Quote : ' + newquoteInst);
                acceptedQuoteMap.put(newquoteInst.id, newquoteInst);

            } else if (newquoteInst.Status == Label.LABS_SF_Quote_Status_Denied && oldQuoteMap.get(newquoteInst.Id).Status == Label.LABS_SF_Quote_Status_Accepted) {

                if (String.isNotBlank(newquoteInst.ContractId)) {

                    System.debug('####OLA Contract ER_Contract_status__c : ' + newquoteInst.ER_Contract_status__c);
                    if (newquoteInst.ER_Contract_status__c.equalsignorecase(Label.LABS_SF_Contract_Status_Draft)) {

                        deniedQuoteContractids.add(newquoteInst.ContractId);
                        newquoteInst.ContractId = null;
                    } else if (newquoteInst.ER_Contract_status__c.equalsignorecase(Label.LABS_SF_Contract_Status_Activated)) {

                        newquoteInst.adderror(Label.LABS_SF_Quote_ContractActivatedCannotBeDeleted);
                    }
                }
            }
        }

        if (!acceptedQuoteMap.isempty()) {

            APER11_Quote_Management.checkRecentQuote(acceptedQuoteMap.values());
            APER12_Contract_Management.createContractFromQuote(acceptedQuoteMap);
        }
        if (!deniedQuoteContractids.isempty()) {

            APER12_Contract_Management.deleteContractFromQuote(deniedQuoteContractids);
        }

        System.debug('###:TRER07_QuoteBeforeUpdate before update End');
    }
}