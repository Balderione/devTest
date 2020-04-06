@RestResource(urlMapping='/ac_document/*') 
global class WSIT06_Document {
    @HttpPut
    global static List<response> AnagraficaClientiUpsert() {
        Map<String, response> mapError = new Map<String, response>();
        List<response> respList = new List<response>();    

        String body = System.RestContext.request.requestBody.toString();
        Request req = (Request) JSON.deserializeStrict(body, Request.class);
        system.debug('data::: '+req);
        Map<String, ER_Financial_Center__c> financialCenterCode = new Map<String, ER_Financial_Center__c>();
        List<String> keyUpsertDocumentClient = new List<String>();
        Map<String, Contract> docForClient = new Map<String, Contract>();
        Map<String, Contract> docForCcontract = new Map<String, Contract>();
        List<ER_Financial_Center__c> docForFC = new List<ER_Financial_Center__c>();
        Set<String> idAttachmentParentDoc = new Set<String>();
        Set<String> nameAttachmentDoc = new Set<String>();
        List<Attachment> attachmentDoc = new List<Attachment>();

        for(IT_Document singleDocument : req.IT_Document){
            keyUpsertDocumentClient.add(singleDocument.IT_Client_Code);
        }

        docForFC = [Select Id, IT_Financial_Center__c, ER_Account_Name__c, (Select Id, IT_Client_Code__c, IT_Contract_Number__c, IT_Contract_Progressive__c, IT_Barcode__c From Contracts__r) From ER_Financial_Center__c Where IT_Financial_Center__c IN: keyUpsertDocumentClient];

        if(docForFC != null && docForFC.size() > 0){
            for(ER_Financial_Center__c singleFC : docForFC){
                financialCenterCode.put(singleFC.IT_Financial_Center__c, singleFC);
                if(singleFC.Contracts__r != null && singleFC.Contracts__r.size() > 0){
                    for(Contract singleContract : singleFC.Contracts__r){
                        if(!String.isblank(singleContract.IT_Contract_Number__c) && singleContract.IT_Contract_Number__c.contains('/')){
                            System.debug('singleContract.IT_Contract_Number__c:: '+singleContract.IT_Contract_Number__c);
                            String[] contractNumberTemp = singleContract.IT_Contract_Number__c.Split('/');
                            String contractNumberKey = contractNumberTemp[0]+'§'+contractNumberTemp[1];
                            System.debug('contractNumberKey:: '+contractNumberKey);
                            docForCcontract.put(contractNumberKey, singleContract);
                        }    
                        if(!String.isblank(singleContract.IT_Barcode__c) && String.isblank(singleContract.IT_Contract_Number__c)) 
                            docForClient.put(singleContract.IT_Client_Code__c+singleContract.IT_Barcode__c, singleContract);
                        idAttachmentParentDoc.add(singleContract.Id);
                    }
                }    
            }    
        }

        attachmentDoc = [Select Id, Name From Attachment Where ParentId IN : idAttachmentParentDoc];

        if(attachmentDoc != null && attachmentDoc.size() > 0){
            for(Attachment singleAttachment : attachmentDoc){
                nameAttachmentDoc.add(singleAttachment.Name);
            }
        }

        for(IT_Document singleDoc : req.IT_Document){
            Savepoint sp = Database.setSavepoint();
            try{
                if(!financialCenterCode.Keyset().contains(singleDoc.IT_Client_Code)){
                    response responseService = new response(); 
                    responseService = populateResponseError(singleDoc.IT_Client_Code+'§'+singleDoc.IT_Barcode, 'Client Code not registered in the system');
                    if(!mapError.Keyset().contains(singleDoc.IT_Client_Code+'§'+singleDoc.IT_Barcode))
                        mapError.put(singleDoc.IT_Client_Code+'§'+singleDoc.IT_Barcode, responseService);
                }

                if(!mapError.Keyset().contains(singleDoc.IT_Client_Code+'§'+singleDoc.IT_Barcode)){
                    //Upsert Document - Start
                    Contract upsertContract = new Contract();
                    upsertContract = populateDocument(singleDoc, financialCenterCode, docForClient, nameAttachmentDoc, docForCcontract);
                    system.debug('upsertContractComplete::: '+upsertContract);   
                    //Upsert Document - End

                    response responseService = new response(); 
                    responseService.statusCode = '200'; 
                    responseService.document_CD = upsertContract.IT_Barcode__c;
                    responseService.client_CD = upsertContract.IT_Client_Code__c;
                    responseService.sfdc_ID = upsertContract.Id;
                    responseService.ErrorDescription = ''; 
                    respList.add(responseService);

                }else{
                    response responseServiceErr = new response(); 
                    responseServiceErr = mapError.get(singleDoc.IT_Client_Code+'§'+singleDoc.IT_Barcode); 
                    respList.add(responseServiceErr);        
                }
            }catch(Exception ecc){
                System.debug('Error WSIT06_Document: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
                Integer singleResponse = 0;
                while (singleResponse < respList.size()){
                    if(respList.get(singleResponse).client_CD+respList.get(singleResponse).document_CD == singleDoc.IT_Client_Code+singleDoc.IT_Barcode){
                        respList.remove(singleResponse);
                    }else{
                        singleResponse++;
                    }
                }

                response responseServiceCatch = new response(); 
                responseServiceCatch.statusCode = '400';   
                responseServiceCatch.errorDescription = ecc.getMessage();
                responseServiceCatch.document_CD = singleDoc.IT_Barcode;
                responseServiceCatch.client_CD = singleDoc.IT_Client_Code;
                responseServiceCatch.sfdc_ID = '';
                respList.add(responseServiceCatch);

                Database.rollback(sp);
            }
        }    

        return respList;    
    }

    private static response populateResponseError(String keyDoc, String errorField){
        response responseService = new response(); 
        responseService.statusCode = '400';
        String[] arrResp = keyDoc.split('§'); 
        responseService.document_CD = arrResp[1];
        responseService.client_CD = arrResp[0];
        responseService.sfdc_ID = '';
        responseService.ErrorDescription = errorField;
        return responseService;
    }

    private static Contract populateDocument(IT_Document docForContract, Map<String, ER_Financial_Center__c> codeFinancialCenterMap, Map<String, Contract> mapContractDoc, Set<String> nameDocAttachment, Map<String, Contract> mapDocForContract){
        Contract newContract = new Contract();
        system.debug('mapDocForContract::: '+mapDocForContract);
        if(mapDocForContract != null && mapDocForContract.size() > 0 && !String.isBlank(docForContract.IT_Document_Protocol) && mapDocForContract.Keyset().contains(docForContract.IT_Document_Protocol.replace('/', '§')))
            newContract = new Contract(Id = mapDocForContract.get(docForContract.IT_Document_Protocol.replace('/', '§')).Id);
        else if(mapContractDoc != null && mapContractDoc.size() > 0 && mapContractDoc.Keyset().contains(docForContract.IT_Client_code+docForContract.IT_Barcode))
            newContract = new Contract(Id = mapContractDoc.get(docForContract.IT_Client_code+docForContract.IT_Barcode).Id);
        
        if(codeFinancialCenterMap != null && codeFinancialCenterMap.size() > 0 && codeFinancialCenterMap.Keyset().contains(docForContract.IT_Client_code)){
            newContract.IT_Financial_Center__c = codeFinancialCenterMap.get(docForContract.IT_Client_code).Id;
            newContract.AccountId = codeFinancialCenterMap.get(docForContract.IT_Client_code).ER_Account_Name__c;
        }
        newContract.IT_Client_Code__c = docForContract.IT_Client_Code;    
        newContract.IT_Document_Protocol__c = docForContract.IT_Document_Protocol;
        newContract.IT_Document_Progressive__c = docForContract.IT_Document_Progressive;
        newContract.IT_Document_Type__c = docForContract.IT_Document_Type;
        if(docForContract.IT_Registration_Date != null)
            newContract.IT_Registration_Date__c = docForContract.IT_Registration_Date;
        if(docForContract.IT_Scan_Date != null)        
            newContract.IT_Scan_Date__c = docForContract.IT_Scan_Date;
        newContract.IT_Barcode__c = docForContract.IT_Barcode;
        newContract.IT_Framework_Barcode__c = docForContract.IT_Framework_Barcode;
        if(!String.isBlank(docForContract.IT_Send_Email) && docForContract.IT_Send_Email == '1')
            newContract.IT_Send_Email__c = true;
        else    
            newContract.IT_Send_Email__c = false;
        newContract.IT_Email__c = docForContract.IT_Email;
        if(docForContract.IT_Email_Sending_Date != null)
            newContract.IT_Email_Sending_Date__c = docForContract.IT_Email_Sending_Date;
        newContract.IT_Barcode_Warrant__c = docForContract.IT_Barcode_Warrant;
        newContract.IT_Service__c = docForContract.IT_Service;
        newContract.IT_Service_2__c = docForContract.IT_Service_2;
        newContract.IT_Barcode_2__c = docForContract.IT_Barcode_2;
        newContract.IT_Service_3__c = docForContract.IT_Service_3;
        newContract.IT_Barcode_3__c = docForContract.IT_Barcode_3;
        if(!String.isBlank(docForContract.IT_136_Send_Email) && docForContract.IT_136_Send_Email == '1')
            newContract.IT_136_Send_Email__c = true;
        else    
            newContract.IT_136_Send_Email__c = false;
        newContract.IT_136_Email_Address__c = docForContract.IT_136_Email_Address;
        if(docForContract.IT_136_Email_Sending_Data != null)
            newContract.IT_136_Email_Sending_Data__c = docForContract.IT_136_Email_Sending_Data;
        newContract.IT_136_User_Sender__c = docForContract.IT_136_User_Sender;
        newContract.IT_AC_User__c = docForContract.IT_AC_User;

        upsert newContract;

        Map<String, String> mapBody = new Map<String, String>();
        if(!String.isBlank(docForContract.IT_PDF_File))
            mapBody.put(docForContract.IT_Barcode, docForContract.IT_PDF_File);
        if(!String.isBlank(docForContract.IT_136_PDF_File))    
            mapBody.put(docForContract.IT_Barcode+'-136',docForContract.IT_136_PDF_File);
        String upsertDoc = APIT11_Utilities.saveAttachmentContract(mapBody, newContract.Id, newContract.IT_Client_Code__c, nameDocAttachment);
        System.debug('upsertDoc:::: '+upsertDoc);

        return newContract;
    }    

    public class Request{
        public List<IT_Document > IT_Document ;
    }
    
    public class IT_Document{
        public String IT_Client_Code;
        public String IT_Document_Protocol;
        public Integer IT_Document_Progressive;
        public String IT_Document_Type;
        public Date IT_Registration_Date;
        public Date IT_Scan_Date;
        public String IT_Barcode;
        public String IT_Framework_Barcode;
        public String IT_PDF_File;
        public String IT_Send_Email;
        public String IT_Email;
        public Date IT_Email_Sending_Date;
        public String IT_Barcode_Warrant;
        public String IT_Service;
        public String IT_Service_2;
        public String IT_Barcode_2;
        public String IT_Service_3;
        public String IT_Barcode_3;
        public String IT_136_PDF_File;
        public String IT_136_Send_Email;
        public String IT_136_Email_Address;
        public Date IT_136_Email_Sending_Data;
        public String IT_136_User_Sender;
        public String IT_AC_User;
    }
    
    global class response {
        public String statusCode;
        public String document_CD;
        public String client_CD; 
        public String sfdc_ID;
        public String errorDescription;    
    }
    
}