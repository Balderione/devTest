/*
----------------------------------------------------------------------
-- - Name          : TRER06_EmailMessageAfterInsert
-- - Author        : OLA
-- - Description   : 1 - When PDF is sent to Contact, change quote status to Presented
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  JAN-2019       OLA                 1.0         Initial version
--  JUL-2019       OLA                 1.1         Add Email message Quote condition.
---------------------------------------------------------------------------------------
*/
trigger TRER06_EmailMessageAfterInsert on EmailMessage (after insert) {

    Map<id, EmailMessage> newEmailMessageMap = trigger.newMap;
    Set<id> emailMessageQuoteIds = new Set<id>();

    if (APER10_User_Management.canTrigger) {

        System.debug('###:TRER06_EmailMessageAfterInsert after insert Start');

        for (EmailMessage EMinst : newEmailMessageMap.values()) {

            //10 JULY Check if From Name starts with user BU or equals user Name.
            if(!EMinst.Incoming && String.isNotBlank(EMinst.FromName) && !EMinst.FromName.startsWith(APER10_User_Management.userBU) && EMinst.FromName != userInfo.getName()){

                EMinst.addError(Label.LABS_SF_EmailMessage_FromAdressForbidden);
            }
            if (String.isNotBlank(EMinst.RelatedToId) && String.valueOf(EMinst.RelatedToId).startsWith('0Q0')) {

                emailMessageQuoteIds.add(EMinst.RelatedToId);
            }
        }
        if(!emailMessageQuoteIds.isEmpty()){
            List<Quote> quoteList = [select id, Status, Opportunity.StageName, OpportunityId
                                     from quote
                                     where id IN : emailMessageQuoteIds and Status = :Label.LABS_SF_Quote_Status_Draft];
            
            if (!quoteList.isEmpty()) {

                APER11_Quote_Management.updateQuoteStatus(quoteList);
            }
        }
        

        System.debug('###:TRER06_EmailMessageAfterInsert after insert End');
    }


}