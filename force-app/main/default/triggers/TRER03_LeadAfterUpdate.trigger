trigger TRER03_LeadAfterUpdate on Lead (After Update) {
    /*
    ----------------------------------------------------------------------
    -- - Name          : TRER03_LeadAfterUpdate
    -- - Author        : AAB
    -- - Description   : Trigger on Lead after update (To create a related Financial center to the account)
    -- Maintenance History:
    --
    -- Date         Name                Version     Remarks
    -- -----------  -----------         --------    ---------------------------------------
    -- 16-JUL-2018  AAB                 1.0         Initial version
    ---------------------------------------------------------------------------------------
    */
    if (APER10_User_Management.canTrigger) {

        System.Debug('## TRER03_LeadAfterUpdate after update Start');

        List<Lead> leadList = new List<Lead>();

        // Loop through the Lead lists and add the converted leads to the List
        for (Lead ld : trigger.new) {
            if (ld.IsConverted && ld.ConvertedAccountId != null) {

                leadList.add(ld);
            }
        }

        if (!leadList.isEmpty()) {

            System.Debug('## Converted Leads : '+leadList);
            APER03_Lead_CreateFinancialCenter.createFinancialCenter(leadList);
        }

        System.Debug('## TRER03_LeadAfterUpdate after update End');
    }
}