@isTest
public class APIT11_Utilities_Test {

    public static testmethod void testUtilities(){
        Test.setMock(HttpCalloutMock.class, new UtilityMock());
        
        APIT11_Utilities.postRequest('urlParam', 'jsonPost');
        
    }
    
    
    
        public class UtilityMock implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}');
        response.setStatusCode(200);
        return response; 
    }
}
}