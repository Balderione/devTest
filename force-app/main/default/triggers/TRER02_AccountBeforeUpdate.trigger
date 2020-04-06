trigger TRER02_AccountBeforeUpdate on Account (before update) {
    /*
    ----------------------------------------------------------------------
    -- - Name          : TRER02_AccountBeforeUpdate
    -- - Author        : AAB
    -- - Description   : Trigger on Account update (To update the related Client if it exists)
    -- Maintenance History:
    --
    -- Date         Name                Version     Remarks
    -- -----------  -----------         --------    ---------------------------------------
    -- 27-FEB-2018  AAB                 1.0         Initial version
    -- 03-May-2019  OLA                 2.0         Merge MC comment lines
    ---------------------------------------------------------------------------------------
    */
    if (APER10_User_Management.canTrigger) {

        System.debug('### TRER02_AccountBeforeUpdate Start');

        //List<Account> mechandList = new List<Account>();
        //static map<String, map<String, RecordType>> recordTypeMap;
        //Boolean isFunctionalUser = false;

        /* Bypass the trigger and Functional user */
        //User currentUser =  [select id, ER_bypassTrigger__c, Profile.Name from User where id =: UserInfo.getUserId()];

        //isFunctionalUser = !(currentUser.Profile.Name.containsIgnoreCase('Admin'));

        /** RecordTypes **/
        /*recordTypeMap = APER01_Account_RelatedClient.getRecordTypesBySObject(new List<String>{
            'Account'
                });
        */
        // Loop through the Account lists and add the necessary account to the set
        for (Account acc : trigger.new) {

            if (acc.ER_Match_Legal_Address__c == true) {
                acc.ShippingStreet = acc.BillingStreet;
                acc.ShippingPostalCode = acc.BillingPostalCode;
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingCountry = acc.BillingCountry;

                //back to false
                acc.ER_Match_Legal_Address__c = false;
            }
            /* To delete, not used anymore
             * if (isFunctionalUser) {
                acc.ER_Last_Modified_By_Functional_user__c  = UserInfo.getUserId();
                acc.ER_Last_Modified_Date_Functional_User__c = DateTime.now();
            }*/

            /*if ((acc.Type == 'Merchant' || acc.Type == 'Client') && acc.ER_Also_Client_Merchant__c == false
                && acc.ER_VAT_Number__c != null) {

                mechandList.add(acc);
            }*/
        }
        /*
        System.Debug('--- APER01_Account_RelatedClient end prepare');

        if(!mechandList.isEmpty() && !currentUser.ER_bypassTrigger__c)
        {
            APER01_Account_RelatedClient.lookForRelatedClientMerchant(mechandList);
        }
        */
    }
}