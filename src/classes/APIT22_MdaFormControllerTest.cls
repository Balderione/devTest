@isTest

public class APIT22_MdaFormControllerTest {
    @testSetup static void setup() {
        
    }
    
    @isTest 
    static void testSubmit() {
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
        List<IT_Welfare_Project__c> welfareProjects= new List<IT_Welfare_Project__c>{
            new IT_Welfare_Project__c(Name='test Welfare')
                };
                    insert welfareProjects;
        
        //list case 
        List<case> cases = new List<case> {
            new Case(AccountId=accounts[0].Id,ContactId=contacts[0].Id, IT_Welfare_Project__c=welfareProjects[0].Id)
                };
                    insert cases;
        
        Case cse= [select CaseNumber from Case limit 1 ];
        system.debug('cases '+cse);   
        //data reference page
        PageReference pageRef = Page.VFIT02_MDA_Form;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('caseNumber',cse.CaseNumber);
        
        Test.setMock(HttpCalloutMock.class, new MdaForm());
        APIT22_MdaFormController mdaform = new APIT22_MdaFormController();
        Test.startTest();
        mdaform.submit();
        Test.stopTest();
    }
    
    @isTest 
    static void testSubmit2() {
        //list Contacts
        List<Contact> contacts= new List<Contact>{
            new Contact(Phone='771252165',Email='',FirstName='maby', LastName='gaye')
                };
                    insert contacts;
        
        //list Accounts
        List<Account> accounts= new List<Account>{
            new Account(Name='test safona', IT_Company_Type__c='private', IT_Industry__c='10', ER_VAT_Number__c='470550013' , IT_Fiscal_Code__c='470550013' )
                };
                    //insert accounts;
                    
                    //list IT_Welfare_Project IT_Welfare_Project__c
                    List<IT_Welfare_Project__c> welfareProjects= new List<IT_Welfare_Project__c>{
                        new IT_Welfare_Project__c(Name='test Welfare')
                            };
                                insert welfareProjects;
        
        //list case (AccountId=accounts[0].Id,)
        List<case> cases = new List<case> {
            new Case(ContactId=contacts[0].Id)
                };
                    insert cases;
        
        Case cse= [select CaseNumber from Case limit 1 ];
        system.debug('cases '+cse);   
        //data reference page
        PageReference pageRef = Page.VFIT02_MDA_Form;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('caseNumber',cse.CaseNumber);
        
        
        APIT22_MdaFormController mdaform = new APIT22_MdaFormController();
        Test.startTest();
        mdaform.submit();
        Test.stopTest();
    }
    
    @isTest 
    static void testGetProvincesStradario() {
        Test.setMock(HttpCalloutMock.class, new MdaForm());
        APIT22_MdaFormController mdaform = new APIT22_MdaFormController();
        Test.startTest();
        mdaform.getProvincesStradario();
        Test.stopTest();
    }
    
    // pageReference retrieveMunicipalities()
    @isTest 
    static void testRetrieveMunicipalities() {
        Test.setMock(HttpCalloutMock.class, new MdaForm());
        IT_Welfare_Project__c project = new IT_Welfare_Project__c(Name='test Welfare',IT_BillingProvince_form__c='Agrigento');
        APIT22_MdaFormController mdaform = new APIT22_MdaFormController();
        mdaform.projectWelfare = project;
        Test.startTest();
        pageReference page= mdaform.retrieveMunicipalities();
        Test.stopTest();
    }
    
    @isTest 
    static void testInsertContact() {
        Contact cont = new Contact(Email='',Phone='00221771111');
        APIT22_MdaFormController mdaform = new APIT22_MdaFormController();
        APIT22_MdaFormController mdaform2 = new APIT22_MdaFormController();
        mdaform2.contact = cont;
        mdaform2.caseInstance = new Case(ContactId = null);
        Test.startTest();
        mdaform.insertContact(cont);
        mdaform2.insertContact(cont);
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