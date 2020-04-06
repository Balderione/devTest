@RestResource(urlMapping='/smartcard/*')
global class WSIT01_SmartcardWS {
    @HttpPut
    global static List<response> SmartCardUpsert() {
        Map<String, response> mapError = new Map<String, response>();
        List<response> respList = new List<response>(); 
        String body = System.RestContext.request.requestBody.toString();
        system.debug('bodyRequest::: '+body);  
        Circuito listCircuit = (Circuito) JSON.deserializeStrict(body, Circuito.class);
        List<IT_Circuit_Product> cirProdControl = new List<IT_Circuit_Product>();
        List<IT_Level> cirLevelControl = new List<IT_Level>();
        Map<String, IT_Circuit__c> mapAllCircuit = new Map<String, IT_Circuit__c>();
        Map<String, ER_Financial_Center__c> mapLevelFc = new Map<String, ER_Financial_Center__c>();
        Set<String> fCFromLevel = new Set<String>();
        List<ER_Financial_Center__c> listFC = new List<ER_Financial_Center__c>();
        
        List<IT_Circuit__c> listAllCircuit = new List<IT_Circuit__c>();
        List<String> listAllCircuitCode = new List<String>();
        for(IT_Circuit singleCircuitQuery : listCircuit.IT_Circuit){
            listAllCircuitCode.add(singleCircuitQuery.IT_Circuit_Code);
            List<IT_Level> circLevel = new List<IT_Level>();
            circLevel = singleCircuitQuery.IT_level;
            for(IT_Level singleLevelCirc : circLevel){
                fCFromLevel.add(singleLevelCirc.IT_Client_Code);
            }
        }
        if(listAllCircuitCode != null && listAllCircuitCode.size() > 0)
            listAllCircuit = [Select Id, IT_Account__c, IT_Circuit_Code__c, Name, IT_Receipt_Circuit_Name__c, IT_Start_Connection_Date__c, IT_End_Connection_Date__c, IT_Agreement_Type__c,IT_Meal_Day__c,(Select Id, IT_Circuit__c, IT_Circuit_Code__c, IT_Level_1__c, IT_Level_1_Description__c, IT_Level_2__c, IT_Level_2_Description__c, IT_Level_3__c, IT_Employee_Type__c, IT_Client_Code__c, IT_Particular_Client_Code__c, IT_Service__c, IT_Circuit_Type__c, IT_Service_Type__c From Levels__r), (Select Id, IT_Circuit_Code__c, IT_Employee_Code__c, IT_Employee_First_Name__c, IT_Employee_Last_Name__c, IT_Level_1__c, IT_Level_2__c, IT_Level_3__c From Employees__r), (Select Id, IT_Circuit_Code__c, IT_Employee_Code__c, IT_Status_Code__c, ER_Card_Operational_System_ID__c From Assets__r), (Select Id, IT_Circuit_Code__c, IT_Service__c, IT_Service_Type__c, IT_Circuit_Type__c, IT_Invoice_Type__c, IT_Management_Type__c, IT_Circularity__c From Circuits_Product__r) From IT_Circuit__c Where IT_Circuit_Code__c IN : listAllCircuitCode];
        
        if(listAllCircuit != null && listAllCircuit.size() > 0){
            for(IT_Circuit__c sinCirc : listAllCircuit){
                if(sinCirc.Levels__r != null && sinCirc.Levels__r.size() > 0){
                    for(IT_Level__c sinLevel : sinCirc.Levels__r){
                        fCFromLevel.add(sinLevel.IT_Client_Code__c);
                    }
                }    
            }    
        }
        
        if(fCFromLevel != null && fCFromLevel.size() > 0)
            listFC = [Select Id, Name, IT_Financial_Center__c, ER_Account_Name__c From ER_Financial_Center__c Where IT_Financial_Center__c IN : fCFromLevel];

        system.debug('listAllCircuitCode::: '+listAllCircuitCode);
        system.debug('listAllCircuit::: '+listAllCircuit);

        for(ER_Financial_Center__c sinItem : listFC){
            mapLevelFc.put(sinItem.IT_Financial_Center__c, sinItem);
        }

        for(IT_Circuit__c recordCircuit: listAllCircuit) {
            mapAllCircuit.put(recordCircuit.IT_Circuit_Code__c, recordCircuit);
        } 

        
        for(IT_Circuit singleCircuit : listCircuit.IT_Circuit){
            Savepoint sp = Database.setSavepoint();
            try{
                //Fields Required Control - Start 
                if(singleCircuit.IT_Circuit_Product != null && singleCircuit.IT_Circuit_Product.size() > 0){
                    cirProdControl = singleCircuit.IT_Circuit_Product;
                    for(IT_Circuit_Product sinWrapper : cirProdControl){ 
                        if(String.isblank(sinWrapper.IT_Circuit_Code)){
                            response responseService = new response();
                            responseService = populateResponseError(singleCircuit.IT_Circuit_Code, 'Required Field Missing IT_Circuit_Code'); 
                            if(!mapError.Keyset().contains(singleCircuit.IT_Circuit_Code))
                                mapError.put(singleCircuit.IT_Circuit_Code, responseService);  
                        }
                        if(String.isblank(sinWrapper.IT_Service_Type) || (!String.isblank(sinWrapper.IT_Service_Type) && sinWrapper.IT_Service_Type.length() > 2)){
                            response responseService = new response();
                            if(String.isblank(sinWrapper.IT_Service_Type)) 
                                responseService = populateResponseError(singleCircuit.IT_Circuit_Code, 'Required Field Missing IT_Service_Type');
                            else 
                                responseService = populateResponseError(singleCircuit.IT_Circuit_Code, 'STRING TOO LONG: IT_Service_Type max 2 character');
                             
                            if(!mapError.Keyset().contains(singleCircuit.IT_Circuit_Code))
                                mapError.put(singleCircuit.IT_Circuit_Code, responseService);  
                        }
                    }
                }
                if(singleCircuit.IT_Level != null && singleCircuit.IT_Level.size() > 0){
                    cirLevelControl =  singleCircuit.IT_Level;
                    for(IT_Level sinWrapperLevel : cirLevelControl){ 
                        if(String.isblank(sinWrapperLevel.IT_Circuit_Code)){
                            response responseService = new response(); 
                            responseService = populateResponseError(singleCircuit.IT_Circuit_Code, 'Required Field Missing IT_Circuit_Code');
                            if(!mapError.Keyset().contains(singleCircuit.IT_Circuit_Code))
                                mapError.put(singleCircuit.IT_Circuit_Code, responseService);  
                        } 
                        if(String.isblank(sinWrapperLevel.IT_Level_1)){
                            response responseService = new response(); 
                            responseService = populateResponseError(singleCircuit.IT_Circuit_Code, 'Required Field Missing IT_Level_1');
                            if(!mapError.Keyset().contains(singleCircuit.IT_Circuit_Code))
                                mapError.put(singleCircuit.IT_Circuit_Code, responseService);  
                        }
                        if(String.isblank(sinWrapperLevel.IT_Level_2)){
                            response responseService = new response(); 
                            responseService = populateResponseError(singleCircuit.IT_Circuit_Code, 'Required Field Missing IT_Level_2');
                            if(!mapError.Keyset().contains(singleCircuit.IT_Circuit_Code))
                                mapError.put(singleCircuit.IT_Circuit_Code, responseService);  
                        }
                        if(String.isblank(sinWrapperLevel.IT_Level_3)){
                            response responseService = new response(); 
                            responseService = populateResponseError(singleCircuit.IT_Circuit_Code, 'Required Field Missing IT_Level_3');
                            if(!mapError.Keyset().contains(singleCircuit.IT_Circuit_Code))
                                mapError.put(singleCircuit.IT_Circuit_Code, responseService);  
                        }
                        if(!String.isblank(sinWrapperLevel.IT_Client_Code) && !mapLevelFc.keyset().contains(sinWrapperLevel.IT_Client_Code)){
                            response responseService = new response(); 
                            responseService = populateResponseError(singleCircuit.IT_Circuit_Code, 'Financial Center '+sinWrapperLevel.IT_Client_Code+' is not present in the system');
                            if(!mapError.Keyset().contains(singleCircuit.IT_Circuit_Code))
                                mapError.put(singleCircuit.IT_Circuit_Code, responseService);  
                        }  
                    }    
                }  
                
                //Fields Required Control - End   
                if(!mapError.Keyset().contains(singleCircuit.IT_Circuit_Code)){
                    //Upsert Circuit - Start
                    IT_Circuit__c upsertCircuit = new IT_Circuit__c();
                    IT_Circuit__c circuitControl = new IT_Circuit__c();
                    if(mapAllCircuit.Keyset().contains(singleCircuit.IT_Circuit_Code)){
                        circuitControl = mapAllCircuit.get(singleCircuit.IT_Circuit_Code);   
                    }
                    upsertCircuit = populateCircuit(circuitControl, singleCircuit);
                    system.debug('upsertCircuitComplete::: '+upsertCircuit);
                    if(upsertCircuit != null)
                        upsert upsertCircuit;
                    //Upsert Circuit - End   
                    response responseService = new response(); 
                    responseService.statusCode = '200'; 
                    responseService.circ_CD = singleCircuit.IT_Circuit_Code;
                    responseService.sfdc_ID = upsertCircuit.Id;
                    responseService.ErrorDescription = ''; 
                    respList.add(responseService);
                    // Map for select chields on parent contestualize
                    Map<String, ER_Employee__c> mapEmployees = new Map<String, ER_Employee__c>();
                    Map<Id,IT_Circuit__c> MyMapFromObject = new Map<Id,IT_Circuit__c>(listAllCircuit);
                    Boolean controlMapSF = false;
                    if(MyMapFromObject != null && MyMapFromObject.size() > 0 && MyMapFromObject.keyset().contains(upsertCircuit.Id))
                        controlMapSF = true; 

                    //Upsert Circuit Product - Start
                    List<IT_Circuit_Product> circProduct = new List<IT_Circuit_Product>();
                    circProduct = singleCircuit.IT_Circuit_Product;
                    List<IT_Circuit_Product__c> circProductUpsert = new List<IT_Circuit_Product__c>();
                    Map<String, IT_Circuit_Product__c> circProductSF = new Map<String, IT_Circuit_Product__c>();

                    if(controlMapSF && MyMapFromObject.get(upsertCircuit.Id).Circuits_Product__r != null && MyMapFromObject.get(upsertCircuit.Id).Circuits_Product__r.size() > 0){
                        for(IT_Circuit_Product__c sinItem : MyMapFromObject.get(upsertCircuit.Id).Circuits_Product__r){
                            circProductSF.put(sinItem.IT_Circuit_Code__c+sinItem.IT_Service_Type__c, sinItem);     
                        }
                    }else {
                        circProductSF = null;
                    }    
                    circProductUpsert = populateListCircuitProduct(upsertCircuit, circProduct, circProductSF); 
                    system.debug('circProductUpsert:: '+circProductUpsert);
                    if(circProductUpsert != null && circProductUpsert.size() > 0)
                        upsert circProductUpsert;
                    //Upsert Circuit Product - End    

                    //Upsert Level - Start
                    List<IT_Level> circLevels = new List<IT_Level>();
                    circLevels = singleCircuit.IT_Level;
                    List<IT_Level__c> circLevelsUpsert = new List<IT_Level__c>();
                    Map<String, IT_Level__c> circLevelsSF = new Map<String, IT_Level__c>();

                    if(controlMapSF && MyMapFromObject.get(upsertCircuit.Id).Levels__r != null && MyMapFromObject.get(upsertCircuit.Id).Levels__r.size() > 0){
                        for(IT_Level__c sinItem : MyMapFromObject.get(upsertCircuit.Id).Levels__r){
                            circLevelsSF.put(sinItem.IT_Circuit_Code__c+sinItem.IT_Level_1__c+sinItem.IT_Level_2__c+sinItem.IT_Level_3__c, sinItem);
                        }
                    }else {
                        circLevelsSF = null;
                    }    
                    circLevelsUpsert = populateListLevels(upsertCircuit, circLevels, circLevelsSF);
                    if(circLevelsUpsert != null && circLevelsUpsert.size() > 0)  
                        upsert circLevelsUpsert;
     
                    //Upsert level - End

                    //Upsert circuit lookup in Financial Center

                    List<ER_Financial_Center__c> circLookupUpsert = new List<ER_Financial_Center__c>();
                    circLookupUpsert = populateLookupFinancialCenter(circLevelsUpsert, mapLevelFc);
                    if(circLookupUpsert != null && circLookupUpsert.size() > 0)  
                        update circLookupUpsert;

                    //Upsert circuit lookup in Financial Center - End    
                    
                }else{
                    response responseServiceErr = new response(); 
                    responseServiceErr = mapError.get(singleCircuit.IT_Circuit_Code); 
                    respList.add(responseServiceErr);      
                }
            }catch(Exception ecc){
                System.debug('Error WSIT01_SmartcardWS: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                Integer singleResponse = 0;
                while (singleResponse < respList.size()){
                    if(respList.get(singleResponse).circ_CD == singleCircuit.IT_Circuit_Code){
                        respList.remove(singleResponse);
                    }else{
                        singleResponse++;
                    }
                }
    
                response responseServiceCatch = new response(); 
                responseServiceCatch.statusCode = '400';
                responseServiceCatch.circ_CD = singleCircuit.IT_Circuit_Code;
                responseServiceCatch.sfdc_ID = '';   
                responseServiceCatch.ErrorDescription = ecc.getMessage();
                respList.add(responseServiceCatch);

                Database.rollback(sp);
            }     
        }

        return respList;
    }

    private static response populateResponseError(String codeCiruit, String errorField){
        response responseService = new response(); 
        responseService.statusCode = '400'; 
        responseService.circ_CD = codeCiruit;
        responseService.sfdc_ID = '';
        responseService.ErrorDescription = errorField;
        return responseService;
    } 
    
    private static IT_Circuit__c populateCircuit(IT_Circuit__c circuitObj, IT_Circuit circuitRequest){
        IT_Circuit__c upsertCircuitMethod = new IT_Circuit__c();

        if(circuitObj != null)
            upsertCircuitMethod = new IT_Circuit__c(Id = circuitObj.Id);

        upsertCircuitMethod.IT_Account__c = circuitObj.IT_Account__c;
        upsertCircuitMethod.IT_Circuit_Code__c = circuitRequest.IT_Circuit_Code;
        upsertCircuitMethod.Name = circuitRequest.IT_Circuit_Code + ' - ' + circuitRequest.Name;
        upsertCircuitMethod.IT_Receipt_Circuit_Name__c = circuitRequest.IT_Receipt_Circuit_Name;
        if(!String.isBlank(circuitRequest.IT_Start_Connection_Date))
            upsertCircuitMethod.IT_Start_Connection_Date__c = Date.ValueOf(circuitRequest.IT_Start_Connection_Date);
        if(!String.isBlank(circuitRequest.IT_End_Connection_Date))
            upsertCircuitMethod.IT_End_Connection_Date__c = Date.ValueOf(circuitRequest.IT_End_Connection_Date);
        upsertCircuitMethod.IT_Agreement_Type__c = circuitRequest.IT_Agreement_Type;
        upsertCircuitMethod.IT_Meal_Day__c = Decimal.ValueOf(circuitRequest.IT_Meal_Day);

        return upsertCircuitMethod;
    }
    
    private static List<IT_Level__c> populateListLevels(IT_Circuit__c circuitObj, List<IT_Level> listLevelsRequest, Map<String, IT_Level__c> mapLevelsSF){
        List<IT_Level__c> upsertLevelsMethod = new List<IT_Level__c>();

        for(IT_Level singleLevel : listLevelsRequest){
            IT_Level__c newLevel = new IT_Level__c();
            if(mapLevelsSF != null && mapLevelsSF.size() > 0 && mapLevelsSF.Keyset().contains(singleLevel.IT_Circuit_Code+singleLevel.IT_Level_1+singleLevel.IT_Level_2+singleLevel.IT_Level_3))
                newLevel = new IT_Level__c(Id = mapLevelsSF.get(singleLevel.IT_Circuit_Code+singleLevel.IT_Level_1+singleLevel.IT_Level_2+singleLevel.IT_Level_3).Id);

            newLevel.Name = singleLevel.IT_Level_1+ ' - '+singleLevel.IT_Level_2+ ' - '+singleLevel.IT_Level_3;
            newLevel.IT_Circuit__c = circuitObj.Id;
            newLevel.IT_Circuit_Code__c = singleLevel.IT_Circuit_Code;
            newLevel.IT_Level_1__c = singleLevel.IT_Level_1;
            newLevel.IT_Level_1_Description__c = singleLevel.IT_Level_1_Description;
            newLevel.IT_Level_2__c = singleLevel.IT_Level_2;
            newLevel.IT_Level_2_Description__c = singleLevel.IT_Level_2_Description;
            newLevel.IT_Level_3__c = singleLevel.IT_Level_3;
            newLevel.IT_Employee_Type__c = singleLevel.IT_Employee_Type;
            newLevel.IT_Client_Code__c = singleLevel.IT_Client_Code;
            newLevel.IT_Particular_Client_Code__c = singleLevel.IT_Particular_Client_Code;
            newLevel.IT_Service__c = singleLevel.IT_Service;
            newLevel.IT_Circuit_Type__c = singleLevel.IT_Circuit_Type;
            newLevel.IT_Service_Type__c = singleLevel.IT_Service_Type;
            upsertLevelsMethod.add(newLevel);
        }

        return upsertLevelsMethod;
    }
    
    private static List<IT_Circuit_Product__c> populateListCircuitProduct(IT_Circuit__c circuitObj, List<IT_Circuit_Product> listCircuitProdRequest, Map<String, IT_Circuit_Product__c> mapCircProductSfdc){
        List<IT_Circuit_Product__c> upsertCircuitsProductMethod = new List<IT_Circuit_Product__c>();

        for(IT_Circuit_Product singleCircuitProduct : listCircuitProdRequest){
            IT_Circuit_Product__c newCircuitProduct = new IT_Circuit_Product__c();
            if(mapCircProductSfdc != null && mapCircProductSfdc.size() > 0 && mapCircProductSfdc != null && mapCircProductSfdc.size() > 0 && mapCircProductSfdc.Keyset().contains(singleCircuitProduct.IT_Circuit_Code+singleCircuitProduct.IT_Service_Type))
                newCircuitProduct = new IT_Circuit_Product__c(Id = mapCircProductSfdc.get(singleCircuitProduct.IT_Circuit_Code+singleCircuitProduct.IT_Service_Type).Id);

            newCircuitProduct.Name = singleCircuitProduct.IT_Service;
            newCircuitProduct.IT_Circuit__c = circuitObj.Id;
            newCircuitProduct.IT_Circuit_Code__c = singleCircuitProduct.IT_Circuit_Code;
            newCircuitProduct.IT_Service__c = singleCircuitProduct.IT_Service;
            newCircuitProduct.IT_Service_Type__c = singleCircuitProduct.IT_Service_Type;
            newCircuitProduct.IT_Circuit_Type__c = singleCircuitProduct.IT_Circuit_Type;
            newCircuitProduct.IT_Invoice_Type__c = singleCircuitProduct.IT_Invoice_Type;
            newCircuitProduct.IT_Management_Type__c = singleCircuitProduct.IT_Management_Type;  
            newCircuitProduct.IT_Circularity__c = singleCircuitProduct.IT_Circularity;
            upsertCircuitsProductMethod.add(newCircuitProduct);
        }

        return upsertCircuitsProductMethod;     
    }

    private static List<ER_Financial_Center__c> populateLookupFinancialCenter(List<IT_Level__c> listLevel, Map<String, ER_Financial_Center__c> mapFcInLevel){
        List<ER_Financial_Center__c> upsertFinancialCenter = new List<ER_Financial_Center__c>();
        Set<String> setClientCode = new Set<String>();

        for(IT_Level__c singleLev : listLevel){
            ER_Financial_Center__c upsertSingleFinancialCenter = new ER_Financial_Center__c();
            if(mapFcInLevel != null && mapFcInLevel.size() > 0 && mapFcInLevel.Keyset().contains(singleLev.IT_Client_Code__c) && !setClientCode.contains(singleLev.IT_Client_Code__c)){
                upsertSingleFinancialCenter = mapFcInLevel.get(singleLev.IT_Client_Code__c);
                upsertSingleFinancialCenter.IT_Circuit__c = singleLev.IT_Circuit__c;
                upsertFinancialCenter.add(upsertSingleFinancialCenter);
                setClientCode.add(singleLev.IT_Client_Code__c);
            }    
        }   
 
        return upsertFinancialCenter;     
    }

    public class Circuito {
        public List<IT_Circuit> IT_Circuit;
    }

    public class IT_Circuit {
        public String IT_Circuit_Code;
        public String Name;
        public String IT_Receipt_Circuit_Name;
        public String IT_Start_Connection_Date;
        public String IT_End_Connection_Date;    
        public String IT_Agreement_Type;
        public String IT_Meal_Day;
        public list<IT_Level> IT_Level;
        public list<IT_Circuit_Product> IT_Circuit_Product;
    }

    public class IT_Level {
        public String IT_Circuit_Code;
        public String IT_Level_1;
        public String IT_Level_1_Description;
        public String IT_Level_2;
        public String IT_Level_2_Description;
        public String IT_Level_3;
        public String IT_Employee_Type;
        public String IT_Client_Code;
        public String IT_Particular_Client_Code;
        public String IT_Service;
        public String IT_Circuit_Type;
        public String IT_Service_Type;
    }

    public class IT_Circuit_Product { 
        public String IT_Circuit_Code;
        public String IT_Service;
        public String IT_Service_Type;
        public String IT_Circuit_Type;
        public String IT_Invoice_Type;
        public String IT_Management_Type;
        public String IT_Circularity;
    }

    global class response {
        public String statusCode;
        public String circ_CD; 
        public String sfdc_ID;
        public String errorDescription;
    }   
}