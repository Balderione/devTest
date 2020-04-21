@isTest

   
      /*  IT_Custom_Control__c settings = IT_Custom_Control__c.getOrgDefaults('KeyCaseNumber');
        settings. IT_Custom_Text__c= '1v4XI+JZGajcDlmOaZnpmpXQfvMOZH+u63nPV9G0XZE=';
        insert settings; */
      

public class APIT30_IntegrationPagesControllerTest {
    @testSetup static void setup() {
        
    }
    
    @isTest 
    static void testSubmit() {
      
        IT_Custom_Control__c setting = new IT_Custom_Control__c();
        setting.Name = 'KeyCaseNumber';
        setting.IT_Custom_Text__c = '1v4XI+JZGajcDlmOaZnpmpXQfvMOZH+u63nPV9G0XZE=';
        insert setting;
        

        //list Contacts
        List<Contact> contacts= new List<Contact>{
            new Contact(Phone='77125216536',Email='testMail@gmail.com',FirstName='Test', LastName='Contact')
                };
                    insert contacts;
        
        //list Accounts
        List<Account> accounts= new List<Account>{
            new Account(Name='test safona', IT_Company_Type__c='private', IT_Industry__c='10', ER_VAT_Number__c='470550013' , IT_Fiscal_Code__c='470550013', IT_Legal_Form__c='AG')
                };
                    insert accounts;
        
        //list IT_Welfare_Project IT_Welfare_Project__c
         IT_Welfare_Project__c  welfareProjects= new IT_Welfare_Project__c (Name='test Welfare', IT_Unique_Billing__c = true);
        
                    insert welfareProjects;
        IT_Plan__c plan = new IT_Plan__c(Name='test plan',IT_Welfare_Project__c = welfareProjects.Id, IT_Html_Body__c = '<html> </html>');
        insert plan;
        //list case 
        
        Blob keyEn = EncodingUtil.base64Decode(setting.IT_Custom_Text__c);
        Blob caseNum = Blob.valueOf('00000001');
        Blob codeEncrypt =  Crypto.encryptWithManagedIV('AES256', keyEn, caseNum);
        
     //   singleCase.IT_Case_Number_Cripted__c = EncodingUtil.base64Encode(codeEncrypt);
        
        Case caseobj = new Case(AccountId=accounts[0].Id, ContactId=contacts[0].Id, IT_Case_Number_Cripted__c=EncodingUtil.base64Encode(codeEncrypt) , IT_Welfare_Project__c=welfareProjects.Id);
                    insert caseobj;
        
        plan.IT_Provisioning_Case__c = caseobj.ID;
        update plan;     
            
        system.debug('cases '+caseobj.IT_Case_Number_Cripted__c);   
        //data reference page
        
        PageReference pageRef = Page.VFIT30_IntegrationPages_Form;
        
        test.setCurrentPageReference(pageRef);
        
        pageRef.getParameters().put('caseNumber',caseobj.IT_Case_Number_Cripted__c);
        
        Test.setMock(HttpCalloutMock.class, new MdaForm());
        APIT30_IntegrationPagesController mdaform = new APIT30_IntegrationPagesController();
        //mdaform.piano = plan;
        
        system.debug('@@@@casen' + mdaform.caseNumber);
        mdaform.projectWelfare = welfareProjects;
        mdaform.piano = plan;
        mdaform.account = accounts[0];
        mdaform.caseInstance = caseobj;
        mdaform.selectedBenefit = 0;
        mdaform.selectedContact = 0;//
        mdaform.strutturaPayroll = 'unico';
        mdaform.pdfHtml = '<p>html content</p>';
        mdaform.benefitDaAttivare = new List<String>{'cassa','istruzione','assistenza','trasporto','previdenza','compliments','other'};
        mdaform.contact = new Contact(LastName='contact',FirstName='test',Phone='77125216536',Email='test@gmail.it');
        Test.startTest();
        mdaform.showReferenteSelected();
        mdaform.displayPdf();
        mdaform.savePdfAttachment();
        mdaform.deleteRows();
        mdaform.addContact();
        mdaform.addContact();
        mdaform.addContact2();
        mdaform.deleteContacts();
        mdaform.addFunding();
        mdaform.savePlan();
        mdaform.insertRefCassaSanitaria(new Contact(LastName='contact',FirstName='test',Phone='77125216536',Email='test@gmail.it', accountId = accounts[0].ID));
        mdaform.insertRefCassaSanitaria(new Contact(LastName='contact',FirstName='test',Phone='77125216536', accountId = accounts[0].ID));
        Test.stopTest();
    
    }
    
    @isTest
    static void PassParametersTest(){
        
        IT_Custom_Control__c setting = new IT_Custom_Control__c();
        setting.Name = 'KeyCaseNumber';
        setting.IT_Custom_Text__c = '1v4XI+JZGajcDlmOaZnpmpXQfvMOZH+u63nPV9G0XZE=';
        insert setting;
        

        //list Contacts
        List<Contact> contacts= new List<Contact>{
            new Contact(Phone='77125216536',Email='testMail@gmail.com',FirstName='Test', LastName='Contact')
                };
                    insert contacts;
        
        //list Accounts
        List<Account> accounts= new List<Account>{
            new Account(Name='test safona', IT_Company_Type__c='private', IT_Industry__c='10', ER_VAT_Number__c='470550013' , IT_Fiscal_Code__c='470550013', IT_Legal_Form__c='AG')
                };
                    insert accounts;
        
        //list IT_Welfare_Project IT_Welfare_Project__c
         IT_Welfare_Project__c  welfareProjects= new IT_Welfare_Project__c (Name='test Welfare', IT_Unique_Billing__c = true);
        
                    insert welfareProjects;
        IT_Plan__c plan = new IT_Plan__c(Name='test plan',IT_Welfare_Project__c = welfareProjects.Id, IT_Html_Body__c = '<html> </html>');
        insert plan;
        //list case 
        
        Blob keyEn = EncodingUtil.base64Decode(setting.IT_Custom_Text__c);
        Blob caseNum = Blob.valueOf('00000001');
        Blob codeEncrypt =  Crypto.encryptWithManagedIV('AES256', keyEn, caseNum);
        
     //   singleCase.IT_Case_Number_Cripted__c = EncodingUtil.base64Encode(codeEncrypt);
        
        Case caseobj = new Case(AccountId=accounts[0].Id, ContactId=contacts[0].Id, IT_Case_Number_Cripted__c=EncodingUtil.base64Encode(codeEncrypt) , IT_Welfare_Project__c=welfareProjects.Id);
                    insert caseobj;
        
        plan.IT_Provisioning_Case__c = caseobj.ID;
        update plan;     
            
        system.debug('cases '+caseobj.IT_Case_Number_Cripted__c);   
        //data reference page
        
        PageReference pageRef = Page.VFIT30_IntegrationPages_Form;
        
        test.setCurrentPageReference(pageRef);
        
        pageRef.getParameters().put('caseNumber',caseobj.IT_Case_Number_Cripted__c);
        
      
        
        Test.setMock(HttpCalloutMock.class, new MdaForm());
        
        
        
        APIT30_IntegrationPagesController mdaform = new APIT30_IntegrationPagesController();
        APIT30_IntegrationPagesController mdaform2 = new APIT30_IntegrationPagesController();
        mdaform.addFunding();
        mdaform.selectedFunding = 0;
        Test.startTest();
        mdaform.PassParameters();
        mdaform2.PassParameters();
        Test.stopTest();
    }
    
    @isTest
    static void listMethodsTest(){
        
        IT_Custom_Control__c setting = new IT_Custom_Control__c();
        setting.Name = 'KeyCaseNumber';
        setting.IT_Custom_Text__c = '1v4XI+JZGajcDlmOaZnpmpXQfvMOZH+u63nPV9G0XZE=';
        insert setting;
        

        //list Contacts
        List<Contact> contacts= new List<Contact>{
            new Contact(Phone='77125216536',Email='testMail@gmail.com',FirstName='Test', LastName='Contact')
                };
                    insert contacts;
        
        //list Accounts
        List<Account> accounts= new List<Account>{
            new Account(Name='test safona', IT_Company_Type__c='private', IT_Industry__c='10', ER_VAT_Number__c='470550013' , IT_Fiscal_Code__c='470550013', IT_Legal_Form__c='AG')
                };
                    insert accounts;
        
        //list IT_Welfare_Project IT_Welfare_Project__c
         IT_Welfare_Project__c  welfareProjects= new IT_Welfare_Project__c (Name='test Welfare', IT_Unique_Billing__c = true);
        
                    insert welfareProjects;
        IT_Plan__c plan = new IT_Plan__c(Name='test plan',IT_Welfare_Project__c = welfareProjects.Id, IT_Html_Body__c = '<html> </html>');
        insert plan;
        //list case 
        
        Blob keyEn = EncodingUtil.base64Decode(setting.IT_Custom_Text__c);
        Blob caseNum = Blob.valueOf('00000001');
        Blob codeEncrypt =  Crypto.encryptWithManagedIV('AES256', keyEn, caseNum);
        
     //   singleCase.IT_Case_Number_Cripted__c = EncodingUtil.base64Encode(codeEncrypt);
        
        Case caseobj = new Case(AccountId=accounts[0].Id, ContactId=contacts[0].Id, IT_Case_Number_Cripted__c=EncodingUtil.base64Encode(codeEncrypt) , IT_Welfare_Project__c=welfareProjects.Id);
                    insert caseobj;
        
        plan.IT_Provisioning_Case__c = caseobj.ID;
        update plan;     
            
        system.debug('cases '+caseobj.IT_Case_Number_Cripted__c);   
        //data reference page
        
        PageReference pageRef = Page.VFIT30_IntegrationPages_Form;
        
        test.setCurrentPageReference(pageRef);
        
        pageRef.getParameters().put('caseNumber',caseobj.IT_Case_Number_Cripted__c);
        
      
        
        Test.setMock(HttpCalloutMock.class, new MdaForm());
        
        
        
        APIT30_IntegrationPagesController mdaform = new APIT30_IntegrationPagesController();
        mdaform.selectedFunding = 0;
        mdaform.indexToDelete = 0;
        //mdaform.societaObject = new SocietaObject('test nome','test indrizzo', 'pec', 'test@test.it', 0);
        Test.startTest();
        mdaform.showReferente = 'unica';
        mdaform.addToSocietaList();
        mdaform.deleteSocietaToList();
        mdaform.showReferente = 'referente';
        mdaform.addToSocietaList();
        mdaform.addToSocietaList();
        mdaform.deleteSocietaToList();
        mdaform.addToSedeList();
        mdaform.addToSedeList();
        mdaform.deleteSedeToList();
        mdaform.addFunding();
        mdaform.addFunding();
        mdaform.getReferenteOptions();
        mdaform.getSeparataOptions();
        mdaform.getBillingOptions();
        mdaform.getReferenteOptions();
        mdaform.deleteRows();
        mdaform.addContact();
        mdaform.addContact();
        mdaform.addToUnicaList();
        mdaform.deleteUnicaToList();
        Test.stopTest();
    }
    
    @isTest
    static void PassParametersTest2(){
        
         IT_Custom_Control__c setting = new IT_Custom_Control__c();
        setting.Name = 'KeyCaseNumber';
        setting.IT_Custom_Text__c = '1v4XI+JZGajcDlmOaZnpmpXQfvMOZH+u63nPV9G0XZE=';
        insert setting;
        

        //list Contacts
        List<Contact> contacts= new List<Contact>{
            new Contact(Phone='77125216536',Email='testMail@gmail.com',FirstName='Test', LastName='Contact')
                };
                    insert contacts;
        
        //list Accounts
        List<Account> accounts= new List<Account>{
            new Account(Name='test safona', IT_Company_Type__c='private', IT_Industry__c='10', ER_VAT_Number__c='470550013' , IT_Fiscal_Code__c='470550013', IT_Legal_Form__c='AG')
                };
                    insert accounts;
        
        //list IT_Welfare_Project IT_Welfare_Project__c
         IT_Welfare_Project__c  welfareProjects= new IT_Welfare_Project__c (Name='test Welfare', IT_Unique_Billing__c = true);
        
                    insert welfareProjects;
        IT_Plan__c plan = new IT_Plan__c(Name='test plan',IT_Welfare_Project__c = welfareProjects.Id, IT_Html_Body__c = '<html> </html>');
        insert plan;
        //list case 
        
        Blob keyEn = EncodingUtil.base64Decode(setting.IT_Custom_Text__c);
        Blob caseNum = Blob.valueOf('00000001');
        Blob codeEncrypt =  Crypto.encryptWithManagedIV('AES256', keyEn, caseNum);
        
     //   singleCase.IT_Case_Number_Cripted__c = EncodingUtil.base64Encode(codeEncrypt);
        
        Case caseobj = new Case(AccountId=accounts[0].Id, ContactId=contacts[0].Id, IT_Case_Number_Cripted__c=EncodingUtil.base64Encode(codeEncrypt) , IT_Welfare_Project__c=welfareProjects.Id);
                    insert caseobj;
        
        plan.IT_Provisioning_Case__c = caseobj.ID;
        update plan;     
            
        system.debug('cases '+caseobj.IT_Case_Number_Cripted__c);   
        //data reference page
        
        PageReference pageRef = Page.VFIT30_IntegrationPages_Form;
        
        test.setCurrentPageReference(pageRef);
        
        pageRef.getParameters().put('caseNumber',caseobj.IT_Case_Number_Cripted__c);
        
      
        
        Test.setMock(HttpCalloutMock.class, new MdaForm());
        
        APIT30_IntegrationPagesController mdaform = new APIT30_IntegrationPagesController();
        Test.startTest(); 
        
        mdaform.PassParameters();
        Test.stopTest();
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