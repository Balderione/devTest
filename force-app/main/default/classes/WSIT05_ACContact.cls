@RestResource(urlMapping='/ac_contact/*') 
global class WSIT05_ACContact {
    @HttpPut
    global static List<response> AnagraficaClientiUpsert() { 
        Map<String, response> mapError = new Map<String, response>();
        List<response> respList = new List<response>();
        Map<String, Contact> mapAllContactWithName = new Map<String, Contact>();
        Map<String, Contact> mapAllContact = new Map<String, Contact>();
        Map<String, IT_Contact_Detail__c> mapAllContactDetails = new Map<String, IT_Contact_Detail__c>();
        Map<String, IT_Contact_Association__c> mapAllContactAss = new Map<String, IT_Contact_Association__c>();
        Set<IT_Contact> contactWS = new Set<IT_Contact>();
        Set<String> allLookupForAssociation = new Set<String>();
        Map<String, sObject> mapAllObjectLookupFC = new Map<String, sObject>();
        Map<String, sObject> mapAllObjectLookup = new Map<String, sObject>();
        List<Contact> contactUpsert = new List<Contact>();
        List<IT_Contact_Association> contactAssociationList = new List<IT_Contact_Association>();

        List<Contact> contactControlName = new List<Contact>();
        List<String> contactControlNameString = new List<String>();
        List<String> contactControlLastNameString = new List<String>();
        Map<String, String> detailAssLastName = new Map<String, String>();
        List<IT_Contact_Detail__c> listAllContactDetailName = new List<IT_Contact_Detail__c>();
        Map<String, IT_Contact_Detail__c> mapAllContactDetailsName = new Map<String, IT_Contact_Detail__c>();
        Map<String, IT_Contact_Association__c> mapAllContactAssName = new Map<String, IT_Contact_Association__c>();
        
        String body = System.RestContext.request.requestBody.toString();
        system.debug('body::: '+body);
        Request req = (Request) JSON.deserializeStrict(body, Request.class);
        system.debug('data::: '+req);

        List<ER_Financial_Center__c> listLookupFC = new List<ER_Financial_Center__c>();
        List<ER_Delivery_Site__c> listLookupDeliverySite = new List<ER_Delivery_Site__c>();
        List<ER_Distribution_Point__c> listLookupDistributionPoint = new List<ER_Distribution_Point__c>(); 

        //AD - Change contact logic 28012020
        Map<String, List<String>> accountIds = new Map<String, List<String>>();
        Map<String, Contact> mapContactSoc = new Map<String, Contact>();
        List<Account> accountObj = new List<Account>();

        for(IT_Contact singleContactQuery : req.IT_Contact){
            if(!String.isBlank(singleContactQuery.LastName) && !String.isBlank(singleContactQuery.FirstName)){
                contactControlLastNameString.add(singleContactQuery.LastName);
                contactControlNameString.add(singleContactQuery.FirstName);     
            }
            allLookupForAssociation.add(singleContactQuery.IT_Code);
            if(singleContactQuery.IT_Contact_Association != null && singleContactQuery.IT_Contact_Association.size() > 0){
                for(IT_Contact_Association singleAssociationQuery : singleContactQuery.IT_Contact_Association){

                    if(!String.isBlank(singleAssociationQuery.IT_Client_Code))
                        allLookupForAssociation.add(singleAssociationQuery.IT_Client_Code);
                    if(!String.isBlank(singleAssociationQuery.IT_Activity_AC))    
                        allLookupForAssociation.add(singleAssociationQuery.IT_Activity_AC);
                    if(singleAssociationQuery.IT_Delivery_AC != null)     
                        allLookupForAssociation.add(String.valueOf(singleAssociationQuery.IT_Delivery_AC));
                }
            }    
        }

        System.debug('allLookupForAssociation::::: '+allLookupForAssociation); 

        if(allLookupForAssociation != null && allLookupForAssociation.size() > 0){
            listLookupFC = [Select Id, Name, IT_Financial_Center__c, ER_Account_Name__c From ER_Financial_Center__c Where IT_Financial_Center__c IN : allLookupForAssociation];
            listLookupDeliverySite = [Select Id, Name, IT_Delivery_AC__c From ER_Delivery_Site__c Where IT_Delivery_AC__c IN : allLookupForAssociation];
            listLookupDistributionPoint = [Select Id, Name, IT_AC_Activity__c From ER_Distribution_Point__c Where IT_AC_Activity__c IN : allLookupForAssociation];

            if(contactControlLastNameString != null && contactControlLastNameString.size() > 0 && contactControlNameString != null && contactControlNameString.size() > 0){
                contactControlName = [Select Id, AccountId, FirstName, LastName, IT_Code__c From Contact Where FirstName IN: contactControlNameString And LastName IN: contactControlLastNameString];
                listAllContactDetailName = [Select Id, Name, IT_Code__c, IT_Contact_Info__c, IT_Contact_progressive__c, IT_Apparatus_Type__c, (Select Id, Name, IT_Code__c, IT_Client_Code__c, IT_Activity_AC__c, IT_Delivery_AC__c, IT_Type__c, IT_Contact_Detail__r.IT_Contact_Progressive__c From Contact_Association__r) From IT_Contact_Detail__c Where IT_Contact__r.FirstName IN: contactControlNameString And IT_Contact__r.LastName IN: contactControlLastNameString];
            }    

            List<Contact> listAllContact = [Select Id, Name, LastName, IT_Code__c From Contact Where IT_Code__c IN : allLookupForAssociation];
            List<IT_Contact_Detail__c> listAllContactDetail = [Select Id, Name, IT_Code__c, IT_Contact_Info__c, IT_Contact_progressive__c, IT_Apparatus_Type__c, (Select Id, Name, IT_Code__c, IT_Client_Code__c, IT_Activity_AC__c, IT_Delivery_AC__c, IT_Type__c, IT_Contact_Detail__r.IT_Contact_Progressive__c From Contact_Association__r) From IT_Contact_Detail__c Where IT_Code__c IN : allLookupForAssociation];
            
            if(listLookupFC != null && listLookupFC.size() > 0){
                for(ER_Financial_Center__c singleFC : listLookupFC){
                    if(accountIds != null && accountIds.keyset().contains(singleFC.ER_Account_Name__c)){
                        List<String> fcTemp = new List<String>();
                        fcTemp = accountIds.get(singleFC.ER_Account_Name__c);
                        fcTemp.add(singleFC.IT_Financial_Center__c);
                        accountIds.put(singleFC.ER_Account_Name__c, fcTemp);
                    }else{
                        List<String> fcTemp = new List<String>();
                        fcTemp.add(singleFC.IT_Financial_Center__c);
                        accountIds.put(singleFC.ER_Account_Name__c, fcTemp);
                    }    


                    mapAllObjectLookupFC.put(singleFC.IT_Financial_Center__c, singleFC);
                }    
            }
            //AD - Change contact logic 28012020
            if(accountIds != null && accountIds.size() > 0){
                List<String> idSOC = new List<String>(); 
                accountObj = [Select Id, Name, ER_VAT_Number__c, (Select Id, IT_Code__c, LastName From Contacts Where IT_Type__c = 'Soc') From Account Where Id IN: accountIds.Keyset()];
                for(Account singleAcc : accountObj){
                    if(singleAcc.contacts != null && singleAcc.contacts.size() > 0){
                        List<String> listFcCode = new List<String>();
                        listFcCode = accountIds.get(singleAcc.Id);
                        for(String singleFc : listFcCode)
                            mapContactSoc.put(singleFc, singleAcc.contacts[0]);
                        idSOC.add(singleAcc.contacts[0].Id);
                    }
                }
                list<IT_Contact_Detail__c> detailSOC = new list<IT_Contact_Detail__c>();
                detailSOC = [Select Id, Name, IT_Code__c, IT_Contact_Info__c, IT_Contact_progressive__c, IT_Apparatus_Type__c, (Select Id, Name, IT_Code__c, IT_Client_Code__c, IT_Activity_AC__c, IT_Delivery_AC__c, IT_Type__c, IT_Contact_Detail__r.IT_Contact_Progressive__c From Contact_Association__r) From IT_Contact_Detail__c Where IT_Contact__c IN: idSOC];
                if(detailSOC != null && detailSOC.size() > 0)
                    listAllContactDetail.addAll(detailSOC); 
            }
            System.debug('mapContactSoc::::: '+mapContactSoc);  
            //AD - Change contact logic 28012020 - END   
            if(listLookupDeliverySite != null && listLookupDeliverySite.size() > 0){
                for(ER_Delivery_Site__c singleDeliverySite : listLookupDeliverySite){
                    mapAllObjectLookup.put(singleDeliverySite.IT_Delivery_AC__c, singleDeliverySite);  
                }
            }
            if(listLookupDistributionPoint != null && listLookupDistributionPoint.size() > 0){
                for(ER_Distribution_Point__c singleDistributionPoint : listLookupDistributionPoint){
                    mapAllObjectLookup.put(singleDistributionPoint.IT_AC_Activity__c, singleDistributionPoint);
                }
            }

            System.debug('mapAllObjectLookup::::: '+mapAllObjectLookup);
            System.debug('listAllContact::::: '+listAllContact);    

            for(Contact recordContact: listAllContact) {
                mapAllContact.put(recordContact.IT_Code__c, recordContact);
            }
            if(contactControlName != null && contactControlName.size() > 0){
                for(Contact recordContactName: contactControlName) {
                    if(!String.isBlank(recordContactName.LastName) && !String.isBlank(recordContactName.LastName)){
                        mapAllContactWithName.put(recordContactName.FirstName+recordContactName.LastName+recordContactName.AccountId, recordContactName);
                        detailAssLastName.put(recordContactName.FirstName+recordContactName.LastName+recordContactName.AccountId, recordContactName.IT_Code__c);
                    }    
                }
            }
            if(listAllContactDetailName != null && listAllContactDetailName.size() > 0){
                System.debug('listAllContactDetailName::::: '+listAllContactDetailName);
                for(IT_Contact_Detail__c sinDel : listAllContactDetailName){
                    mapAllContactDetailsName.put(sinDel.IT_Code__c+sinDel.IT_Apparatus_Type__c+sinDel.IT_Contact_Info__c.toLowerCase(), sinDel);
                    System.debug('sinDel.Contact_Association__r::::: '+sinDel.Contact_Association__r);
                    for(IT_Contact_Association__c singleContactAss : sinDel.Contact_Association__r){
                        mapAllContactAssName.put(singleContactAss.IT_Code__c+singleContactAss.IT_Client_Code__c+singleContactAss.IT_Type__c+singleContactAss.IT_Contact_Detail__r.IT_Contact_Progressive__c+singleContactAss.IT_Activity_AC__c+singleContactAss.IT_Delivery_AC__c, singleContactAss);
                    }
                }    
            }

            System.debug('mapAllContact::::: '+mapAllContact); 

            for(IT_Contact_Detail__c singleContactDetail : listAllContactDetail){
                mapAllContactDetails.put(singleContactDetail.IT_Code__c+singleContactDetail.IT_Apparatus_Type__c+singleContactDetail.IT_Contact_Info__c.toLowerCase(), singleContactDetail);
                for(IT_Contact_Association__c singleContactAss : singleContactDetail.Contact_Association__r){
                    mapAllContactAss.put(singleContactAss.IT_Code__c+singleContactAss.IT_Client_Code__c+singleContactAss.IT_Type__c+singleContactAss.IT_Contact_Detail__r.IT_Contact_Progressive__c+singleContactAss.IT_Activity_AC__c+singleContactAss.IT_Delivery_AC__c, singleContactAss);
                }
            } 
        }

        for(IT_Contact singleContactQuery : req.IT_Contact){
            Savepoint sp = Database.setSavepoint();
            Contact conatactControl = new Contact();
            String fcCode = '';
            try{
                if(String.isblank(singleContactQuery.IT_Code)){
                    response responseService = new response();
                    responseService = populateResponseError(singleContactQuery.IT_Code, 'Required Field Missing IT_Code');  
                    if(!mapError.Keyset().contains(singleContactQuery.IT_Code))
                        mapError.put(singleContactQuery.IT_Code, responseService);
                }
                contactAssociationList = singleContactQuery.IT_Contact_Association;
                for(IT_Contact_Association singleContactAss : contactAssociationList){

                    if(String.isblank(singleContactAss.IT_Code)){
                        response responseService = new response();
                        responseService = populateResponseError(singleContactQuery.IT_Code, 'Required Field Missing IT_Code'); 
                        if(!mapError.Keyset().contains(singleContactQuery.IT_Code))
                            mapError.put(singleContactQuery.IT_Code, responseService);
                    }
                    /*if(String.isblank(singleContactAss.IT_Contact_Progressive)){
                        response responseService = new response();
                        responseService = populateResponseError(singleContactQuery.IT_Code, 'Required Field Missing IT_Contact_Progressive'); 
                        if(!mapError.Keyset().contains(singleContactQuery.IT_Code))
                            mapError.put(singleContactQuery.IT_Code, responseService);
                    }*/
                    if(String.isblank(singleContactAss.IT_Client_Code)){
                        response responseService = new response();
                        responseService = populateResponseError(singleContactQuery.IT_Code, 'Required Field Missing IT_Client_Code'); 
                        if(!mapError.Keyset().contains(singleContactQuery.IT_Code))
                            mapError.put(singleContactQuery.IT_Code, responseService);
                    }
                    /*if(String.isblank(singleContactAss.IT_Apparatus_Type)){
                        response responseService = new response();
                        responseService = populateResponseError(singleContactQuery.IT_Code, 'Required Field Missing IT_Apparatus_Type'); 
                        if(!mapError.Keyset().contains(singleContactQuery.IT_Code))
                            mapError.put(singleContactQuery.IT_Code, responseService);
                    }*/
                    if(String.isblank(singleContactAss.IT_Type)){
                        response responseService = new response();
                        responseService = populateResponseError(singleContactQuery.IT_Code, 'Required Field Missing IT_Type'); 
                        if(!mapError.Keyset().contains(singleContactQuery.IT_Code))
                            mapError.put(singleContactQuery.IT_Code, responseService);
                    }

                    if(String.isBlank(fcCode))
                        fcCode = singleContactAss.IT_Client_Code;

                }
                if(!mapError.Keyset().contains(singleContactQuery.IT_Code)){

                    Contact circuitControl = new Contact();
                    Contact upsertContact = new Contact();
                    if(mapAllContact.Keyset().contains(singleContactQuery.IT_Code)){
                        conatactControl = mapAllContact.get(singleContactQuery.IT_Code);   
                    }    

                    upsertContact = populateContact(conatactControl, singleContactQuery, mapAllObjectLookupFC, fcCode, mapAllContactWithName);
                    if(upsertContact != null && upsertContact.IT_Type__c != 'Cli')
                        upsert upsertContact;

                    response responseService = new response(); 
                    responseService.statusCode = '200'; 
                    responseService.contact_CD = singleContactQuery.IT_Code;  
                    responseService.sfdc_ID = upsertContact.Id;
                    responseService.ErrorDescription = ''; 
                    respList.add(responseService);

                    //Upsert Contact_Association  - Start
                    List<IT_Contact_Association> contactAssoc = new List<IT_Contact_Association>();
                    contactAssoc = singleContactQuery.IT_Contact_Association;
                    List<IT_Contact_Detail__c> contactDetUpsert = new List<IT_Contact_Detail__c>();
                    
                    contactDetUpsert = populateContactDetail(upsertContact, contactAssoc, mapAllObjectLookup, mapAllContactDetails, mapAllContactAss, mapContactSoc, fcCode, detailAssLastName, mapAllContactDetailsName); 
                    system.debug('contactDetUpsert:: '+contactDetUpsert);
                    if(contactDetUpsert != null && contactDetUpsert.size() > 0)
                        upsert contactDetUpsert;

                    if(contactDetUpsert != null && contactDetUpsert.size() > 0){ 
                        Map<String, String> populateLookupContactDetail = new Map<String, String>();
                        for(IT_Contact_Detail__c sinDetail : contactDetUpsert){
                            populateLookupContactDetail.put(sinDetail.IT_Code__c+sinDetail.IT_Apparatus_Type__c+sinDetail.IT_Contact_Progressive__c, sinDetail.Id);
                        }   
                        List<IT_Contact_Association__c> contactAssUpsert = new List<IT_Contact_Association__c>(); 
                        contactAssUpsert = populateContactAssociation(upsertContact, contactAssoc, mapAllObjectLookup, mapAllContactDetails, mapAllContactAss, populateLookupContactDetail, mapAllObjectLookupFC, mapContactSoc, fcCode, detailAssLastName, mapAllContactAssName); 
                        system.debug('contactAssUpsert:: '+contactAssUpsert);
                        if(contactAssUpsert != null && contactAssUpsert.size() > 0)
                            upsert contactAssUpsert;
                    }     
                    //Upsert Contact_Association - End 

                }else{
                    response responseServiceErr = new response(); 
                    responseServiceErr = mapError.get(singleContactQuery.IT_Code); 
                    respList.add(responseServiceErr);        
                }    

            }catch(Exception ecc){
                System.debug('Error WSIT05_ACContact: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                Integer singleResponse = 0;
                while (singleResponse < respList.size()){
                    if(respList.get(singleResponse).contact_CD == singleContactQuery.IT_Code){
                        respList.remove(singleResponse);
                    }else{
                        singleResponse++;
                    }
                }

                response responseServiceCatch = new response(); 
                responseServiceCatch.statusCode = '400';   
                responseServiceCatch.errorDescription = ecc.getMessage();
                responseServiceCatch.contact_CD = singleContactQuery.IT_Code;
                responseServiceCatch.sfdc_ID = '';
                respList.add(responseServiceCatch);

                Database.rollback(sp);
            }

        }

        return respList;
   
    }

    private static response populateResponseError(String codeContact, String errorField){
        response responseService = new response(); 
        responseService.statusCode = '400'; 
        responseService.contact_CD = codeContact;
        responseService.sfdc_ID = '';
        responseService.ErrorDescription = errorField;
        return responseService;
    } 

    private static Contact populateContact(Contact contactObj, IT_Contact contactRequest, Map<String, sObject> mapAllObjectLookup, String fcCode, Map<String, Contact> mapAllLastNameContact){
        Contact upsertContactMethodTemp = new Contact();
        Contact upsertContactMethod = new Contact();

        System.debug('contactObj:::: '+contactObj); 
        if(contactObj != upsertContactMethodTemp){
            upsertContactMethod = new Contact(Id = contactObj.Id);
        }else {
            if(mapAllObjectLookup != null && mapAllObjectLookup.size() > 0 && mapAllObjectLookup.keyset().contains(fcCode)){
                ER_Financial_Center__c objFinancialCenter = new ER_Financial_Center__c();
                objFinancialCenter = (ER_Financial_Center__c) mapAllObjectLookup.get(fcCode);
                upsertContactMethod.ER_FinancialCenter__c = objFinancialCenter.Id;
                System.debug('upsertContactMethod.ER_FinancialCenter__c:::: '+upsertContactMethod.ER_FinancialCenter__c);
                if(mapAllLastNameContact != null && mapAllLastNameContact.size() > 0 && mapAllLastNameContact.keyset().contains(contactRequest.FirstName+contactRequest.LastName+objFinancialCenter.ER_Account_Name__c))
                    upsertContactMethod = new Contact(Id = mapAllLastNameContact.get(contactRequest.FirstName+contactRequest.LastName+objFinancialCenter.ER_Account_Name__c).Id);
                upsertContactMethod.AccountId = objFinancialCenter.ER_Account_Name__c;
                   
            }else{
                throw new system.DMLException ('Client Code not Present in the system for '+contactObj.IT_Code__c);
            }    
        }
        
        System.debug('mapAllLastNameContact:::: '+mapAllLastNameContact);
        System.debug('upsertContactMethod:::: '+upsertContactMethod);

        upsertContactMethod.IT_Code__c = contactRequest.IT_Code;
        upsertContactMethod.LastName = contactRequest.LastName;
        if(contactRequest.IT_Code.length() == 7)
            upsertContactMethod.FirstName = contactRequest.FirstName;
        upsertContactMethod.Phone = contactRequest.Phone;
        upsertContactMethod.Fax = contactRequest.Fax;
        upsertContactMethod.Email = contactRequest.Email;
        upsertContactMethod.IT_PEC__c = contactRequest.IT_PEC;
        upsertContactMethod.IT_Type__c = contactRequest.IT_Type;
        if(contactRequest.IT_Order_Making != null)
            upsertContactMethod.IT_Order_Making__c = contactRequest.IT_Order_Making;
        if(contactRequest.IT_Ticket_Receipts != null)    
            upsertContactMethod.IT_Ticket_Receipts__c = contactRequest.IT_Ticket_Receipts;
        if(contactRequest.IT_Client_Billing_Recepits != null)      
            upsertContactMethod.IT_Client_Billing_Recepits__c = contactRequest.IT_Client_Billing_Recepits;
        upsertContactMethod.IT_Referent_Progressive__c = contactRequest.IT_Referent_Progressive;  
        upsertContactMethod.IT_AC_User__c = contactRequest.IT_AC_User;
        upsertContactMethod.IT_Validity_Start_Date__c = contactRequest.IT_Validity_Start_Date;
        upsertContactMethod.IT_Validity_End_Date__c = contactRequest.IT_Validity_End_Date;
            
        return upsertContactMethod;
    }

    private static List<IT_Contact_Detail__c> populateContactDetail(Contact contactObj, List<IT_Contact_Association> listContactAssoc, Map<String, sObject> mapAllObjectLookup, Map<String, IT_Contact_Detail__c> mapAllContactDetailsLookup, Map<String, IT_Contact_Association__c> mapAllContactAssLookup, Map<String, Contact> contactSocMap, String codeFC, Map<String, String> detailAssLastNameMethod, Map<String, IT_Contact_Detail__c> mapAllContactDetailsLookupName){
        List<IT_Contact_Detail__c> upsertAllContractDet = new List<IT_Contact_Detail__c>();
        Map<String, String> controlDuplicateDetail = new Map<String, String>();

        for(IT_Contact_Association singledetAss : listContactAssoc){
            IT_Contact_Detail__c upsertContactDetailMethod = new IT_Contact_Detail__c();
            System.debug('mapAllContactDetailsLookupName::: '+mapAllContactDetailsLookupName);
            System.debug('detailAssLastNameMethod:: '+detailAssLastNameMethod);  
            System.debug('mapAllContactDetailsLookup:: '+mapAllContactDetailsLookup); 
            System.debug('contactSocMap:: '+contactSocMap);
            String contactInfo = '';
            if(!String.isblank(singledetAss.IT_Contact_Info))
                contactInfo = singledetAss.IT_Contact_Info.toLowerCase();

            if(controlDuplicateDetail != null && (!controlDuplicateDetail.keyset().contains(singledetAss.IT_Code+singledetAss.IT_Apparatus_Type+contactInfo) && contactSocMap != null && contactSocMap.keyset().contains(codeFC) && !controlDuplicateDetail.keyset().contains(contactSocMap.get(codeFC).IT_Code__c+singledetAss.IT_Apparatus_Type+contactInfo))){
                if(mapAllContactDetailsLookup != null && mapAllContactDetailsLookup.keyset().contains(singledetAss.IT_Code+singledetAss.IT_Apparatus_Type+contactInfo)){
                    upsertContactDetailMethod = new IT_Contact_Detail__c(Id = mapAllContactDetailsLookup.get(singledetAss.IT_Code+singledetAss.IT_Apparatus_Type+contactInfo).Id);
                    System.debug('upsertContactDetailMethod REF:: '+upsertContactDetailMethod);
                }else if(mapAllContactDetailsLookup != null && mapAllContactDetailsLookup.keyset().contains(contactSocMap.get(codeFC).IT_Code__c+singledetAss.IT_Apparatus_Type+contactInfo)){
                    upsertContactDetailMethod = new IT_Contact_Detail__c(Id = mapAllContactDetailsLookup.get(contactSocMap.get(codeFC).IT_Code__c+singledetAss.IT_Apparatus_Type+contactInfo).Id);    
                    System.debug('KEY_SOC:: '+contactSocMap.get(codeFC).IT_Code__c+ '-----' +singledetAss.IT_Apparatus_Type+ '-----' +contactInfo);
                    System.debug('upsertContactDetailMethod SOC:: '+upsertContactDetailMethod);
                }else if(detailAssLastNameMethod != null && detailAssLastNameMethod.keyset().contains(contactObj.FirstName+contactObj.LastName+contactObj.AccountId) && mapAllContactDetailsLookupName.keyset().contains(detailAssLastNameMethod.get(contactObj.FirstName+contactObj.LastName+contactObj.AccountId)+singledetAss.IT_Apparatus_Type+contactInfo)){
                    upsertContactDetailMethod = new IT_Contact_Detail__c(Id = mapAllContactDetailsLookupName.get(detailAssLastNameMethod.get(contactObj.FirstName+contactObj.LastName+contactObj.AccountId)+singledetAss.IT_Apparatus_Type+contactInfo).Id);
                    System.debug('upsertContactDetailMethod  SF:: '+upsertContactDetailMethod); 
                }

                if(!String.isBlank(singledetAss.IT_Contact_Info)){
                    upsertContactDetailMethod.Name = singledetAss.IT_Contact_Info.toLowerCase(); 
                    upsertContactDetailMethod.IT_Contact_Info__c = singledetAss.IT_Contact_Info.toLowerCase();  
                }else{
                    upsertContactDetailMethod.Name = '-'; 
                }
                    
                upsertContactDetailMethod.IT_Code__c = singledetAss.IT_Code;                     
                upsertContactDetailMethod.IT_Contact_Progressive__c = singledetAss.IT_Contact_Progressive;
                upsertContactDetailMethod.IT_Apparatus_Type__c = singledetAss.IT_Apparatus_Type;
                if(singledetAss.IT_Main_Contact != null)
                    upsertContactDetailMethod.IT_Main_Contact__c = singledetAss.IT_Main_Contact;
                upsertContactDetailMethod.IT_AC_User__c = singledetAss.IT_AC_User;
                if(contactObj.IT_Type__c == 'Cli'){
                    upsertContactDetailMethod.IT_Contact__c = contactSocMap.get(codeFC).Id; 
                    controlDuplicateDetail.put(contactSocMap.get(codeFC).IT_Code__c+singledetAss.IT_Apparatus_Type+contactInfo, singledetAss.IT_Code);
                }else{
                    upsertContactDetailMethod.IT_Contact__c = contactObj.Id;
                    controlDuplicateDetail.put(singledetAss.IT_Code+singledetAss.IT_Apparatus_Type+contactInfo, singledetAss.IT_Code);
                }    
                upsertAllContractDet.add(upsertContactDetailMethod);
            }    
        }

        return upsertAllContractDet;
    }

    private static List<IT_Contact_Association__c> populateContactAssociation(Contact contactObj, List<IT_Contact_Association> listContactAssoc, Map<String, sObject> mapAllObjectLookup, Map<String, IT_Contact_Detail__c> mapAllContactDetailsLookup, Map<String, IT_Contact_Association__c> mapAllContactAssLookup, Map<String, String> mapLookupDetail, Map<String, sObject> mapForFC, Map<String, Contact> contactSocMap, String codeFC, Map<String, String> detailAssLastNameMethod, Map<String, IT_Contact_Association__c> mapAllContactAssLookupName){
        List<IT_Contact_Association__c> upsertAllContractAss = new List<IT_Contact_Association__c>();

        for(IT_Contact_Association singledetAss : listContactAssoc){
            IT_Contact_Association__c upsertContactAssociationMethod = new IT_Contact_Association__c();

            System.debug('mapAllContactAssLookupName::: '+mapAllContactAssLookupName);
            System.debug('singledetAss.IT_Client_Code::: '+singledetAss.IT_Client_Code);
            System.debug('singledetAss.IT_Type:: '+singledetAss.IT_Type);
            System.debug('detailAssLastNameMethod.get():: '+detailAssLastNameMethod.get(contactObj.FirstName+contactObj.LastName+contactObj.AccountId));

            if(!String.isBlank(singledetAss.IT_Contact_Progressive) && mapAllContactAssLookup != null && mapAllContactAssLookup.keyset().contains(singledetAss.IT_Code+singledetAss.IT_Client_Code+singledetAss.IT_Type+singledetAss.IT_Contact_Progressive+singledetAss.IT_Activity_AC+singledetAss.IT_Delivery_AC))
                upsertContactAssociationMethod = new IT_Contact_Association__c(Id = mapAllContactAssLookup.get(singledetAss.IT_Code+singledetAss.IT_Client_Code+singledetAss.IT_Type+singledetAss.IT_Contact_Progressive+singledetAss.IT_Activity_AC+singledetAss.IT_Delivery_AC).Id);    
            
            else if(String.isBlank(singledetAss.IT_Contact_Progressive) && mapAllContactAssLookup != null && mapAllContactAssLookup.keyset().contains(singledetAss.IT_Code+singledetAss.IT_Client_Code+singledetAss.IT_Type+singledetAss.IT_Activity_AC+singledetAss.IT_Delivery_AC))
                upsertContactAssociationMethod = new IT_Contact_Association__c(Id = mapAllContactAssLookup.get(singledetAss.IT_Code+singledetAss.IT_Client_Code+singledetAss.IT_Type+singledetAss.IT_Activity_AC+singledetAss.IT_Delivery_AC).Id);

            else if(detailAssLastNameMethod != null && detailAssLastNameMethod.keyset().contains(contactObj.FirstName+contactObj.LastName+contactObj.AccountId) && mapAllContactAssLookupName.keyset().contains(detailAssLastNameMethod.get(contactObj.FirstName+contactObj.LastName+contactObj.AccountId)+singledetAss.IT_Client_Code+singledetAss.IT_Type+singledetAss.IT_Contact_Progressive+singledetAss.IT_Activity_AC+singledetAss.IT_Delivery_AC))
                upsertContactAssociationMethod = new IT_Contact_Association__c(Id = mapAllContactAssLookupName.get(detailAssLastNameMethod.get(contactObj.FirstName+contactObj.LastName+contactObj.AccountId)+singledetAss.IT_Client_Code+singledetAss.IT_Type+singledetAss.IT_Contact_Progressive+singledetAss.IT_Activity_AC+singledetAss.IT_Delivery_AC).Id);    

            if(contactObj.IT_Type__c == 'Cli')  
                upsertContactAssociationMethod.IT_Contact__c = contactSocMap.get(codeFC).Id; 
            else
                upsertContactAssociationMethod.IT_Contact__c = contactObj.Id;
            upsertContactAssociationMethod.IT_Code__c = singledetAss.IT_Code;
            upsertContactAssociationMethod.IT_Type__c = singledetAss.IT_Type;
            upsertContactAssociationMethod.IT_Client_Code__c = singledetAss.IT_Client_Code;
            upsertContactAssociationMethod.IT_Activity_AC__c = singledetAss.IT_Activity_AC;
            upsertContactAssociationMethod.IT_Activity_SF__c = singledetAss.IT_Activity_SF;
            upsertContactAssociationMethod.IT_Delivery_AC__c = singledetAss.IT_Delivery_AC;
            upsertContactAssociationMethod.IT_Delivery_SF__c = singledetAss.IT_Delivery_SF;
            if(singledetAss.IT_Order_Confirm_Address != null)
                upsertContactAssociationMethod.IT_Order_Confirm_Address__c = singledetAss.IT_Order_Confirm_Address;
            if(singledetAss.IT_Billing_Confirm_Address != null)             
                upsertContactAssociationMethod.IT_Billing_Confirm_Address__c = singledetAss.IT_Billing_Confirm_Address;
            if(singledetAss.IT_Sut != null)         
                upsertContactAssociationMethod.IT_Send_Sut__c = singledetAss.IT_Sut;
            if(singledetAss.IT_Notifications != null)                                                 
                upsertContactAssociationMethod.IT_Notifications__c = singledetAss.IT_Notifications;

            upsertContactAssociationMethod.IT_Association_Progressive__c = singledetAss.IT_Contact_Progressive;    

            if(!String.isBlank(singledetAss.IT_Contact_Info))
                upsertContactAssociationMethod.IT_Contact_Info__c = singledetAss.IT_Contact_Info.toLowerCase();
            upsertContactAssociationMethod.IT_Apparatus_Type__c = singledetAss.IT_Apparatus_Type;
            if(singledetAss.IT_Main_Contact != null)
                upsertContactAssociationMethod.IT_Main_Contact__c = singledetAss.IT_Main_Contact;       
                                    
            if(!String.isBlank(singledetAss.IT_Client_Code) && mapForFC != null && mapForFC.keyset().contains(singledetAss.IT_Client_Code)){
                ER_Financial_Center__c objFinancialCenter = new ER_Financial_Center__c();
                objFinancialCenter = (ER_Financial_Center__c) mapForFC.get(singledetAss.IT_Client_Code);
                upsertContactAssociationMethod.IT_Account__c = objFinancialCenter.ER_Account_Name__c;
                upsertContactAssociationMethod.IT_Financial_Center__c = objFinancialCenter.Id;
            }
            System.debug('mapAllObjectLookup::::: '+mapAllObjectLookup);
            System.debug('singledetAss.IT_Activity_AC::::: '+singledetAss.IT_Activity_AC);
            if(!String.isBlank(singledetAss.IT_Activity_AC) && mapAllObjectLookup != null && mapAllObjectLookup.keyset().contains(singledetAss.IT_Activity_AC)){
                ER_Distribution_Point__c objDistributionPoint = new ER_Distribution_Point__c();
                objDistributionPoint = (ER_Distribution_Point__c) mapAllObjectLookup.get(singledetAss.IT_Activity_AC);
                upsertContactAssociationMethod.IT_Distribution_Point__c = objDistributionPoint.Id;
            }
            System.debug('singledetAss.IT_Delivery_AC::::: '+singledetAss.IT_Delivery_AC);
            if(singledetAss.IT_Delivery_AC != null && mapAllObjectLookup != null && mapAllObjectLookup.keyset().contains(String.valueOf(singledetAss.IT_Delivery_AC))){
                ER_Delivery_Site__c objDeliverySite = new ER_Delivery_Site__c();
                objDeliverySite = (ER_Delivery_Site__c) mapAllObjectLookup.get(String.valueOf(singledetAss.IT_Delivery_AC));
                upsertContactAssociationMethod.IT_Delivery_Site__c = objDeliverySite.Id;
            }
            System.debug('mapLookupDetail::::: '+mapLookupDetail);
            if(mapLookupDetail != null && mapLookupDetail.size() > 0){
                upsertContactAssociationMethod.IT_Contact_Detail__c = mapLookupDetail.get(singledetAss.IT_Code+singledetAss.IT_Apparatus_Type+singledetAss.IT_Contact_Progressive);
            }
            upsertAllContractAss.add(upsertContactAssociationMethod);
        }

        return upsertAllContractAss;
    }            

    public class Request{
        public List<IT_Contact> IT_Contact;
    }

    public class IT_Contact {
        public String IT_Code;
        public String LastName; 
        public String FirstName; 
        public String Phone; 
        public String Fax; 
        public String Email; 
        public String IT_PEC; 
        public String IT_Type;                        //Picklist
        public Boolean IT_Order_Making;
        public Boolean IT_Ticket_Receipts;
        public Boolean IT_Client_Billing_Recepits;
        public String IT_Referent_Progressive;
        public String IT_AC_User; 
        public Date IT_Validity_Start_Date;
        public Date IT_Validity_End_Date;
        public List<IT_Contact_Association> IT_Contact_Association;
    }

    public class IT_Contact_Association{
        public String IT_Code;
        public String IT_Client_Code;
        public String IT_Type;                               //Picklist
        public String IT_Activity_AC;
        public String IT_Activity_SF;
        public String IT_Delivery_AC;
        public String IT_Delivery_SF;
        //public String IT_Address_Progressive; 
        public String IT_Contact_Info;
        public String IT_Apparatus_Type;
        public Boolean IT_Order_Confirm_Address;
        public Boolean IT_Billing_Confirm_Address;
        public Boolean IT_Sut;
        public Boolean IT_Notifications;
        public Boolean IT_Main_Contact;
        public String IT_Contact_Progressive;
        public String IT_AC_User; 
    }
    
    global class response {
        public String statusCode;
        public String contact_CD; 
        public String sfdc_ID;
        public String errorDescription;       
    }
    
}