@RestResource(urlMapping='/ac_account/*') 
global with sharing class WSIT04_ACVatGroupWS {
    @HttpPut
    global static List<response> AnagraficaClientiUpsert() {
        Map<String, response> mapError = new Map<String, response>();
        List<response> respList = new List<response>();
        Map<String, Account> mapAllAccount = new Map<String, Account>();
        Set<String> accountVatNumber = new Set<String>();  
        List<Account> listAllAccount = new List<Account>(); 
        String body = System.RestContext.request.requestBody.toString();
        Map<String, Contact> mapContacts = new Map<String, Contact>(); 
        Request req = (Request) JSON.deserializeStrict(body, Request.class);
        system.debug('req::: '+req); 
        system.debug('req.VatGroup::: '+req.IT_VatGroup);

        for(IT_VatGroup singleVatQuery : req.IT_VatGroup){
            List<IT_Account> accountList = new List<IT_Account>();
            accountList = singleVatQuery.IT_Account;
            for(IT_Account singleAccount : accountList){
                accountVatNumber.add(singleAccount.ER_VAT_Number);
            }
        }

        if(accountVatNumber != null && accountVatNumber.size() > 0)
            listAllAccount = [Select Id, Name, IT_VAT_Group_AC_User__c, IT_Private_work_for_institution__c, BillingPostalCode, IT_State_Code__c, IT_VAT_Group_Naming__c, IT_VAT_Group_PEC__c, IT_VAT_Group_SDI__c, IT_VAT_Group_Start_Date__c, IT_Vat_Group_End_Date__c,  ER_VAT_Number__c, IT_Foreign_VAT_Number__c, IT_Fiscal_Code__c, ER_Legal_Name__c, IT_Legal_Form__c, ER_Segment__c, IT_Industry__c, NumberOfEmployees, Website, IT_Company_Type__c, IT_Split_Payment__c, IT_Group_VAT_Number__c, IT_Invoice_Naming__c, BillingState, IT_Toponym__c, BillingStreet, IT_Short_Address__c, BillingCity, IT_Hamlet__c, IT_Additional_Locality__c, IT_City_Code__c, IT_Hamlet_Code__c, IT_Sestiere_Code__c, IT_Street_Code__c, IT_Road_Arch_Code__c, IT_MetRef_Loc_X__c, IT_MetRef_Loc_Y__c, BillingLongitude, BillingLatitude, IT_Extra_Urban_Specifications__c, IT_AC_User__c, IT_Address_Validity_Start_Date__c, IT_Address_Validity_End_Date__c, IT_Validity_Start_Date__c, IT_Validity_End_Date__c, (Select Id, Name, IT_Fiscal_Code__c, IT_Validity_Year__c, IT_Progressive__c, IT_Declaration_Number__c, IT_Type__c, IT_Presentation_Date__c, IT_Exporter_Type__c, IT_Operation_Type__c, IT_Declared_Amount__c, IT_AC_User__c, IT_Validity_Start_Date__c, IT_Validity_End_Date__c From Intent_declaration__r), (Select Id From Contacts Where IT_Type__c = 'Soc') From Account Where ER_VAT_Number__c IN : accountVatNumber];
        for(Account sinAcc : listAllAccount){
            mapAllAccount.put(sinAcc.ER_VAT_Number__c, sinAcc);
            List<Contact> listContUpSingle = new List<Contact>();
            listContUpSingle = sinAcc.Contacts;
            if(listContUpSingle != null && listContUpSingle.Size() > 0){
                mapContacts.put(sinAcc.ER_VAT_Number__c, listContUpSingle[0]);
            }
        }

        system.debug('req.IT_VatGroup::: '+req.IT_VatGroup.size());
        for(IT_VatGroup singleVatGroup : req.IT_VatGroup){
            system.debug('req.IT_Account::: '+singleVatGroup.IT_Account.size());
            for(IT_Account singleAccount : singleVatGroup.IT_Account){ 
                system.debug('req.IT_Intent_Declaration::: '+singleAccount.IT_Intent_Declaration);
                Savepoint sp = Database.setSavepoint();
                try{
                    if(String.isblank(singleAccount.ER_VAT_Number)){
                        response responseService = new response();
                        responseService = populateResponseError(singleAccount.ER_VAT_Number, 'Required Field Missing ER_VAT_Number'); 
                        if(!mapError.Keyset().contains(singleAccount.ER_VAT_Number))
                            mapError.put(singleAccount.ER_VAT_Number, responseService);  
                    }
                    if(String.isblank(singleAccount.IT_Fiscal_Code)){
                        response responseService = new response();
                        responseService = populateResponseError(singleAccount.ER_VAT_Number, 'Required Field Missing IT_Fiscal_Code'); 
                        if(!mapError.Keyset().contains(singleAccount.ER_VAT_Number))
                            mapError.put(singleAccount.ER_VAT_Number, responseService);  
                    }
                    if(String.isblank(singleAccount.ER_Legal_Name)){
                        response responseService = new response();
                        responseService = populateResponseError(singleAccount.ER_VAT_Number, 'Required Field Missing ER_Legal_Name'); 
                        if(!mapError.Keyset().contains(singleAccount.ER_VAT_Number))
                            mapError.put(singleAccount.ER_VAT_Number, responseService);  
                    }
                    if(singleAccount.IT_Validity_Start_Date == null){
                        response responseService = new response();
                        responseService = populateResponseError(singleAccount.ER_VAT_Number, 'Required Field Missing IT_Validity_Start_Date'); 
                        if(!mapError.Keyset().contains(singleAccount.ER_VAT_Number))
                            mapError.put(singleAccount.ER_VAT_Number, responseService);  
                    }
                    /*if(singleAccount.IT_Validity_End_Date == null){
                        response responseService = new response();
                        responseService = populateResponseError(singleAccount.ER_VAT_Number, 'Required Field Missing IT_Validity_End_Date'); 
                        if(!mapError.Keyset().contains(singleAccount.ER_VAT_Number))
                            mapError.put(singleAccount.ER_VAT_Number, responseService);  
                    }*/
                    
                    if(!mapError.Keyset().contains(singleAccount.ER_VAT_Number)){
                        Map<Id,Account> MyMapFromObject = new Map<Id,Account>(listAllAccount);
                        //Upsert Acccount - Start
                        Account upsertAccount = new Account();
                        Account accountControl = new Account();
                        if(mapAllAccount.Keyset().contains(singleAccount.ER_VAT_Number)){
                            accountControl = mapAllAccount.get(singleAccount.ER_VAT_Number);   
                        }
                        upsertAccount = populateAccount(accountControl, singleAccount, singleVatGroup);
                        system.debug('upsertAccountComplete::: '+upsertAccount);
                        if(upsertAccount != null){
                            Contact contactSOC = new Contact();
                            if(mapContacts.keySet().contains(upsertAccount.ER_VAT_Number__c))
                                contactSOC = new Contact(Id = mapContacts.get(upsertAccount.ER_VAT_Number__c).Id);

                            contactSOC.IT_Type__c = 'Soc';
                            contactSOC.LastName = upsertAccount.ER_Legal_Name__c;
                            contactSOC.IT_Code__c = upsertAccount.ER_VAT_Number__c;

                            upsert upsertAccount;
                            contactSOC.AccountId = upsertAccount.Id;
                            upsert contactSOC;  
                        }    
                        //Upsert Account - End   
                        response responseService = new response(); 
                        responseService.statusCode = '200'; 
                        responseService.account_CD = singleAccount.ER_VAT_Number;
                        responseService.sfdc_ID = upsertAccount.Id;
                        responseService.ErrorDescription = ''; 
                        respList.add(responseService);

                        if(singleAccount.IT_Intent_Declaration != null){
                            Map<String, IT_Intent_Declaration__c> sfIntentDeclartion = new Map<String, IT_Intent_Declaration__c>();
                            List<IT_Intent_Declaration__c> upsertIntentDeclaration = new List<IT_Intent_Declaration__c>();
                            if(MyMapFromObject != null && MyMapFromObject.keyset().contains(upsertAccount.Id) && MyMapFromObject.get(upsertAccount.Id).Intent_declaration__r != null){
                                for(IT_Intent_Declaration__c singleInetentDec : MyMapFromObject.get(upsertAccount.Id).Intent_declaration__r){
                                    sfIntentDeclartion.put(singleInetentDec.IT_Fiscal_Code__c+singleInetentDec.IT_Progressive__c, singleInetentDec);
                                }
                            }
                            upsertIntentDeclaration = populateIntentDeclaration(singleAccount.IT_Intent_Declaration, sfIntentDeclartion, upsertAccount);
                            if(upsertIntentDeclaration != null && upsertIntentDeclaration.size() > 0){  
                                upsert upsertIntentDeclaration;
                            }    
                        }
                    }else{
                        response responseServiceErr = new response(); 
                        responseServiceErr = mapError.get(singleAccount.ER_VAT_Number); 
                        respList.add(responseServiceErr);        
                    }

                }catch(Exception ecc){
                    System.debug('Error WSIT04_ACVatGroupWS: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                    Integer singleResponse = 0;
                    while (singleResponse < respList.size()){
                        if(respList.get(singleResponse).account_CD == singleAccount.ER_VAT_Number){
                            respList.remove(singleResponse);
                        }else{
                            singleResponse++;
                        }
                    }

                    response responseServiceCatch = new response(); 
                    responseServiceCatch.statusCode = '400';   
                    responseServiceCatch.errorDescription = ecc.getMessage();
                    responseServiceCatch.account_CD = singleAccount.ER_VAT_Number;
                    responseServiceCatch.sfdc_ID = '';
                    respList.add(responseServiceCatch);

                    Database.rollback(sp);
                }
            }    
        }   

        return respList;    
    }

    private static response populateResponseError(String vatNumberAccount, String errorField){
        response responseService = new response(); 
        responseService.statusCode = '400'; 
        responseService.account_CD = vatNumberAccount;
        responseService.sfdc_ID = '';
        responseService.ErrorDescription = errorField;
        return responseService;
    }

    private static Account populateAccount(Account accountObj, IT_Account accountRequest, IT_VatGroup vatGroupRequest){
        Account upsertAccounttMethod = new Account();
        if(accountObj != null && accountObj != new Account())
            upsertAccounttMethod = new Account(Id = accountObj.Id);    

        upsertAccounttMethod.Name = accountRequest.ER_Legal_Name;
        upsertAccounttMethod.ER_VAT_Number__c = accountRequest.ER_VAT_Number;
        if(accountRequest.IT_Foreign_VAT_Number != null)
            upsertAccounttMethod.IT_Foreign_VAT_Number__c = accountRequest.IT_Foreign_VAT_Number;
        upsertAccounttMethod.IT_Fiscal_Code__c = accountRequest.IT_Fiscal_Code;
        upsertAccounttMethod.ER_Legal_Name__c = accountRequest.ER_Legal_Name;
        upsertAccounttMethod.IT_Legal_Form__c = accountRequest.IT_Legal_Form;
        upsertAccounttMethod.ER_Segment__c = accountRequest.ER_Segment;
        upsertAccounttMethod.IT_Industry__c = accountRequest.IT_Industry;
        upsertAccounttMethod.NumberOfEmployees = accountRequest.NumberOfEmployees;
        upsertAccounttMethod.Website = accountRequest.Website;
        upsertAccounttMethod.Type = 'Client';

        upsertAccounttMethod.IT_Company_Type__c = accountRequest.IT_Company_Type;
        if(accountRequest.IT_Institution && !accountRequest.IT_Private_work_for_institution){
            upsertAccounttMethod.IT_Company_Type__c = 'Institution';
        }else if(!accountRequest.IT_Institution && !accountRequest.IT_Private_work_for_institution){
            upsertAccounttMethod.IT_Company_Type__c = 'Private';
        }else if(!accountRequest.IT_Institution && accountRequest.IT_Private_work_for_institution){
            upsertAccounttMethod.IT_Company_Type__c = 'Private (work for Institution)';
        }

        if(accountRequest.IT_NSO != null)
            upsertAccounttMethod.IT_NSO__c = accountRequest.IT_NSO;
        if(accountRequest.IT_Display_VAT_Group != null)    
            upsertAccounttMethod.IT_Display_VAT_Group__c = accountRequest.IT_Display_VAT_Group;
        if(accountRequest.IT_Send_Client_Billing_SDI != null)
            upsertAccounttMethod.IT_Send_Client_Billing_SDI__c = accountRequest.IT_Send_Client_Billing_SDI;

        if(accountRequest.IT_Split_Payment != null)
            upsertAccounttMethod.IT_Split_Payment__c = accountRequest.IT_Split_Payment;
        upsertAccounttMethod.IT_Invoice_Naming__c = accountRequest.IT_Invoice_Naming;
        upsertAccounttMethod.IT_Private_work_for_institution__c = accountRequest.IT_Private_work_for_institution;
        upsertAccounttMethod.IT_Zone__c = accountRequest.IT_Zone;
        upsertAccounttMethod.IT_AC_User__c = accountRequest.IT_AC_User;
        if(accountRequest.IT_Validity_Start_Date != null)
            upsertAccounttMethod.IT_Validity_Start_Date__c = accountRequest.IT_Validity_Start_Date;
        if(accountRequest.IT_Validity_End_Date != null)    
            upsertAccounttMethod.IT_Validity_End_Date__c = accountRequest.IT_Validity_End_Date;

        if(vatGroupRequest != null){
            upsertAccounttMethod.IT_VAT_Group_AC_User__c = vatGroupRequest.IT_AC_User;
            upsertAccounttMethod.IT_VAT_Group_Naming__c = vatGroupRequest.IT_VAT_Group_Naming;
            upsertAccounttMethod.IT_VAT_Group_PEC__c = vatGroupRequest.IT_VAT_Group_PEC;
            upsertAccounttMethod.IT_VAT_Group_SDI__c = vatGroupRequest.IT_VAT_Group_SDI;
            if(vatGroupRequest.IT_START_Date != null)   
                upsertAccounttMethod.IT_VAT_Group_Start_Date__c = vatGroupRequest.IT_START_Date;
            if(vatGroupRequest.IT_END_Date != null)       
                upsertAccounttMethod.IT_Vat_Group_End_Date__c = vatGroupRequest.IT_END_Date;
            upsertAccounttMethod.IT_Group_VAT_Number__c = accountRequest.IT_VAT_Group;
        }

        upsertAccounttMethod.BillingState = accountRequest.IT_Province;
        upsertAccounttMethod.IT_Toponym__c = accountRequest.IT_Toponym;
        upsertAccounttMethod.BillingStreet = accountRequest.IT_Street+', '+accountRequest.IT_Street_Number;
        upsertAccounttMethod.IT_Short_Address__c = accountRequest.IT_Short_Address;
        upsertAccounttMethod.BillingPostalCode = accountRequest.IT_Postal_Code;
        upsertAccounttMethod.BillingCity = accountRequest.IT_City;
        upsertAccounttMethod.IT_Hamlet__c = accountRequest.IT_Hamlet;
        upsertAccounttMethod.IT_Additional_Locality__c = accountRequest.IT_Additional_Locality;
        upsertAccounttMethod.IT_State_Code__c = accountRequest.IT_State_Code;
        upsertAccounttMethod.IT_City_Code__c = accountRequest.IT_City_Code;
        upsertAccounttMethod.IT_Hamlet_Code__c = accountRequest.IT_Hamlet_Code;
        upsertAccounttMethod.IT_Sestiere_Code__c = accountRequest.IT_Sestiere_Code;
        upsertAccounttMethod.IT_Street_Code__c = accountRequest.IT_Street_Code;
        upsertAccounttMethod.IT_Road_Arch_Code__c = accountRequest.IT_Road_Arch_Code;
        upsertAccounttMethod.IT_MetRef_Loc_X__c = accountRequest.IT_MetRef_Loc_X;
        upsertAccounttMethod.IT_MetRef_Loc_Y__c = accountRequest.IT_MetRef_Loc_Y;
        if(accountRequest.IT_GeoRef_Loc_X != null)
            upsertAccounttMethod.BillingLongitude = Decimal.valueOf(accountRequest.IT_GeoRef_Loc_X);
        if(accountRequest.IT_GeoRef_Loc_Y != null )    
            upsertAccounttMethod.BillingLatitude = Decimal.valueOf(accountRequest.IT_GeoRef_Loc_Y); 
        upsertAccounttMethod.IT_Extra_Urban_Specifications__c = accountRequest.IT_Extra_Urban_Specifications;
        
        return upsertAccounttMethod;
    }

    private static List<IT_Intent_Declaration__c> populateIntentDeclaration(List<IT_Intent_Declaration> intentDeclarationRequest, Map<String, IT_Intent_Declaration__c> mapObjectLookup, Account AccObj){
        List<IT_Intent_Declaration__c> upsertIntentDecListMethod = new List<IT_Intent_Declaration__c>();
        for(IT_Intent_Declaration singleIDecRequest : intentDeclarationRequest){
            IT_Intent_Declaration__c upsertIntentDecMethod = new IT_Intent_Declaration__c();
            if(mapObjectLookup != null && mapObjectLookup.keyset().contains(singleIDecRequest.IT_Fiscal_Code+singleIDecRequest.IT_Progressive))
                upsertIntentDecMethod = new IT_Intent_Declaration__c(Id = mapObjectLookup.get(singleIDecRequest.IT_Fiscal_Code+singleIDecRequest.IT_Progressive).Id);

            upsertIntentDecMethod.Name = singleIDecRequest.IT_Declaration_Number;
            upsertIntentDecMethod.IT_Fiscal_Code__c = singleIDecRequest.IT_Fiscal_Code;
            upsertIntentDecMethod.IT_Validity_Year__c = singleIDecRequest.IT_Validity_Year;
            upsertIntentDecMethod.IT_Progressive__c = singleIDecRequest.IT_Progressive;
            upsertIntentDecMethod.IT_Declaration_Number__c = singleIDecRequest.IT_Declaration_Number;
            upsertIntentDecMethod.IT_Type__c = singleIDecRequest.IT_Type;
            upsertIntentDecMethod.IT_Presentation_Date__c = singleIDecRequest.IT_Presentation_Date;
            upsertIntentDecMethod.IT_Exporter_Type__c = singleIDecRequest.IT_Exporter_Type;
            upsertIntentDecMethod.IT_Operation_Type__c = singleIDecRequest.IT_Operation_Type;
            upsertIntentDecMethod.IT_Declared_Amount__c = singleIDecRequest.IT_Declared_Amount;
            upsertIntentDecMethod.IT_AC_User__c = singleIDecRequest.IT_AC_User;
            if(singleIDecRequest.IT_Validity_Start_Date != null)       
                upsertIntentDecMethod.IT_Validity_Start_Date__c = singleIDecRequest.IT_Validity_Start_Date;
            if(singleIDecRequest.IT_Validity_End_Date != null)           
                upsertIntentDecMethod.IT_Validity_End_Date__c = singleIDecRequest.IT_Validity_End_Date;
            if(AccObj != null)
                upsertIntentDecMethod.IT_Account__c = AccObj.Id;
                
            upsertIntentDecListMethod.add(upsertIntentDecMethod);    
        }        
        
        return upsertIntentDecListMethod;
    }

    public class Request{
        public list<IT_VatGroup> IT_VatGroup;    
    }

    global class response {
        public String statusCode;
        public String account_CD; 
        public String sfdc_ID;
        public String errorDescription;    
    }
    
    public class IT_VatGroup{
        public String IT_VAT_Number_Group;
        public String IT_VAT_Group_Naming;
        public String IT_VAT_Group_PEC;
        public String IT_VAT_Group_SDI;
        public String IT_AC_User;
        public Date IT_START_Date;
        public Date IT_END_Date;
        public List<IT_Account> IT_Account;
    }

    public class IT_Account{
        public String ER_VAT_Number;
        public Boolean IT_Foreign_VAT_Number;
        public String IT_Fiscal_Code;
        public String ER_Legal_Name;
        public String IT_Legal_Form;                       //Picklist
        public String ER_Segment;                          //Picklist
        public String IT_Industry;                         //Picklist
        public Integer NumberOfEmployees;
        public String Website;
        public String IT_Company_Type;                     //Picklist
        public Boolean IT_Split_Payment;
        public String IT_VAT_Group;
        public String IT_Invoice_Naming;
        public String IT_Province;
        public String IT_Toponym;
        public String IT_Street;
        public String IT_Short_Address;
        public String IT_Street_Number;
        public String IT_Postal_Code;
        public String IT_State_Code;
        public String IT_City;
        public String IT_Hamlet;
        public String IT_Additional_Locality;
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
        public Boolean IT_NSO;
        public Boolean IT_Display_VAT_Group;
        public Boolean IT_Send_Client_Billing_SDI;
        public Boolean IT_Private_work_for_institution;
        public Boolean IT_Institution;
        public String IT_Zone;
        public String IT_AC_User;
        public Date IT_Validity_Start_Date;
        public Date IT_Validity_End_Date;              
        public List<IT_Intent_Declaration> IT_Intent_Declaration; 
    }

    public class IT_Intent_Declaration{
        public String IT_Fiscal_Code;
        public String IT_Validity_Year;
        public String IT_Progressive;
        public String IT_Declaration_Number;
        public String IT_Type;                      //picklist
        public Date IT_Presentation_Date;
        public String IT_Exporter_Type;             //picklist
        public String IT_Operation_Type;            //picklist
        public Decimal IT_Declared_Amount;
        public String IT_AC_User;
        public Date IT_Validity_Start_Date;
        public Date IT_Validity_End_Date;
    }
}