@isTest
public class APIT23_FileUploadControllerTest {
    @istest static void testAttachPic(){
        IT_Welfare_Project__c projectWelfare = new IT_Welfare_Project__c(Name='test Welfare');
        insert projectWelfare;
        String fileName = 'cartoon.jpg';
        APIT23_FileUploadController upload = new APIT23_FileUploadController();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://er-italy--devam.my.salesforce.com/services/apexrest/FileUpload/v1/upload/';
        String postData = 'Body content is there';
        req.requestBody = Blob.valueof(postData);
        req.params.put('id',projectWelfare.Id);
        req.params.put('filename',fileName);
        req.httpMethod = 'POST';
    
        RestContext.request = req;
    
        Test.startTest();
        	String actual = APIT23_FileUploadController.attachPic();
            //String actual = null;//HttpClass.updateCustomObject();
        Test.stopTest();
    
        //System.assertEquals('expected value', actual, 'Value is incorrect');
    }
    
    public class MdaForm implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/java');
            response.setBody('{ "meta": {"messages":[],"status":"succeeded"},"data":[{"abbreviation":"AG", "chief_town_istat_code":"084001", "istat_code":"084", "name":"AGRIGENTO", "name_display":"Agrigento", "province_ref":"38000000022", "region_ref":"38000000020"}]}');
            response.setStatusCode(200);
            return response; 
        }
        
    }
}