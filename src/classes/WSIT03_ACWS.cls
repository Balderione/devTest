@RestResource(urlMapping='/ac_financial_center/*') 
global class WSIT03_ACWS  {
    @HttpPut
    global static List<response> AnagraficaClientiUpsert() {
        List<response> respList = new List<response>();
        Map<String, response> mapError = new Map<String, response>();
        Map<String, ER_Financial_Center__c> mapFinancialCenterSF =  new Map<String, ER_Financial_Center__c>();
        Map<String, Contract> mapContactSF = new Map<String, Contract>();
        Map<String, ER_ContractLineItem__c> mapContactLineItem = new Map<String, ER_ContractLineItem__c>();
        Map<String, ER_Delivery_Site__c> mapDeliverySite = new Map<String, ER_Delivery_Site__c>();
        Map<String, ER_Distribution_Point__c> mapDistributionPoint = new Map<String, ER_Distribution_Point__c>();
        Map<String, ER_Distribution_Point__c> mapDistributionPointForNote = new Map<String, ER_Distribution_Point__c>();
        Map<String, IT_Group_Code__c> mapGroupCode = new Map<String, IT_Group_Code__c>();
        Map<String, ER_Bank_Account__c> mapBankAccount = new Map<String, ER_Bank_Account__c>();
        Map<String, IT_Address> mapAddress = new Map<String, IT_Address>();
        Map<String, Product2> lookuoProduct2 = new Map<String, Product2>();
        List<ER_Financial_Center__c> listAllFC = new List<ER_Financial_Center__c>();
        List<String> listAllService = new List<String>();
        List<String> listAllClientCode = new List<String>();
        List<String> VatNumberAccounts = new List<String>();
        List<Account> infoAccountOnFC = new List<Account>();
        Map<String, Account> vatAccount = new Map<String, Account>();
        List<Contract> contractMatchClientCode = new List<Contract>();
        List<Product2> contractAssignService = new List<Product2>();

        Set<String> setAbiCab = new Set<String>(); 
        List<IT_ABI_CAB__c> listAbiCabObj = new List<IT_ABI_CAB__c>();
        Map<String, IT_Abi_Cab__c> mapAbiCabForBank = new Map<String, IT_Abi_Cab__c>(); 

        List<IT_Group__c> listConnectionGroupCode = new List<IT_Group__c>();
        List<String> listGroupCode = new List<String>();
        Map<String, IT_Group__c> mapGroupForCode = new Map<String, IT_Group__c>();

        Map<String, IT_Additional_Expenses__c> mapAdditionalExpense = new Map<String, IT_Additional_Expenses__c>();
        Map<String, IT_Note__c> mapNote = new Map<String, IT_Note__c>();

        Map<String, String> controlDuplicateDelivery = new Map<String, String>();

        //Usercheck 16012020
        Map<String, String> authorizationUserDistributioPoint = new Map<String, String>();
        for(User dingleUser : [Select Id, IT_AC_User_Code__c From User Where IT_AC_User_Code__c != '']){
            authorizationUserDistributioPoint.put(dingleUser.IT_AC_User_Code__c, dingleUser.Id);    
        }    

        String body = System.RestContext.request.requestBody.toString();
        system.debug('body::: '+body);
        Request req = (Request) JSON.deserializeStrict(body, Request.class);
        system.debug('data::: '+req);

        Map<String, String> pickListValuesMap= new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = ER_Bank_Account__c.IT_Bank_Account_Code__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesMap.put(pickListVal.getValue(), pickListVal.getLabel());
        }     
        System.debug('pickListValuesMap::: '+pickListValuesMap); 

        for(ER_Financial_Center singleFCQuery : req.ER_Financial_Center){
            listAllClientCode.add(singleFCQuery.IT_Client_Code);
            VatNumberAccounts.add(singleFCQuery.IT_VAT_Number);
            listAllService.add(singleFCQuery.IT_Service);
            if(!String.isBlank(singleFCQuery.IT_ABI) && !String.isBlank(singleFCQuery.IT_CAB))
                setAbiCab.add(singleFCQuery.IT_ABI+singleFCQuery.IT_CAB);
            for(IT_Group singleGroupCode : singleFCQuery.IT_Group)
                listGroupCode.add(singleGroupCode.IT_Client_Code);    
        }

        if(VatNumberAccounts != null && VatNumberAccounts.size() > 0)
            infoAccountOnFC = [Select Id, Name, ER_VAT_Number__c From Account Where ER_VAT_Number__c IN : VatNumberAccounts];
        if(VatNumberAccounts != null && VatNumberAccounts.size() > 0){
            for(Account sinAcc : infoAccountOnFC){
                vatAccount.put(sinAcc.ER_VAT_Number__c, sinAcc);
            }    
        }    

        /**
            * Valuing maps for upsert operations
            * START
        */

        if(listAllClientCode != null && listAllClientCode.size() > 0){
            listAllFC = [Select Id, Name, IT_Financial_Center__c, ER_Account_Name__c, IT_Contract__c, IT_Product2__c, 
            (Select Id, IT_Client_Code__c, IT_Technical_Data_Progressive__c From Contract_Line_Items__r), 
            (Select Id, IT_Activity_AC__c, IT_Activity_SF__c, IT_Delivery_AC__c, IT_Delivery_SF__c From Delivery_Sites__r), 
            (Select Id, ER_Delivery_Site__c, IT_Client_Code__c, IT_SF_Activity__c, IT_AC_Activity__c, IT_Raw_Number_for_Display__c From Distribution_Points__r), 
            (Select Id, IT_Client_Code__c, IT_Group_Code__c, ER_Financial_Center__c, IT_Group_Type__c From Groups_Code__r), 
            (Select Id, IT_AC_Activity__c, IT_Progressive__c,  IT_AC_Delivery__c, IT_Note_Type__c, IT_Title__c, IT_Client_Code__c From Note__r), 
            (Select Id, IT_Client_Code__c, IT_Code__c, IT_AC_User__c, IT_Amount__c, IT_Progressive__c, IT_Calculation_Type__c, IT_Validity_End_Date__c, IT_Validity_Start_Date__c, IT_Financial_Center__c From Additional_Expenses__r), 
            (Select Id, IT_Client_Code__c, IT_ABI__c, ER_IBAN__c, IT_CAB__c, IT_CIN__c, IT_CC__c, ER_Country__c, IT_Check_Iban__c From Bank_Accounts__r) From ER_Financial_Center__c Where IT_Financial_Center__c IN : listAllClientCode]; 
            
            contractMatchClientCode = [Select Id, IT_Client_Code__c, IT_Contract_Number__c, IT_Contract_Progressive__c From Contract Where IT_Client_Code__c IN : listAllClientCode];
        
            contractAssignService = [Select Id, Name, ProductCode From Product2 Where ProductCode IN : listAllService];

            if(setAbiCab != null && setAbiCab.size() > 0)
                listAbiCabObj = [Select Id, Name, IT_AbiCab__c, IT_Bank__c, IT_CAB__c, IT_ABI__c From IT_Abi_Cab__c Where IT_AbiCab__c IN: setAbiCab];

            if(listGroupCode != null && listGroupCode.size() > 0)
                listConnectionGroupCode = [Select Id, IT_Group_Code__c, IT_Group_Type__c, IT_Service__c, IT_Description__c, IT_Financial_Center_Code__c From IT_Group__c Where IT_Financial_Center_Code__c IN: listGroupCode];
        }

        if(contractMatchClientCode != null & contractMatchClientCode.size() > 0){
            for(Contract singleContact : contractMatchClientCode){
                mapContactSF.put(singleContact.IT_Client_Code__c+singleContact.IT_Contract_Number__c+singleContact.IT_Contract_Progressive__c, singleContact);
            }
        }

        if(contractAssignService != null & contractAssignService.size() > 0){
            for(Product2 singleProduct : contractAssignService){
                lookuoProduct2.put(singleProduct.ProductCode, singleProduct);
            }
        }

        if(listAbiCabObj != null && listAbiCabObj.size() > 0){
            for(IT_Abi_Cab__c singleAbiCab : listAbiCabObj){
                mapAbiCabForBank.put(singleAbiCab.IT_AbiCab__c, singleAbiCab);
                System.debug('mapAbiCabForBank:: '+mapAbiCabForBank);
            }
        }

        if(listConnectionGroupCode != null && listConnectionGroupCode.size() > 0){
            for(IT_Group__c singleGroup : listConnectionGroupCode){
                mapGroupForCode.put(singleGroup.IT_Financial_Center_Code__c, singleGroup);
            }
        }     

        for(ER_Financial_Center__c singleSfFC : listAllFC){
            mapFinancialCenterSF.put(singleSfFC.IT_Financial_Center__c, singleSfFC);
            if(singleSfFC.Contract_Line_Items__r != null && singleSfFC.Contract_Line_Items__r.size() > 0){
                for(ER_ContractLineItem__c sinLineItem : singleSfFC.Contract_Line_Items__r){
                    mapContactLineItem.put(sinLineItem.IT_Client_Code__c+sinLineItem.IT_Technical_Data_Progressive__c, sinLineItem);
                }
            }
            if(singleSfFC.Delivery_Sites__r != null && singleSfFC.Delivery_Sites__r.size() > 0){
                for(ER_Delivery_Site__c sinDelSite : singleSfFC.Delivery_Sites__r){
                    String keyCode = '';
                    if(!String.isBlank(sinDelSite.IT_Delivery_SF__c)) 
                        keyCode = sinDelSite.IT_Delivery_SF__c;
                    else
                        keyCode = sinDelSite.IT_Delivery_AC__c;  
      
                    mapDeliverySite.put(keyCode, sinDelSite);
                }
            }
            if(singleSfFC.Distribution_Points__r != null && singleSfFC.Distribution_Points__r.size() > 0){
                for(ER_Distribution_Point__c sinDisPoint : singleSfFC.Distribution_Points__r){
                    String keyCode = '';
                    if(!String.isBlank(sinDisPoint.IT_AC_Activity__c) && sinDisPoint.IT_Raw_Number_for_Display__c == null)
                        keyCode = sinDisPoint.IT_AC_Activity__c;
                    else
                        keyCode = sinDisPoint.IT_SF_Activity__c;  
      
                    mapDistributionPoint.put(keyCode, sinDisPoint);
                    mapDistributionPointForNote.put(sinDisPoint.IT_AC_Activity__c, sinDisPoint);
                }
            }
            if(singleSfFC.Groups_Code__r != null && singleSfFC.Groups_Code__r.size() > 0){
                for(IT_Group_Code__c sinGroup : singleSfFC.Groups_Code__r){
                    mapGroupCode.put(sinGroup.IT_Group_Code__c+sinGroup.IT_Group_Type__c+sinGroup.IT_Client_Code__c, sinGroup);
                }
            }
            if(singleSfFC.Bank_Accounts__r != null && singleSfFC.Bank_Accounts__r.size() > 0){
                for(ER_Bank_Account__c sinBankAcc : singleSfFC.Bank_Accounts__r){
                    mapBankAccount.put(sinBankAcc.IT_Client_Code__c+sinBankAcc.ER_IBAN__c, sinBankAcc);  
                }
            }
            if(singleSfFC.Additional_Expenses__r != null && singleSfFC.Additional_Expenses__r.size() > 0){
                for(IT_Additional_Expenses__c sinAddExp : singleSfFC.Additional_Expenses__r){
                    mapAdditionalExpense.put(singleSfFC.IT_Financial_Center__c+sinAddExp.IT_Code__c, sinAddExp);  
                }
            }
            if(singleSfFC.Note__r != null && singleSfFC.Note__r.size() > 0){
                for(IT_Note__c sinNote : singleSfFC.Note__r){
                    mapNote.put(singleSfFC.IT_Financial_Center__c+sinNote.IT_Progressive__c, sinNote); 
                }
            }              
        }

        /**
            * Valuing maps for upsert operations
            * END
        */

        for(ER_Financial_Center singleFinancialCenter : req.ER_Financial_Center){
            /**
                * Manage Address
                * START
            */ 
            for(IT_Address singleAddress : singleFinancialCenter.IT_Address){
                for(IT_AddressType singleAddressType : singleAddress.IT_AddressType){
                    if(singleAddressType.IT_Type == 'F')
                        mapAddress.put(singleFinancialCenter.IT_Client_Code, singleAddress);
                    else if(singleAddressType.IT_Type == 'AT')
                        mapAddress.put(singleAddressType.IT_Activity_AC, singleAddress);
                    else if(singleAddressType.IT_Type == 'C')
                        mapAddress.put(singleAddressType.IT_Delivery_AC, singleAddress);
                } 
            }
            /**
                * Manage Address
                * START
            */  
            Savepoint sp = Database.setSavepoint();
            try{
                /**
                    * Error Control for all objects in single Financial Center
                    * START
                */
                if(!vatAccount.keyset().contains(singleFinancialCenter.IT_VAT_Number)){
                    response responseService = new response(); 
                    responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'VAT number not registered in the system');
                    if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                        mapError.put(singleFinancialCenter.IT_Client_Code, responseService);
                }
                if(String.isblank(singleFinancialCenter.IT_Client_Code)){
                    response responseService = new response(); 
                    responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Upsert Fail, Required Field Missing IT_Client_Code');
                    if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                        mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                }
                if(String.isblank(singleFinancialCenter.IT_Service)){
                    response responseService = new response(); 
                    responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Upsert Fail, Required Field Missing IT_Service');
                    if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                        mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                }
                if(singleFinancialCenter.IT_Contract != null && singleFinancialCenter.IT_Contract.size() > 0){
                    Integer controllProgressive = 0;
                    Contract newContract = new Contract();
                    IT_Contract newContractRequest = new IT_Contract();
                    for(IT_Contract sinWrapper : singleFinancialCenter.IT_Contract){  
                        System.debug('sinWrapper::: '+sinWrapper);     
                        //if(sinWrapper.IT_Contract_Progressive > controllProgressive){
                            newContractRequest = sinWrapper;
                        //}            
                    }
                    if(String.isblank(newContractRequest.IT_Client_Code)){
                        response responseService = new response();
                        responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Client_Code'); 
                        if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                            mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                    }
                    if(String.isblank(newContractRequest.IT_Contract_Number)){
                        response responseService = new response();
                        responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Contract_Number'); 
                        if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                            mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                    }
                    if(newContractRequest.IT_Contract_Progressive == null){
                        response responseService = new response();
                        responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Contract_Progressive'); 
                        if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                            mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                    } 
                }
                if(singleFinancialCenter.IT_Billable_Service != null && singleFinancialCenter.IT_Billable_Service.size() > 0){
                    for(IT_Billable_Service sinWrapperBS : singleFinancialCenter.IT_Billable_Service){ 
                        if(String.isblank(sinWrapperBS.IT_Client_Code)){
                            response responseService = new response();
                            responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Client_Code'); 
                            if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                                mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                        }
                        if(sinWrapperBS.IT_Technical_Data_Progressive == null){
                            response responseService = new response();
                            responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Technical_Data_Progressive'); 
                            if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                                mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                        }
                    }    
                }
                if(singleFinancialCenter.IT_Delivery_Site != null && singleFinancialCenter.IT_Delivery_Site.size() > 0){
                    for(IT_Delivery_Site sinWrapperDS : singleFinancialCenter.IT_Delivery_Site){
                        controlDuplicateDelivery.put(sinWrapperDS.IT_Activity_AC, sinWrapperDS.IT_Delivery_AC); 
                        if(String.isblank(sinWrapperDS.IT_Client_Code)){
                            response responseService = new response();
                            responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Client_Code'); 
                            if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                                mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                        }
                        if(sinWrapperDS.IT_Delivery_AC == null){
                            response responseService = new response();
                            responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Delivery_AC'); 
                            if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                                mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                        }
                        if(sinWrapperDS.IT_Activity_AC == null){
                            response responseService = new response();
                            responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Activity_AC'); 
                            if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                                mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                        }
                    }    
                }
                if(singleFinancialCenter.IT_Distribution_Point != null && singleFinancialCenter.IT_Distribution_Point.size() > 0){
                    for(IT_Distribution_Point sinWrapperDP : singleFinancialCenter.IT_Distribution_Point){ 
                        if(String.isblank(sinWrapperDP.IT_Client_Code)){
                            response responseService = new response();
                            responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Client_Code'); 
                            if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                                mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                        }
                        if(String.isblank(sinWrapperDP.IT_AC_Activity)){
                            response responseService = new response();
                            responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_AC_Activity'); 
                            if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                                mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                        }
                        if(sinWrapperDP.IT_Technical_Data_Progressive == null){
                            response responseService = new response();
                            responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Technical_Data_Progressive'); 
                            if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                                mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                        }
                    }    
                }
                if(singleFinancialCenter.IT_Group != null && singleFinancialCenter.IT_Group.size() > 0){
                    for(IT_Group sinWrapperGroup : singleFinancialCenter.IT_Group){ 
                        if(String.isblank(sinWrapperGroup.IT_Client_Code)){
                            response responseService = new response();
                            responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Client_Code'); 
                            if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                                mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                        }
                        if(String.isblank(sinWrapperGroup.IT_Group_Code)){
                            response responseService = new response();
                            responseService = populateResponseError(singleFinancialCenter.IT_Client_Code, 'Required Field Missing IT_Group_Code'); 
                            if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code))
                                mapError.put(singleFinancialCenter.IT_Client_Code, responseService);  
                        }
                    }    
                }
                /**
                    * Error Control for all objects in single Financial Center
                    * END
                */
                if(!mapError.Keyset().contains(singleFinancialCenter.IT_Client_Code)){
                    /**
                        * Upsert Financial center
                        * START
                    */  
                    ER_Financial_Center__c upsertFinCen = new ER_Financial_Center__c();
                    ER_Financial_Center__c finCenControl = new ER_Financial_Center__c();
                    if(mapFinancialCenterSF.Keyset().contains(singleFinancialCenter.IT_Client_Code)){
                        finCenControl = mapFinancialCenterSF.get(singleFinancialCenter.IT_Client_Code);   
                    }
                    upsertFinCen = populateFinancialCenter(finCenControl, singleFinancialCenter, vatAccount, mapAddress, lookuoProduct2);
                    system.debug('upsertFinCenComplete::: '+upsertFinCen);
                    if(upsertFinCen != null)
                        upsert upsertFinCen;
                    /**
                        * Upsert Financial center
                        * END
                    */
                    response responseService = new response(); 
                    responseService.statusCode = '200'; 
                    responseService.financialCenter_CD = singleFinancialCenter.IT_Client_Code;
                    responseService.sfdc_ID = upsertFinCen.Id;
                    responseService.ErrorDescription = ''; 
                    respList.add(responseService);

                    /**
                        * Upsert Bank Account
                        * START
                    */  
                    ER_Bank_Account__c upsertBankAcc = new ER_Bank_Account__c();
                    upsertBankAcc = populateBankAccount(upsertFinCen, singleFinancialCenter, mapBankAccount, pickListValuesMap, mapAbiCabForBank);
                    system.debug('upsertFinCenComplete::: '+upsertFinCen);
                    if(upsertBankAcc != null && upsertBankAcc != new ER_Bank_Account__c())
                        upsert upsertBankAcc;
                    /**
                        * Upsert FBank Account
                        * END
                    */
                    /**
                        * Upsert Contract
                        * START
                    */
                    List<IT_Contract> fC_Contract = new List<IT_Contract>();
                    fC_Contract = singleFinancialCenter.IT_Contract;
                    List<Contract> fC_ContractUpsert = new List<Contract>();
                    if(fC_Contract != null && fC_Contract.size() > 0){
                        system.debug('fC_Contract::: '+fC_Contract);
                        fC_ContractUpsert = populateContract(upsertFinCen, fC_Contract, mapContactSF, singleFinancialCenter);
                       
                        if(fC_ContractUpsert != null && fC_ContractUpsert.size() > 0){ 
                            system.debug('fC_ContractUpsert::: '+fC_ContractUpsert); 
                            upsert fC_ContractUpsert;
                            populateLookupFCContract(upsertFinCen, fC_ContractUpsert, fC_Contract);
                        }    
                    }else{
                        if(!String.isBlank(singleFinancialCenter.IT_Payment_Code)){
                            system.debug('fC_Contractelse::: '+fC_Contract);
                            system.debug('finCenControl::: '+finCenControl);
                            fC_ContractUpsert = populateContract(finCenControl, null, mapContactSF, singleFinancialCenter); 
                            if(fC_ContractUpsert != null && fC_ContractUpsert.size() > 0){ 
                                system.debug('fC_ContractUpsertelse::: '+fC_ContractUpsert); 
                                update fC_ContractUpsert;
                            }
                        }       
                    }

                    /**
                        * Upsert Contract
                        * END
                    */
                    /**
                        * Upsert ContractLineItem
                        * START
                    */
                    List<IT_Billable_Service> fC_ContractLineItem = new List<IT_Billable_Service>();
                    fC_ContractLineItem = singleFinancialCenter.IT_Billable_Service;
                    List<ER_ContractLineItem__c> fC_ContractLineUpsert = new List<ER_ContractLineItem__c>();

                    if(fC_ContractLineItem != null && fC_ContractLineItem.size() > 0){
                        system.debug('fC_ContractUpsert::: '+fC_ContractUpsert);
                        if(fC_ContractUpsert != null && fC_ContractUpsert.size() > 0) 
                            fC_ContractLineUpsert = populateContractLineItem(upsertFinCen, fC_ContractLineItem, mapContactLineItem, fC_ContractUpsert[0]);
                        else
                            fC_ContractLineUpsert = populateContractLineItem(upsertFinCen, fC_ContractLineItem, mapContactLineItem, null);    
                    }    
                    if(fC_ContractLineUpsert != null && fC_ContractLineUpsert.size() > 0) 
                        upsert fC_ContractLineUpsert;

                    /**
                        * Upsert ContractLineItem
                        * END
                    */
                    /**
                        * Upsert DeliverySite
                        * START
                    */

                    List<IT_Delivery_Site> fC_DeliverySite = new List<IT_Delivery_Site>();
                    fC_DeliverySite = singleFinancialCenter.IT_Delivery_Site;
                    List<ER_Delivery_Site__c> fC_DeliverySiteUpsert = new List<ER_Delivery_Site__c>();
 
                    fC_DeliverySiteUpsert = populateDeliverySite(upsertFinCen, fC_DeliverySite, mapDeliverySite, mapAddress);
                    if(fC_DeliverySiteUpsert != null && fC_DeliverySiteUpsert.size() > 0) 
                        upsert fC_DeliverySiteUpsert;

                    /**
                        * Upsert DeliverySite
                        * END
                    */
                    /**
                        * Upsert Distribution Point
                        * START
                    */

                    List<IT_Distribution_Point> fC_DistributionPoint = new List<IT_Distribution_Point>();
                    fC_DistributionPoint = singleFinancialCenter.IT_Distribution_Point;
                    List<ER_Distribution_Point__c> fC_DistributionPointUpsert = new List<ER_Distribution_Point__c>();
                    System.debug('fC_DeliverySiteUpsert:: '+fC_DeliverySiteUpsert);
                    fC_DistributionPointUpsert = populateDistributionPoint(upsertFinCen, fC_DistributionPoint, mapDistributionPoint, fC_DeliverySiteUpsert, fC_ContractLineUpsert, mapAddress, authorizationUserDistributioPoint, controlDuplicateDelivery);
                    System.debug('fC_DistributionPointUpsert:: '+fC_DistributionPointUpsert);
                    if(fC_DistributionPointUpsert != null && fC_DistributionPointUpsert.size() > 0) 
                        upsert fC_DistributionPointUpsert;
                    /**
                        * Upsert Distribution Point
                        * END
                    */
                    /**
                        * Case management without activities not managed by AC
                        * START
                    */
                    System.debug('fC_DeliverySiteUpsert.size():: '+fC_DeliverySiteUpsert.size());
                    System.debug('fC_DistributionPoint.size():: '+fC_DistributionPoint.size());
                    if(fC_DeliverySiteUpsert != null && fC_DeliverySiteUpsert.size() == 2 && (fC_DistributionPoint == new List<IT_Distribution_Point>() || fC_DistributionPoint.size() == 0)){
                        List<ER_Distribution_Point__c> updateListDistributionP = new List<ER_Distribution_Point__c>();
                        updateListDistributionP = updateDistributionFromDeleivery(fC_DeliverySite, mapDistributionPoint, fC_DeliverySiteUpsert);
                        if(updateListDistributionP != null && updateListDistributionP.size() > 0)
                            update updateListDistributionP; 
                    }
                    /**
                        * Case management without activities not managed by AC
                        * START
                    */
                    /**
                        * Upsert Group
                        * START
                    */

                    List<IT_Group> fC_Group = new List<IT_Group>();
                    fC_Group = singleFinancialCenter.IT_Group;
                    List<IT_Group_Code__c> fC_GroupUpsert = new List<IT_Group_Code__c>();
 
                    fC_GroupUpsert = populateGroup(upsertFinCen, fC_Group, mapGroupCode, mapGroupForCode);
                    if(fC_GroupUpsert != null && fC_GroupUpsert.size() > 0) 
                        upsert fC_GroupUpsert;

                    /**
                        * Upsert Group
                        * END
                    */
                    /**
                        * Upsert Additional Expenses
                        * START
                    */  
                    List<IT_Additional_Expenses> upsertAddExpList = new List<IT_Additional_Expenses>();
                    upsertAddExpList = singleFinancialCenter.IT_Additional_Expenses;
                    List<IT_Additional_Expenses__c> fC_AddExpUpsert = new List<IT_Additional_Expenses__c>();
                    fC_AddExpUpsert = populateAdditionalExpenses(upsertFinCen, upsertAddExpList, mapAdditionalExpense);
                    system.debug('fC_AddExpUpsert::: '+fC_AddExpUpsert);
                    if(fC_AddExpUpsert != null && fC_AddExpUpsert.size() > 0)
                        upsert fC_AddExpUpsert;
                    /**
                        * Upsert Additional Expenses
                        * END
                    */
                    /**
                        * Upsert Notes
                        * START
                    */  
                    List<IT_Note> upsertNoteList = new List<IT_Note>();
                    upsertNoteList = singleFinancialCenter.IT_Note;
                    List<IT_Note__c> fC_NoteUpsert = new List<IT_Note__c>();
                    fC_NoteUpsert = populateNotes(upsertFinCen, upsertNoteList, mapNote, mapDeliverySite, mapDistributionPointForNote);
                    system.debug('fC_NoteUpsert::: '+fC_NoteUpsert);
                    if(fC_NoteUpsert != null && fC_NoteUpsert.size() > 0)
                        upsert fC_NoteUpsert;
                    /**
                        * Upsert Notes
                        * END
                    */
                    if(null != upsertFinCen.Id && null != upsertBankAcc.Id){
                        APIT11_Utilities.pupulateBankAccountLookup(upsertFinCen.Id, upsertBankAcc.Id);
                    }
                }else{
                    response responseServiceErr = new response(); 
                    responseServiceErr = mapError.get(singleFinancialCenter.IT_Client_Code); 
                    respList.add(responseServiceErr);      
                }
            }catch(Exception ecc){
                System.debug('Error WSIT03_ACWS: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                Integer singleResponse = 0;
                while (singleResponse < respList.size()){
                    if(respList.get(singleResponse).financialCenter_CD == singleFinancialCenter.IT_Client_Code){
                        respList.remove(singleResponse);
                    }else{
                        singleResponse++;
                    }
                }
    
                response responseServiceCatch = new response(); 
                responseServiceCatch.statusCode = '400';
                responseServiceCatch.financialCenter_CD = singleFinancialCenter.IT_Client_Code;
                responseServiceCatch.sfdc_ID = '';   
                responseServiceCatch.ErrorDescription = ecc.getMessage();
                respList.add(responseServiceCatch);

                Database.rollback(sp);
            }     
        }

        return respList; 
    }

    private static response populateResponseError(String codeFinCent, String errorField){
        response responseService = new response(); 
        responseService.statusCode = '400'; 
        responseService.financialCenter_CD = codeFinCent;
        responseService.sfdc_ID = '';
        responseService.ErrorDescription = errorField;
        return responseService;
    }

    /**
        * Mapping method for a single object
        * START
    */

    private static ER_Financial_Center__c populateFinancialCenter(ER_Financial_Center__c financialCenterObj, ER_Financial_Center financialCenterRequest, Map<String, Account> mapAccount, Map<String, IT_Address> mapAddressFields, Map<String, Product2> mapProduct2){
        ER_Financial_Center__c upsertFCMethod = new ER_Financial_Center__c();
        ER_Financial_Center__c newFCAddressFuture = new ER_Financial_Center__c();
        ER_Financial_Center__c newFCEconomicFuture = new ER_Financial_Center__c();
        ER_Financial_Center__c newFCFuture = new ER_Financial_Center__c();
        ER_Financial_Center__c newFCComplete = new ER_Financial_Center__c();
        if(financialCenterObj != null){
            upsertFCMethod = new ER_Financial_Center__c(Id = financialCenterObj.Id);

            //FutureChange
            newFCAddressFuture = new ER_Financial_Center__c(Id = financialCenterObj.Id);
            newFCFuture = upsertFCMethod;
            newFCEconomicFuture = new ER_Financial_Center__c(Id = financialCenterObj.Id);
            newFCComplete = new ER_Financial_Center__c(Id = financialCenterObj.Id);
        }

        if(financialCenterRequest.IT_Economic_Validity_Start_Date != null && financialCenterRequest.IT_Economic_Validity_Start_Date == System.today() + 1)
            upsertFCMethod.IT_Future_Change_Economic_Conditions__c = ''; 
        if(financialCenterRequest.IT_Admin_Data_Validity_Start_Date != null && financialCenterRequest.IT_Admin_Data_Validity_Start_Date == System.today() + 1)
            upsertFCMethod.IT_Future_Change_FC__c = '';                   
        
        if(mapProduct2!= null && mapProduct2.size() > 0 && mapProduct2.keyset().contains(financialCenterRequest.IT_Service))
            upsertFCMethod.Name = financialCenterRequest.IT_Client_Code + ' - ' + mapProduct2.get(financialCenterRequest.IT_Service).Name;
        else 
            upsertFCMethod.Name = financialCenterRequest.IT_Client_Code;

        upsertFCMethod.IT_Financial_Center__c = financialCenterRequest.IT_Client_Code;
        upsertFCMethod.ER_Type__c = 'Client';
        upsertFCMethod.ER_Invoicing_Site__c = true; 
        upsertFCMethod.ER_Account_Name__c = mapAccount.get(financialCenterRequest.IT_VAT_Number).Id;
        upsertFCMethod.IT_Service__c = financialCenterRequest.IT_Service;
        upsertFCMethod.IT_Client_Status__c = financialCenterRequest.IT_Client_Status;
        upsertFCMethod.IT_VAT_Number__c = financialCenterRequest.IT_VAT_Number;
        upsertFCMethod.IT_Employee_Number__c = financialCenterRequest.IT_Employee_Number;
        if(financialCenterRequest.IT_Single_Client_Multiactivity != null)
            upsertFCMethod.IT_Single_Client_Multiactivity__c = financialCenterRequest.IT_Single_Client_Multiactivity;
        upsertFCMethod.IT_Client_Situation__c = financialCenterRequest.IT_Client_Situation;
        upsertFCMethod.IT_Opening_Outcome__c = financialCenterRequest.IT_Opening_Outcome;
        upsertFCMethod.IT_Concurrency__c = financialCenterRequest.IT_Concurrency;
        upsertFCMethod.IT_Beneficiary_Type__c = financialCenterRequest.IT_Beneficiary_Type;
        upsertFCMethod.IT_Previous_Code__c = financialCenterRequest.IT_Previous_Code;
        upsertFCMethod.IT_Fused_Client__c = financialCenterRequest.IT_Fused_Client;
        upsertFCMethod.IT_New_Code__c = financialCenterRequest.IT_New_Code;
        upsertFCMethod.IT_Associated_Client__c = financialCenterRequest.IT_Associated_Client;
        upsertFCMethod.IT_Short_name__c = financialCenterRequest.IT_Short_name;
        upsertFCMethod.IT_Extended_Company_Name__c = financialCenterRequest.IT_Extended_Company_Name;
        upsertFCMethod.IT_CIG__c = financialCenterRequest.IT_CIG;
        upsertFCMethod.IT_Derived_CIG__c = financialCenterRequest.IT_Derived_CIG;
        upsertFCMethod.IT_Circuit_Code__c = financialCenterRequest.IT_Circuit_Code;
        upsertFCMethod.IT_Client_Type__c = financialCenterRequest.IT_Client_Type;
        upsertFCMethod.IT_Contact_Code__c = financialCenterRequest.IT_Contact_Code;
        upsertFCMethod.IT_Admin_Data_AC_User__c = financialCenterRequest.IT_Admin_Data_AC_User;
        upsertFCMethod.IT_Admin_Data_Validity_Start_Date__c = financialCenterRequest.IT_Admin_Data_Validity_Start_Date;
        upsertFCMethod.IT_Admin_Data_Validity_End_Date__c = financialCenterRequest.IT_Admin_Data_Validity_End_Date;

        if(!String.isBlank(financialCenterRequest.IT_Payment_Code)){
            newFCEconomicFuture.IT_Special_Billing_Type__c = financialCenterRequest.IT_Special_Billing_Type;
            newFCEconomicFuture.IT_Payment_Term__c = financialCenterRequest.IT_Payment_Code;
            newFCEconomicFuture.IT_Invoice_Detraction__c = financialCenterRequest.IT_Invoice_Detraction;
            System.debug('IT_Company_Name::: '+financialCenterRequest.IT_Client_Code+ ' - ' +financialCenterRequest.IT_Company_Name.length());
            if(!String.isBlank(financialCenterRequest.IT_Company_Name) && financialCenterRequest.IT_Company_Name.length() <= 30){
                newFCEconomicFuture.IT_Billing_Company_Name_R1__c = financialCenterRequest.IT_Company_Name;
            }else if(!String.isBlank(financialCenterRequest.IT_Company_Name) && financialCenterRequest.IT_Company_Name.length() > 30 && financialCenterRequest.IT_Company_Name.length() <= 50){
                newFCEconomicFuture.IT_Billing_Company_Name_R1__c = financialCenterRequest.IT_Company_Name.substring(0, 30);
                newFCEconomicFuture.IT_Billing_Company_Name_R2__c = financialCenterRequest.IT_Company_Name.substring(30, financialCenterRequest.IT_Company_Name.length()); 
            }else if(!String.isBlank(financialCenterRequest.IT_Company_Name) && financialCenterRequest.IT_Company_Name.length() > 50 && financialCenterRequest.IT_Company_Name.length() <= 80){
                newFCEconomicFuture.IT_Billing_Company_Name_R1__c = financialCenterRequest.IT_Company_Name.substring(0, 30);
                newFCEconomicFuture.IT_Billing_Company_Name_R2__c = financialCenterRequest.IT_Company_Name.substring(30, 50);
                newFCEconomicFuture.IT_Billing_Company_Name_R3__c = financialCenterRequest.IT_Company_Name.substring(50, financialCenterRequest.IT_Company_Name.length()); 
            }
            if(!String.isBlank(financialCenterRequest.IT_Send_SUT_Printout) && financialCenterRequest.IT_Send_SUT_Printout == '1')
                newFCEconomicFuture.IT_Send_SUT_Printout__c = true;
            else 
                newFCEconomicFuture.IT_Send_SUT_Printout__c = false; 
            if(!String.isBlank(financialCenterRequest.IT_Accepts_New_Billing_System_PA) && financialCenterRequest.IT_Accepts_New_Billing_System_PA == '1')
                newFCEconomicFuture.IT_Accepts_New_Billing_System_PA__c = true;
            else 
                newFCEconomicFuture.IT_Accepts_New_Billing_System_PA__c = false;

            newFCEconomicFuture.IT_Office_Code__c = financialCenterRequest.IT_Office_Code;
            newFCEconomicFuture.IT_CUP_Code__c = financialCenterRequest.IT_CUP_Code;
            newFCEconomicFuture.IT_Order_Code__c = financialCenterRequest.IT_Order_Code;
            newFCEconomicFuture.IT_EORI_Code__c = financialCenterRequest.IT_EORI_Code;
            if(!String.isBlank(financialCenterRequest.IT_Accepts_New_Billing_System) && financialCenterRequest.IT_Accepts_New_Billing_System == '1')
                newFCEconomicFuture.IT_Accepts_New_Billing_System__c = true;
            else
                newFCEconomicFuture.IT_Accepts_New_Billing_System__c = false;      
            newFCEconomicFuture.IT_SDI__c = financialCenterRequest.IT_SDI;
            newFCEconomicFuture.IT_PEC_Mail__c = financialCenterRequest.IT_PEC_Mail;
            if(!String.isBlank(financialCenterRequest.IT_Dont_Send_Debt_Note) && financialCenterRequest.IT_Dont_Send_Debt_Note == '1')
                newFCEconomicFuture.IT_Don_t_Send_Debt_Note__c = true;
            else 
                newFCEconomicFuture.IT_Don_t_Send_Debt_Note__c = false;
                    
            newFCEconomicFuture.IT_Particularities_Progressive_Number__c = financialCenterRequest.IT_Particularities_Progressive_Number;
            newFCEconomicFuture.IT_Contractual_Particularities__c = financialCenterRequest.IT_Contractual_Particularities;
            newFCEconomicFuture.IT_Economic_AC_User__c = financialCenterRequest.IT_Economic_AC_User;
            if(financialCenterRequest.IT_Economic_Validity_Start_Date != null)
                newFCEconomicFuture.IT_Economic_Validity_Start_Date__c = financialCenterRequest.IT_Economic_Validity_Start_Date;
            if(financialCenterRequest.IT_Economic_Validity_End_Date != null)
                newFCEconomicFuture.IT_Economic_Validity_End_Date__c = financialCenterRequest.IT_Economic_Validity_End_Date;

            if(mapProduct2!= null && mapProduct2.size() > 0 && mapProduct2.keyset().contains(financialCenterRequest.IT_Service))
                newFCEconomicFuture.IT_Product2__c = mapProduct2.get(financialCenterRequest.IT_Service).Id; 
        }               

        if(mapAddressFields != null && mapAddressFields.keyset().contains(financialCenterRequest.IT_Client_Code)){
            IT_Address newAddress = mapAddressFields.get(financialCenterRequest.IT_Client_Code);
            newFCAddressFuture.IT_Province__c = newAddress.IT_Province;
            newFCAddressFuture.IT_Toponym__c = newAddress.IT_Toponym;
            newFCAddressFuture.ER_Street__c = newAddress.IT_Street + ', ' + newAddress.IT_Street_Number; 
            newFCAddressFuture.IT_Short_Address__c = newAddress.IT_Short_Address;
            newFCAddressFuture.ER_Zip_Code__c = newAddress.IT_Postal_Code;
            newFCAddressFuture.ER_City__c = newAddress.IT_City;
            newFCAddressFuture.IT_Hamlet__c = newAddress.IT_Hamlet;
            newFCAddressFuture.IT_Additional_Locality__c = newAddress.IT_Additional_Locality;
            newFCAddressFuture.IT_State_Code__c = newAddress.IT_State_Code;
            newFCAddressFuture.IT_City_Code__c = newAddress.IT_City_Code;
            newFCAddressFuture.IT_Hamlet_Code__c = newAddress.IT_Hamlet_Code;
            newFCAddressFuture.IT_Sestiere_Code__c = newAddress.IT_Sestiere_Code;
            newFCAddressFuture.IT_Street_Code__c = newAddress.IT_Street_Code;
            newFCAddressFuture.IT_Road_Arch_Code__c = newAddress.IT_Road_Arch_Code;
            newFCAddressFuture.IT_MetRef_Loc_X__c = newAddress.IT_MetRef_Loc_X;
            newFCAddressFuture.IT_MetRef_Loc_Y__c = newAddress.IT_MetRef_Loc_Y;
            newFCAddressFuture.IT_GeoRef_Loc_X__c = newAddress.IT_GeoRef_Loc_X;
            newFCAddressFuture.IT_GeoRef_Loc_Y__c = newAddress.IT_GeoRef_Loc_Y;
            newFCAddressFuture.IT_Extra_Urban_Specifications__c = newAddress.IT_Extra_Urban_Specifications;
            newFCAddressFuture.IT_Ticket_Naming__c = newAddress.IT_Ticket_Naming;
            newFCAddressFuture.IT_Address_Validity_Start_Date__c = newAddress.IT_Validity_Start_Date;
            newFCAddressFuture.IT_Address_Validity_End_Date__c = newAddress.IT_Validity_End_Date;
            newFCAddressFuture.IT_Address_AC_User__c = newAddress.IT_AC_User;

            if(newAddress.IT_Validity_Start_Date != null && newAddress.IT_Validity_Start_Date == System.today() + 1)
                newFCAddressFuture.IT_Future_Change_Address__c = ''; 

        }

        //AD - Continue 17/09/2019
        if(!String.isBlank(newFCEconomicFuture.Id) && newFCEconomicFuture.IT_Economic_Validity_Start_Date__c != null && newFCEconomicFuture.IT_Economic_Validity_Start_Date__c > System.today() + 1){
            Map<Id, SObject> newMapFC = new Map<Id, SObject>();
            SObject newFinancialCenter = (SObject) newFCEconomicFuture;
            newMapFC.put(newFCEconomicFuture.Id, newFinancialCenter);
            newFinancialCenter = APIT11_Utilities.FutureChange(newMapFC, 'ER_Financial_Center__c', 'IT_Future_Change_Economic_Conditions__c');
            ER_Financial_Center__c newUpdate = new ER_Financial_Center__c();
            newUpdate = (ER_Financial_Center__c) newFinancialCenter;
            newFCComplete.IT_Future_Change_Economic_Conditions__c = newUpdate.IT_Future_Change_Economic_Conditions__c;
        }
        if(!String.isBlank(upsertFCMethod.Id) && upsertFCMethod.IT_Admin_Data_Validity_Start_Date__c != null && upsertFCMethod.IT_Admin_Data_Validity_Start_Date__c > System.today() + 1){
            Map<Id, SObject> newMapFC = new Map<Id, SObject>();
            SObject newFinancialCenter = (SObject) upsertFCMethod;
            newMapFC.put(upsertFCMethod.Id, newFinancialCenter);
            newFinancialCenter = APIT11_Utilities.FutureChange(newMapFC, 'ER_Financial_Center__c', 'IT_Future_Change_FC__c');
            ER_Financial_Center__c newUpdate = new ER_Financial_Center__c();
            newUpdate = (ER_Financial_Center__c) newFinancialCenter;
            newFCComplete.IT_Future_Change_FC__c = newUpdate.IT_Future_Change_FC__c;
        }
        if(!String.isBlank(newFCAddressFuture.Id) && newFCAddressFuture.IT_Address_Validity_Start_Date__c != null && newFCAddressFuture.IT_Address_Validity_Start_Date__c > System.today() + 1){
            Map<Id, SObject> newMapFC = new Map<Id, SObject>();
            SObject newFinancialCenter = (SObject) newFCAddressFuture;
            newMapFC.put(newFCAddressFuture.Id, newFinancialCenter);
            newFinancialCenter = APIT11_Utilities.FutureChange(newMapFC, 'ER_Financial_Center__c', 'IT_Future_Change_Address__c');
            ER_Financial_Center__c newUpdate = new ER_Financial_Center__c();
            newUpdate = (ER_Financial_Center__c) newFinancialCenter;
            newFCComplete.IT_Future_Change_Address__c = newUpdate.IT_Future_Change_Address__c;
        }

        System.debug('newFCComplete.IT_Future_Change_Address__c::: '+newFCComplete.IT_Future_Change_Address__c);
        System.debug('newFCComplete.IT_Future_Change_FC__c::: '+newFCComplete.IT_Future_Change_FC__c);
        System.debug('newFCComplete.IT_Future_Change_Economic_Conditions__c::: '+newFCComplete.IT_Future_Change_Economic_Conditions__c);    

        if(String.isBlank(newFCComplete.IT_Future_Change_Address__c) && String.isBlank(newFCComplete.IT_Future_Change_FC__c) && String.isBlank(newFCComplete.IT_Future_Change_Economic_Conditions__c)){
            for(SObjectField field:upsertFCMethod.getSObjectType().getDescribe().fields.getMap().values()) {
                try {
                    Object FC1Field = upsertFCMethod.get(field);
                    Object FC2Field = newFCEconomicFuture.get(field);
                    Object FC3Field = newFCAddressFuture.get(field);
                    if (FC2Field != null)
                        upsertFCMethod.put(field, FC2Field);   
                    if (FC3Field != null)
                        upsertFCMethod.put(field, FC3Field);      
                        
                }catch (SObjectException ecc) {
                    System.debug('populateFCMerge: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                }
            }
        }else if(String.isBlank(newFCComplete.IT_Future_Change_Address__c) && String.isBlank(newFCComplete.IT_Future_Change_FC__c) && !String.isBlank(newFCComplete.IT_Future_Change_Economic_Conditions__c)){
            upsertFCMethod.IT_Future_Change_Economic_Conditions__c = newFCComplete.IT_Future_Change_Economic_Conditions__c;
            for(SObjectField field:upsertFCMethod.getSObjectType().getDescribe().fields.getMap().values()) {
                try {
                    Object FC1Field = upsertFCMethod.get(field);
                    Object FC2Field = newFCEconomicFuture.get(field);
                    Object FC3Field = newFCAddressFuture.get(field);  
                    if (FC3Field != null)
                        upsertFCMethod.put(field, FC3Field);     
                        
                }catch (SObjectException ecc) {
                    System.debug('populateFCMerge: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                }
            }    
        }else if(!String.isBlank(newFCComplete.IT_Future_Change_Address__c) && String.isBlank(newFCComplete.IT_Future_Change_FC__c) && String.isBlank(newFCComplete.IT_Future_Change_Economic_Conditions__c)){
            upsertFCMethod.IT_Future_Change_Address__c = newFCComplete.IT_Future_Change_Address__c;
            for(SObjectField field:upsertFCMethod.getSObjectType().getDescribe().fields.getMap().values()) {
                try {
                    Object FC1Field = upsertFCMethod.get(field);
                    Object FC2Field = newFCEconomicFuture.get(field);
                    Object FC3Field = newFCAddressFuture.get(field);  
                    if (FC2Field != null)
                        upsertFCMethod.put(field, FC2Field);     
                        
                }catch (SObjectException ecc) {
                    System.debug('populateFCMerge: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                }
            }    
        }else if(String.isBlank(newFCComplete.IT_Future_Change_Address__c) && !String.isBlank(newFCComplete.IT_Future_Change_FC__c) && String.isBlank(newFCComplete.IT_Future_Change_Economic_Conditions__c)){
            for(SObjectField field:upsertFCMethod.getSObjectType().getDescribe().fields.getMap().values()) {
                try {
                    Object FC1Field = upsertFCMethod.get(field);
                    Object FC2Field = newFCEconomicFuture.get(field);
                    Object FC3Field = newFCAddressFuture.get(field);  
                    if (FC1Field != null)
                        newFCEconomicFuture.put(field, FC1Field);
                    
                    newFCEconomicFuture.ER_Account_Name__c = upsertFCMethod.ER_Account_Name__c;
                    upsertFCMethod = newFCEconomicFuture;
                    upsertFCMethod.IT_Future_Change_FC__c = newFCComplete.IT_Future_Change_FC__c;
                        
                }catch (SObjectException ecc) {
                    System.debug('populateFCMerge: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                }
            }    
        }else if(!String.isBlank(newFCComplete.IT_Future_Change_Address__c) && String.isBlank(newFCComplete.IT_Future_Change_FC__c) && !String.isBlank(newFCComplete.IT_Future_Change_Economic_Conditions__c)){
            upsertFCMethod.IT_Future_Change_Address__c = newFCComplete.IT_Future_Change_Address__c;
            upsertFCMethod.IT_Future_Change_Economic_Conditions__c = newFCComplete.IT_Future_Change_Address__c;               
        }else if(!String.isBlank(newFCComplete.IT_Future_Change_Address__c) && !String.isBlank(newFCComplete.IT_Future_Change_FC__c) && String.isBlank(newFCComplete.IT_Future_Change_Economic_Conditions__c)){
            newFCEconomicFuture.ER_Account_Name__c = upsertFCMethod.ER_Account_Name__c;
            upsertFCMethod = newFCEconomicFuture;
            upsertFCMethod.IT_Future_Change_FC__c = newFCComplete.IT_Future_Change_FC__c;
            upsertFCMethod.IT_Future_Change_Address__c = newFCComplete.IT_Future_Change_Address__c;            
        }else if(String.isBlank(newFCComplete.IT_Future_Change_Address__c) && !String.isBlank(newFCComplete.IT_Future_Change_FC__c) && !String.isBlank(newFCComplete.IT_Future_Change_Economic_Conditions__c)){
            newFCAddressFuture.ER_Account_Name__c = upsertFCMethod.ER_Account_Name__c;
            upsertFCMethod = newFCAddressFuture;
            upsertFCMethod.IT_Future_Change_FC__c = newFCComplete.IT_Future_Change_FC__c;
            upsertFCMethod.IT_Future_Change_Economic_Conditions__c = newFCComplete.IT_Future_Change_Economic_Conditions__c;            
        }else{
            newFCComplete.ER_Account_Name__c = upsertFCMethod.ER_Account_Name__c;
            upsertFCMethod = newFCComplete;   
        }    
            
        return upsertFCMethod;
    }

    private static ER_Bank_Account__c populateBankAccount(ER_Financial_Center__c financialCenterObj, ER_Financial_Center financialCenterRequest, Map<String, ER_Bank_Account__c> mapBankAccount, Map<String, String> pickListMap, Map<String, IT_Abi_Cab__c> mapCabAbi){
        ER_Bank_Account__c upsertBankAccountMethod = new ER_Bank_Account__c();
        ER_Bank_Account__c newFutureComplete = new ER_Bank_Account__c();
        ER_Bank_Account__c newBAFuture = new ER_Bank_Account__c();

        if(!String.isBlank(financialCenterRequest.IT_Payment_Code)){
            System.debug('FIRSTfinancialCenterObj.Id::: '+financialCenterObj.Id);
            if(mapBankAccount != null && mapBankAccount.size() > 0 && mapBankAccount.keyset().contains(financialCenterRequest.IT_Client_Code+financialCenterRequest.IT_IBAN)){
                upsertBankAccountMethod = new ER_Bank_Account__c(Id = mapBankAccount.get(financialCenterRequest.IT_Client_Code+financialCenterRequest.IT_IBAN).Id);
                newFutureComplete = new ER_Bank_Account__c(Id = mapBankAccount.get(financialCenterRequest.IT_Client_Code+financialCenterRequest.IT_IBAN).Id);
            }

            if(pickListMap != null && pickListMap.size() > 0 && pickListMap.Keyset().contains(financialCenterRequest.IT_Bank_Account_Code))
                upsertBankAccountMethod.Name = pickListMap.get(financialCenterRequest.IT_Bank_Account_Code);
            else if(mapCabAbi != null && mapCabAbi.size() > 0 && mapCabAbi.keyset().contains(financialCenterRequest.IT_ABI+financialCenterRequest.IT_CAB))
                upsertBankAccountMethod.Name = mapCabAbi.get(financialCenterRequest.IT_ABI+financialCenterRequest.IT_CAB).IT_Bank__c;
            else 
                upsertBankAccountMethod.Name = 'N.D.';         
            upsertBankAccountMethod.IT_Client_Code__c = financialCenterRequest.IT_Client_Code;
            upsertBankAccountMethod.IT_Payment_Code__c = financialCenterRequest.IT_Payment_Code;
            upsertBankAccountMethod.IT_SDD_Payment_Code__c = financialCenterRequest.IT_SDD_Payment_Code;
            upsertBankAccountMethod.IT_Bank_Account_Code__c = financialCenterRequest.IT_Bank_Account_Code;
            upsertBankAccountMethod.IT_ABI__c = financialCenterRequest.IT_ABI;
            upsertBankAccountMethod.IT_CAB__c = financialCenterRequest.IT_CAB;
            upsertBankAccountMethod.IT_CC__c = financialCenterRequest.IT_CC;
            upsertBankAccountMethod.IT_CIN__c = financialCenterRequest.IT_CIN;
            upsertBankAccountMethod.ER_Country__c = financialCenterRequest.IT_Country;
            upsertBankAccountMethod.ER_IBAN__c = financialCenterRequest.IT_IBAN;
            upsertBankAccountMethod.IT_Check_Iban__c = financialCenterRequest.IT_Check_Iban;
            upsertBankAccountMethod.IT_SDD_Contract_Code__c = financialCenterRequest.IT_SDD_Contract_Code;
            upsertBankAccountMethod.IT_SDD_Subscription_Date__c = financialCenterRequest.IT_SDD_Subscription_Date;
            upsertBankAccountMethod.IT_SDD_Fiscal_Code__c = financialCenterRequest.IT_SDD_Fiscal_Code;
            upsertBankAccountMethod.IT_SDD_Authorized__c = financialCenterRequest.IT_Authorized;  
            upsertBankAccountMethod.IT_Economic_AC_User__c = financialCenterRequest.IT_Economic_AC_User; 
            if(financialCenterRequest.IT_Economic_Validity_Start_Date != null)
                upsertBankAccountMethod.IT_Economic_Validity_Start_Date__c = financialCenterRequest.IT_Economic_Validity_Start_Date;
            if(financialCenterRequest.IT_Economic_Validity_End_Date != null)
                upsertBankAccountMethod.IT_Economic_Validity_End_Date__c = financialCenterRequest.IT_Economic_Validity_End_Date;

            System.debug('financialCenterObj.Id::: '+financialCenterObj.Id);               
            upsertBankAccountMethod.ER_Financial_Center__c = financialCenterObj.Id;

            // Change Future
            if(!String.isBlank(upsertBankAccountMethod.Id) && financialCenterRequest.IT_Economic_Validity_Start_Date != null && financialCenterRequest.IT_Economic_Validity_Start_Date > System.today() + 1){
                Map<Id, SObject> newMapDS = new Map<Id, SObject>();
                SObject updateBankAccount = (SObject) upsertBankAccountMethod;
                newMapDS.put(upsertBankAccountMethod.Id, updateBankAccount);
                updateBankAccount = APIT11_Utilities.FutureChange(newMapDS, 'ER_Bank_Account__c', 'IT_Future_Change_Bank_Account__c');
                newBAFuture = new ER_Bank_Account__c();
                newBAFuture = (ER_Bank_Account__c) updateBankAccount;
                upsertBankAccountMethod = new ER_Bank_Account__c();
                upsertBankAccountMethod.IT_Future_Change_Bank_Account__c = newBAFuture.IT_Future_Change_Bank_Account__c;
            } 
            if(!String.isBlank(upsertBankAccountMethod.IT_Future_Change_Bank_Account__c)){
                newFutureComplete.IT_Future_Change_Bank_Account__c = upsertBankAccountMethod.IT_Future_Change_Bank_Account__c;
                upsertBankAccountMethod = newFutureComplete;
            }else{
                upsertBankAccountMethod = upsertBankAccountMethod;    
            }

        }    

        return upsertBankAccountMethod;
    } 

    private static List<Contract> populateContract(ER_Financial_Center__c financialCenterObj, List<IT_Contract> contractRequest, Map<String, Contract> mapContractSF, ER_Financial_Center fcReq){
        List<Contract> upsertContractMethod = new List<Contract>();
        System.debug('contractRequest:: '+contractRequest);
        Integer controllProgressive = 0;
        Contract newContract = new Contract();
        Contract newContractRequestChange = new Contract();
        Contract newContractEconomicFuture = new Contract();
        Contract newContractFuture = new Contract();
        Contract newcontractComplete = new Contract();
        if(contractRequest != null && contractRequest.size() > 0){
            for(IT_Contract singleContract : contractRequest){
                IT_Contract newContractRequest = new IT_Contract();
                newContract = new Contract();
                newContractRequest = singleContract;   
            
                if(mapContractSF != null && mapContractSF.size() > 0 && mapContractSF.Keyset().contains(newContractRequest.IT_Client_Code+newContractRequest.IT_Contract_Number+newContractRequest.IT_Contract_Progressive))
                    newContract = new Contract(Id = mapContractSF.get(newContractRequest.IT_Client_Code+newContractRequest.IT_Contract_Number+newContractRequest.IT_Contract_Progressive).Id);
                
                if(!String.isBlank(newContract.Id)){
                    if(singleContract.EndDate == null){
                        newContractEconomicFuture = new Contract(Id = newContract.Id);
                        newContractFuture = newContract;
                        newcontractComplete = new Contract(Id = newContract.Id);
                    }    
                }

                if(fcReq.IT_Economic_Validity_Start_Date != null && fcReq.IT_Economic_Validity_Start_Date == System.today() + 1)
                    newContract.IT_Future_Change_Economic_Conditions__c = ''; 
                if(singleContract.StartDate != null && singleContract.StartDate == System.today() + 1)
                    newContract.IT_Future_Change_Contract__c = '';

                newContract.AccountId = financialCenterObj.ER_Account_Name__c;
                newContract.IT_Financial_Center__c = financialCenterObj.Id;
                newContract.IT_Contract_Number__c = newContractRequest.IT_Contract_Number;
                if(newContractRequest.IT_Contract_Progressive != null)
                    newContract.IT_Contract_Progressive__c = String.valueOf(newContractRequest.IT_Contract_Progressive);
                newContract.IT_Opportunity_Code__c = newContractRequest.IT_Opportunity_Code;
                newContract.IT_Client_Code__c = newContractRequest.IT_Client_Code;
                newContract.IT_Attendance_Type__c = newContractRequest.IT_Attendance_Type;
                newContract.IT_Contract_Renewal_Type__c = newContractRequest.IT_Contract_Renewal_Type;
                newContract.IT_Contract_Type__c = newContractRequest.IT_Contract_Type;
                newContract.IT_Contract_Status__c = newContractRequest.IT_Contract_Status;
                if(newContractRequest.StartDate != null)
                    newContract.StartDate = newContractRequest.StartDate;
                if(newContractRequest.EndDate != null)    
                    newContract.EndDate = newContractRequest.EndDate;
                if(newContractRequest.IT_Sign_Sending_Date != null)    
                    newContract.IT_Sign_Sending_Date__c = newContractRequest.IT_Sign_Sending_Date;
                if(newContractRequest.IT_Contract_Sign_Date != null)    
                    newContract.IT_Contract_Sign_Date__c = newContractRequest.IT_Contract_Sign_Date;
                if(newContractRequest.IT_Expiration_Contract_Date != null)    
                    newContract.IT_Expiration_Contract_Date__c = newContractRequest.IT_Expiration_Contract_Date;
                newContract.IT_Contract_Closing_Type__c = newContractRequest.IT_Contract_Closing_Type;
                if(!String.isBlank(newContractRequest.IT_Penal_Presence) && newContractRequest.IT_Penal_Presence == '1')
                    newContract.IT_Penal_Presence__c = true;
                else
                    newContract.IT_Penal_Presence__c = false;  
                newContract.IT_Delivery_Date_Bond__c = newContractRequest.IT_Delivery_Date_Bond;
                newContract.IT_Delivery_Term__c = newContractRequest.IT_Delivery_Term;
                newContract.IT_Term_Type__c = newContractRequest.IT_Term_Type;
                newContract.IT_Delivery_Fixed_Day__c = newContractRequest.IT_Delivery_Fixed_Day;
                newContract.IT_Fixed_Day_Type__c = newContractRequest.IT_Fixed_Day_Type;
                newContract.IT_Order_Reception_Term__c = newContractRequest.IT_Order_Reception_Term;
                newContract.IT_Order_Reception_Term_Type__c = newContractRequest.IT_Order_Reception_Term_Type;
                if(!String.isBlank(newContractRequest.IT_No_Sign_Activation_Authorization) && newContractRequest.IT_No_Sign_Activation_Authorization == '1')
                    newContract.IT_No_Sign_Activation_Authorization__c = true;
                else    
                    newContract.IT_No_Sign_Activation_Authorization__c = false;
                newContract.IT_Reception_Type__c = newContractRequest.IT_Reception_Type;
                if(!String.isBlank(newContractRequest.IT_No_Massive_Print) && newContractRequest.IT_No_Massive_Print == '1')
                    newContract.IT_No_Massive_Print__c = true;
                else    
                    newContract.IT_No_Massive_Print__c = false;
                if(!String.isBlank(newContractRequest.IT_Date_presence) && newContractRequest.IT_Date_presence == '1')    
                    newContract.IT_Date_presence__c = true;
                else    
                    newContract.IT_Date_presence__c = false;
                if(!String.isBlank(newContractRequest.IT_No_Date_Presence) && newContractRequest.IT_No_Date_Presence == '1') 
                    newContract.IT_No_Date_Presence__c = true;
                else    
                    newContract.IT_No_Date_Presence__c = false;
                if(!String.isBlank(newContractRequest.IT_SDD_Payment) && newContractRequest.IT_SDD_Payment == '1') 
                    newContract.IT_SDD_Payment__c = true;
                else    
                    newContract.IT_SDD_Payment__c = false;
                if(!String.isBlank(newContractRequest.IT_Multidiscount) && newContractRequest.IT_Multidiscount == '1') 
                    newContract.IT_Multidiscount__c = true;
                else    
                    newContract.IT_Multidiscount__c = false; 
                if(!String.isBlank(newContractRequest.IT_Extradiscount) && newContractRequest.IT_Extradiscount == '1') 
                    newContract.IT_Extradiscount__c = true;
                else    
                    newContract.IT_Extradiscount__c = false;
                if(!String.isBlank(newContractRequest.IT_No_Exclusivity) && newContractRequest.IT_No_Exclusivity == '1') 
                    newContract.IT_No_Exclusivity__c = true;
                else    
                    newContract.IT_No_Exclusivity__c = false;
                newContract.IT_Annual_Potential__c = newContractRequest.IT_Annual_Potential;   
                newContract.IT_Renewal_Reason__c = newContractRequest.IT_Renewal_Reason;
                if(!String.isBlank(newContractRequest.IT_Accepts_Privacy) && newContractRequest.IT_Accepts_Privacy == '1') 
                    newContract.IT_Accepts_Privacy__c = true;
                else    
                    newContract.IT_Accepts_Privacy__c = false;
                newContract.IT_Framework_Head_Code__c = newContractRequest.IT_Framework_Head_Code;
                if(!String.isBlank(newContractRequest.IT_Framework_Warrant) && newContractRequest.IT_Framework_Warrant == '1') 
                    newContract.IT_Framework_Warrant__c = true;
                else    
                    newContract.IT_Framework_Warrant__c = false;
                if(!String.isBlank(newContractRequest.IT_Only_Client_Copy) && newContractRequest.IT_Only_Client_Copy == '1')     
                    newContract.IT_Only_Client_Copy__c = true;
                else    
                    newContract.IT_Only_Client_Copy__c = false;
                if(!String.isBlank(newContractRequest.IT_Supply_Conditions) && newContractRequest.IT_Supply_Conditions == '1')     
                    newContract.IT_Supply_Conditions__c = true;
                else    
                    newContract.IT_Supply_Conditions__c = false; 
                if(newContractRequest.IT_Campaign_Start_Date != null)
                    newContract.IT_Campaign_Start_Date__c = newContractRequest.IT_Campaign_Start_Date;
                if(newContractRequest.IT_Campaing_End_Date != null)    
                    newContract.IT_Campaign_End_Date__c = newContractRequest.IT_Campaing_End_Date;
                if(!String.isBlank(newContractRequest.IT_Card_Cost))
                    newContract.IT_Card_Cost__c = Decimal.valueOf(newContractRequest.IT_Card_Cost);
                newContract.IT_Card_Cost_Billing_Type__c = newContractRequest.IT_Card_Cost_Billing_Type;
                newContract.IT_Card_Cost_Billing_Frequency__c = newContractRequest.IT_Card_Cost_Billing_Frequency;
                newContract.IT_Card_Cost_Billing_Rules__c = newContractRequest.IT_Card_Cost_Billing_Rules;
                newContract.IT_UTA_Monthly_Limit__c = newContractRequest.IT_UTA_Monthly_Limit;
                newContract.IT_UTA_Offer_Type__c = newContractRequest.IT_UTA_Offer_Type;
                newContract.IT_UTA_Vehicles_Number__c = newContractRequest.IT_UTA_Vehicles_Number;
                newContract.IT_AC_User__c = newContractRequest.IT_AC_User;

                System.debug('newContract.EndDate::: '+newContract.EndDate);

                if(newContract.EndDate == null && contractRequest.size() == 2){
                    newContractRequestChange = newContract;
                }
                if(newContract.EndDate != null && contractRequest.size() == 2){
                    upsertContractMethod.add(newContract);
                    System.debug('upsertContractMethod::: '+upsertContractMethod);
                }    

            }
            if(contractRequest.size() == 2) 
                newContract = newContractRequestChange;   

        }else{
            System.debug('financialCenterObj.IT_Contract__c::: '+financialCenterObj.IT_Contract__c);
            if(financialCenterObj != null && financialCenterObj != new ER_Financial_Center__c() && !String.isBlank(financialCenterObj.IT_Contract__c)){
                newContractEconomicFuture = new Contract(Id = financialCenterObj.IT_Contract__c);
                //newContract = new Contract(Id = financialCenterObj.IT_Contract__c);
                //newContractFuture = newContract;
                //newcontractComplete = new Contract(Id = financialCenterObj.IT_Contract__c);
            }    
            newContractEconomicFuture.AccountId = financialCenterObj.ER_Account_Name__c;
            newContractEconomicFuture.IT_AC_User__c = fcReq.IT_Admin_Data_AC_User;    
        }

        if(!String.isBlank(fcReq.IT_Payment_code) && newContractEconomicFuture.EndDate == null){
            System.debug('fcReq.IT_Payment_code::: '+fcReq.IT_Payment_code);
            System.debug('newContractEconomicFuture.EndDate::: '+newContractEconomicFuture.EndDate);

            newContractEconomicFuture.IT_Commission_Type__c = fcReq.IT_Commission_Type;
            newContractEconomicFuture.IT_Commission_Percentage__c = fcReq.IT_Commission_Percentage;
            newContractEconomicFuture.IT_Discount_Type__c = fcReq.IT_Discount_Type;
            newContractEconomicFuture.IT_Discount_Percentage__c = fcReq.IT_Discount_Percentage;
            newContractEconomicFuture.IT_Fine_Interest_Type__c = fcReq.IT_Fine_Interest_Type;
            newContractEconomicFuture.IT_Not_Standard_VAT__c = fcReq.IT_Not_Standard_VAT;
            newContractEconomicFuture.IT_Transport_Cost__c = fcReq.IT_Transport_Cost;
            newContractEconomicFuture.IT_No_Cost_Reason__c = fcReq.IT_No_Cost_Reason;
            newContractEconomicFuture.IT_Promo_Code__c = fcReq.IT_Promo_Code;
            newContractEconomicFuture.IT_Invoice_Detail__c = fcReq.IT_Invoice_Detail;
            newContractEconomicFuture.IT_Debt_Notes__c = fcReq.IT_Debt_Notes;
            if(fcReq.IT_Debt_Notes_Effective_Date != null)
                newContractEconomicFuture.IT_Debt_Notes_Effective_Date__c = fcReq.IT_Debt_Notes_Effective_Date;
            newContractEconomicFuture.IT_Debt_Notes_Percentage__c = fcReq.IT_Debt_Notes_Percentage;
            newContractEconomicFuture.IT_Debt_Notes_Locale_Type__c = fcReq.IT_Debt_Notes_Locale_Type;
            newContractEconomicFuture.IT_Expendia_Startup_Cost__c = fcReq.IT_Expendia_Startup_Cost;
            newContractEconomicFuture.IT_Number_of_Expendia_cards__c = fcReq.IT_Number_of_Expendia_cards;
            newContractEconomicFuture.IT_Expendia_Monthly_Fee__c = fcReq.IT_Expendia_Monthly_Fee;
            newContractEconomicFuture.IT_Expendia_Card_Amount__c = fcReq.IT_Card_Amount;
            newContractEconomicFuture.IT_Flexben_Startup_Cost__c = fcReq.IT_Flexben_Startup_Cost;
            if(fcReq.IT_Flexben_Startup_Date != null)
                newContractEconomicFuture.IT_Flexben_Startup_Date__c = fcReq.IT_Flexben_Startup_Date;
            newContractEconomicFuture.IT_Flexben_Fee_Cost__c = fcReq.IT_Flexben_Fee_Cost;
            if(fcReq.IT_Flexben_Fee_Date != null)
                newContractEconomicFuture.IT_Flexben_Start_Fee_Date__c = fcReq.IT_Flexben_Fee_Date;
            newContractEconomicFuture.IT_Flexben_Fee_Frequency__c = fcReq.IT_Flexben_Fee_Frequency;
            newContractEconomicFuture.IT_Payment_Code__c = fcReq.IT_Payment_Code;
            if(fcReq.IT_Economic_Validity_Start_Date != null)
                newContractEconomicFuture.IT_Validity_Start_Date_EC__c = fcReq.IT_Economic_Validity_Start_Date;
            if(fcReq.IT_Economic_Validity_End_Date != null)    
                newContractEconomicFuture.IT_Validity_End_Date_EC__c = fcReq.IT_Economic_Validity_End_Date;

            newContractEconomicFuture.IT_Billing_Frequency_UTA__c = fcReq.IT_Billing_Frequency_UTA;
            newContractEconomicFuture.IT_Bond_UTA__c = fcReq.IT_Bond_UTA;

            //UserCheck 16012020
            newContractEconomicFuture.IT_Discount_Percentage_2__c = fcReq.IT_Discount_Percentage_2; 
            newContractEconomicFuture.IT_Discount_Percentage_3__c = fcReq.IT_Discount_Percentage_3;
            if(fcReq.IT_Discount_Validity_Date_2 != null)  
                newContractEconomicFuture.IT_Discount_Validity_Date_2__c = fcReq.IT_Discount_Validity_Date_2;
             if(fcReq.IT_Discount_Validity_Date_3 != null)  
                newContractEconomicFuture.IT_Discount_Validity_Date_3__c = fcReq.IT_Discount_Validity_Date_3;
            newContractEconomicFuture.IT_Extradiscount_Percentage__c = fcReq.IT_Extradiscount_Percentage;
            newContractEconomicFuture.IT_Type_Extradiscount__c = fcReq.IT_Type_Extradiscount;
        }    

        if(null != newContract && newContract != new Contract() && !String.isBlank(newContract.Id) && newContract.StartDate != null && newContract.StartDate > System.today() + 1){
            System.debug('IF_1');
            Map<Id, SObject> newMapDS = new Map<Id, SObject>();
            SObject updateDelverySite = (SObject) newContract;
            newMapDS.put(newContract.Id, updateDelverySite);
            updateDelverySite = APIT11_Utilities.FutureChange(newMapDS, 'Contract', 'IT_Future_Change_Contract__c');
            newContractFuture = new Contract();
            newContractFuture = (Contract) updateDelverySite;
            newcontractComplete.IT_Future_Change_Contract__c = newContractFuture.IT_Future_Change_Contract__c;
        } 
        if(!String.isBlank(newContractEconomicFuture.Id) && fcReq.IT_Economic_Validity_Start_Date != null && fcReq.IT_Economic_Validity_Start_Date > System.today() + 1){
            System.debug('IF_2');
            Contract tempContr = new Contract();
            if(newContract == null || newContract == tempContr)
                newContract = new Contract(Id = financialCenterObj.IT_Contract__c);
            Map<Id, SObject> newMapDS = new Map<Id, SObject>();
            SObject updateDelverySite = (SObject) newContractEconomicFuture;
            newMapDS.put(newContractEconomicFuture.Id, updateDelverySite);
            updateDelverySite = APIT11_Utilities.FutureChange(newMapDS, 'Contract', 'IT_Future_Change_Economic_Conditions__c');
            newContractFuture = new Contract();
            newContractFuture = (Contract) updateDelverySite;
            newcontractComplete.IT_Future_Change_Economic_Conditions__c = newContractFuture.IT_Future_Change_Economic_Conditions__c;
        }
        if((null == newContract || newContract == new Contract()) && String.isBlank(newcontractComplete.IT_Future_Change_Contract__c) && String.isBlank(newcontractComplete.IT_Future_Change_Economic_Conditions__c)){
            System.debug('IF_3');
            upsertContractMethod.add(newContractEconomicFuture);
        }
        else if(null != newContract && newContract != new Contract() && String.isBlank(newcontractComplete.IT_Future_Change_Contract__c) && String.isBlank(newcontractComplete.IT_Future_Change_Economic_Conditions__c)){
            System.debug('IF_4');
            newContractFuture = new Contract();
            for(SObjectField field:newContract.getSObjectType().getDescribe().fields.getMap().values()) {
                try {
                    Object del1Field = newContract.get(field);
                    Object del2Field = newContractEconomicFuture.get(field);
                    if (del2Field != null) {
                        newContract.put(field, del1Field==null ? del2Field : del1Field);
                    }
                }catch (SObjectException ecc) {
                    System.debug('populateDeliverySiteMerge: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                }
            }
            System.debug('newContract:: '+newContract);
            upsertContractMethod.add(newContract);    
        }
        else if(!String.isBlank(newcontractComplete.IT_Future_Change_Contract__c) && String.isBlank(newcontractComplete.IT_Future_Change_Economic_Conditions__c)){
            System.debug('IF_5');
            newContractFuture = new Contract();
            newContractFuture = newContractEconomicFuture;
            newContractFuture.IT_Future_Change_Contract__c = newcontractComplete.IT_Future_Change_Contract__c;
            upsertContractMethod.add(newContractFuture);
        }
        else if(String.isBlank(newcontractComplete.IT_Future_Change_Contract__c) && !String.isBlank(newcontractComplete.IT_Future_Change_Economic_Conditions__c)){
            System.debug('IF_6');
            newContractFuture = new Contract();
            newContractFuture = newContract;
            newContractFuture.IT_Future_Change_Economic_Conditions__c = newcontractComplete.IT_Future_Change_Economic_Conditions__c;
            upsertContractMethod.add(newContractFuture);
        }else{
            System.debug('IF_7');
            upsertContractMethod.add(newcontractComplete);    
        }

        //upsertContractMethod.add(newContract);    

        return upsertContractMethod;
    }

    private static void populateLookupFCContract(ER_Financial_Center__c financialCenterObj, List<Contract> contractObj, List<IT_Contract> listContractReq){
        ER_Financial_Center__c upsertFCMethodTemp = new ER_Financial_Center__c();
        Contract upsertContractMethodTemp = new Contract();
        ER_Financial_Center__c upsertFCMethod = new ER_Financial_Center__c();
        if(financialCenterObj != upsertFCMethodTemp && contractObj != null && contractObj.size() > 0){
            for(Contract singleContract : contractObj){
                if((singleContract.EndDate == null && financialCenterObj.IT_Contract__c != singleContract.Id) || (contractObj.size() == 1 && financialCenterObj.IT_Contract__c != singleContract.Id)){
                    System.debug('singleContract.Id::: '+singleContract.Id);
                    upsertFCMethod = new ER_Financial_Center__c(Id = financialCenterObj.Id);
                    upsertFCMethod.IT_Contract__c = singleContract.Id;
                    System.debug('upsertFCMethod.IT_Contract__c::: '+upsertFCMethod.IT_Contract__c);
                    update upsertFCMethod;
                }    
            }    
        }     
    }

    private static List<ER_ContractLineItem__c> populateContractLineItem(ER_Financial_Center__c financialCenterObj, List<IT_Billable_Service> contractLineItemRequest, Map<String, ER_ContractLineItem__c> mapContractLineItemSF, Contract lookupContract){
        List<ER_ContractLineItem__c> upsertContractLineItemMethod = new List<ER_ContractLineItem__c>();
        Contract contractControlNull = new Contract();
        for(IT_Billable_Service singleContractLineItem : contractLineItemRequest){
            ER_ContractLineItem__c newContractLineItem = new ER_ContractLineItem__c();
            ER_ContractLineItem__c newFutureComplete = new ER_ContractLineItem__c();
            ER_ContractLineItem__c newProductFuture = new ER_ContractLineItem__c();
            if(mapContractLineItemSF != null && mapContractLineItemSF.size() > 0 && mapContractLineItemSF.Keyset().contains(singleContractLineItem.IT_Client_Code+singleContractLineItem.IT_Technical_Data_Progressive)){
                newContractLineItem = new ER_ContractLineItem__c(Id = mapContractLineItemSF.get(singleContractLineItem.IT_Client_Code+singleContractLineItem.IT_Technical_Data_Progressive).Id);
                newFutureComplete = new ER_ContractLineItem__c(Id = mapContractLineItemSF.get(singleContractLineItem.IT_Client_Code+singleContractLineItem.IT_Technical_Data_Progressive).Id); 
            }

            if(!String.isBlank(financialCenterObj.name) && financialCenterObj.Name.contains(' - '))
                newContractLineItem.Name = financialCenterObj.Name.split(' - ')[1]; 

            if(singleContractLineItem.IT_Validity_Start_Date != null && singleContractLineItem.IT_Validity_Start_Date == System.today() + 1)
                newContractLineItem.IT_Future_Change_Contract_Line_Item__c = '';        

            newContractLineItem.IT_Client_Code__c = singleContractLineItem.IT_Client_Code;
            newContractLineItem.IT_Technical_Data_Progressive__c = singleContractLineItem.IT_Technical_Data_Progressive;
            newContractLineItem.IT_Product__c = singleContractLineItem.IT_Product;
            newContractLineItem.IT_Feedback_Type__c = singleContractLineItem.IT_Feedback_Type;
            newContractLineItem.IT_Logo_Type__c = singleContractLineItem.IT_Logo_Type;
            if(!String.isBlank(singleContractLineItem.IT_Feedback_Request) && singleContractLineItem.IT_Feedback_Request == '1')
                newContractLineItem.IT_Feedback_Request__c = true;
            else    
                newContractLineItem.IT_Feedback_Request__c = false;
            newContractLineItem.IT_Ticket_Type__c = singleContractLineItem.IT_Ticket_Type;
            newContractLineItem.IT_Font_Type__c = singleContractLineItem.IT_Font_Type;
            newContractLineItem.IT_Order_Receipts_Type__c = singleContractLineItem.IT_Order_Receipts_Type;
            newContractLineItem.IT_Order_Frequence_Type__c = singleContractLineItem.IT_Order_Frequence_Type;
            if(!String.isBlank(singleContractLineItem.IT_Single_Series_Emission) && singleContractLineItem.IT_Single_Series_Emission == '1')
                newContractLineItem.IT_Single_Series_Emission__c = true;
            else    
                newContractLineItem.IT_Single_Series_Emission__c = false;
            if(!String.isBlank(singleContractLineItem.IT_Ticket_Return_Request) && singleContractLineItem.IT_Ticket_Return_Request == '1')
                newContractLineItem.IT_Ticket_Return_Request__c = true;
            else    
                newContractLineItem.IT_Ticket_Return_Request__c = false;
            if(!String.isBlank(singleContractLineItem.IT_Itinerant_Client) && singleContractLineItem.IT_Itinerant_Client == '1')
                newContractLineItem.IT_Itinerant_Client__c = true;
            else    
                newContractLineItem.IT_Itinerant_Client__c = false;
            if(!String.isBlank(singleContractLineItem.IT_Ticket_Display) && singleContractLineItem.IT_Ticket_Display == '1')
                newContractLineItem.IT_Ticket_Display__c = true;
            else    
                newContractLineItem.IT_Ticket_Display__c = false;
            if(!String.isBlank(singleContractLineItem.IT_No_Ads) && singleContractLineItem.IT_No_Ads == '1')
                newContractLineItem.IT_No_Ads__c = true;
            else    
                newContractLineItem.IT_No_Ads__c = false;
            if(!String.isBlank(singleContractLineItem.IT_No_Insert) && singleContractLineItem.IT_No_Insert == '1')
                newContractLineItem.IT_No_Insert__c = true;
            else    
                newContractLineItem.IT_No_Insert__c = false;
            if(!String.isBlank(singleContractLineItem.IT_Display_Locale) && singleContractLineItem.IT_Display_Locale == '1')
                newContractLineItem.IT_Display_Locale__c = true;
            else    
                newContractLineItem.IT_Display_Locale__c = false;
            if(!String.isBlank(singleContractLineItem.IT_Display_Address) && singleContractLineItem.IT_Display_Address == '1')
                newContractLineItem.IT_Display_Address__c = true;
            else    
                newContractLineItem.IT_Display_Address__c = false;
            if(!String.isBlank(singleContractLineItem.IT_Display_Active_Name) && singleContractLineItem.IT_Display_Active_Name == '1')
                newContractLineItem.IT_Display_Active_Name__c = true;
            else    
                newContractLineItem.IT_Display_Active_Name__c = false;
            if(!String.isBlank(singleContractLineItem.IT_Address_Row_Display) && singleContractLineItem.IT_Address_Row_Display == '1')
                newContractLineItem.IT_Address_Row_Display__c = true;
            else    
                newContractLineItem.IT_Address_Row_Display__c = false;
            if(!String.isBlank(singleContractLineItem.IT_Amount_Display) && singleContractLineItem.IT_Amount_Display == '1')
                newContractLineItem.IT_Amount_Display__c = true;
            else 
                newContractLineItem.IT_Amount_Display__c = false;  
            if(singleContractLineItem.IT_Ticket_Value != null)    
                newContractLineItem.IT_Ticket_Value__c = singleContractLineItem.IT_Ticket_Value;
            newContractLineItem.IT_Amount__c = singleContractLineItem.IT_Amount;
            newContractLineItem.IT_Logo_Code__c = singleContractLineItem.IT_Logo_Code;
            newContractLineItem.IT_Business_Association_Logo_Type__c = singleContractLineItem.IT_Business_Association_Logo_Type;
            newContractLineItem.IT_Business_Association_Font_Type__c = singleContractLineItem.IT_Business_Association_Font_Type;
            newContractLineItem.IT_Business_Association_Logo_Code__c = singleContractLineItem.IT_Business_Association_Logo_Code;
            newContractLineItem.IT_Printout_Employee_Copies_Number__c = singleContractLineItem.IT_Printout_Employee_Copies_Number;
            newContractLineItem.IT_Emitted_Ticket_Copies_Number__c = singleContractLineItem.IT_Emitted_Ticket_Copies_Number;
            newContractLineItem.IT_Card_Type__c = singleContractLineItem.IT_Card_Type;
            newContractLineItem.IT_Web_Enabling_Level__c = singleContractLineItem.IT_Web_Enabling_Level;
            if(!String.isBlank(singleContractLineItem.IT_File_Sending_Authorization) && singleContractLineItem.IT_File_Sending_Authorization == '1')
                newContractLineItem.IT_File_Sending_Authorization__c = true;
            else    
                newContractLineItem.IT_File_Sending_Authorization__c = false; 
            if(!String.isBlank(singleContractLineItem.IT_Front_and_Back_Printout) && singleContractLineItem.IT_Front_and_Back_Printout == '1')
                newContractLineItem.IT_Front_and_Back_Printout__c = true;
            else    
                newContractLineItem.IT_Front_and_Back_Printout__c = false;
            newContractLineItem.IT_Stock_Orders__c = singleContractLineItem.IT_Stock_Orders;
            newContractLineItem.IT_Graphic_Layer_Front__c = singleContractLineItem.IT_Graphic_Layer_Front;
            newContractLineItem.IT_Graphic_Layer_Back__c = singleContractLineItem.IT_Graphic_Layer_Back;
            newContractLineItem.IT_Graphic_Background_Front__c = singleContractLineItem.IT_Graphic_Background_Front;
            newContractLineItem.IT_Graphic_Background_Back__c = singleContractLineItem.IT_Graphic_Background_Back;
            newContractLineItem.IT_Envelope__c = singleContractLineItem.IT_Envelope;
            newContractLineItem.IT_Data_on_Address_Row__c = singleContractLineItem.IT_Data_on_Address_Row; 
            if(singleContractLineItem.IT_Activity_Exception != null)
                newContractLineItem.IT_Activity_Exception__c = singleContractLineItem.IT_Activity_Exception;
            newContractLineItem.IT_AC_User__c = singleContractLineItem.IT_AC_User;   
            if(singleContractLineItem.IT_Validity_Start_Date != null)
                newContractLineItem.IT_Validity_Start_Date__c = singleContractLineItem.IT_Validity_Start_Date;
            if(singleContractLineItem.IT_Validity_End_Date != null)
                newContractLineItem.IT_Validity_End_Date__c = singleContractLineItem.IT_Validity_End_Date;
            newContractLineItem.IT_Financial_Center__c = financialCenterObj.Id;
            newContractLineItem.ER_Product2__c = financialCenterObj.IT_Product2__c;
            newContractLineItem.IT_Service__c = financialCenterObj.IT_Service__c;
            if(lookupContract != null && lookupContract != contractControlNull)
                newContractLineItem.ER_Contract__c = lookupContract.Id;

            //mandatory fields not used in Italy
            newContractLineItem.ER_Quantity__c = 0;
            newContractLineItem.ER_UnitPrice__c = 0;

            if(!String.isBlank(newContractLineItem.Id) && newContractLineItem.IT_Validity_Start_Date__c != null && newContractLineItem.IT_Validity_Start_Date__c > System.today() + 1){
                Map<Id, SObject> newMapDS = new Map<Id, SObject>();
                SObject updateProduct = (SObject) newContractLineItem;
                newMapDS.put(newContractLineItem.Id, updateProduct);
                updateProduct = APIT11_Utilities.FutureChange(newMapDS, 'ER_ContractLineItem__c', 'IT_Future_Change_Contract_Line_Item__c');
                newProductFuture = new ER_ContractLineItem__c();
                newProductFuture = (ER_ContractLineItem__c) updateProduct;
                newContractLineItem = new ER_ContractLineItem__c();
                newContractLineItem.IT_Future_Change_Contract_Line_Item__c = newProductFuture.IT_Future_Change_Contract_Line_Item__c;
            } 
            if(!String.isBlank(newContractLineItem.IT_Future_Change_Contract_Line_Item__c)){
                newFutureComplete.IT_Future_Change_Contract_Line_Item__c = newContractLineItem.IT_Future_Change_Contract_Line_Item__c;
                upsertContractLineItemMethod.add(newFutureComplete);
            }else{
                upsertContractLineItemMethod.add(newContractLineItem);    
            } 

            //upsertContractLineItemMethod.add(newContractLineItem);
        }
        return upsertContractLineItemMethod;  
    }

    private static List<ER_Delivery_Site__c> populateDeliverySite(ER_Financial_Center__c financialCenterObj, List<IT_Delivery_Site> deliverySiteRequest, Map<String, ER_Delivery_Site__c> mapDeliverySiteSF, Map<String, IT_Address> mapAddressFields){
        List<ER_Delivery_Site__c> upsertDeliverySiteMethod = new List<ER_Delivery_Site__c>();
        List<String> controlDuplicate = new List<String>();

        for(IT_Delivery_Site singleDeliverySite : deliverySiteRequest){
            ER_Delivery_Site__c newDeliverySite = new ER_Delivery_Site__c();
            ER_Delivery_Site__c newDeliverySiteAddressFuture = new ER_Delivery_Site__c();
            ER_Delivery_Site__c newDeliverySiteFuture = new ER_Delivery_Site__c();
            ER_Delivery_Site__c newDeliverySiteComplete = new ER_Delivery_Site__c();
            
            System.debug('singleDeliverySiteAC::: '+singleDeliverySite.IT_Delivery_AC);
            System.debug('singleDeliverySiteSF::: '+singleDeliverySite.IT_Delivery_SF);

            if(!String.isBlank(singleDeliverySite.IT_Delivery_SF) && mapDeliverySiteSF != null && mapDeliverySiteSF.size() > 0 && mapDeliverySiteSF.Keyset().contains(singleDeliverySite.IT_Delivery_SF)){
                newDeliverySite = new ER_Delivery_Site__c(Id = mapDeliverySiteSF.get(singleDeliverySite.IT_Delivery_SF).Id);
            }else if(!String.isBlank(singleDeliverySite.IT_Delivery_AC) && mapDeliverySiteSF != null && mapDeliverySiteSF.size() > 0 && mapDeliverySiteSF.Keyset().contains(singleDeliverySite.IT_Delivery_AC)){
                newDeliverySite = new ER_Delivery_Site__c(Id = mapDeliverySiteSF.get(singleDeliverySite.IT_Delivery_AC).Id);
            }     
            
            System.debug('newDeliverySite::: '+newDeliverySite);
            System.debug('controlDuplicate::: '+controlDuplicate);
            if(newDeliverySite == new ER_Delivery_Site__c() || !controlDuplicate.contains(newDeliverySite.Id)){         
                System.debug('IF OK::: ');

                if(!String.isBlank(newDeliverySite.Id)){
                    newDeliverySiteAddressFuture = new ER_Delivery_Site__c(Id = newDeliverySite.Id);
                    newDeliverySiteFuture = newDeliverySite;
                    newDeliverySiteComplete = new ER_Delivery_Site__c(Id = newDeliverySite.Id);
                }

                if(singleDeliverySite.IT_Validity_Start_Date != null && singleDeliverySite.IT_Validity_Start_Date == System.today() + 1)
                    newDeliverySite.IT_Future_Change_DS__c = '';
                
                newDeliverySite.IT_Client_Code__c = singleDeliverySite.IT_Client_Code;
                //newDeliverySite.IT_Activity_AC__c = singleDeliverySite.IT_Activity_AC;
                newDeliverySite.IT_Delivery_SF__c = singleDeliverySite.IT_Delivery_SF;
                newDeliverySite.IT_Delivery_AC__c = singleDeliverySite.IT_Delivery_AC;
                newDeliverySite.IT_Delivery_Type__c = singleDeliverySite.IT_Delivery_Type;
                if(singleDeliverySite.IT_Delivery_Point != null)
                    newDeliverySite.IT_Delivery_Point__c = singleDeliverySite.IT_Delivery_Point;
                newDeliverySite.IT_Branch__c = singleDeliverySite.IT_Branch;
                newDeliverySite.IT_Provider__c = singleDeliverySite.IT_Provider;
                newDeliverySite.IT_Vehicle__c = singleDeliverySite.IT_Vehicle;
                if(!String.isBlank(singleDeliverySite.IT_Vehicle_Forcing) && singleDeliverySite.IT_Vehicle_Forcing == '1')
                    newDeliverySite.IT_Vehicle_Forcing__c = true;
                else    
                    newDeliverySite.IT_Vehicle_Forcing__c = false;
                newDeliverySite.IT_Special_Service__c = singleDeliverySite.IT_Special_Service;
                newDeliverySite.IT_Matched_Delivery__c = singleDeliverySite.IT_Matched_Delivery;
                newDeliverySite.IT_Notes_type__c = singleDeliverySite.IT_Notes_type;
                newDeliverySite.IT_Notes__c = singleDeliverySite.IT_Notes;
                newDeliverySite.IT_Text__c = singleDeliverySite.IT_Text;
                newDeliverySite.IT_AC_User__c = singleDeliverySite.IT_AC_User;
                if(singleDeliverySite.IT_Validity_Start_Date != null)
                    newDeliverySite.IT_Validity_Start_Date__c = singleDeliverySite.IT_Validity_Start_Date;
                if(singleDeliverySite.IT_Validity_End_Date != null) 
                    newDeliverySite.IT_Validity_End_Date__c = singleDeliverySite.IT_Validity_End_Date;
                newDeliverySite.ER_Financial_Center__c = financialCenterObj.Id;
                newDeliverySite.ER_Account_Name__c = financialCenterObj.ER_Account_Name__c;

                //UserCheck 30012020
                newDeliverySite.IT_Note_Validity_Start_Date__c = singleDeliverySite.IT_Note_Validity_Start_Date;
                newDeliverySite.IT_Note_Validity_End_Date__c = singleDeliverySite.IT_Note_Validity_End_Date;

                //Menage Address
                if(mapAddressFields != null && mapAddressFields.keyset().contains(singleDeliverySite.IT_Delivery_AC)){
                    IT_Address newAddress = mapAddressFields.get(singleDeliverySite.IT_Delivery_AC);

                    newDeliverySiteAddressFuture.Name = newAddress.IT_Ticket_Naming;
                    newDeliverySiteAddressFuture.IT_Ticket_Naming__c = newAddress.IT_Ticket_Naming;
                    newDeliverySiteAddressFuture.IT_Province__c = newAddress.IT_Province;
                    newDeliverySiteAddressFuture.IT_Toponym__c = newAddress.IT_Toponym;
                    newDeliverySiteAddressFuture.ER_Street__c = newAddress.IT_Street + ', ' + newAddress.IT_Street_Number; 
                    newDeliverySiteAddressFuture.IT_Short_Address__c = newAddress.IT_Short_Address;
                    newDeliverySiteAddressFuture.ER_Zip_Code__c = newAddress.IT_Postal_Code;
                    newDeliverySiteAddressFuture.ER_City__c = newAddress.IT_City;
                    newDeliverySiteAddressFuture.IT_Hamlet__c = newAddress.IT_Hamlet;
                    newDeliverySiteAddressFuture.ER_Street_additionnal__c = newAddress.IT_Additional_Locality;
                    newDeliverySiteAddressFuture.IT_State_Code__c = newAddress.IT_State_Code;
                    newDeliverySiteAddressFuture.IT_City_Code__c = newAddress.IT_City_Code;
                    newDeliverySiteAddressFuture.IT_Hamlet_Code__c = newAddress.IT_Hamlet_Code;
                    newDeliverySiteAddressFuture.IT_Sestiere_Code__c = newAddress.IT_Sestiere_Code;
                    newDeliverySiteAddressFuture.IT_Street_Code__c = newAddress.IT_Street_Code;
                    newDeliverySiteAddressFuture.IT_Road_Arch_Code__c = newAddress.IT_Road_Arch_Code;
                    newDeliverySiteAddressFuture.IT_MetRef_Loc_X__c = newAddress.IT_MetRef_Loc_X;
                    newDeliverySiteAddressFuture.IT_MetRef_Loc_Y__c = newAddress.IT_MetRef_Loc_Y;
                    newDeliverySiteAddressFuture.IT_GeoRef_Loc_X__c = newAddress.IT_GeoRef_Loc_X;
                    newDeliverySiteAddressFuture.IT_GeoRef_Loc_Y__c = newAddress.IT_GeoRef_Loc_Y;
                    newDeliverySiteAddressFuture.IT_Extra_Urban_Specifications__c = newAddress.IT_Extra_Urban_Specifications;
                    newDeliverySiteAddressFuture.IT_Zone__c = newAddress.IT_Zone;
                    newDeliverySiteAddressFuture.IT_Address_Validity_Start_Date__c = newAddress.IT_Validity_Start_Date;
                    newDeliverySiteAddressFuture.IT_Address_Validity_End_Date__c = newAddress.IT_Validity_End_Date;
                    newDeliverySiteAddressFuture.IT_Address_AC_User__c = newAddress.IT_AC_User;

                    if(newAddress.IT_Validity_Start_Date != null && newAddress.IT_Validity_Start_Date == System.today() + 1)
                        newDeliverySiteAddressFuture.IT_Future_Change_Address__c = '';
                } 
                //Menage Address - END

                if(!String.isBlank(newDeliverySite.Id) && newDeliverySite.IT_Validity_Start_Date__c != null && newDeliverySite.IT_Validity_Start_Date__c > System.today() + 1){
                        Map<Id, SObject> newMapDS = new Map<Id, SObject>();
                        SObject updateDelverySite = (SObject) newDeliverySite;
                        newMapDS.put(newDeliverySite.Id, updateDelverySite);
                        updateDelverySite = APIT11_Utilities.FutureChange(newMapDS, 'ER_Delivery_Site__c', 'IT_Future_Change_DS__c');
                        newDeliverySiteFuture = new ER_Delivery_Site__c();
                        newDeliverySiteFuture = (ER_Delivery_Site__c) updateDelverySite;
                        newDeliverySiteComplete.IT_Future_Change_DS__c = newDeliverySiteFuture.IT_Future_Change_DS__c;
                    } 
                    if(!String.isBlank(newDeliverySiteAddressFuture.Id) && newDeliverySiteAddressFuture.IT_Address_Validity_Start_Date__c != null && newDeliverySiteAddressFuture.IT_Address_Validity_Start_Date__c > System.today() + 1){
                        Map<Id, SObject> newMapDS = new Map<Id, SObject>();
                        SObject updateDelverySite = (SObject) newDeliverySiteAddressFuture;
                        newMapDS.put(newDeliverySiteAddressFuture.Id, updateDelverySite);
                        updateDelverySite = APIT11_Utilities.FutureChange(newMapDS, 'ER_Delivery_Site__c', 'IT_Future_Change_Address__c');
                        newDeliverySiteFuture = new ER_Delivery_Site__c();
                        newDeliverySiteFuture = (ER_Delivery_Site__c) updateDelverySite;
                        newDeliverySiteComplete.IT_Future_Change_Address__c = newDeliverySiteFuture.IT_Future_Change_Address__c;
                    }
                    if(String.isBlank(newDeliverySiteComplete.IT_Future_Change_DS__c) && String.isBlank(newDeliverySiteComplete.IT_Future_Change_Address__c)){
                        newDeliverySiteFuture = new ER_Delivery_Site__c();
                        for(SObjectField field:newDeliverySite.getSObjectType().getDescribe().fields.getMap().values()) {
                            try {
                                Object del1Field = newDeliverySite.get(field);
                                Object del2Field = newDeliverySiteAddressFuture.get(field);
                                if (del2Field != null) {
                                    newDeliverySite.put(field, del1Field==null ? del2Field : del1Field);
                                }
                            }catch (SObjectException ecc) {
                                System.debug('populateDeliverySiteMerge: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                            }
                        }
                        upsertDeliverySiteMethod.add(newDeliverySite);    
                    }
                    else if(!String.isBlank(newDeliverySiteComplete.IT_Future_Change_DS__c) && String.isBlank(newDeliverySiteComplete.IT_Future_Change_Address__c)){
                        newDeliverySiteFuture = new ER_Delivery_Site__c();
                        newDeliverySiteFuture = newDeliverySiteAddressFuture;
                        newDeliverySiteFuture.IT_Activity_AC__c = singleDeliverySite.IT_Activity_AC;
                        newDeliverySiteFuture.IT_Activity_SF__c = singleDeliverySite.IT_Activity_SF;
                        newDeliverySiteFuture.IT_Future_Change_DS__c = newDeliverySiteComplete.IT_Future_Change_DS__c;
                        upsertDeliverySiteMethod.add(newDeliverySiteFuture);
                    }
                    else if(String.isBlank(newDeliverySiteComplete.IT_Future_Change_DS__c) && !String.isBlank(newDeliverySiteComplete.IT_Future_Change_Address__c)){
                        newDeliverySiteFuture = new ER_Delivery_Site__c();
                        newDeliverySiteFuture = newDeliverySite;
                        newDeliverySiteFuture.IT_Activity_AC__c = singleDeliverySite.IT_Activity_AC;
                        newDeliverySiteFuture.IT_Activity_SF__c = singleDeliverySite.IT_Activity_SF;
                        newDeliverySiteFuture.IT_Future_Change_Address__c = newDeliverySiteComplete.IT_Future_Change_Address__c;
                        upsertDeliverySiteMethod.add(newDeliverySiteFuture);
                    }else{
                        upsertDeliverySiteMethod.add(newDeliverySiteComplete);    
                    }

                //upsertDeliverySiteMethod.add(newDeliverySite);
                if(newDeliverySiteComplete.Id != null)
                    controlDuplicate.add(newDeliverySiteComplete.Id);
            }
        }
        return upsertDeliverySiteMethod;   
    }

    private static List<ER_Distribution_Point__c> populateDistributionPoint(ER_Financial_Center__c financialCenterObj, List<IT_Distribution_Point> distributionPointRequest, Map<String, ER_Distribution_Point__c> mapDistributionPointSF, List<ER_Delivery_Site__c> listDeliveryParent, List<ER_ContractLineItem__c> ListItemParent, Map<String, IT_Address> mapAddressFields, Map<String, String> authorizationUserDP, Map<String, String> controloDSDuplicate){
        List<ER_Distribution_Point__c> upsertDistributionPointMethod = new List<ER_Distribution_Point__c>();
        //AD MultiActivity Menage - 16032020
        List<String> controlActivityACPresent = new List<String>();
        Map<String, Map<Integer, IT_Distribution_Point>> multiDistribution = new Map<String, Map<Integer, IT_Distribution_Point>>();
        for(IT_Distribution_Point singleDistributionPoint : distributionPointRequest){
            if(multiDistribution != null && multiDistribution.size() > 0 && multiDistribution.Keyset().contains(singleDistributionPoint.IT_AC_Activity)){
                if(singleDistributionPoint.IT_Raw_Number_for_Display != null){
                    Map<Integer, IT_Distribution_Point> distributionTemp = new Map<Integer, IT_Distribution_Point>();
                    distributionTemp = multiDistribution.get(singleDistributionPoint.IT_AC_Activity);
                    distributionTemp.put(singleDistributionPoint.IT_Raw_Number_for_Display, singleDistributionPoint);
                    multiDistribution.put(singleDistributionPoint.IT_AC_Activity, distributionTemp);
                }            
            }else{
                Map<Integer, IT_Distribution_Point> distributionTemp = new Map<Integer, IT_Distribution_Point>();
                distributionTemp.put(singleDistributionPoint.IT_Raw_Number_for_Display, singleDistributionPoint);
                multiDistribution.put(singleDistributionPoint.IT_AC_Activity, distributionTemp);    
            }
        }
        //AD MultiActivity Menage - 16032020 - END 

        IT_Custom_Control__c mhc = IT_Custom_Control__c.getInstance('Control Consegna');  
        String deliveryStandard = mhc.IT_Custom_Text__c;
        List<ER_Delivery_Site__c> deliveryStandardList = new List<ER_Delivery_Site__c>();
        if(!String.isBlank(deliveryStandard))
            deliveryStandardList = [Select Id From ER_Delivery_Site__c Where Name =: deliveryStandard];   

        for(IT_Distribution_Point singleDistributionPoint : distributionPointRequest){
            if(!controlActivityACPresent.contains(singleDistributionPoint.IT_AC_Activity)){ 
                ER_Distribution_Point__c newDistributionPoint = new ER_Distribution_Point__c();
                ER_Distribution_Point__c newDPAddressFuture = new ER_Distribution_Point__c();
                ER_Distribution_Point__c newDPFuture = new ER_Distribution_Point__c();
                ER_Distribution_Point__c newDPComplete = new ER_Distribution_Point__c();
                if(!String.isBlank(singleDistributionPoint.IT_SF_Activity) && mapDistributionPointSF != null && mapDistributionPointSF.size() > 0 && mapDistributionPointSF.Keyset().contains(singleDistributionPoint.IT_SF_Activity))
                    newDistributionPoint = new ER_Distribution_Point__c(Id = mapDistributionPointSF.get(singleDistributionPoint.IT_SF_Activity).Id);
                else if(!String.isBlank(singleDistributionPoint.IT_AC_Activity) && mapDistributionPointSF != null && mapDistributionPointSF.size() > 0 && mapDistributionPointSF.Keyset().contains(singleDistributionPoint.IT_AC_Activity))
                    newDistributionPoint = new ER_Distribution_Point__c(Id = mapDistributionPointSF.get(singleDistributionPoint.IT_AC_Activity).Id);

                if(!String.isBlank(newDistributionPoint.Id)){
                    newDPAddressFuture = new ER_Distribution_Point__c(Id = newDistributionPoint.Id);
                    newDPFuture = newDistributionPoint;
                    newDPComplete = new ER_Distribution_Point__c(Id = newDistributionPoint.Id);
                }      

                if(singleDistributionPoint.IT_Validity_Start_Date != null && singleDistributionPoint.IT_Validity_Start_Date == System.today() + 1)
                    newDistributionPoint.IT_Future_Change_Distribution_Point__c = '';

                newDistributionPoint.IT_Client_Code__c = singleDistributionPoint.IT_Client_Code;
                newDistributionPoint.IT_SF_Activity__c = singleDistributionPoint.IT_SF_Activity;
                newDistributionPoint.IT_AC_Activity__c = singleDistributionPoint.IT_AC_Activity;
                if(!String.isBlank(singleDistributionPoint.IT_Suspension) && singleDistributionPoint.IT_Suspension == '1')
                    newDistributionPoint.IT_Suspension__c = true;
                else    
                    newDistributionPoint.IT_Suspension__c = false;
                if(!String.isBlank(singleDistributionPoint.IT_Cancellation) && singleDistributionPoint.IT_Cancellation == '1')    
                    newDistributionPoint.IT_Cancellation__c = true;
                else    
                    newDistributionPoint.IT_Cancellation__c = false;
                newDistributionPoint.IT_Cancellation_Type__c = singleDistributionPoint.IT_Cancellation_Type;
                newDistributionPoint.IT_Employees_Number__c = singleDistributionPoint.IT_Employees_Number;
                if(singleDistributionPoint.IT_Technical_Data_Progressive != null) 
                    newDistributionPoint.IT_Technical_Data_Progressive__c = String.valueOf(singleDistributionPoint.IT_Technical_Data_Progressive);
                newDistributionPoint.IT_Contact_Code__c = singleDistributionPoint.IT_Contact_Code;
                if(!String.isBlank(singleDistributionPoint.IT_Free_Description_to_Display) && singleDistributionPoint.IT_Free_Description_to_Display == '1') 
                    newDistributionPoint.IT_Free_Description_to_Display__c = true;
                else    
                    newDistributionPoint.IT_Free_Description_to_Display__c = false;
                if(!String.isBlank(singleDistributionPoint.IT_Address_to_Display) && singleDistributionPoint.IT_Address_to_Display == '1')    
                    newDistributionPoint.IT_Address_to_Display__c = true;
                else    
                    newDistributionPoint.IT_Address_to_Display__c = false;
                if(!String.isBlank(singleDistributionPoint.IT_Naming_to_Display) && singleDistributionPoint.IT_Naming_to_Display == '1')
                    newDistributionPoint.IT_Locality_to_Display__c = true;
                else    
                    newDistributionPoint.IT_Locality_to_Display__c = false; 
                //if(!String.isBlank(singleDistributionPoint.IT_Free_Description_to_Display) && singleDistributionPoint.IT_Free_Description_to_Display == '1')
                    //newDistributionPoint.IT_Naming_to_Display__c = true;
                //else    
                    //newDistributionPoint.IT_Naming_to_Display__c = false; 
                
                newDistributionPoint.IT_Raw_Number_for_Display__c = singleDistributionPoint.IT_Raw_Number_for_Display;
                newDistributionPoint.IT_Data_to_Display__c = singleDistributionPoint.IT_Data_to_Display;
                newDistributionPoint.IT_Data_Type_to_Display__c = singleDistributionPoint.IT_Data_Type_to_Display;
                
                if(singleDistributionPoint.IT_Raw_Number_for_Display == null)
                    newDistributionPoint.IT_Cost_Center__c = singleDistributionPoint.IT_Cost_Center;

                if(multiDistribution != null && multiDistribution.size() > 0 && multiDistribution.Keyset().contains(singleDistributionPoint.IT_AC_Activity)){
                    if(multiDistribution.get(singleDistributionPoint.IT_AC_Activity).Keyset().contains(2)){
                        newDistributionPoint.IT_Data_to_Display_2__c = multiDistribution.get(singleDistributionPoint.IT_AC_Activity).get(2).IT_Data_to_Display;
                        newDistributionPoint.IT_Data_Type_to_Display_2__c = multiDistribution.get(singleDistributionPoint.IT_AC_Activity).get(2).IT_Data_Type_to_Display;
                    }
                    if(multiDistribution.get(singleDistributionPoint.IT_AC_Activity).Keyset().contains(3)){
                        newDistributionPoint.IT_Data_to_Display_3__c = multiDistribution.get(singleDistributionPoint.IT_AC_Activity).get(3).IT_Data_to_Display;
                        newDistributionPoint.IT_Data_Type_to_Display_3__c = multiDistribution.get(singleDistributionPoint.IT_AC_Activity).get(3).IT_Data_Type_to_Display;
                        if(multiDistribution.get(singleDistributionPoint.IT_AC_Activity).get(3).IT_Free_Description_to_Display == '1') 
                            newDistributionPoint.IT_Free_Description_to_Display_2__c = true; 
                        else    
                            newDistributionPoint.IT_Free_Description_to_Display_2__c = false;
                    }
                    if(multiDistribution.get(singleDistributionPoint.IT_AC_Activity).Keyset().contains(4)){
                        newDistributionPoint.IT_Data_to_Display_4__c = multiDistribution.get(singleDistributionPoint.IT_AC_Activity).get(4).IT_Data_to_Display;
                        newDistributionPoint.IT_Data_Type_to_Display_4__c = multiDistribution.get(singleDistributionPoint.IT_AC_Activity).get(4).IT_Data_Type_to_Display;
                        if(multiDistribution.get(singleDistributionPoint.IT_AC_Activity).get(4).IT_Free_Description_to_Display == '1') 
                            newDistributionPoint.IT_Free_Description_to_Display_3__c = true;
                        else
                            newDistributionPoint.IT_Free_Description_to_Display_3__c = false;  
                    }
                } 
                newDistributionPoint.IT_AC_User__c = singleDistributionPoint.IT_AC_User;
                if(singleDistributionPoint.IT_Validity_Start_Date != null) 
                    newDistributionPoint.IT_Validity_Start_Date__c = singleDistributionPoint.IT_Validity_Start_Date;
                if(singleDistributionPoint.IT_Validity_End_Date != null)
                    newDistributionPoint.IT_Validity_End_Date__c = singleDistributionPoint.IT_Validity_End_Date;

                //UserCheck 16012020
                if(singleDistributionPoint.IT_Cost_Center_End_Date != null)
                    newDistributionPoint.IT_Cost_Center_End_Date__c = singleDistributionPoint.IT_Cost_Center_End_Date;
                if(singleDistributionPoint.IT_Suspension_Start_Date != null)    
                    newDistributionPoint.IT_Suspension_Start_Date__c = singleDistributionPoint.IT_Suspension_Start_Date;
                if(singleDistributionPoint.IT_Suspension_End_Date != null)
                    newDistributionPoint.IT_Suspension_End_Date__c = singleDistributionPoint.IT_Suspension_End_Date;
                newDistributionPoint.IT_Authorization_Suspension_User_Text__c = singleDistributionPoint.IT_Authorization_Suspension_User_Text;
                newDistributionPoint.IT_Authorization_Reactivation_User_Text__c = singleDistributionPoint.IT_Authorization_Reactivation_User_Text;
                newDistributionPoint.IT_Suspension_Reason__c = singleDistributionPoint.IT_Suspension_Reason;

                if(authorizationUserDP != null && authorizationUserDP.size() > 0 && !String.isBlank(singleDistributionPoint.IT_Authorization_Reactivation_User_Text) && authorizationUserDP.Keyset().contains(singleDistributionPoint.IT_Authorization_Reactivation_User_Text))    
                    newDistributionPoint.IT_Authorization_Reactivation_User__c = authorizationUserDP.get(singleDistributionPoint.IT_Authorization_Reactivation_User_Text);
                if(authorizationUserDP != null && authorizationUserDP.size() > 0 && !String.isBlank(singleDistributionPoint.IT_Authorization_Suspension_User_Text) && authorizationUserDP.Keyset().contains(singleDistributionPoint.IT_Authorization_Suspension_User_Text))    
                    newDistributionPoint.IT_Authorization_Suspension_User__c = authorizationUserDP.get(singleDistributionPoint.IT_Authorization_Suspension_User_Text);       

                //UserCheck 30012020
                newDistributionPoint.IT_Notes_Type__c = singleDistributionPoint.IT_Notes_Type;
                newDistributionPoint.IT_Notes__c = singleDistributionPoint.IT_Notes;
                newDistributionPoint.IT_Note_Validity_Start_Date__c = singleDistributionPoint.IT_Note_Validity_Start_Date;
                newDistributionPoint.IT_Note_Validity_End_Date__c = singleDistributionPoint.IT_Note_Validity_End_Date;
                
                //Menage Address
                if(mapAddressFields != null && mapAddressFields.keyset().contains(singleDistributionPoint.IT_AC_Activity)){
                    IT_Address newAddress = mapAddressFields.get(singleDistributionPoint.IT_AC_Activity);

                    newDPAddressFuture.Name = newAddress.IT_Ticket_Naming;
                    newDPAddressFuture.IT_Ticket_Naming__c = newAddress.IT_Ticket_Naming;
                    newDPAddressFuture.IT_Province__c = newAddress.IT_Province;
                    newDPAddressFuture.IT_Toponym__c = newAddress.IT_Toponym;
                    newDPAddressFuture.ER_Street__c = newAddress.IT_Street + ', ' + newAddress.IT_Street_Number; 
                    newDPAddressFuture.IT_Short_Address__c = newAddress.IT_Short_Address;
                    newDPAddressFuture.ER_Zip_Code__c = newAddress.IT_Postal_Code;
                    newDPAddressFuture.ER_City__c = newAddress.IT_City;
                    newDPAddressFuture.IT_Hamlet__c = newAddress.IT_Hamlet;
                    newDPAddressFuture.IT_Additional_Locality__c = newAddress.IT_Additional_Locality;
                    newDPAddressFuture.IT_State_Code__c = newAddress.IT_State_Code;
                    newDPAddressFuture.IT_City_Code__c = newAddress.IT_City_Code;
                    newDPAddressFuture.IT_Hamlet_Code__c = newAddress.IT_Hamlet_Code;
                    newDPAddressFuture.IT_Sestiere_Code__c = newAddress.IT_Sestiere_Code;
                    newDPAddressFuture.IT_Street_Code__c = newAddress.IT_Street_Code;
                    newDPAddressFuture.IT_Road_Arch_Code__c = newAddress.IT_Road_Arch_Code;
                    newDPAddressFuture.IT_MetRef_Loc_X__c = newAddress.IT_MetRef_Loc_X;
                    newDPAddressFuture.IT_MetRef_Loc_Y__c = newAddress.IT_MetRef_Loc_Y;
                    newDPAddressFuture.IT_GeoRef_Loc_X__c = newAddress.IT_GeoRef_Loc_X;
                    newDPAddressFuture.IT_GeoRef_Loc_Y__c = newAddress.IT_GeoRef_Loc_Y;
                    newDPAddressFuture.IT_Extra_Urban_Specifications__c = newAddress.IT_Extra_Urban_Specifications;
                    newDPAddressFuture.IT_Zone__c = newAddress.IT_Zone;
                    newDPAddressFuture.IT_Address_Validity_Start_Date__c = newAddress.IT_Validity_Start_Date;
                    newDPAddressFuture.IT_Address_Validity_End_Date__c = newAddress.IT_Validity_End_Date;
                    newDPAddressFuture.IT_Address_AC_User__c = newAddress.IT_AC_User;

                    if(newAddress.IT_Validity_Start_Date != null && newAddress.IT_Validity_Start_Date == System.today() + 1)
                        newDPAddressFuture.IT_Future_Change_Address__c = '';
                } 
                //Menage Address - END

                newDistributionPoint.IT_Financial_Center__c = financialCenterObj.Id;
                if(listDeliveryParent != null && listDeliveryParent.size() > 0){
                    Boolean controlActivityOK = false;
                    for(ER_Delivery_Site__c sinDel : listDeliveryParent){
                        System.debug('controloDSDuplicate:: '+controloDSDuplicate);
                        System.debug('singleDistributionPoint.IT_AC_Activity:: '+singleDistributionPoint.IT_AC_Activity);
                        if(sinDel.IT_Delivery_AC__c == controloDSDuplicate.get(singleDistributionPoint.IT_AC_Activity)){
                            newDistributionPoint.ER_Delivery_Site__c = sinDel.Id;
                            System.debug('newDistributionPoint.ER_Delivery_Site__c:: '+newDistributionPoint.ER_Delivery_Site__c);
                            controlActivityOK = true;
                        }
                    }
                    if(deliveryStandardList != null && deliveryStandardList.size() > 0 && controlActivityOK == false)
                        newDistributionPoint.ER_Delivery_Site__c = deliveryStandardList[0].Id;   
                }else if(newDistributionPoint.Id == null){
                    if(deliveryStandardList != null && deliveryStandardList.size() > 0)
                        newDistributionPoint.ER_Delivery_Site__c = deliveryStandardList[0].Id;    
                }
                if(ListItemParent != null && ListItemParent.size() > 0){
                    String distributionControl = singleDistributionPoint.IT_Client_Code + String.valueOf(singleDistributionPoint.IT_Technical_Data_Progressive);
                    for(ER_ContractLineItem__c sinItem : ListItemParent){
                        String keyControl = sinItem.IT_Client_Code__c + String.valueOf(sinItem.IT_Technical_Data_Progressive__c);
                        if(keyControl == distributionControl){
                            newDistributionPoint.IT_Contract_Line_Item__c = sinItem.Id; 
                        }
                    }
                }

                if(!String.isBlank(newDistributionPoint.Id) && newDistributionPoint.IT_Validity_Start_Date__c != null && newDistributionPoint.IT_Validity_Start_Date__c > System.today() + 1){
                        Map<Id, SObject> newMapDS = new Map<Id, SObject>();
                        SObject updateDelverySite = (SObject) newDistributionPoint;
                        newMapDS.put(newDistributionPoint.Id, updateDelverySite);
                        updateDelverySite = APIT11_Utilities.FutureChange(newMapDS, 'ER_Distribution_Point__c', 'IT_Future_Change_Distribution_Point__c');
                        newDPFuture = new ER_Distribution_Point__c();
                        newDPFuture = (ER_Distribution_Point__c) updateDelverySite;
                        newDPComplete.IT_Future_Change_Distribution_Point__c = newDPFuture.IT_Future_Change_Distribution_Point__c;
                    } 
                    if(!String.isBlank(newDPAddressFuture.Id) && newDPAddressFuture.IT_Address_Validity_Start_Date__c != null && newDPAddressFuture.IT_Address_Validity_Start_Date__c > System.today() + 1){
                        Map<Id, SObject> newMapDS = new Map<Id, SObject>();
                        SObject updateDelverySite = (SObject) newDPAddressFuture;
                        newMapDS.put(newDPAddressFuture.Id, updateDelverySite);
                        updateDelverySite = APIT11_Utilities.FutureChange(newMapDS, 'ER_Distribution_Point__c', 'IT_Future_Change_Address__c');
                        newDPFuture = new ER_Distribution_Point__c();
                        newDPFuture = (ER_Distribution_Point__c) updateDelverySite;
                        newDPComplete.IT_Future_Change_Address__c = newDPFuture.IT_Future_Change_Address__c;
                    }
                    if(String.isBlank(newDPComplete.IT_Future_Change_Distribution_Point__c) && String.isBlank(newDPComplete.IT_Future_Change_Address__c)){
                        newDPFuture = new ER_Distribution_Point__c();
                        for(SObjectField field:newDistributionPoint.getSObjectType().getDescribe().fields.getMap().values()) {
                            try {
                                Object del1Field = newDistributionPoint.get(field);
                                Object del2Field = newDPAddressFuture.get(field);
                                if (del2Field != null) {
                                    newDistributionPoint.put(field, del1Field==null ? del2Field : del1Field);
                                }
                            }catch (SObjectException ecc) {
                                System.debug('populateDeliverySiteMerge: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                            }
                        }
                        upsertDistributionPointMethod.add(newDistributionPoint);    
                    }
                    else if(!String.isBlank(newDPComplete.IT_Future_Change_Distribution_Point__c) && String.isBlank(newDPComplete.IT_Future_Change_Address__c)){
                        newDPFuture = new ER_Distribution_Point__c();
                        newDPFuture = newDPAddressFuture;
                        newDPFuture.ER_Delivery_Site__c = newDistributionPoint.ER_Delivery_Site__c;
                        newDPFuture.IT_Future_Change_Distribution_Point__c = newDPComplete.IT_Future_Change_Distribution_Point__c;
                        upsertDistributionPointMethod.add(newDPFuture);
                    }
                    else if(String.isBlank(newDPComplete.IT_Future_Change_Distribution_Point__c) && !String.isBlank(newDPComplete.IT_Future_Change_Address__c)){
                        newDPFuture = new ER_Distribution_Point__c();
                        newDPFuture = newDistributionPoint;
                        newDPFuture.ER_Delivery_Site__c = newDistributionPoint.ER_Delivery_Site__c;
                        newDPFuture.IT_Future_Change_Address__c = newDPComplete.IT_Future_Change_Address__c;
                        upsertDistributionPointMethod.add(newDPFuture);
                    }else{
                        upsertDistributionPointMethod.add(newDPComplete);    
                    }

                //upsertDistributionPointMethod.add(newDistributionPoint);
            }
            controlActivityACPresent.add(singleDistributionPoint.IT_AC_Activity);   
        }
        return upsertDistributionPointMethod;
    }

    private static List<IT_Group_Code__c> populateGroup(ER_Financial_Center__c financialCenterObj, List<IT_Group> groupRequest, Map<String, IT_Group_Code__c> mapgroupSF, Map<String, IT_Group__c> mapGroupParent){
        List<IT_Group_Code__c> upsertGroupMethod = new List<IT_Group_Code__c>();

        if(groupRequest != null && groupRequest.size() > 0){
            for(IT_Group singleGroup : groupRequest){
                IT_Group_Code__c newGroup = new IT_Group_Code__c();
                IT_Group_Code__c newGroupCodeFuture = new IT_Group_Code__c();
                IT_Group_Code__c newFutureComplete = new IT_Group_Code__c();
                System.debug('singleGroup.IT_Group_Code:: '+singleGroup.IT_Group_Code);
                System.debug('singleGroup.IT_Group_Type:: '+singleGroup.IT_Group_Type);
                if(mapgroupSF != null && mapgroupSF.size() > 0 && mapgroupSF.Keyset().contains(singleGroup.IT_Group_Code+singleGroup.IT_Group_Type+singleGroup.IT_Client_Code)){
                    newGroup = new IT_Group_Code__c(Id = mapgroupSF.get(singleGroup.IT_Group_Code+singleGroup.IT_Group_Type+singleGroup.IT_Client_Code).Id);
                    newFutureComplete = new IT_Group_Code__c(Id = mapgroupSF.get(singleGroup.IT_Group_Code+singleGroup.IT_Group_Type+singleGroup.IT_Client_Code).Id);
                }

                if(singleGroup.IT_Validity_Start_Date != null && singleGroup.IT_Validity_Start_Date == System.today() + 1)
                    newGroup.IT_Future_Change_Group_Code__c = '';

                newGroup.Name = singleGroup.IT_Group_Code + ' - ' +singleGroup.IT_Group_Type;
                newGroup.IT_Client_Code__c = singleGroup.IT_Client_Code;
                newGroup.IT_Group_Code__c = singleGroup.IT_Group_Code;
                newGroup.IT_Group_Type__c = singleGroup.IT_Group_Type;
                newGroup.IT_AC_User__c = singleGroup.IT_AC_User;
                if(singleGroup.IT_Validity_End_Date != null)
                    newGroup.IT_Validity_End_Date__c = singleGroup.IT_Validity_End_Date;
                if(singleGroup.IT_Validity_Start_Date != null)
                    newGroup.IT_Validity_Start_Date__c = singleGroup.IT_Validity_Start_Date;
                newGroup.ER_Financial_Center__c = financialCenterObj.Id;
                if(mapGroupParent != null && mapGroupParent.size() > 0 && mapGroupParent.Keyset().contains(singleGroup.IT_Client_Code))
                    newGroup.IT_Group__c = mapGroupParent.get(singleGroup.IT_Client_Code).Id;

                // Change Future
                if(!String.isBlank(newGroup.Id) && newGroup.IT_Validity_Start_Date__c != null && newGroup.IT_Validity_Start_Date__c > System.today() + 1){
                    Map<Id, SObject> newMapDS = new Map<Id, SObject>();
                    SObject updateGroupCode = (SObject) newGroup;
                    newMapDS.put(newGroup.Id, updateGroupCode);
                    updateGroupCode = APIT11_Utilities.FutureChange(newMapDS, 'IT_Group_Code__c', 'IT_Future_Change_Group_Code__c');
                    newGroupCodeFuture = new IT_Group_Code__c();
                    newGroupCodeFuture = (IT_Group_Code__c) updateGroupCode;
                    newGroup = new IT_Group_Code__c();
                    newGroup.IT_Future_Change_Group_Code__c = newGroupCodeFuture.IT_Future_Change_Group_Code__c;
                } 
                if(!String.isBlank(newGroup.IT_Future_Change_Group_Code__c)){
                    newFutureComplete.IT_Future_Change_Group_Code__c = newGroup.IT_Future_Change_Group_Code__c;
                    upsertGroupMethod.add(newFutureComplete);
                }else{
                    upsertGroupMethod.add(newGroup);    
                } 
                        
                //upsertGroupMethod.add(newGroup);
            }
        }    
        return upsertGroupMethod;
    }

    private static List<IT_Additional_Expenses__c> populateAdditionalExpenses(ER_Financial_Center__c financialCenterObj, List<IT_Additional_Expenses> additionalExpensesRequest, Map<String, IT_Additional_Expenses__c> mapAdditionalExpensesSF){
        List<IT_Additional_Expenses__c> upsertAdditionalExpensesMethod = new List<IT_Additional_Expenses__c>();

        if(additionalExpensesRequest != null && additionalExpensesRequest.size() > 0){
            for(IT_Additional_Expenses singleAdditionalExpenses : additionalExpensesRequest){
                IT_Additional_Expenses__c newAdditionalExpenses = new IT_Additional_Expenses__c();
            
                System.debug('singleGroup.IT_Code:: '+singleAdditionalExpenses.IT_Code);
                if(mapAdditionalExpensesSF != null && mapAdditionalExpensesSF.size() > 0 && mapAdditionalExpensesSF.Keyset().contains(singleAdditionalExpenses.IT_Client_Code+singleAdditionalExpenses.IT_Code)){
                    newAdditionalExpenses = new IT_Additional_Expenses__c(Id = mapAdditionalExpensesSF.get(singleAdditionalExpenses.IT_Client_Code+singleAdditionalExpenses.IT_Code).Id);
                }    
                newAdditionalExpenses.IT_Client_Code__c = singleAdditionalExpenses.IT_Client_Code;
                newAdditionalExpenses.IT_Code__c = singleAdditionalExpenses.IT_Code;
                newAdditionalExpenses.IT_AC_User__c = singleAdditionalExpenses.IT_AC_User;
                newAdditionalExpenses.IT_Amount__c = singleAdditionalExpenses.IT_Amount;
                newAdditionalExpenses.IT_Progressive__c = singleAdditionalExpenses.IT_Progressive;
                newAdditionalExpenses.IT_Calculation_Type__c = singleAdditionalExpenses.IT_Calculation_Type;

                if(singleAdditionalExpenses.IT_Validity_End_Date != null)
                    newAdditionalExpenses.IT_Validity_End_Date__c = singleAdditionalExpenses.IT_Validity_End_Date;
                if(singleAdditionalExpenses.IT_Validity_Start_Date != null)
                    newAdditionalExpenses.IT_Validity_Start_Date__c = singleAdditionalExpenses.IT_Validity_Start_Date;
                newAdditionalExpenses.IT_Financial_Center__c = financialCenterObj.Id;
                        
                upsertAdditionalExpensesMethod.add(newAdditionalExpenses);
            }
        }    
        return upsertAdditionalExpensesMethod;
    }

    private static List<IT_Note__c> populateNotes(ER_Financial_Center__c financialCenterObj, List<IT_Note> notesRequest, Map<String, IT_Note__c> mapNotesSF, Map<String, ER_Delivery_Site__c> mapDelSF, Map<String, ER_Distribution_Point__c> mapDisSF){
        List<IT_Note__c> upsertNotesMethod = new List<IT_Note__c>();

        if(notesRequest != null && notesRequest.size() > 0){
            for(IT_Note singleNotes : notesRequest){
                IT_Note__c newNote = new IT_Note__c();
            
                System.debug('singleNotes.IT_Progressive:: '+singleNotes.IT_Progressive);
                if(mapNotesSF != null && mapNotesSF.size() > 0 && mapNotesSF.Keyset().contains(singleNotes.IT_Client_Code+singleNotes.IT_Progressive)){
                    newNote = new IT_Note__c(Id = mapNotesSF.get(singleNotes.IT_Client_Code+singleNotes.IT_Progressive).Id);
                }    
                newNote.Name = singleNotes.IT_Title;
                newNote.IT_Progressive__c = singleNotes.IT_Progressive;
                newNote.IT_Client_Code__c = singleNotes.IT_Client_Code;
                newNote.IT_AC_Activity__c = singleNotes.IT_AC_Activity;
                newNote.IT_SF_Activity__c = singleNotes.IT_SF_Activity;
                newNote.IT_AC_Delivery__c = singleNotes.IT_AC_Delivery;
                newNote.IT_SF_Delivery__c = singleNotes.IT_SF_Delivery;
                newNote.IT_Note_Type__c = singleNotes.IT_Note_Type; 
                newNote.IT_Text_Notes__c = singleNotes.IT_Text_Notes;
                newNote.IT_Validity_Start_Date__c = singleNotes.IT_Validity_Start_Date;
                newNote.IT_Validity_End_Date__c = singleNotes.IT_Validity_End_Date;
                newNote.IT_AC_User__c = singleNotes.IT_AC_User;
                newNote.IT_Financial_Center__c = financialCenterObj.Id;

                System.debug('mapDisSF:: '+mapDisSF.Keyset());
                System.debug('singleNotes.IT_AC_Activity:: '+singleNotes.IT_AC_Activity);
                if(singleNotes.IT_SF_Delivery != null && mapDelSF != null && mapDelSF.size() > 0 && mapDelSF.keyset().contains(String.valueOf(singleNotes.IT_SF_Delivery)))
                    newNote.IT_Delivery_Site__c = mapDelSF.get(String.valueOf(singleNotes.IT_SF_Delivery)).Id;
                else if(singleNotes.IT_AC_Delivery != null && mapDelSF != null && mapDelSF.size() > 0 && mapDelSF.keyset().contains(String.valueOf(singleNotes.IT_AC_Delivery)))
                    newNote.IT_Delivery_Site__c = mapDelSF.get(String.valueOf(singleNotes.IT_AC_Delivery)).Id;      
                else if(!String.isBlank(singleNotes.IT_AC_Activity) && mapDisSF != null && mapDisSF.size() > 0 && mapDisSF.keyset().contains(singleNotes.IT_AC_Activity))    
                    newNote.IT_Distribution_Point__c = mapDisSF.get(singleNotes.IT_AC_Activity).Id;
                        
                upsertNotesMethod.add(newNote);
            }
        }    
        return upsertNotesMethod;
    }

    private static List<ER_Distribution_Point__c> updateDistributionFromDeleivery(List<IT_Delivery_Site> listDeliveries, Map<String, ER_Distribution_Point__c> mapDistributionSF, List<ER_Delivery_Site__c> listDeliverySF){
        List<ER_Distribution_Point__c> listDis = new List<ER_Distribution_Point__c>();
        ER_Distribution_Point__c updatedeistribution = new ER_Distribution_Point__c();
        String keyCode = '';  
        Map<String, ER_Delivery_Site__c> mapDeliverySF = new Map<String, ER_Delivery_Site__c>();
        for(ER_Delivery_Site__c sinDe :listDeliverySF) 
            mapDeliverySF.put(sinDe.IT_Delivery_AC__c, sinDe);

        System.debug('listDeliveries:: '+listDeliveries);
        for(IT_Delivery_Site sinfleDel : listDeliveries){
            if(sinfleDel.IT_Validity_End_Date == null){
                if(!String.isBlank(sinfleDel.IT_Activity_AC)) 
                    keyCode = sinfleDel.IT_Activity_AC;
                else
                    keyCode = sinfleDel.IT_Activity_SF;

                if(mapDistributionSF != null && mapDistributionSF.size() > 0 && mapDistributionSF.keyset().contains(keyCode)){
                    updatedeistribution = new ER_Distribution_Point__c(Id = mapDistributionSF.get(keyCode).Id);
                    updatedeistribution.ER_Delivery_Site__c = mapDeliverySF.get(sinfleDel.IT_Delivery_AC).Id;
                    listDis.add(updatedeistribution);
                }    
            }     
        }
        System.debug('listDis:: '+listDis);
        return listDis;     
    }

    /**
        * Mapping method for a single object
        * END
    */

    public class Request{
        public List<ER_Financial_Center> ER_Financial_Center;
    }

    public class ER_Financial_Center{
        public String IT_Client_Code;
        public String IT_Service;
        public String IT_Client_Status;                        //Picklist
        public String IT_VAT_Number;
        public Integer IT_Employee_Number;
        public Boolean IT_Single_Client_Multiactivity;
        public String IT_Client_Situation;                     //Picklist
        public String IT_Opening_Outcome;                      //Picklist
        public String IT_Concurrency;                          //Picklist
        public String IT_Beneficiary_Type;                     //Picklist
        public String IT_Previous_Code;
        public String IT_Fused_Client;
        public String IT_New_Code;
        public String IT_Associated_Client;
        public String IT_Company_Name;
        public String IT_Short_name;
        public String IT_Extended_Company_Name;
        public String IT_CIG;
        public String IT_Derived_CIG;
        public String IT_Circuit_Code;
        public String IT_Client_Type;                          //Picklist
        public String IT_Contact_Code;
        public String IT_Admin_Data_AC_User;
        public Date IT_Admin_Data_Validity_Start_Date;
        public Date IT_Admin_Data_Validity_End_Date;
        public String IT_Payment_Code;                      //Picklist
        public String IT_SDD_Payment_Code;                  //Picklist
        public String IT_Bank_Account_Code;
        public String IT_ABI;
        public String IT_CAB;
        public String IT_CC;
        public String IT_CIN;
        public String IT_Country;
        public String IT_Iban;
        public String IT_Check_Iban;
        public String IT_SDD_Contract_Code;
        public Date IT_SDD_Subscription_Date;                
        public String IT_SDD_Fiscal_Code;
        public String IT_Authorized;
        public String IT_Special_Billing_Type;                //Picklist
        public String IT_Commission_Type;
        public Decimal IT_Commission_Percentage;
        public String IT_Discount_Type;
        public Decimal IT_Discount_Percentage;
        public String IT_Fine_Interest_Type;
        public String IT_Not_Standard_VAT;
        public String IT_Transport_Cost;
        public String IT_No_Cost_Reason;
        public String IT_Promo_Code;
        public String IT_Invoice_Detail;
        public String IT_Invoice_Detraction;                  //Picklist
        public String IT_Send_SUT_Printout;
        public String IT_Debt_Notes;
        public Date IT_Debt_Notes_Effective_Date;
        public Decimal IT_Debt_Notes_Percentage;
        public String IT_Debt_Notes_Locale_Type;
        public Decimal IT_Expendia_Startup_Cost;
        public Integer IT_Number_of_Expendia_cards;
        public Decimal IT_Expendia_Monthly_Fee;
        public Decimal IT_Card_Amount;
        public Decimal IT_Flexben_Startup_Cost;
        public Date IT_Flexben_Startup_Date;
        public Decimal IT_Flexben_Fee_Cost;
        public Date IT_Flexben_Fee_Date;                  
        public String IT_Flexben_Fee_Frequency;
        public String IT_Billing_Frequency_UTA;               
        public Integer IT_Bond_UTA;                         
        public String IT_Accepts_New_Billing_System_PA;
        public String IT_Office_Code;
        public String IT_CUP_Code;
        public String IT_Order_Code;
        public String IT_EORI_Code;
        public String IT_Accepts_New_Billing_System;
        public String IT_SDI;
        public String IT_PEC_Mail;
        public String IT_Dont_Send_Debt_Note;
        public Integer IT_Particularities_Progressive_Number;
        public String IT_Contractual_Particularities;
        public String IT_Economic_AC_User;
        public Date IT_Economic_Validity_Start_Date;
        public Date IT_Economic_Validity_End_Date;
        public Decimal IT_Discount_Percentage_2;
        public Decimal IT_Discount_Percentage_3;
        public Date IT_Discount_Validity_Date_2;
        public Date IT_Discount_Validity_Date_3;
        public Decimal IT_Extradiscount_Percentage;
        public String IT_Type_Extradiscount;


        //Add address fields
        public List<IT_Contract> IT_Contract;
        public List<IT_Billable_Service> IT_Billable_Service;
        public List<IT_Distribution_Point> IT_Distribution_Point;
        public List<IT_Delivery_Site> IT_Delivery_Site;
        public List<IT_Group> IT_Group;
        public List<IT_Address> IT_Address;
        public List<IT_Additional_Expenses> IT_Additional_Expenses;
        public List<IT_Note> IT_Note;
    }

    public class IT_Contract{ 
        public String IT_Opportunity_Code;
        public String IT_Contract_Number;
        public Integer IT_Contract_Progressive;
        public String IT_Client_Code;
        public String IT_Attendance_Type;                             //Picklist
        public String IT_Contract_Renewal_Type;                       //Picklist
        public String IT_Contract_Type;                               //Picklist
        public String IT_Contract_Status;                             //Picklist
        public Date StartDate;
        public Date EndDate;
        public Date IT_Sign_Sending_Date;
        public Date IT_Contract_Sign_Date;
        public Date IT_Expiration_Contract_Date;
        public String IT_Contract_Closing_Type;                       //Picklist
        public String IT_Penal_Presence;
        public String IT_Delivery_Date_Bond;                          //Picklist
        public Integer IT_Delivery_Term;
        public String IT_Term_Type;                                   //Picklist
        public Integer IT_Delivery_Fixed_Day;
        public String IT_Fixed_Day_Type;                              //Picklist 
        public Integer IT_Order_Reception_Term;
        public String IT_Order_Reception_Term_Type;                   //Picklist
        public String IT_No_Sign_Activation_Authorization;
        public String IT_Reception_Type;                              //Picklist
        public String IT_No_Massive_Print;
        public String IT_Date_presence;
        public String IT_No_Date_Presence;
        public String IT_SDD_Payment;
        public String IT_Multidiscount;
        public String IT_Extradiscount;
        public String IT_No_Exclusivity;
        public Integer IT_Annual_Potential;
        public String IT_Renewal_Reason;                              //Picklist
        public String IT_Accepts_Privacy;
        public String IT_Framework_Head_Code;
        public String IT_Framework_Warrant;
        public String IT_Only_Client_Copy;
        public String IT_Supply_Conditions;
        public Date IT_Campaign_Start_Date;
        public Date IT_Campaing_End_Date;
        public String IT_Card_Cost;
        public String IT_Card_Cost_Billing_Type;                      //Picklist
        public String IT_Card_Cost_Billing_Frequency;                 //Picklist
        public String IT_Card_Cost_Billing_Rules;                     //Picklist 
        public Decimal IT_UTA_Monthly_Limit;
        public String IT_UTA_Offer_Type;                              //Picklist
        public Integer IT_UTA_Vehicles_Number;
        public String IT_AC_User;
    }  

    public class IT_Billable_Service{
        public String IT_Client_Code;
        public Integer IT_Technical_Data_Progressive;
        public String IT_Product;                                 //Picklist
        public String IT_Feedback_Type;                           //Picklist
        public String IT_Logo_Type;                               //Picklist
        public String IT_Feedback_Request;
        public String IT_Ticket_Type;
        public String IT_Font_Type;                               //Picklist
        public String IT_Order_Receipts_Type;                     //Picklist
        public String IT_Order_Frequence_Type;                    //Picklist
        public String IT_Single_Series_Emission;
        public String IT_Ticket_Return_Request;
        public String IT_Itinerant_Client;
        public String IT_Ticket_Display;
        public String IT_No_Ads;
        public String IT_No_Insert;
        public String IT_Display_Locale;
        public String IT_Display_Address;
        public String IT_Display_Active_Name;
        public String IT_Address_Row_Display;
        public String IT_Amount_Display;
        public Boolean IT_Ticket_Value;
        public Decimal IT_Amount;
        public String IT_Logo_Code;                               //Picklist
        public String IT_Business_Association_Logo_Type;          //Picklist
        public String IT_Business_Association_Font_Type;          //Picklist
        public String IT_Business_Association_Logo_Code;          //Picklist
        public Integer IT_Printout_Employee_Copies_Number;
        public Integer IT_Emitted_Ticket_Copies_Number;
        public String IT_Card_Type;                               //Picklist
        public String IT_Web_Enabling_Level;                      //Picklist
        public String IT_File_Sending_Authorization;
        public String IT_Front_and_Back_Printout;
        public String IT_Stock_Orders;
        public String IT_Graphic_Layer_Front;
        public String IT_Graphic_Layer_Back;
        public String IT_Graphic_Background_Front;
        public String IT_Graphic_Background_Back;
        public String IT_Envelope;
        public String IT_Data_on_Address_Row;
        public Boolean IT_Activity_Exception;                                //Picklist
        public String IT_AC_User;
        public Date IT_Validity_Start_Date;
        public Date IT_Validity_End_Date; 
    }
    
    public class IT_Group {
        public String IT_Group_Code;
        public String IT_Group_Type;
        public String IT_Client_Code;
        public String IT_AC_User;
        public Date IT_Validity_Start_Date;
        public Date IT_Validity_End_Date;
    }

    public class IT_Delivery_Site{
        public String IT_Client_Code;
        public String IT_Delivery_AC;
        public String IT_Delivery_SF;
        public String IT_Activity_AC;
        public String IT_Activity_SF;
        public String IT_Delivery_Type;            //Picklist
        public Boolean IT_Delivery_Point;
        public String IT_Branch;                   //Picklist
        public String IT_Provider;
        public String IT_Vehicle;
        public String IT_Vehicle_Forcing;
        public String IT_Special_Service;          //Picklist
        public Integer IT_Matched_Delivery;
        public String IT_Notes_type;
        public String IT_Notes;
        public String IT_Text;
        public String IT_AC_User;
        public Date IT_Validity_Start_Date;
        public Date IT_Validity_End_Date;
        public Date IT_Note_Validity_Start_Date;
        public Date IT_Note_Validity_End_Date;
    }

    public class IT_Distribution_Point{
        public String IT_Client_Code;
        public String IT_AC_Activity;
        public String IT_SF_Activity;
        public String IT_Suspension;
        public String IT_Cancellation;
        public String IT_Cancellation_Type;
        public Integer IT_Employees_Number;
        public Integer IT_Technical_Data_Progressive;
        public String IT_Contact_Code;
        public String IT_Cost_Center;
        public String IT_Free_Description_to_Display;
        public String IT_Address_to_Display;
        public String IT_Locality_to_Display;
        public String IT_Naming_to_Display;
        public Integer IT_Raw_Number_for_Display;
        public String IT_Data_to_Display;
        public String IT_Data_Type_to_Display;                //Picklist
        public String IT_AC_User;
        public Date IT_Validity_Start_Date;
        public Date IT_Validity_End_Date;
        public Date IT_Cost_Center_End_Date;
        public Date IT_Suspension_Start_Date;
        public Date IT_Suspension_End_Date;
        public String IT_Authorization_Suspension_User_Text;
        public String IT_Authorization_Reactivation_User_Text;
        public String IT_Suspension_Reason;
        public String IT_Notes_Type;
        public String IT_Notes;
        public Date IT_Note_Validity_Start_Date;
        public Date IT_Note_Validity_End_Date;
    }

    public class IT_Address{
        public String IT_Client_Code;
        public String IT_Ticket_Naming;
        public String IT_Province;
        public String IT_Toponym;
        public String IT_Street;
        public String IT_Short_Address;
        public String IT_Street_Number;
        public String IT_Postal_Code;
        public String IT_City;
        public String IT_Hamlet;
        public String IT_Additional_Locality;
        public String IT_State_Code;
        public String IT_City_Code;
        public String IT_Hamlet_Code;
        public String IT_Sestiere_Code;
        public String IT_Street_Code;
        public String IT_Road_Arch_Code;
        public String IT_MetRef_Loc_X;
        public String IT_MetRef_Loc_Y;
        public String IT_GeoRef_Loc_X;
        public String IT_GeoRef_Loc_Y;
        public String IT_Extra_Urban_Specifications;
        public String IT_Zone;
        public String IT_AC_User;
        public Date IT_Validity_Start_Date;
        public Date IT_Validity_End_Date; 
        public List<IT_AddressType> IT_AddressType;  
    }

    public class IT_AddressType {
        public String IT_Type;
        public String IT_Delivery_AC;
        public String IT_Delivery_SF;
        public String IT_Activity_AC;
        public String IT_Activity_SF;    
    }

    public class IT_Additional_Expenses {
        public Integer IT_Progressive;
        public String IT_Client_Code;
        public String IT_Code;
        public Decimal IT_Amount;
        public String IT_Calculation_Type; 
        public String IT_AC_User; 
        public Date IT_Validity_Start_Date; 
        public Date IT_Validity_End_Date;    
    }

    public class IT_Note {
        public Integer IT_Progressive;
        public String IT_Client_Code;
        public String IT_AC_Activity;
        public String IT_SF_Activity;
        public Integer IT_AC_Delivery;
        public Integer IT_SF_Delivery;
        public String IT_Note_Type; 
        public String IT_Title;
        public String IT_Text_Notes; 
        public Date IT_Validity_Start_Date; 
        public Date IT_Validity_End_Date; 
        public String IT_AC_User;   
    }

    global class response {
        public String statusCode;
        public String financialCenter_CD; 
        public String sfdc_ID;
        public String errorDescription;    
    }

}