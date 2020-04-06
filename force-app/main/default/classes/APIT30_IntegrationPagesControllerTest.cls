@isTest

public class APIT30_IntegrationPagesControllerTest {
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
        IT_Plan__c plan = new IT_Plan__c(Name='test plan',IT_Welfare_Project__c = welfareProjects[0].Id);
        insert plan;
        //list case 
        List<case> cases = new List<case> {
            new Case(AccountId=accounts[0].Id,ContactId=contacts[0].Id, IT_Welfare_Project__c=welfareProjects[0].Id)
                };
                    insert cases;
        //plan 
        
        
        
        /*list benefit
        List<IT_Benefit__c> lbenefit = new List<IT_Benefit__c> {
          new IT_Benefit__c ( IT_Macro_Benefit__c = 'Reimbursement', IT_Benefit__c = 'School Fees'),
          new IT_Benefit__c(IT_Macro_Benefit__c = 'Reimbursement', IT_Benefit__c = 'Family Care'),
          new IT_Benefit__c(IT_Macro_Benefit__c = 'Reimbursement', IT_Benefit__c = 'Public Transport'),
          new IT_Benefit__c(IT_Macro_Benefit__c = 'Fund', IT_Benefit__c = 'Insurance', IT_Fund_Name_1__c='test')
              };
                  insert lbenefit;
        
        */
         
       
            
        Case cse= [select CaseNumber from Case limit 1 ];
        system.debug('cases '+cse);   
        //data reference page
        PageReference pageRef = Page.VFIT30_IntegrationPages_Form;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('caseNumber',cse.CaseNumber);
        
        Test.setMock(HttpCalloutMock.class, new MdaForm());
        APIT30_IntegrationPagesController mdaform = new APIT30_IntegrationPagesController();
        //mdaform.piano = plan;
        mdaform.selectedBenefit = 0;
        mdaform.selectedContact = 0;// 
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
        mdaform.deleteContacts();
        mdaform.addFunding();
        mdaform.savePlan();
        mdaform.insertRefCassaSanitaria(new Contact(LastName='contact',FirstName='test',Phone='77125216536',Email='test@gmail.it'));
        mdaform.insertRefCassaSanitaria(new Contact(LastName='contact',FirstName='test',Phone='77125216536'));
        Test.stopTest();
    
    }
    
    @isTest
    static void PassParametersTest(){
        APIT30_IntegrationPagesController mdaform = new APIT30_IntegrationPagesController();
        APIT30_IntegrationPagesController mdaform2 = new APIT30_IntegrationPagesController();
        mdaform2.addFunding();
        mdaform2.selectedFunding = 0;
        Test.startTest();
        mdaform.PassParameters();
        mdaform2.PassParameters();
        Test.stopTest();
    }
    
    @isTest
    static void listMethodsTest(){
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