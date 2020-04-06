@istest
public class WSIT06_Document_Test {
    @isTest static void DocumentUpsertError() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        try{
            RestRequest request = new RestRequest();
            RestResponse res = new RestResponse();
            request.requestUri = '/services/apexrest/ac_document/';
            request.httpMethod = 'PUT';
            request.addHeader('Content-Type', 'application/json');
            request.requestBody = Blob.valueOf('{ "IT_Document": [ { "IT_Client_Code": "004311", "IT_Document_Protocol": "007432/20072006", "IT_Document_Progressive": 34330, "IT_Document_Type": "002", "IT_Registration_Date": "2010-12-20", "IT_Scan_Date": "2010-12-30", "IT_Barcode": "barCode", "IT_Framework_Barcode": null, "IT_PDF_File": "TGEgdml0YSDDqCBjb21lIHVuYSBzY2F0b2xhIGRpIGNpb2Njb2xhdGluaSwgbm9uIHNhbWkgcXVlbGxvIGNoZSB0aSBjYXBpdGVyw6AuCkNpdC4=", "IT_Send_Email": null, "IT_Email": null, "IT_Email_Sending_Date": null, "IT_Barcode_Warrant": null, "IT_Service": null, "IT_Service_2": null, "IT_Barcode_2": null, "IT_Service_3": null, "IT_Barcode_3": null, "IT_136_PDF_File": null, "IT_136_Send_Email": null, "IT_136_Email_Address": null, "IT_136_Email_Sending_Data": null, "IT_136_User_Sender": null, "IT_AC_User": null } ] }');
            RestContext.request = request;
            RestContext.response= res;
            WSIT06_Document.AnagraficaClientiUpsert(); 
        }catch(Exception ecc){
            System.debug('populateFinancialCenter: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());     
        }    
    }
    @isTest static void DocumentUpsert() {
        IT_ControlUpdateTrigger__c settings = IT_ControlUpdateTrigger__c.getOrgDefaults();
        settings.IT_ControlTreiggerUpdate__c = true;
        insert settings;
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        accountTest.ER_VAT_Number__c = '02554698475';
        insert accountTest;
        Contact contactTest = APIT14_DataFactory.create_Contact(accountTest.Id);
        contactTest.IT_Code__c = 'StringString';
        insert contactTest;
        ER_Financial_Center__c FinancialTest = APIT14_DataFactory.create_FinancialCenter(accountTest.Id, contactTest.Id);
        FinancialTest.ER_Card_Operational_System_ID__c = 'Tes2w';
        FinancialTest.ER_Type__c = 'Client'; 
        FinancialTest.IT_Financial_Center__c = '004311';
        insert FinancialTest;
        Contract contractTest = APIT14_DataFactory.create_Contract(accountTest.Id);
        contractTest.IT_Financial_center__c = FinancialTest.Id;
        contractTest.IT_Contract_Number__c = '5555/6666';
        insert contractTest;
        Attachment attach = new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=contractTest.id;
        insert attach;
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri = '/services/apexrest/ac_document/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ "IT_Document": [ { "IT_Client_Code": "004311", "IT_Document_Protocol": "007432/20072006", "IT_Document_Progressive": 34330, "IT_Document_Type": "002", "IT_Registration_Date": "2010-12-20", "IT_Scan_Date": "2010-12-30", "IT_Barcode": "barCode", "IT_Framework_Barcode": null, "IT_PDF_File": "TGEgdml0YSDDqCBjb21lIHVuYSBzY2F0b2xhIGRpIGNpb2Njb2xhdGluaSwgbm9uIHNhbWkgcXVlbGxvIGNoZSB0aSBjYXBpdGVyw6AuCkNpdC4=", "IT_Send_Email": null, "IT_Email": null, "IT_Email_Sending_Date": null, "IT_Barcode_Warrant": null, "IT_Service": null, "IT_Service_2": null, "IT_Barcode_2": null, "IT_Service_3": null, "IT_Barcode_3": null, "IT_136_PDF_File": null, "IT_136_Send_Email": null, "IT_136_Email_Address": null, "IT_136_Email_Sending_Data": null, "IT_136_User_Sender": null, "IT_AC_User": null } ] }');
        RestContext.request = request;
        RestContext.response= res;
        WSIT06_Document.AnagraficaClientiUpsert();  
    }

}