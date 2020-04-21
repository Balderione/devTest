@RestResource(urlMapping='/FileUpload/v1/upload/*')
global class APIT23_FileUploadController{
    private static final Integer IMAGE_MAX_SIZE = 100240; 
    
    @HttpPost
    global static id attachPic(){
        ContentVersion cversion = new ContentVersion();
        RestRequest req = RestContext.request;
        String base64Data=req.requestBody.toString().trim();
        String cversiontitle = RestContext.request.params.get('filename');
        Id projectWelfareId=RestContext.request.params.get('id');
        System.debug('cversiontitle++++'+cversiontitle);
        try
        {
            System.debug('projectWalfareId'+projectWelfareId);
            
            cversion.versionData = EncodingUtil.base64Decode(base64Data);
            cversion.Title = cversiontitle;
            cversion.PathOnClient = cversiontitle;
            insert cversion;
            
            
            ContentVersion cversiontest = [select id, ContentDocumentId from ContentVersion WHERE Id =: cversion.Id][0];
            System.debug('projectWalfare@@@@ '+projectwelfareId);
            //ContentDocumentLink cd = [select id, ContentDocumentId from ContentDocumentLink WHERE ContentDocumentId=:cversion.ContentDocumentId];
            ContentDocumentLink cl = new ContentDocumentLink();
            cl.ContentDocumentId = cversiontest.ContentDocumentId;
            cl.LinkedEntityId = projectWelfareId; 
            cl.ShareType = 'V';
            cl.Visibility = 'AllUsers';
            insert cl;
            
            system.debug('testContentInsert.id');
            return null;
        }
        catch (exception ex)
            
        {
            System.debug(ex + 'upload Error');
        }
        return null;
    }
    /*
    @HttpPost
    global static id attachFiles(){
        ContentVersion cversion = new ContentVersion();
        RestRequest req = RestContext.request;
        String[] base64Data=req.requestBody;
        String cversiontitle = RestContext.request.params.get('filename');
        Id projectWelfareId=RestContext.request.params.get('id');
        System.debug('cversiontitle++++'+cversiontitle);
        try
        {
            System.debug('projectWalfareId'+projectWelfareId);
            
            cversion.versionData = EncodingUtil.base64Decode(base64Data);
            cversion.Title = cversiontitle;
            cversion.PathOnClient = cversiontitle;
            insert cversion;
            
            
            ContentVersion cversiontest = [select id, ContentDocumentId from ContentVersion WHERE Id =: cversion.Id][0];
            System.debug('projectWalfare@@@@ '+projectwelfareId);
            //ContentDocumentLink cd = [select id, ContentDocumentId from ContentDocumentLink WHERE ContentDocumentId=:cversion.ContentDocumentId];
            ContentDocumentLink cl = new ContentDocumentLink();
            cl.ContentDocumentId = cversiontest.ContentDocumentId;
            cl.LinkedEntityId = projectWelfareId; 
            cl.ShareType = 'V';
            cl.Visibility = 'AllUsers';
            insert cl;
            
            system.debug('testContentInsert.id');
            return null;
        }
        catch (exception ex)
            
        {
            System.debug(ex + 'upload Error');
        }
        return null;
    }*/
}