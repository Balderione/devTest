public class APIT09_CreatePDFController {

    public static String documentHTML {get; set;}

    public void APIT09_CreatePDFControllerReplace(String TemplateId, String templateName, String templateObjectId) {
        try{  
            if(!String.isBlank(TemplateId)) {
                List<IT_PDF_TemplateMdt__mdt> htmlContent2 = new List<IT_PDF_TemplateMdt__mdt>();
                htmlContent2 = [Select Id, IT_Active__c, IT_HtmlForPdf__c, IT_Object_Name__c, (Select Id, IT_Replace_Type__c, IT_Child_Object__c, IT_Active__c, IT_Field_Name__c, IT_Object_Name__c, IT_Placeholder__c From Replace_Items__r Where IT_Active__c = true) From IT_PDF_TemplateMdt__mdt Where IT_Active__c = true And Id =: TemplateId];
                String documentHTMLTemp =  htmlContent2[0].IT_HtmlForPdf__c;
                system.debug('htmlContent2[0].Replace_Items__r:::: '+htmlContent2[0].Replace_Items__r);
                List<String> objectsChild = new List<String>();
                if(htmlContent2[0].Replace_Items__r != null && htmlContent2[0].Replace_Items__r.size() > 0){
                    for(IT_Replace_ItemMdt__mdt sigleItem : htmlContent2[0].Replace_Items__r){
                        if(sigleItem.IT_Replace_Type__c == 'Child'){
                            objectsChild.add(sigleItem.IT_Child_Object__c);
                        }
                    }
                }    
                documentHTML = Replacer(documentHTMLTemp, templateObjectId, templateName, objectsChild, TemplateId);
                documentHTML = documentHTML.replace('</tr></p>', '</tr>');
                documentHTML = documentHTML.replace('<p><tr', '<tr');
                system.debug('documentHTML: '+documentHTML);   
            }
        }catch(Exception ecc){
            System.debug('Error APIT09_CreatePDFController: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }        
    }

    public APIT09_CreatePDFController() {
        String TemplateIdTemp = Apexpages.currentPage().getParameters().get('templateId');
        String TemplateNameTemp = Apexpages.currentPage().getParameters().get('templateObjectName');
        String ObjectIdTemp = Apexpages.currentPage().getParameters().get('templateObjectId'); 
         
        system.debug('TemplateIdTemp: '+TemplateIdTemp);
        APIT09_CreatePDFControllerReplace(TemplateIdTemp, TemplateNameTemp, ObjectIdTemp);
    }

    @AuraEnabled
    public static void ShowPdf(String TemplateId, String recordObjectId, String recordObjectName) { 
        try{
            List<IT_PDF_TemplateMdt__mdt> htmlContent = new List<IT_PDF_TemplateMdt__mdt>();
            htmlContent = [Select Id, IT_Active__c, IT_HtmlForPdf__c, IT_Object_Name__c, (Select Id, IT_Active__c, IT_Field_Name__c, IT_Object_Name__c, IT_Placeholder__c From Replace_Items__r Where IT_Active__c = true) From IT_PDF_TemplateMdt__mdt Where IT_Active__c = true And Id =: TemplateId];
            documentHTML = htmlContent[0].IT_HtmlForPdf__c;
            system.debug('TemplateId::: '+TemplateId);
            if(htmlContent != null && htmlContent.size() > 0){
                documentHTML = htmlContent[0].IT_HtmlForPdf__c.unescapeHtml4();
                PageReference pageRef = createPageReference(TemplateId, recordObjectName, recordObjectId);
            
                ContentVersion cv = new ContentVersion();
                if(Test.isRunningTest())
                    cv.VersionData = blob.valueOf('Testtest');
                else
                    cv.VersionData = pageRef.getContent();
                cv.Title = 'FlexBen' + recordObjectId + '_' + Datetime.now().format('MM_dd') + '.pdf';
                cv.PathOnClient = 'FlexBen' + recordObjectId + '_' + Datetime.now().format('MM_dd') + '.pdf';
                insert cv;
                
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
                
                ContentDocumentLink cDe = new ContentDocumentLink();
                cDe.ContentDocumentId = conDoc;
                cDe.LinkedEntityId = recordObjectId;
                cDe.ShareType = 'I'; 
                cDe.Visibility = 'AllUsers';
                insert cDe;

            }
        }catch(Exception ecc){
            System.debug('Error APIT09_CreatePDFController: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }    

    }

    public static PageReference createPageReference (String TemplateId, String nameObj, String idObj){

        PageReference pageRef = new PageReference('/apex/VFIT01_CreatePDF?templateId='+TemplateId+'&templateObjectName='+nameObj+'&templateObjectId='+idObj);
        pageRef.setRedirect(true);
        system.debug('HO CREATO PAGE REFERENCE');
        return pageRef;

    }

    public String Replacer(String htmlforPdf, Id objId, String ObjectName, List<String> objChild, String TemplateId){
        System.debug('objId::: '+objId+' ObjectName:::: '+ObjectName+' objChild::::'+objChild);
        map<String, String> mapApiLookup = new map<String, String>(); 
        String objC = '';
        String fieldsChild = '';
        List<String> subQueryChilds = new List<String>();
        try{
            if(objChild != null && objChild.size() > 0){
                for(String sinString : objChild){
                    if(sinString.contains('__c'))
                        objC = sinString.replace('__c', 's__r');
                    else 
                        objC = sinString+'s__r';

                    if(objC.contains('IT_'))
                        objC = objC.replace('IT_', '');
                    if(objC.contains('ER_'))
                        objC = objC.replace('ER_', '');          
                    

                    System.debug('sinString::: '+sinString);    

                    SObjectType objType = Schema.getGlobalDescribe().get(sinString);
                    Map<String,Schema.SObjectField> mfields = objType.getDescribe().fields.getMap();
                    fieldsChild = '(SELECT ';
                    for(String field : mfields.keySet()) {
                        fieldsChild+=field+',';
                    }
                    fieldsChild = fieldsChild.removeEnd(',');
                    fieldsChild += ' FROM '+objC+')';
                    //fieldsChild += ' FROM '+objC+' WHERE '+ObjectName+'=: objId)'; 
                    subQueryChilds.add(fieldsChild);
                    mapApiLookup.put(sinString, objC); 
                }          
            }

            map<String, List<IT_Replace_ItemMdt__mdt>> replaceMap = new map<String, List<IT_Replace_ItemMdt__mdt>>();
            List<sObject> replaceObject = new List<sObject>();
            List<sObject> replaceObjectChilds = new List<sObject>();

            SObjectType objType = Schema.getGlobalDescribe().get(ObjectName);
            Map<String,Schema.SObjectField> mfields = objType.getDescribe().fields.getMap();
            String query = 'SELECT ';
            for(String field : mfields.keySet()) {
                query+=field+',';
            }
            query = query.removeEnd(',');

            if(subQueryChilds != null && subQueryChilds.size() > 0){
                for(String sString : subQueryChilds){
                    query += ' , '+sString;
                }
            }            

            query += ' FROM '+ObjectName+' WHERE Id =: objId';
            System.debug('StringQuery::: '+query);
            replaceObject = Database.query(query); 

            List<IT_PDF_TemplateMdt__mdt> PdfT = new List<IT_PDF_TemplateMdt__mdt>();
            PdfT = [Select Id, IT_Active__c, IT_HtmlForPdf__c, IT_Object_Name__c, (Select Id, IT_Active__c, IT_Image__c, IT_Field_Name__c, IT_Object_Name__c, IT_Placeholder__c, IT_Replace_Type__c, IT_Child_Object__c From Replace_Items__r) From IT_PDF_TemplateMdt__mdt Where IT_Active__c = true And Id =: TemplateId];
            List<IT_Replace_ItemMdt__mdt> listReplaceItem = PdfT[0].Replace_Items__r;
            for(IT_Replace_ItemMdt__mdt singleReplace : listReplaceItem){
                List<IT_Replace_ItemMdt__mdt> replaceTemp = new List<IT_Replace_ItemMdt__mdt>();
                if(replaceMap != null && replaceMap.keyset().contains(singleReplace.IT_Replace_Type__c)){
                    replaceTemp = replaceMap.get(singleReplace.IT_Replace_Type__c);
                    replaceTemp.add(singleReplace);
                    replaceMap.put(singleReplace.IT_Replace_Type__c,replaceTemp);
                }else{
                    replaceTemp.add(singleReplace);
                    replaceMap.put(singleReplace.IT_Replace_Type__c,replaceTemp);    
                }
                    
            }
            for(IT_Replace_ItemMdt__mdt singleReplace : listReplaceItem){
                System.debug('singleReplace.IT_Replace_Type__c:::: '+singleReplace.IT_Replace_Type__c);
                System.debug('singleReplace.IT_Placeholder__c:::: '+singleReplace.IT_Placeholder__c);
                if(singleReplace.IT_Replace_Type__c != '' && singleReplace.IT_Replace_Type__c == 'Parent'){
                    sObject caseHtml = replaceObject[0];
                    Schema.SobjectField singleItem = Schema.getGlobalDescribe().get(singleReplace.IT_Object_Name__c).getDescribe().fields.getMap().get(singleReplace.IT_Field_Name__c);
                    System.debug('singleItem:::: '+singleItem);
                    String field = (String)caseHtml.get(singleItem);
                    if(!String.isBlank(field))
                        htmlforPdf = htmlforPdf.replace(singleReplace.IT_Placeholder__c, field);
                    else
                        htmlforPdf = htmlforPdf.replace(singleReplace.IT_Placeholder__c, ''); 
                            
                }else if(singleReplace.IT_Replace_Type__c != '' && singleReplace.IT_Replace_Type__c == 'Child'){
                    System.debug('mapApiLookup:: '+mapApiLookup);
                    System.debug('singleReplace.IT_Child_Object__c:: '+singleReplace.IT_Child_Object__c);
                    replaceObjectChilds = replaceObject[0].getSObjects(mapApiLookup.get(singleReplace.IT_Child_Object__c)); 
                    List<sObject> childHtml = replaceObjectChilds;
                    for(sObject sigleSObject : childHtml){
                        Schema.SobjectField singleItemC = Schema.getGlobalDescribe().get(singleReplace.IT_Object_Name__c).getDescribe().fields.getMap().get(singleReplace.IT_Field_Name__c);
                        String fieldChild = (String) String.valueOf(sigleSObject.get(singleItemC));
                        if(!String.isBlank(fieldChild))
                            htmlforPdf = htmlforPdf.replace(singleReplace.IT_Placeholder__c, fieldChild);      
                    }        
                }/*else if(singleReplace.IT_Replace_Type__c != '' && singleReplace.IT_Replace_Type__c == 'Group'){   
                    replaceObjectChilds = replaceObject[0].getSObjects(mapApiLookup.get(singleReplace.IT_Child_Object__c)); 

                    List<sObject> childHtml = replaceObjectChilds;
                    List<IT_Replace_ItemMdt__mdt> replaceItemChields = replaceMap.get('Child'); 
                    String tableComplete = '';
                    for(sObject sigleSObject : childHtml){
                        //String htmlTemp = '<tr> <td style="width:33%">{!PlanNeme}</td> <td style="width:33%">{!PlanStartDate}</td> <td style="text-align:right; width:34%">{!PlanEndDate}</td></tr>';
                        String htmlTemp = singleReplace.IT_Image__c.unescapeHtml4(); 
                        //for(IT_Replace_ItemMdt__mdt singleRI : replaceItemChields){
                            //if(singleRI.IT_Replace_Item__c == singleReplace.Id){
                                //Schema.SobjectField singleItemC = Schema.getGlobalDescribe().get(singleRI.IT_Object_Name__c).getDescribe().fields.getMap().get(singleRI.IT_Field_Name__c);
                                //String fieldChild = (String) String.valueOf(sigleSObject.get(singleItemC));
                                //if(!String.isBlank(fieldChild))
                                    //htmlTemp = htmlTemp.replace(singleRI.IT_Placeholder__c, fieldChild);
                            //}
                        //}
                        if(!String.isBlank(htmlTemp))
                            tableComplete = tableComplete += htmlTemp;
                    }
                    if(!String.isBlank(tableComplete))
                        htmlforPdf = htmlforPdf.replace(singleReplace.IT_Placeholder__c, tableComplete);
                }*/else if(singleReplace.IT_Replace_Type__c != '' && singleReplace.IT_Replace_Type__c == 'Image'){
                    system.debug('Image:::: '+singleReplace.IT_Image__c);
                    if(!String.isBlank(singleReplace.IT_Image__c)){
                        htmlforPdf = htmlforPdf.replace(singleReplace.IT_Placeholder__c, singleReplace.IT_Image__c);
                    }    
                }
            }
            return htmlforPdf;
        }catch(Exception ecc){
            System.debug('Error APIT09_CreatePDFController: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            return null;
        }    
    }

    @AuraEnabled
    public static List<picklistWrapper> ShowPdfList(String objectType) {
        try{
            system.debug('objectType::: '+objectType); 
            List<picklistWrapper> lstPWrapper = new List<picklistWrapper>();

            List<IT_PDF_TemplateMdt__mdt> listTemplateForPdf = new List<IT_PDF_TemplateMdt__mdt>();
            listTemplateForPdf = [Select Id, MasterLabel, IT_Active__c, IT_HtmlForPdf__c, IT_Object_Name__c From IT_PDF_TemplateMdt__mdt Where IT_Object_Name__c =: objectType And IT_Active__c = true];

            if(listTemplateForPdf != null && listTemplateForPdf.size() >0){
                for(IT_PDF_TemplateMdt__mdt singleItem : listTemplateForPdf) {
                    System.debug('singleItem: '+singleItem);
                    lstPWrapper.add(new picklistWrapper(singleItem.Id, singleItem.MasterLabel));
                }
            }    
            System.debug('lstPWrappe: '+lstPWrapper); 
            return lstPWrapper; 
        }catch(Exception ecc){
            System.debug('Error APIT09_CreatePDFController: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            return null;
        }     
    }

    public class picklistWrapper {      
        @AuraEnabled
        public String strValue {get;set;}
        @AuraEnabled
        public String strLabel {get;set;}

        public picklistWrapper(String strValue, String strLabel) {  
            this.strValue = strValue;
            this.strLabel = strLabel;
        }
    }

}