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
        Test.stopTest();
    
        //System.assertEquals(null, actual, 'Value is incorrect');
    }
}