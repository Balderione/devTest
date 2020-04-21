//
//Onboarding Form Controller


public class APIT30_IntegrationPagesController {
    
    public Case caseInstance {get; set;}
    public Account account{get;set;}
    public IT_Welfare_Project__c projectWelfare{get;set;}
    public List<WrapperClass> lFunding{get;set;}
    public List<WrapperClass> lBenefit{get;set;}
    public List<WrapperClass> lContact{get;set;}
    public IT_Plan__c piano{get;set;}
    Integer marker=1;
    Integer markerB=2;
    public Integer markerC{get;set;}
    public Integer selectedFunding{get;set;}
    public Integer selectedFunding2{get;set;}
    public Integer selectedBenefit{get;set;}
    public Integer selectedContact{get;set;}
    public String caseNumber{get;set;}
    public Integer value{get;set;}
    public List<String> benefitDaAttivare{get;set;}
    public Date dateChoice_Start_Date{get;set;}
    public Date dateChoice_Start_Date_PDR{get;set;}
    public Date dateChoice_End_Date_PDR{get;set;}
    public Boolean confirm{get;set;}
    public Boolean showPdf{get;set;}
    public String showPdr{get;set;}
    public String showIncentivo{get;set;}
    public String showSectionIncentivo{get;set;}
    public String sceltaConversione{get;set;}
    public String showModalitaScelta{get;set;}
    public String showDettagliScelta{get;set;}
    public String showTipologiaCategorie{get;set;}
    public String showGestioneResidui{get;set;}
    public String showGestioneResiduiLib{get;set;}
    public String showNote{get;set;}
    public String showTipologinaFinanziamento{get;set;}
    public String residuiDaAttivare{get;set;}
    public String showRiepilogoEm{get;set;}
    public Contact contact {get; set;}
    public Contact contCassaSanitaria{get;set;}
    // public Contact contactAccount{get;set;}
    public IT_Contact_Detail__c contactDetail{get;set;}
    public IT_Contact_Detail__c contactDetailPay{get;set;}
    public IT_Contact_Detail__c contactDetailResidue{get;set;}
    public Decimal incentive1{get;set;}
    public Decimal incentive2{get;set;} 
    public String incentivo{get;set;} 
    public String attachmentId{get;set;}
    
    public String showReferenteCassa{get;set;}
    public String showReferente{get; set;}
    public Boolean saveDone{get; set;}
    public Integer indexToDelete{get;set;}
    public List<SocietaObject> listSocietas{get;set;}
    public List<SocietaObject> listUnicas{get;set;}
    public SocietaObject societaObject{get;set;}
    public SocietaObject unicaObject{get;set;}
    public List<SedeObject> listSedes{get;set;}
    public SedeObject sedeObject{get;set;}
    public String emailRiepilogoDati {get;set;}
    public String dettagliAltro{get;set;}
    public String dettagliAltroFatt{get;set;}
    public List<SelectOption> emailRiepilogo{get;set;}
    public String getRiepilogo{get;set;}
    public String payroll{get;set;}
    public String strutturaPayroll{get;set;}
    public Boolean cassa{get;set;}
    
    public String pdfHtml {get;set;}
    public Attachment attach{get; set;}
    public ContentVersion cversion{get;set;}
    public String cversiontitle{get;set;}
    public String pdfBody{get;set;}
   // public String linkToPdf{get;set;}
    public Integer CurrentItemSelected{get;set;}
    
    
    
    //nella sezione benefit da attivare, se seleziono cassa si mostra
    //la sezione "contatti referente cassa sanitaria"
    public void PassParameters()
    {   
    
        try{
            
            cassa = benefitDaAttivare.contains('cassa');
            lFunding[selectedFunding].flag.set(0, showPdr);
            lFunding[selectedFunding].flag.set(1, showSectionIncentivo);
            lFunding[selectedFunding].flag.set(2, showIncentivo);
            lFunding[selectedFunding].flag.set(3, sceltaConversione);
            lFunding[selectedFunding].flag.set(4, showModalitaScelta);
            lFunding[selectedFunding].flag.set(5, showDettagliScelta);
            lFunding[selectedFunding].flag.set(6, showNote);
            lFunding[selectedFunding].flag.set(7, showTipologiaCategorie);
            lFunding[selectedFunding].flag.set(8, showGestioneResidui);
            lFunding[selectedFunding].flag.set(9, showTipologinaFinanziamento);
            lFunding[selectedFunding].flag.set(10, showGestioneResiduiLib);
            
        }catch(exception e) 
        {system.debug('error!' + e.getMessage()); 
        }
    }
    
    
    public APIT30_IntegrationPagesController() {
        value=0;
        residuiDaAttivare = '';
        incentive1 = 0;
        incentive2 = 0;
        incentivo = ''; 
        dettagliAltro = '';
        dettagliAltroFatt ='';
        CurrentItemSelected=0;
        confirm = true;
        showPdf = false;
        saveDone = false;
        showPdr = '';
        showRiepilogoEm = '';
        payroll = '';
        cassa = false;
        cversiontitle = '';
        showReferenteCassa='';
        showIncentivo = '';
        markerC=2;
        showSectionIncentivo = '';
        sceltaConversione = '';
        showModalitaScelta = '';
        showDettagliScelta = '';
        showNote = '';
        showTipologiaCategorie = '';
        showGestioneResidui = '';
        showGestioneResiduiLib = '';
        benefitDaAttivare = new List<String>();
        cversion = new ContentVersion();
        
        if ( System.currentPageReference().getParameters().get('caseNumber') != null)
        { 
            this.caseNumber = this.getCaseNumber();
            system.debug('Attachment @@@ IF ' + attachmentId);
        }
            else
        {
            this.pdfBody = getAttachment();
            system.debug('Attachment @@@ ELSE ' + attachmentId);
        }
        this.emailRiepilogoDati = '';                 
        this.pdfHtml = '';
        
      //  if (attach != null)
      //      this.linkToPdf = 'https://devam-welcomeonboardingtest.cs89.force.com/apex/VFIT31_ShowPdf?attachmentId='+attach.ID;
        //istanzio le classi wrapper per gli oggetti da 
        //inserire su SFDC
        //
        lFunding = new List<WrapperClass>();
        IT_Funding_Source__c f = new IT_Funding_Source__c();   
        List <String> flag = new List<String>();
        flag.add('');
        flag.add('');
        flag.add('');
        lFunding.add(new WrapperClass(f, 0, flag));
        lBenefit = new List<WrapperClass>();
        lContact = new List<WrapperClass>();
        contCassaSanitaria = new Contact();
        
        //setto parametri per il Contact Detail Credenziali e Payroll
        contactDetail = new IT_Contact_Detail__c();
        contactDetailPay = new IT_Contact_Detail__c();
        contactDetailResidue = new IT_Contact_Detail__c();
        contactDetail.IT_Credentials__c = true;
        contactDetail.IT_Apparatus_Type__c = '005';
        if (contactDetail.Name == contactDetailPay.Name)
            contactDetail.IT_Payroll__c = true;
        else
            contactDetailPay.IT_Payroll__c = true;
        if (contactDetailResidue.Name == contactDetail.Name )
            contactDetail.IT_Residue__c = true;
        else if (contactDetailPay.Name == contactDetailResidue.Name ) 
            contactDetailPay.IT_Residue__c = true;
        else
            contactDetailResidue.IT_Residue__c = true;
        
        contactDetailPay.IT_Apparatus_Type__c = '005';
        contactDetailResidue.IT_Apparatus_Type__c = '005';
        
        societaObject = new SocietaObject(0);
        unicaObject = new SocietaObject(0);
        sedeObject = new SedeObject(0);
        listSocietas = new List<SocietaObject>();
        listUnicas = new List<SocietaObject>();
        listSedes = new List<SedeObject>();
        if (this.caseNumber != null)
        {
            System.debug('caseNumber1: '+caseNumber);
            List<case> cases = [SELECT id, AccountId, ContactId, IT_Welfare_Project__r.Id, IT_Form_Submitted__c, IT_Case_Number_Cripted__c from Case WHERE CaseNumber =: this.caseNumber];
            //if no cases are found show message Error
            if( cases.size()<1)
            {
                apexpages.Message msg = new apexpages.Message( 
                    apexpages.Severity.ERROR,'The given case number is incorrect');
                apexpages.addMessage(msg);
            }else 
            {
                //if at least one instance found
                this.caseInstance=cases[0];  
                
                //check if lookup Account is found
                if(this.caseInstance.AccountId!=null){ 
                    this.account = [SELECT Id, Name, ER_VAT_Number__c, IT_Account_Address__c, isPersonAccount, ParentId,
                                    NumberOfEmployees, IT_Industry__c, IT_Toponym__c, BillingStreet, BillingCity, BillingPostalCode, BillingState
                                    From Account WHERE Id =:this.caseInstance.AccountId];                       
                    //istanzio la lista delle Email con i Recapiti del piano di tutti i contatti dell' Account collegato  al Case
                    //
                    emailRiepilogo = new List<SelectOption>();
                    if(String.isBlank(getRiepilogo))
                        emailRiepilogo.add(new SelectOption('','Seleziona una email dal menù a tendina'));
                    emailRiepilogo.add(new SelectOption('','- Altro -'));
                   // List<Contact> cList = [Select id,Email,accountId from Contact where accountId =: this.account.Id];
                      List<IT_Contact_Detail__c> cList = [select id, Name, IT_Apparatus_Type__c from IT_Contact_Detail__c where IT_Contact__c IN:
                                                        [select id from Contact where AccountId =: this.account.ID] and IT_Apparatus_Type__c ='005'];
                    for(IT_Contact_Detail__c c: cList)
                    {
                        if(c.Name != null)
                        {
                            emailRiepilogo.add(new SelectOption(c.Name, c.Name)); 
                        }
                    }
                    
                    
                }
                
                //check if lookup Contact is found
                if(this.caseInstance.ContactId!=NULL){
                    this.contact = [SELECT Id, FirstName, LastName, Email, Phone, Title, ER_Role__c FROM Contact WHERE Id =: this.caseInstance.ContactId];
                    if( contact == null)
                    {
                        this.contact = new Contact();
                    }
                }
                
                //check if lookup IT_Welfare_Project is found  
                if(this.caseInstance.IT_Welfare_Project__r.Id!=null){
                    this.projectWelfare = [SELECT Id,Name,IT_Acquisition_Channel__c, IT_Project_Start_Date__c from IT_Welfare_Project__c where Id=:this.caseInstance.IT_Welfare_Project__r.Id];
                    system.debug('PROGETTO: ' +  this.projectWelfare );
                    
                    // List<IT_Plan__c> plans = [SELECT id, name, IT_Welfare_Project__r.id, IT_Plan_End_Date__c, IT_Plan_Start_Date__c from IT_Plan__c 
                    //        where IT_Welfare_Project__r.Id =: this.projectWelfare.ID order by CreatedDate desc ];  
                    List<IT_Plan__c> plans = [SELECT id, name, IT_Provisioning_Case__c, CreatedDate, IT_Welfare_Project__r.id, IT_Plan_End_Date__c, IT_Plan_Start_Date__c from IT_Plan__c where IT_Provisioning_Case__c =: this.caseInstance.ID 
                                              order by CreatedDate desc];
                
                    if( plans.size() <1 )
                    {
                        apexpages.Message msg = new apexpages.Message( 
                            apexpages.Severity.ERROR,'No Plans found for the Project Welfare');
                        apexpages.addMessage(msg);
                    } else 
                    {
                        this.piano = plans[0];
                        
                    }
                    
                    if(this.caseInstance.IT_Form_Submitted__c)
                    this.attachmentId = [SELECT Id from IT_Plan__c where Name =: this.piano.Name limit 1].ID;
                    system.debug('NOME PIANO' + this.piano.Name);
                    system.debug('ATTACH ID' + this.attachmentId);
                    
                }
            }
        }
         system.debug('Attachment @@@ ' + attachmentId);
    }
    
    public PageReference savePdfAttachment(){
        this.attach = new Attachment();
        Blob body;
        this.attach.Body = blob.toPDF(EncodingUtil.urlEncode (this.pdfHtml, 'UTF-8'));
        //this.attach.Body = blob.toPDF(this.pdfHtml);
        this.piano.IT_Html_Body__c = this.pdfHtml;
        this.attach.Name = this.projectWelfare.Name+'.pdf';//this.projectWelfare.Name+
        this.attach.IsPrivate = false;
        this.attach.ParentId = this.projectWelfare.Id;
        insert this.attach;
        this.attachmentId = this.piano.ID;
        System.debug('this.attachmentId : '+attachmentId);
        update this.piano;
        sendMail();
        
        System.debug('saved : '+attach);
        return null;
        
    }
    
    public PageReference showPdfPage()
    {
        system.debug('Attach into ShowPDF method' + attachmentId );
        PageReference pageRef = new PageReference('/VFIT31_ShowPdf?attachmentId='+attachmentId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    public void sendMail(){
        System.debug('Email '+this.emailRiepilogoDati);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string[] toAdresses = new string[] {this.emailRiepilogoDati};
        email.setToAddresses(toAdresses);
        EmailTemplate emailTemplate = [select HtmlValue from EmailTemplate where Name='IT Recup'];
        string htmlBodytemp = emailTemplate.HtmlValue;
    
        IT_LinksCustom__c customSet = IT_LinksCustom__c.getInstance();
        String customSetField = customSet.IT_formLink__c + '/?caseNumber=' + this.caseInstance.IT_Case_Number_Cripted__c;
        System.debug('customSetField:: '+customSetField);
        String htmlBody = htmlBodytemp.replace('{!$Setup.IT_LinksCustom__c.IT_formLink__c}/?caseNumber={!Case.IT_Case_Number_Cripted__c}', customSetField);
        email.setSubject('Modulo di attivazione Welfare  ' + this.Account.ER_VAT_Number__c + ' '+ this.Account.Name);
        email.setHtmlBody(htmlBody); 
        try
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email },false);
            System.debug('Email sent successfuly');
        }
        catch(exception e)
        {
            System.debug('Error sending email '+e.getMessage());
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
    }
    
    public PageReference savePlan()
    {
        if (confirm) 
        {
            // update del PIANO
            //this.piano.IT_Plan_Start_Date__c = (dateChoice_Start_Date != null ? dateChoice_Start_Date: this.piano.IT_Plan_Start_Date__c);
            
            //setto la data inizio PIANO, sovrascrivo con la data minore presa dal Form 
            system.debug('welfare ' + this.projectWelfare);
            system.debug('payroll@@' + strutturaPayroll);
            this.projectWelfare.IT_Unique_Billing__c = (strutturaPayroll == 'unico' ? true : false);
            this.projectWelfare.IT_Splitted_Billing_for_CDC__c = ( strutturaPayroll == 'separato' ? true : false );
            update this.projectWelfare;
            List<String> listCd = new List<String>();
            if (!String.isBlank(contactDetail.Name) && !listCd.contains(contactDetail.Name)){
                insertContactDetail(contactDetail);
                listCd.add(contactDetail.Name);
            }    
            if (!String.isBlank(contactDetailPay.Name) && !listCd.contains(contactDetailPay.Name)){
                insertContactDetail(contactDetailPay);
                listCd.add(contactDetailPay.Name);
            }
            if (!String.isBlank(contactDetailResidue.Name) && !listCd.contains(contactDetailResidue.Name) ){
                insertContactDetail(contactDetailResidue);
            }
            
            insertFundingScource(lFunding);
            insertBenefit(lBenefit, contCassaSanitaria);            
            insertContact(contact);
            
            //if ( cassa )
            //{  
                //insertRefCassaSanitaria(contCassaSanitaria);
            //}
            insertContactAccount(lContact);
            this.saveDone = true;
            refreshPage();
            this.caseInstance.IT_Form_Submitted__c = true;
            update this.caseInstance;
            apexpages.Message msg = new apexpages.Message( 
                apexpages.Severity.CONFIRM,'Dati inseriti con successo. ' );
            apexpages.addMessage(msg);
            //confirm = false;
        }
        else 
        {
            apexpages.Message msg = new apexpages.Message( 
                apexpages.Severity.ERROR,'Dati non inseriti' );
            apexpages.addMessage(msg);                
        }
        
        return null; 
    }
    public void displayPdf(){
        this.showPdf = true;
        System.debug('Showing pdf'+this.showPdf);
        //return null;
    }
    //----------UTILS METHOD FOR INSERT CHILD OBJ-------------------
    
    public void insertRefCassaSanitaria(Contact c)
    {
        c.accountId = this.account.ID;
        c.Phone = '0';
        if((String.isBlank(c.FirstName) || String.isBlank(c.LastName)) || ( c.Email == null))
        {
            apexpages.Message msg = new apexpages.Message( 
                apexpages.Severity.ERROR,'Errore durante inserimento referente Cassa Sanitaria. Riprova' );
            apexpages.addMessage(msg);
        }
        else{
            insert c;
        }
    }
    
    public PageReference refreshPage() {
        if(this.saveDone){
            System.debug('on refresh '+this.saveDone);
            PageReference ref = Page.VFIT30_IntegrationPages_Form;
            ref.getParameters().putAll(ApexPages.currentPage().getParameters());
            ref.setRedirect(true); // Discard page state
            return ref;
        }
        return null;
    } 
    
    public void insertContactAccount(List<WrapperClass> wrapper)
    {
        Boolean controllo = true;
        List<Contact> listContAcc = new List<Contact>();
        for ( WrapperClass w: wrapper )
        {
            Contact c = new Contact();
            c.LastName = w.contact.LastName;
            c.FirstName = w.contact.FirstName;
            c.Email = w.contact.Email;
            c.Phone = w.contact.Phone;
            c.AccountId = w.contact.AccountId;
            c.Title = w.contact.Title;
            listContAcc.add(c);
            
            if (String.isBlank(c.FirstName) || String.isBlank(c.LastName) ) 
            {
                controllo = false;
            }
        }
        if ( listContAcc.size() >= 1 && controllo)
        {
            insert listContAcc;
        } /*else
{
apexpages.Message msg = new apexpages.Message( 
apexpages.Severity.ERROR,'Errore durante inserimento Contatti su Account! Riprova' );
apexpages.addMessage(msg);
} */
        
    }
    
    public void insertFundingScource(List<WrapperClass> wrapper)
    {
        
        //mi prendo la lista della Date di tutte le fonti finanziamento
        List<Date> datesStart = new List<Date>();
        List<Date> datesEnd = new List<Date>();
        
        List<IT_Funding_Source__c> fontiList = new List<IT_Funding_Source__c>();
        
        for( Integer i = 0; i<wrapper.size(); i++){
            IT_Funding_Source__c fs = new IT_Funding_Source__c();
            if(!String.isBlank(wrapper[i].funding.IT_Type__c))
                fs.Name = wrapper[i].funding.IT_Type__c.touppercase() + ' = ' + 'Fonte_' + i;
            fs.IT_Beneficiaries__c = wrapper[i].funding.IT_Beneficiaries__c;
            fs.IT_Per_capita_Amount__c = wrapper[i].funding.IT_Per_capita_Amount__c;
            //Insert of dependent Picklist Type, platformchoice and Memebership payment
            fs.IT_Type__c = wrapper[i].funding.IT_Type__c;
            fs.IT_Platform_Choice__c = wrapper[i].funding.IT_Platform_Choice__c;
            fs.IT_Membership_Payment_Type__c = (wrapper[i].funding.IT_Platform_Choice__c == 'No' ? '' : wrapper[i].funding.IT_Membership_Payment_Type__c);
            //  fs.IT_Membership_Choice_Start_Date__c = (dateChoice_Start_Date_PDR != null ? dateChoice_Start_Date_PDR: this.piano.IT_Plan_Start_Date__c);
            fs.IT_Membership_Choice_Start_Date__c = wrapper[i].funding.IT_Membership_Choice_Start_Date__c;
            fs.IT_Membership_Choice_End_Date__c = wrapper[i].funding.IT_Membership_Choice_End_Date__c ;
            fs.IT_Incentive_for_Membership__c = wrapper[i].funding.IT_Incentive_for_Membership__c; 
            fs.Incentive_for_Membership_percentage__c = wrapper[i].funding.Incentive_for_Membership_percentage__c; 
            //  fs.IT_Membership_Choice_End_Date__c = dateChoice_End_Date_PDR;
            fs.IT_Details_CCNL__c = (wrapper[i].funding.IT_Details_CCNL__c != null ? wrapper[i].funding.IT_Details_CCNL__c : '' );
            fs.IT_End_Plan_Residue_Management__c = wrapper[i].funding.IT_End_Plan_Residue_Management__c; 
            fs.IT_Membership_Payment_Type_Notes__c = (wrapper[i].funding.IT_Membership_Payment_Type_Notes__c != null ? wrapper[i].funding.IT_Membership_Payment_Type_Notes__c +  ' Dettagli Scelta PDR: ' + wrapper[i].DettaglisceltaPDR : '');
            // fs.IT_Membership_Payment_Type_Notes__c = wrapper[i].funding.IT_Membership_Payment_Type_Notes__c +  ' Dettagli Scelta PDR: ' + wrapper[i].DettaglisceltaPDR;
            fs.IT_Informative_Notes__c = (wrapper[i].funding.IT_Informative_Notes__c != null ? wrapper[i].funding.IT_Informative_Notes__c : '' );
            fs.IT_Plan__c = this.piano.Id;
            
            fontiList.add(fs);
            datesStart.add(wrapper[i].funding.IT_Membership_Choice_Start_Date__c);
            datesEnd.add(wrapper[i].funding.IT_Membership_Choice_End_Date__c);            
            
        }
        if( fontiList.size() > 0) {
            try{
                
                
                for (integer i=0; i<datesStart.size(); i++)
                {
                    if(datesStart.get(i) == null)
                    {
                        datesStart.remove(i);
                    }
                    
                }
                datesStart.sort();
                datesEnd.sort();
                this.piano.IT_Plan_Start_Date__c = (datesStart.get(0) > this.projectWelfare.IT_Project_Start_Date__c ? datesStart.get(0) : this.projectWelfare.IT_Project_Start_Date__c);
               // this.piano.IT_Plan_End_Date__c = (datesEnd.get(datesEnd.size()-1) < this.projectWelfare.IT_Project_End_Date__c ? datesEnd.get(datesEnd.size()-1) :this.projectWelfare.IT_Project_End_Date__c);
                update this.piano;
                system.debug('Data inizio piano: ' + this.piano.IT_Plan_Start_Date__c +'Data fine:  ' +  datesStart.get(0) + 'data fine: ' +  this.piano.IT_Plan_End_Date__c);
                system.debug('NUMERO FONTI INSERITE : ' + fontiList.size());
                insert fontiList;
            }
            catch(exception e) 
            { 
                system.debug(e.getMessage() + 'insert error'); 
                confirm = false;
            }
            
        } else 
        {
            confirm = false; 
        }
    }
    
    public void insertBenefit(List<WrapperClass> wrapper, Contact contactCassa)
    {
        //chiamo il metodo addBenefit che popola la lista lBenefit con i valori del form selezionati
        
        addBenefit(); 
        
        List<IT_Benefit__c> benefitList = new List<IT_Benefit__c>();
        for( WrapperClass wc : wrapper){
            IT_Benefit__c b = new IT_Benefit__C(
                IT_Macro_Benefit__c = wc.benefit.IT_Macro_Benefit__c,
                IT_Benefit__c = wc.benefit.IT_Benefit__c,
                IT_Fund_Name_1__c = (wc.benefit.IT_Macro_Benefit__c == 'Fund'? 'Nominare il fondo previdenza':''),
                IT_Plan__c = this.piano.ID
            );
            if(contactCassa != null && wc.benefit.IT_Macro_Benefit__c == 'Reimbursement' && wc.benefit.IT_Benefit__c == 'Medical Fees'){ 
                b.IT_Medical_Fees_Name__c = contactCassa.FirstName;
                b.IT_Medical_Fees_Surname__c = contactCassa.LastName;
                b.IT_Medical_Fees_Email__c = contactCassa.Email;
            }                                                       
            benefitList.add(b);
        }
        
        if ( benefitList.size() > 0){
            system.debug('NUMERO BENEFIT INSERITI : ' + benefitList.size());
            insert benefitList;
        }
        else
        {
            apexpages.Message msg = new apexpages.Message( 
                apexpages.Severity.ERROR,'Nessun benefit è stato selezionato. ' );
            apexpages.addMessage(msg);  
            confirm = false;
        }
    }
    
    public void insertContact(Contact c)
    { 
        upsert c;
    }
    
    public void insertContactDetail(IT_Contact_Detail__c cd)
    {
        if (cd.IT_Residue__c == true)
        {
            cd.Name= ( cd.Name==null? getRiepilogo : cd.Name);
        }
        
        if ( cd.Name != null )
        {
            cd.IT_Plan__c = this.piano.Id;
            cd.IT_Contact__c = this.contact.ID;
            try{
                insert cd;  
            }
            catch(exception e)
            {
                system.debug('ERRORE inserimento contact detail' + e.getMessage());
            }
        }
    }
    //-------------------------------------------------------------------------------------
    
    
    
    //----------------Manage Funding sources section and Contact--------------------------------------
    public PageReference addFunding(){
        IT_Funding_Source__c f = new IT_Funding_Source__c();
        List <String> flag = new List<String>();
        flag.add('');
        flag.add('');
        flag.add('');
        lFunding.add(new WrapperClass(f, marker,flag));
        marker= marker+1;
        return null;
    }
    
    public PageReference addContact(){ 
        try
        {
            Contact c = new Contact();
            c.AccountId = this.account.Id;
            lContact.add(new WrapperClass(c, markerC));
            markerC = markerC +1;
        }
        catch (exception e)
        {
            system.debug(e.getMessage() + 'error');
        }
        return null;
    }
    
    public PageReference addContact2(){
        try
        {
            Contact c = new Contact();
            c.AccountId = this.account.Id;
            
            c.FirstName = this.contact.FirstName;
            c.LastName = this.contact.LastName;
            c.Title = this.contact.Title;
            c.Phone = this.contact.Phone;
            c.Email = this.contact.Email;
            
            lContact.add(new WrapperClass(c, markerC));
            markerC = markerC +1;
        }
        catch (exception e)
        {
            system.debug(e.getMessage() + 'error');
        }
        return null;
    }
    
    
    
    public void showReferenteSelected(){
        System.debug('section : '+showReferente);
    }
    public PageReference deleteRows(){
        Integer x=-1;
        for(WrapperClass wc : lFunding){
            x++;
            if(wc.counter==selectedFunding2){
                break;
                
            } 
        }
        try
        {
            lFunding.remove(x);
            marker--;
        }
        catch (exception e)
        {
            system.debug('Error: ' + e.getMessage());
        }
        
        
        return null;
    }
    
    public PageReference deleteContacts(){
        Integer x=-1;
        for (WrapperClass wc: lContact){
            x++;
            if(wc.counter==selectedContact){
                break;
            }
        }
        try
        {
            lContact.remove(x);
            markerC = markerC -1;
        } catch (exception e)
        {
            system.debug('Error: ' + e.getMessage());
        }
        return null;
    }
    
    
    //aggiunge alla lista tutti i benefit che vengono selezionati dal form
    public void addBenefit(){
        system.debug('benefitDaAttivare :' + benefitDaAttivare);
        if( benefitDaAttivare.size() == 0 )
        {
            confirm = false;
        }
        for(String s:benefitDaAttivare){
            if(s =='istruzione')
            {
                IT_Benefit__c b = new IT_Benefit__c(IT_Macro_Benefit__c = 'Reimbursement', 
                                                    IT_Benefit__c = 'School Fees');
                lBenefit.add(new WrapperClass(b,markerB));
                markerB++;
                
            } else if( s == 'assistenza')
            {
                IT_Benefit__c b = new IT_Benefit__c(IT_Macro_Benefit__c = 'Reimbursement', 
                                                    IT_Benefit__c = 'Family Care');
                lBenefit.add(new WrapperClass(b,markerB));
                markerB++;
                
            } else if (s == 'trasporto')
            {
                IT_Benefit__c b = new IT_Benefit__c(IT_Macro_Benefit__c = 'Reimbursement', 
                                                    IT_Benefit__c = 'Public Transport');
                lBenefit.add(new WrapperClass(b,markerB));
                markerB++;
                
            } else if (s == 'previdenza')
            {
                IT_Benefit__c b = new IT_Benefit__c(IT_Macro_Benefit__c = 'Fund', 
                                                    IT_Benefit__c = 'Insurance');
                lBenefit.add(new WrapperClass(b,markerB));
                markerB++;
                
            } else if (s =='cassa')
            {
                IT_Benefit__c b = new IT_Benefit__c(IT_Macro_Benefit__c = 'Reimbursement', 
                                                    IT_Benefit__c = 'Medical Fees');
                lBenefit.add(new WrapperClass(b,markerB));
                markerB++;
                
            }
            else if (s == 'compliments')
            {
                IT_Benefit__c b = new IT_Benefit__c(IT_Macro_Benefit__c = 'Ticket Compliments', 
                                                    IT_Benefit__c = 'Printable Selection');
                lBenefit.add(new WrapperClass(b,markerB));
                markerB = markerB+1;
                IT_Benefit__c b1 = new IT_Benefit__c(IT_Macro_Benefit__c = 'Ticket Compliments', 
                                                     IT_Benefit__c = 'Printable Top Premium');
                lBenefit.add(new WrapperClass(b1,markerB));
                markerB++;
                
            }else 
            {
                IT_Benefit__c b = new IT_Benefit__c(IT_Macro_Benefit__c = 'Ticket Welfare', 
                                                    IT_Benefit__c = 'Ticket Welfare1');
                lBenefit.add(new WrapperClass(b,markerB));
                markerB++;
                
            } 
        } 
    }
    
    //---------------------WRAPPER CLASS-----------------------------------
    public class WrapperClass {
        public Integer counter{get;set;}
        public IT_Funding_Source__c funding{get;set;}
        public IT_Benefit__c benefit{get;set;}
        public Contact contact{get;set;}
        public List<String> flag{get;set;}
        public String DettaglisceltaPDR{get;set;}
        public String tipologieCoinvolte{get;set;}
        
        WrapperClass(IT_Funding_Source__c f, Integer i, List<String> l){
            this.funding = f;
            this.counter = i;
            this.flag = l;
        }
        WrapperClass(IT_Benefit__c b, Integer i){
            this.benefit = b;
            this.counter = i;
        }
        WrapperClass(Contact c, Integer i){
            this.contact = c;
            this.counter = i;
        }
        
    }
    //------------------------------------------------------------
    
    //get current caseNumber used in the controller to make SOQL
    public string getCaseNumber(){
        //AD encrypt case number
        IT_Custom_Control__c mhc = IT_Custom_Control__c.getInstance('KeyCaseNumber');  
        String stringKey = mhc.IT_Custom_Text__c;
        System.debug('Key stringKey '+ stringKey);
        Blob keyEn = EncodingUtil.base64Decode(stringKey);
        String caseNumebrString = System.currentPageReference().getParameters().get('caseNumber');
        System.debug('caseNumebrString:: '+caseNumebrString);
        Blob caseNumberBlob = EncodingUtil.base64Decode(caseNumebrString);
        Blob codeDecrypt =  Crypto.decryptWithManagedIV('AES256', keyEn, caseNumberBlob);
        String caseNumber = codeDecrypt.toString();
        System.debug('caseNumber1: '+caseNumber);
        //AD encrypt case number - END
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
    
    public String getAttachment()
        
    {
        system.debug('attachmentId'+ attachmentId );
        String result = System.currentPageReference().getParameters().get('attachmentId'); 
        system.debug('@@ RESULT'+ result );
        //  Attachment attch = [ SELECT ID, Body from Attachment where Id =: result LIMIT 1]; 
        IT_Plan__c pl = [ SELECT ID, IT_Html_Body__c from IT_Plan__c where Id =: result LIMIT 1];
        
        String bodyString = pl.IT_Html_Body__c;
        //String bodyString = attch.Body.toPDF('');
        system.debug('attachmentId'+ bodyString );
        
        
        return bodyString;
        
    }
  
    
    //referente methods
    public List<SelectOption> getReferenteOptions(){
        return new List<SelectOption>{new SelectOption('si','Si'),new SelectOption('no','No')};
            }
    
    public List<SelectOption> getSeparataOptions(){
        return new List<SelectOption>{new SelectOption('società','Società'),new SelectOption('sede','Sede'),new SelectOption('altro','Altro')};
            }
    
    public List<SelectOption> getBillingOptions(){
        return new List<SelectOption>{new SelectOption('unica','Unica'),new SelectOption('separata','Separata')};
            }
    
    public PageReference addToSocietaList(){
        this.listSocietas.add(this.societaObject);
        this.societaObject = new SocietaObject(this.listSocietas.size());
        return null;
    }
    public PageReference addToUnicaList(){
        this.listUnicas.add(this.unicaObject);
        this.unicaObject = new SocietaObject(0);
        return null;
    }
    public void deleteUnicaToList(){
        this.listUnicas.remove(0);
        //return null;
    }
    public void deleteSocietaToList(){
        this.listSocietas.remove(this.indexToDelete);
        for(Integer i=0; i<this.listSocietas.size();i++){
            this.listSocietas[i].index = i;
        }
        //return null;
    }
    
    public void addToSedeList(){
        System.debug('called');
        this.listSedes.add(this.sedeObject);
        System.debug('Table : '+this.listSedes);
        this.sedeObject = new SedeObject(this.listSedes.size());
    }
    
    public void deleteSedeToList(){
        this.listSedes.remove(this.indexToDelete);
        for(Integer i=0; i<this.listSedes.size();i++){
            this.listSedes[i].index = i;
        }
    }
    
    public abstract class TableObject{
        public Integer index{get;set;}
        public String indirizzo{get;set;}
        public String pec{get;set;}
        public String mail{get;set;}
        
        public TableObject(Integer index){
            this.indirizzo = '';
            this.pec = '';
            this.mail = '';
            this.index = index;
        }
        
    }
    
    public class SedeObject extends TableObject{
        public String nomeSede{get;set;}
        public SedeObject(Integer index){
            super(index);
            this.nomeSede = '';
        }
    }
    
    public class SocietaObject extends TableObject{
        public Long pIva{get;set;}
        public String nomeAzianda{get;set;}
        
        public SocietaObject(Integer index){
            super(index);
            this.nomeAzianda = '';
        }
    }
}