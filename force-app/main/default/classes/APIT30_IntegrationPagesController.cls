//
//Insert of multiple child record on Piano

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
    public String residuiDaAttivare{get;set;}
    public Contact contact {get; set;}
    public Contact contCassaSanitaria{get;set;}
   // public Contact contactAccount{get;set;}
    public IT_Contact_Detail__c contactDetail{get;set;}
    public IT_Contact_Detail__c contactDetailPay{get;set;}
    public IT_Contact_Detail__c contactDetailResidue{get;set;}
    public Decimal incentive1{get;set;}
    public Decimal incentive2{get;set;} 
    public String incentivo{get;set;} 
   	
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
    public List<SelectOption> emailRiepilogo{get;set;}
    public String getRiepilogo{get;set;}
    public String payroll{get;set;}
    public String strutturaPayroll{get;set;}
    public Boolean cassa{get;set;}
    
    public String pdfHtml {get;set;}
    public ContentVersion cversion{get;set;}
    public String cversiontitle{get;set;}
    //parametro showPDR
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
        CurrentItemSelected=0;
        confirm = true;
        showPdf = false;
        saveDone = false;
        showPdr = '';
        payroll = '';
        cassa = false;
        cversiontitle = '';
        showReferenteCassa='';
        showIncentivo = '';
        markerC=2;
        showSectionIncentivo = '';
        benefitDaAttivare = new List<String>();
        cversion = new ContentVersion();
        this.caseNumber = this.getCaseNumber();
        this.emailRiepilogoDati = '';
        this.pdfHtml = '';
        //this.files = new List<Blob>();
        //addFile();
        //addFile();
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
        contactDetailPay.IT_Payroll__c = true;
        contactDetailPay.IT_Apparatus_Type__c = '005';
        contactDetailResidue.IT_Apparatus_Type__c = '005';
        contactDetailResidue.IT_Residue__c = true;
        societaObject = new SocietaObject(0);
        unicaObject = new SocietaObject(0);
        sedeObject = new SedeObject(0);
        listSocietas = new List<SocietaObject>();
        listUnicas = new List<SocietaObject>();
        listSedes = new List<SedeObject>();
        if (this.caseNumber != null)
        {
            List<case> cases = [SELECT id, AccountId, ContactId, IT_Welfare_Project__r.Id, IT_Form_Submitted__c from Case WHERE CaseNumber =: caseNumber];
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
                                    NumberOfEmployees, IT_Industry__c
                                    From Account WHERE Id =:this.caseInstance.AccountId];
            
                   //istanzio la lista delle Email di tutti i contatti su Account
                   //e popolo emailRiepilogo List
                    emailRiepilogo = new List<SelectOption>();
                    List<Contact> cList = [Select id,Email,accountId from Contact where accountId =: this.account.Id];
                    for(Contact c: cList)
                    {
                      if(c.Email != null)
                      {
                         emailRiepilogo.add(new SelectOption(c.Email, c.Email)); 
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
                    this.projectWelfare = [SELECT Id,Name,IT_Acquisition_Channel__c from IT_Welfare_Project__c where Id=:this.caseInstance.IT_Welfare_Project__r.Id];
                    
                    
                    List<IT_Plan__c> plans = [SELECT id, name, IT_Welfare_Project__r.id, IT_Plan_End_Date__c, IT_Plan_Start_Date__c from IT_Plan__c 
                                              where IT_Welfare_Project__r.Id =: this.projectWelfare.ID order by CreatedDate desc ];  
                    if( plans.size() <1 )
                    {
                        apexpages.Message msg = new apexpages.Message( 
                            apexpages.Severity.ERROR,'No Plans found for the Project Welfare');
                        apexpages.addMessage(msg);
                    } else 
                    {
                        this.piano = plans[0];
                        
                    }
                }
            }
        }
    }
    
    public PageReference savePdfAttachment(){
        PageReference pdf = Page.VFIT30_IntegrationPages_Form;
        //System.debug('pdf'+pdf.getContent());
		// add parent id to the parameters for standardcontroller
        pdf.getParameters().put('id',this.projectWelfare.Id);
    
        // create the new attachment
        Attachment attach = new Attachment();
        
        // the contents of the attachment from the pdf
        Blob body;
        /*
        try {
            
            // returns the output of the page as a PDF
            body = pdf.getContentAsPDF();
            
        // need to pass unit test -- current bug	
        } catch (VisualforceException e) {
            System.debug('Error : '+e.getMessage());
            body = Blob.valueOf('Some Text');
        }
        */
        attach.Body = blob.toPDF(this.pdfHtml);
        // add the user entered name
        attach.Name = this.projectWelfare.Name+'.pdf';//this.projectWelfare.Name+
        attach.IsPrivate = false;
        // attach the pdf to the account
        attach.ParentId = this.projectWelfare.Id;
        insert attach;
        System.debug('saved : '+attach);
        return null;
        // send the user to the account to view results
        //return new PageReference('/'+this.projectWelfare.Id);
    }
    /*
    public void addFile(){
        if(files.size() < 5){
            Blob file;
            files.add(file);
            System.debug('file added');
        }
    }
    */
    public PageReference savePlan()
    {
        if (confirm) 
        {
        // update del PIANO
        //this.piano.IT_Plan_Start_Date__c = (dateChoice_Start_Date != null ? dateChoice_Start_Date: this.piano.IT_Plan_Start_Date__c);
       
        //setto la data inizio PIANO, sovrascrivo con la data minore presa dal Form 
    
        this.projectWelfare.IT_Unique_Billing__c = (strutturaPayroll == 'unico' ? true : false);
        this.projectWelfare.IT_Splitted_Billing_for_CDC__c = ( strutturaPayroll == 'separato' ? true : false );
        update this.projectWelfare;
        insertContactDetail(contactDetail);
        insertContactDetail(contactDetailPay);
        insertContactDetail(contactDetailResidue);
        insertFundingScource(lFunding);
        insertBenefit(lBenefit);            
        insertContact(contact);
        
            if ( cassa )
            {  
        insertRefCassaSanitaria(contCassaSanitaria);
            }
        insertContactAccount(lContact);
  		saveDone = true;
            this.caseInstance.IT_Form_Submitted__c = true;
            update this.caseInstance;
            apexpages.Message msg = new apexpages.Message( 
                apexpages.Severity.CONFIRM,'Dati inseriti con successo. ' );
            apexpages.addMessage(msg);
        confirm = false;
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
            fs.Name = 'Fonte_di_finanziamento_' + i;
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
                
                datesStart.sort();
                datesEnd.sort();
                for (integer i=0; i<datesStart.size(); i++)
                {
                    if(datesStart.get(i) == null)
                    {
                        datesStart.remove(i);
                    }
                        
                }
                this.piano.IT_Plan_Start_Date__c = datesStart.get(0);
                this.piano.IT_Plan_End_Date__c = datesEnd.get(datesEnd.size()-1);
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
    
    public void insertBenefit(List<WrapperClass> wrapper)
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
            );										                    //inserisce un nome "campo required" al fondo se inserisco benefit previdenza
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