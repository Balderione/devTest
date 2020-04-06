/*
----------------------------------------------------------------------
-- - Name          : TRER04_CaseBeforeInsert
-- - Author        : OLA
-- - Description   : Trigger on Case insert (
- Handle Web To case : Link Asset to Case.

-- Maintenance History:
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
-- JUN-2019         OLA                1.0                 Initial version
---------------------------------------------------------------------------------------
*/
trigger TRER04_CaseBeforeInsert on Case (before insert) {

    List<Case> casesFromWeb = new List<Case>();

    if (APER10_User_Management.canTrigger) {

        System.debug('###:TRER04_CaseBeforeInsert before insert Start');

        for (Case cs : Trigger.New) {

            // Check that the case is a user case and that the origin is "Web"
            if (cs.Origin == Label.LABS_SF_Case_Origin_Web && cs.AssetId==null && cs.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ER_User_Case_RT').getRecordTypeId()) {

                casesFromWeb.add(cs);
            }
        }

        if (!casesFromWeb.isEmpty()) {
            
            System.debug('###:TRER04_CaseBeforeInsert casesFromWeb '+casesFromWeb);
            APER08_Case_Management.manageCasesFromWeb(casesFromWeb);
        }

        APER08_Case_Management.manageCasesEntitlment(Trigger.New);

        System.debug('###:TRER04_CaseBeforeInsert before insert End');
    }
}