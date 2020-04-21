public without sharing class APIT22_MdaFormController {

      
    public Boolean result{get;set;}
    //object instances
    public Contact contact {get; set;}
    public IT_Welfare_Project__c projectWelfare{get;set;}    
    public ContentVersion cversion{get;set;}
    public Case caseInstance {get; set;}
    public Account account{get;set;}
    public String accountId{get;set;}
    public String caseNumber{get;set;}
    public String cversiontitle{get;set;}
    public Boolean controllo {get; set;}
    
    private static final Integer IMAGE_MAX_SIZE = 100240; 
    
    
    //integration part
    public List<SelectOption> provinceLst {get;set;}
    public List<SelectOption> municipalityLst {get;set;}
    
    public APIT22_MdaFormController(){
        this.controllo=true;
        this.contact = new Contact(); 
        this.projectWelfare = new IT_Welfare_Project__c();
        this.cversion = new ContentVersion();
        
        //find case number
        this.caseNumber=this.getCaseNumber();
        if(this.caseNumber!=null){
            //retrieving case list from the number
            List<case> cases=[SELECT Id, AccountId,ContactId,IT_Welfare_Project__r.Id from Case WHERE CaseNumber =: caseNumber];
            //if a case number is not found by the given number
            if(cases.size()<1){
                apexpages.Message msg = new apexpages.Message( 
                    apexpages.Severity.ERROR,'The given case number is incorrect');
                apexpages.addMessage(msg);
            } else {
                //if at least one instance found
                this.caseInstance=cases[0];
                //check if lookup Account is found
                if(this.caseInstance.AccountId!=null){
                    this.account = [SELECT Id, Name, ER_VAT_Number__c, IT_Account_Address__c, isPersonAccount, ParentId
                                    From Account WHERE Id =:this.caseInstance.AccountId];
                }
                //check if lookup Contact is found
                if(this.caseInstance.ContactId!=NULL){
                    this.contact = [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Id =: this.caseInstance.ContactId];
                }
                //check if lookup IT_Welfare_Project is found
                if(this.caseInstance.IT_Welfare_Project__r.Id!=null){
                    this.projectWelfare = [SELECT Id,Name,IT_PO_ODA__c,IT_Involved_locations__c,IT_Involved_Society__c,
                                           IT_Unique_Billing__c,IT_Splitted_Billing_for_CDC__c,IT_Fee_Parent_Group__c,
                                           IT_CdC_Center_of_Cost__c,IT_Acquisition_Channel__c,  IT_Plan_Description__c,
                                           IT_Payroll_for_Levels__c,IT_Payroll_Personalization__c, IT_Financial_Sources__c,                            
                                           IT_BillingStreetSquare_form__c,IT_BillingStreetNumber_form__c,
                                           IT_BillingPostalCodeBilling_form__c,IT_BillingAdressNotes_form__c,
                                           IT_Per_Capita_Amount__c,IT_Beneficiaries_Number__c,IT_Membership_Payment_Type__c,
                                           IT_End_Plan_Residue_Management__c,IT_Type__c,IT_Platform_Choice__c,
                                           IT_BillingProvince_form__c,IT_BillingCityBillingCity_form__c, IT_Cessation_Residue_Management__c,
                                           IT_Macro_Benefit__c, IT_Benefit__c, IT_Membership_Choice_Start_Date__c, IT_Membership_Choice_End_Date__c,
                                           IT_Benefit_Start_Date__c, IT_Benefit_End_Date__c, IT_Email_send_payroll__c,
                                           IT_Email_Credentials__c, IT_Replacement__c, IT_Plan_Start_Date__c,
                                           IT_Plan_End_Date__c
                                           from IT_Welfare_Project__c where Id=:this.caseInstance.IT_Welfare_Project__r.Id];
                }  
            }
        }
        
        //integration part
        provinceLst=new List<SelectOption>();
        municipalityLst=new List<SelectOption>();
        provinceLst.add(new SelectOption('','--None--'));
        try
        {
            getProvincesStradario();
        }
        catch(exception e)
        {
            System.debug(e + 'webservice error');
        }
    }
    
    public string getCaseNumber(){
        string caseNumber = System.currentPageReference().getParameters().get('caseNumber');
        System.debug(System.currentPageReference().getParameters());
        if ( String.isBlank(caseNumber) || String.isEmpty(caseNumber)) 
        {
            apexpages.Message msg = new apexpages.Message( 
                apexpages.Severity.ERROR,' Non è stato trovato il caseNumber!' );
            apexpages.addMessage(msg);
            return null;
        }
        return caseNumber;
    }
    
    public void submit()
    {
        //insertAccount(this.account);
        insertWelfareP(this.projectWelfare);
        insertContact(this.contact);
        //update case if the inserts function updated the case lookup fields
        update this.caseInstance;
        
        
        if ( controllo == true) 
        {
            apexpages.Message msg = new apexpages.Message( 
                apexpages.Severity.CONFIRM,' SUBMIT eseguito con successo ' );
            apexpages.addMessage(msg);
            try 
            {
                sendMail();
            }
            catch (exception ex)
            {   
                apexpages.Message msg2 = new apexpages.Message( 
                    apexpages.Severity.ERROR,' Non è stato possibile inviare l\'email ' );
                apexpages.addMessage(msg2);
                System.debug( ex.getStackTraceString() + 'errore @@');
            }
            
        }
        
    }
    
    
    public void insertWelfareP(IT_Welfare_Project__c pw)                                         //Utils Methods for validations before insert
    {
        if (String.isBlank(this.projectWelfare.Name) || String.isEmpty(this.projectWelfare.Name))
        {
            apexpages.Message msg = new apexpages.Message( 
                apexpages.Severity.WARNING,'  ' );
            apexpages.addMessage(msg);
            this.controllo = false;
            
        }
        try 
        {
            if ( this.controllo )
            {
                update pw;
                if(this.caseInstance.IT_Welfare_Project__r.Id==null){
                    this.caseInstance.IT_Welfare_Project__c=this.projectWelfare.Id;
                }
            }
        } catch (exception ex)
        {
            System.debug(ex);
        }
    }   
    

    
    public void insertContact(Contact cont) 
    {  
        if ( String.isBlank(this.contact.Email) && String.isBlank(this.contact.Phone) )
        {
            apexpages.Message msg = new apexpages.Message( 
                apexpages.Severity.WARNING,' Inserire almeno uno tra Email e Numero di telefono. ' );
            apexpages.addMessage(msg);
            controllo = false;
            
        }
        
        if(!String.isBlank(this.contact.Phone))
        {
            // String phoneRegex = '[\\s0-9]+';
            String phoneRegex = '[0-9]{10,12}';
            boolean result = false;
            Pattern MyPattern = Pattern.compile(phoneRegex);
            Matcher MyMatcher = MyPattern.matcher(this.contact.Phone);
            result = MyMatcher.matches(); 
            
            if (!result) 
            {
                controllo = false;
                apexpages.Message msg = new apexpages.Message( 
                    apexpages.Severity.WARNING,' Il campo Telefono deve essere in un formato corretto!' );
                apexpages.addMessage(msg);
            }
            
        }
        
        if ( String.isBlank(this.contact.FirstName) || String.isBlank(this.contact.LastName) )
        {
            apexpages.Message msg = new apexpages.Message( 
                apexpages.Severity.WARNING,' Inserire il Nome e Cognoome del referente!' );
            apexpages.addMessage(msg);
            controllo = false;
        }
        if( controllo ) 
            
        {
            upsert contact;
            if(this.caseInstance.ContactId==null){
                this.caseInstance.ContactId=this.contact.Id;
            }
        }
        
    }     
    
    
    /*   public void insertAccount(Account acc )
{

AND(
$User.ER_BypassVR__c = False,
ISPICKVAL( $User.ER_Business_Unit__c , 'IT'),
NOT( REGEX( Phone , "[\\s0-9]+"))

)
*   String vatRegex = '[0-9]{8}-[0-9]{1}-[0-9]{2}';
boolean result = false;
Pattern MyPattern = Pattern.compile(vatRegex);
Matcher MyMatcher = MyPattern.matcher(aiva);
result = MyMatcher.matches(); 

if(!result) 
{
apexpages.Message msg = new apexpages.Message( 
apexpages.Severity.WARNING,' P.iva doesn\'t respect the format ' );
apexpages.addMessage(msg);

} 
else 
{
if(account!=null){
upsert account;
if(this.caseInstance.AccountId==null){
this.caseInstance.AccountId=this.account.Id;
}                
}
//}

}                   */
    
    public void sendMail()
    {
        String value = '';
        System.debug('prijectWalfare'+this.projectwelfare);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string[] toAdresses = new string[] {this.contact.Email};
            EmailTemplate emailTemplate = [select HtmlValue from EmailTemplate where Name='IT Summarize'];
        string htmlBody = emailTemplate.HtmlValue;
        value = this.account.ER_VAT_Number__c;     
        htmlBody = htmlBody.replace('{!Account.ER_VAT_Number__c}', value);
        value = this.account.Name;
        htmlBody = htmlBody.replace('{!Account.Name}', value);
        value = this.projectwelfare.IT_Acquisition_Channel__c!=null?this.projectwelfare.IT_Acquisition_Channel__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Acquisition_Channel__c}', value);
        value = this.projectWelfare.IT_PO_ODA__c!=null?this.projectWelfare.IT_PO_ODA__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_PO_ODA__c}', value);
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Unique_Billing__c}', this.projectWelfare.IT_Unique_Billing__c == true?'Yes':'No');
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_CdC_Center_of_Cost__c}', this.projectWelfare.IT_CdC_Center_of_Cost__c == true?'Yes':'No');
        value = this.projectwelfare.IT_Involved_locations__c!=null?this.projectwelfare.IT_Involved_locations__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Involved_locations__c}', value);            
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Splitted_Billing_for_CDC__c }', this.projectWelfare.IT_Splitted_Billing_for_CDC__c == true?'Yes':'No');
        value = this.projectwelfare.IT_Involved_Society__c!=null?''+this.projectwelfare.IT_Involved_Society__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Involved_Society__c}', value);
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Fee_Parent_Group__c}', this.projectWelfare.IT_Fee_Parent_Group__c == true?'Yes':'No');
        htmlBody = htmlBody.replace('{!Contact.FirstName}', this.contact.FirstName);
        htmlBody = htmlBody.replace('{!Contact.Phone}', this.contact.Phone);
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Plan_Start_Date__c}', ''+this.projectwelfare.IT_Plan_Start_Date__c);
        value = this.projectWelfare.IT_Membership_Payment_Type__c!=null?this.projectWelfare.IT_Membership_Payment_Type__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Membership_Payment_Type__c}', value);
        value = this.projectwelfare.IT_Type__c!=null?this.projectwelfare.IT_Type__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Type__c}', value);
        htmlBody = htmlBody.replace('{!Contact.LastName}', this.contact.LastName);
        value = this.projectwelfare.IT_Per_Capita_Amount__c!=null?''+this.projectwelfare.IT_Per_Capita_Amount__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Per_Capita_Amount__c}', value);
        value = this.projectwelfare.IT_Plan_End_Date__c!=null?''+this.projectwelfare.IT_Plan_End_Date__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Plan_End_Date__c}', value);
        value = this.projectwelfare.IT_End_Plan_Residue_Management__c != null ?this.projectwelfare.IT_End_Plan_Residue_Management__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_End_Plan_Residue_Management__c}',value);
        htmlBody = htmlBody.replace('{!Contact.Email}', this.contact.Email);
        value = this.projectwelfare.IT_Beneficiaries_Number__c!=null?''+this.projectwelfare.IT_Beneficiaries_Number__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Beneficiaries__c}', value);
        value = this.projectwelfare.IT_Platform_Choice__c!=null?''+this.projectwelfare.IT_Platform_Choice__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Platform_Choice__c}', value);
        value = this.projectwelfare.IT_Cessation_Residue_Management__c!=null?''+this.projectwelfare.IT_Cessation_Residue_Management__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Cessation_Residue_Management__c}', value);
        value = this.projectwelfare.IT_Membership_Choice_Start_Date__c!=null?''+this.projectwelfare.IT_Membership_Choice_Start_Date__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Membership_Choice_Start_Date__c}', value);
        value = this.projectwelfare.IT_Membership_Choice_End_Date__c!=null?''+this.projectwelfare.IT_Membership_Choice_End_Date__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Membership_Choice_End_Date__c}', value);
        value = this.projectwelfare.IT_Type__c!=null?''+this.projectwelfare.IT_Type__c:'';
        htmlBody = htmlBody.replace('{!IT_Funding_Source__c.IT_Type__c}', value);
        value = this.projectwelfare.IT_Benefit_Start_Date__c!=null?''+this.projectwelfare.IT_Benefit_Start_Date__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Benefit_Start_Date__c}', value);
        value = this.projectwelfare.IT_Benefit_End_Date__c!=null?''+this.projectwelfare.IT_Benefit_End_Date__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Benefit_End_Date__c}', value);
        value = this.projectwelfare.IT_Email_send_payroll__c!=null?''+this.projectwelfare.IT_Email_send_payroll__c:'';
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Email_send_payroll__c}', value);    
        value = this.projectwelfare.IT_Email_Credentials__c!=null?''+this.projectwelfare.IT_Email_Credentials__c:'';    
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Email_Credentials__c}', value);    
        //  htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Credentials__c}', this.projectWelfare.IT_Credentials__c == true?'Yes':'No');
        value = this.projectwelfare.IT_Replacement__c!=null?''+this.projectwelfare.IT_Replacement__c:'';  
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Replacement__c}', value); 
        value = this.projectwelfare.IT_Plan_Description__c!=null?''+this.projectwelfare.IT_Plan_Description__c:'';  
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Plan_Description__c}', value); 
        value = this.projectwelfare.IT_Financial_Sources__c!=null?''+this.projectwelfare.IT_Financial_Sources__c:'';  
        htmlBody = htmlBody.replace('{!IT_Welfare_Project__c.IT_Financial_Sources__c}', value); 
     
        
        email.setToAddresses(toAdresses);
        email.setSubject('Summary');
        email.setHtmlBody(htmlBody);
        try
        {
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
        catch(exception e)
        {
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
        
    }
    
    //integration part
    public void getProvincesStradario(){
        Http h = new Http();
        HttpRequest req = APER06_WebserviceUtility.getHttpRequest(
            '/referential/addresses/provinces',
            'GET',
            null,
            null);
        req.setHeader('Content-Type', 'application/java');
        HttpResponse res = h.send(req);
        String responseBody = res.getbody();
        System.debug( responseBody + '@@@ Response ');
        //JSONParser parser = JSON.createParser(responseBody);
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        System.debug( meta + '@@@ Response ');
        List<Object> datas = (List<Object>)meta.get('data');
        if( datas.size() > 0 ) 
        {
            for(Object data : datas){
                Object province_ref = ((Map<String, Object>)data).get('province_ref'),
                    name_display = ((Map<String, Object>)data).get('name_display'),
                    region_ref = ((Map<String, Object>)data).get('region_ref');
                
                provinceLst.add(new SelectOption(
                    province_ref.toString(),
                    name_display.toString()
                ));
            }
        }
    }
    
    public pageReference retrieveMunicipalities(){
        
        System.debug('Hi, we are there '+projectwelfare.IT_BillingProvince_form__c);
        String provinceRef = '';
        municipalityLst.clear();
        System.debug('province ===> '+projectwelfare.IT_BillingProvince_form__c);
        
        if(projectwelfare.IT_BillingProvince_form__c != ''){
            String[] values = projectwelfare.IT_BillingProvince_form__c.split('§');
            provinceRef = values[0];
        }
        System.debug('provinceRef ===>  '+provinceRef);
        if(provinceRef != ''){
            Http h = new Http();
            HttpRequest req = APER06_WebserviceUtility.getHttpRequest(
                '/referential/addresses/provinces/'+provinceRef+'/municipalities',
                'GET',
                null,
                null);
            req.setHeader('Content-Type', 'application/java');
            HttpResponse res = h.send(req);
            String responseBody = res.getbody();
            //JSONParser parser = JSON.createParser(responseBody);
            Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            List<Object> datas = (List<Object>)meta.get('data');
            for(Object data : datas){
                System.debug(data);
                
                Object municipality_ref = ((Map<String, Object>)data).get('municipality_ref'),
                    name_display = ((Map<String, Object>)data).get('name_display');
                municipalityLst.add(new SelectOption(
                    municipality_ref +'§'+ name_display,
                    name_display.toString()
                ));
            }
        }
        return null;
        
    }
    
    public blob file {get;set;}
    
    /* public PageReference upload() {
        //  public void upload() {
        try
        {
            System.debug('projectWalfare'+this.projectwelfare);
            if ( file.size() < IMAGE_MAX_SIZE )
            {
                cversion.versionData = file;
                cversion.Title = cversiontitle;
                cversion.PathOnClient = 'test.jpg';
                insert cversion;
                
                
                ContentVersion cversiontest = [select id, ContentDocumentId from ContentVersion WHERE Id =: cversion.Id][0];
                System.debug('projectWalfare@@@@ '+this.projectwelfare);
                //ContentDocumentLink cd = [select id, ContentDocumentId from ContentDocumentLink WHERE ContentDocumentId=:cversion.ContentDocumentId];
                ContentDocumentLink cl = new ContentDocumentLink();
                cl.ContentDocumentId = cversiontest.ContentDocumentId;
                cl.LinkedEntityId = this.projectWelfare.Id; 
                cl.ShareType = 'V';
                cl.Visibility = 'AllUsers';
                insert cl;
                
                system.debug('testContentInsert.id');
                apexpages.Message msg = new apexpages.Message( 
                    apexpages.Severity.CONFIRM,' File caricato con successo! ' );
                apexpages.addMessage(msg);
                return null;
                
                
                //     cd.LinkedEntityId = this.projectWelfare.Id;
                //        cd.LinkedEntityId = 'a0Z0E000002d0gqUAA';
                
            }
            else 
            {
                apexpages.Message msg = new apexpages.Message( 
                    apexpages.Severity.ERROR,' File troppo grande, dimensione massima 10MB! ' );
                apexpages.addMessage(msg);
                return null;
            }
        }
        catch (exception ex)
            
        {
            System.debug(ex + 'upload Error');
        }
        return null;
    }        
     */
    
}