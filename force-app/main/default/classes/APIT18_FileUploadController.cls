public class APIT18_FileUploadController {
    // =============================================
    //-- Author:		Claudio Baffi
    //-- Create date: 	15/10/2019
    //-- Description:	Classe che fa da controller per il component flowUpload e gestisce l'inserimento dei file 
    //-- 				e l'associazione di quest'ultimi a record ContentDocumentLink. Contiene un metodo per 
    //-- 				inviare dinamicamente mail con allegati da opportunità vinte
    //-- ============================================= 
    
    public static boolean firstRun = true;
    
    @auraenabled
    public static List<IT_Edenred_Document__c> returnCurrentAttachment (id recordId , string fileType){
        //Restituisce gli attachment di un determinato tipo dell'opportunità in cui si trova il component
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        string compare = '%'+ fileType + '%';
        string myquery = 'SELECT name, Id, IT_Version__c , IT_Type__c , IT_Record_Link__c , createddate from IT_Edenred_Document__c where ';
        if(sObjName == 'Case'){
            myquery += 'IT_Case__c';
        }
        else{
            //myquery += 'Opportunita_Multi_Area__c';
        }
        myquery += ' =:recordId AND IT_Type__c LIKE :compare AND IT_Is_Last_Version__c = true order by IT_Version__c desc';
        List<IT_Edenred_Document__c> Links = database.query(myquery);
        if(links != null && links.size() > 0){
            return Links;
        }
        else{
            return NULL;
        }
        
    }
    @auraenabled
    public static List<CMIT04_File_Type__mdt> getPickListValuesIntoList(string caseId){
        //Restituisce una picklist dinamica in base a Custom metadata
        List<CMIT04_File_Type__mdt> DocumentTypeList= [SELECT id , MasterLabel, IT_Multi_Upload__c, IT_View_Detail__c FROM CMIT04_File_Type__mdt];
        Case currentCase = [SELECT id, IT_Statement__c FROM Case WHERE id =:caseId LIMIT 1];
        if(currentCase.IT_Statement__c == 'Consip BP 8'){
            for(integer i = 0; i < DocumentTypeList.size(); i++){
                if(DocumentTypeList[i].masterLabel == 'ALFA'){
                    DocumentTypeList.remove(i);
                }
            }
        }
        return DocumentTypeList;
    }
    @auraenabled
    public static string newAttachmentVer (id recordId , id documentId , string type , string title, string oldDocId, boolean caricamentoMulti , date recievedDate , boolean cigFlag , boolean ipaFlag, boolean accepted){
        //All'inserimento del nuovo file crea un record IT_Edenred_Document__c associato a quel file
        //Dopo che il file è stato inserito controlla se esiste già un file di questo tipo e , se esiste, aggiorna la versione 
        //e rende il file appena inserito l'ultima versione caricata
        decimal oldversion = 0;
        decimal oldCode = 0;
        string FCLinkId;
        List<Case> currentCase = [SELECT Id , IT_Financial_Center__c FROM Case WHERE Id =:recordId LIMIT 1];
        if(currentCase != null && currentCase.size() > 0){
            if(currentCase[0].IT_Financial_Center__c != null){
                FCLinkId = currentCase[0].IT_Financial_Center__c;
            }
        }
        //Monto la query dinamica
        ////OPPMULTI
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        string myQuery = 'SELECT IT_Version__c , id , IT_Type__c , IT_Is_Last_Version__c , IT_Record_Link__c ,IT_Latest_Version__c, IT_Financial_Center__c  FROM IT_Edenred_Document__c WHERE ';
        if(sObjName == 'Case'){
            myquery += 'IT_Case__c ';
        }
        else{
            //myquery += 'Opportunita_Multi_Area__c';
        }
        myquery += '=:recordId ';
        if(oldDocId != null){
            myQuery += ' AND ((id =:oldDocId) OR (IT_Latest_Version__c = :oldDocId)) ';
        }else{
            myQuery += ' AND IT_Type__c = :type ';
        }
        myQuery += ' order by IT_Version__c desc';
        List<IT_Edenred_Document__c> oldversionDoc = database.Query(myQuery);
        //se trovo un documento aggiorno la versione e il tipo
        if(oldversionDoc != null && oldversionDoc.size() > 0 ){
            oldversion = oldversionDoc[0].IT_Version__c;
            if (oldDocId != null){
                type = oldversionDoc[0].IT_Type__c;
            }
            /*else if (caricamentoMulti){
for(IT_Edenred_Document__c b80doc : oldversionDoc){
if (b80doc.Codice__c > oldCode){
oldCode = b80doc.Codice__c;
oldversion = 0;
} 
}
}*/
        }
        //Inserisco il nuovo record IT_Edenred_Document__c
        IT_Edenred_Document__c bdoc = new IT_Edenred_Document__c (
            IT_Type__c = type,
            IT_Version__c = oldversion + 1,
            Name = Title,
            //Opportunity__c = recordId, 
            IT_Is_Last_Version__c = true,
            IT_Accepted__c = accepted
            
        );
        if(sObjName == 'Case'){
            bdoc.IT_Case__c = recordId;
        }
        if(FCLinkId != null && FCLinkId != ''){
            bdoc.IT_Financial_Center__c = FCLinkId;
        }
        if(bdoc.IT_Type__c == 'Alpha' || bdoc.IT_Type__c == 'B'){
            if(recievedDate != null){
                bdoc.IT_Recieved_Date__c = recievedDate;
            }
        }
        else if(bdoc.IT_Type__c == 'ODA'){
            if(cigFlag != null){
                bdoc.IT_CIG__c = cigFlag;
            }
            if(ipaFlag != null){
                bdoc.IT_IPA__c = ipaFlag; 
            }
        }
        
        
        insert bdoc;
        //Aggiorno il vecchio documento
        if(caricamentoMulti == true ){
            if(oldDocId != null) {
                for(IT_Edenred_Document__c b80doc : oldversionDoc){
                    b80doc.IT_Latest_Version__c = bdoc.id;
                    b80doc.IT_Is_Last_Version__c = false;
                }
                update oldversionDoc;
            }        
        }
        else if(oldversionDoc != null && oldversionDoc.size() > 0 ){
            for(IT_Edenred_Document__c b80doc : oldversionDoc){
                b80doc.IT_Latest_Version__c = bdoc.id;
                b80doc.IT_Is_Last_Version__c = false;
            }
            update oldversionDoc;
            
        }
        return bdoc.id;
        
    }
    @auraenabled
    //Associo il nuovo IT_Edenred_Document__c a un ContentDocumentLink
    public static void createLink (string bdocid , id documentId){
        system.debug('VARIABILI LINK:: '+bdocid+' '+documentId);
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = documentId;
        cdl.LinkedEntityId = bdocid;
        cdl.ShareType = 'V';
        insert cdl;
    }
    
    @auraenabled
    //Metodo per restituire una lista di suggerimenti da mostrare in un menù a tendina
    public static list<String> getSuggestions (string input , id recordId){
        list<String> response = new list<string>();
        Set<String> predictionsList = new Set<string>();
        string compare = '%' + input +'%';
        string stringToRemove = input + ' - ';
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        string myquery = 'SELECT IT_Type__c FROM IT_Edenred_Document__c WHERE IT_Type__c LIKE :compare AND ';
        if(sObjName == 'Case'){
            myquery += 'IT_Case__c';
        }
        else{
            //myquery += 'Opportunita_Multi_Area__c';
        }
        myquery += '=:recordId';
        //list<IT_Edenred_Document__c> b80docs = [SELECT IT_Type__c FROM IT_Edenred_Document__c WHERE IT_Type__c LIKE :compare AND Opportunity__c =:recordId];
        list<IT_Edenred_Document__c> b80docs = database.query(myquery);
        if(b80docs != null && b80docs.size() > 0 ){
            for(IT_Edenred_Document__c b : b80docs){
                predictionsList.add(b.IT_Type__c.split('-')[1].replacefirst(' ',''));
            }  
            
        }
        
        response.addall(predictionsList) ;
        return response;
    }
    @auraenabled
    //Metodo utilizzato per aggiornare un singolo document
    public static string newAttachmentUpdate (string recordId , id documentId , string title){
        system.debug('VARIABILI UPDATE:: '+recordId+' '+documentId);
        string type = '';
        decimal oldversion = 0;
        //OPPMULTI
        List<IT_Edenred_Document__c> oldversionDoc = [SELECT IT_Version__c ,id ,IT_Type__c, IT_Case__c ,  IT_Is_Last_Version__c , IT_Latest_Version__c FROM IT_Edenred_Document__c WHERE Id = :recordId OR IT_Latest_Version__c =:recordId order by IT_Version__c desc];
        if(oldversionDoc != null && oldversionDoc.size() > 0 ){
            oldversion = oldversionDoc[0].IT_Version__c;
            type = oldversionDoc[0].IT_Type__c;
        }
        IT_Edenred_Document__c bdoc = new IT_Edenred_Document__c (
            IT_Type__c = type,
            IT_Version__c = oldversion + 1,
            Name = Title,
            IT_Case__c = oldversionDoc[0].IT_Case__c,
            IT_Is_Last_Version__c = true
            
        );
        insert bdoc;
        
        if(oldversionDoc != null && oldversionDoc.size() > 0 ){
            for(IT_Edenred_Document__c b80doc : oldversionDoc){
                b80doc.IT_Latest_Version__c = bdoc.id;
                b80doc.IT_Is_Last_Version__c = false;
            }
            update oldversionDoc;
            
        }
        return bdoc.id;
        
    }
    @auraenabled
    public static string deleteLastVersion (string recordId ){ 
        system.debug('VARIABILI UPDATE:: '+recordId);
        string redirectId;
        List<IT_Edenred_Document__c> oldversionDoc = [SELECT IT_Version__c ,id ,IT_Type__c, IT_Is_Last_Version__c , IT_Latest_Version__c, IT_Case__c FROM IT_Edenred_Document__c WHERE Id = :recordId OR IT_Latest_Version__c =:recordId order by IT_Version__c desc];
        if(oldversionDoc != null && oldversionDoc.size() > 1 ){
            system.debug('SIZE MAGGIORE DI 1');
            oldversionDoc[1].IT_Is_Last_Version__c = true;
            oldversionDoc[1].IT_Latest_Version__c = null;
            redirectId = oldversionDoc[1].id; 
            for(IT_Edenred_Document__c b80doc : oldversionDoc){
                if(b80doc.id != redirectId){
                    system.debug('CAMBIATO VERSIONE PIU RECENTE');
                    b80doc.IT_Latest_Version__c = redirectId;
                }    
            }  
        }
        else{
            redirectId = oldversionDoc[0].IT_Case__c;
        }
        ContentDocumentLink cdl = [SELECT id , ContentDocument.id from contentDocumentLink where LinkedEntityId = :oldversionDoc[0].id LIMIT 1];
        delete cdl.ContentDocument;
        update oldversionDoc;          
        delete oldversionDoc[0];
        return redirectId;
        
    }
    
    @auraenabled
    public static void completeCONSIPMilestones(Id caseId, string fileType) {  
        DateTime complDate = dateTime.now();
        
        List<CaseMilestone> cmsToUpdate = [select Id, completionDate, Milestonetype.Name
                                           from CaseMilestone cm
                                           where caseId = :caseId
                                           and completionDate = null];
        
        if (cmsToUpdate.isEmpty() == false){
            for (CaseMilestone cm : cmsToUpdate){
                
                system.debug(cm.Milestonetype.Name);
                
                if(fileType != null && fileType != '' ){
                    if(cm.Milestonetype.Name.containsIgnorecase(' '+fileType)){
                        system.debug('Trovato '+ fileType + ' in '+cm.Milestonetype.Name);
                        cm.completionDate = complDate;
                    }
                }
                else{
                    cm.completionDate = complDate;
                }
                
            }
            update cmsToUpdate;
            
        }
    }
    
    public static void reopenCONSIPMilestones(Id caseId, string fileType) {  
        
        List<CaseMilestone> cmsToUpdate = [select Id, completionDate, Milestonetype.Name
                                           from CaseMilestone cm
                                           where caseId = :caseId
                                           and completionDate != null];
        
        if (cmsToUpdate.isEmpty() == false){
            for (CaseMilestone cm : cmsToUpdate){
                
                system.debug(cm.Milestonetype.Name);
                
                if(fileType != null && fileType != '' ){
                    if(cm.Milestonetype.Name.containsIgnorecase(' '+fileType)){
                        system.debug('Trovato '+ fileType + ' in '+cm.Milestonetype.Name);
                        cm.completionDate = null;
                    }
                }
                
            }
            update cmsToUpdate;
        }
    }
    
    @auraenabled
    public static void updateMilestoneFields(id caseId) { 
        List<Case> caseToUpdate = [SELECT id FROM Case WHERE Id =:caseId LIMIT 1];
        APIT15_CaseTriggerHandler.populateCaseMilestoneFields(caseToUpdate[0]);
        
    }
    @auraenabled
    public static string getMilestoneName(id caseId) { 
        List<Case> caseList = [SELECT id, IT_Active_Milestone__c, IT_ConsipFase__c, (SELECT id FROM Documents__r WHERE IT_Case__c = :caseId) FROM Case WHERE Id =:caseId LIMIT 1];
        return caseList[0].IT_Active_Milestone__c+'§'+caseList[0].IT_ConsipFase__c+'§'+caseList[0].Documents__r.size();
        
    }
    
    
}