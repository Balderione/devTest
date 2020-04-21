public class APIT02_InvoicesListController {
   
    
    @AuraEnabled
    public static string callCase(String idCase) {
        List<Case> contextualizeCase = new List<Case>();
        contextualizeCase = [Select Id, Account.ER_VAT_Number__c, IT_Financial_Center__r.IT_Financial_Center__c, IT_Financial_Center__r.Name, IT_Circuit__r.Name From Case Where Id =: idCase limit 1];
        
        if(contextualizeCase != null && contextualizeCase.size() > 0)
            return contextualizeCase[0].IT_Financial_Center__r.IT_Financial_Center__c; 
        else
            return null; 
        
    }
    
    
    @AuraEnabled
    public static List<data> listInvoices(Date dataDa, Date dataA, String caseId , String codCli) {
        try{
            date dateFrom;
            date dateTo;
            //check date
            if(dataDa == null || dataA == null){
            dateFrom = date.newinstance(1970, 1, 1);
            dateTo = date.today();
            }
            else{
            dateFrom = dataDa;
            dateTo = dataA;
            }
            String profileName = 'ProfileName'; // Change to received specifications 
            String returnJson = '';
            String codeCli = '';
            List<Case> fCCase = new List<Case>();
            fCCase = [Select Id, IT_Financial_Center__r.IT_Financial_Center__c From Case Where Id =: caseId];
            system.debug(fCCase[0].IT_Financial_Center__r.IT_Financial_Center__c);
            if(fCCase != null && fCCase.size() > 0)
                codeCli = fCCase[0].IT_Financial_Center__r.IT_Financial_Center__c;
            if(codCli == null || codCli == ''){
               codeCli = codCLi; 
            }
            //String requestSFDC = 'http://eit-wsexportdaticrm-d.edenred.net/ExportDatiCRMWS/rest/exportDatiCRMWSJson/ordine?idRichiedente=SF&codiceCliente'+codeCli+'&dal='+dataDA+'&al='+dataA+'&userProfile='+profileName+'&response=application/json';
            //Add Parameter In requestSFDC
            //String requestSFDC = 'https://salesforce.it.dev.edenred.io/v1/statements';
            //http://eit-kiwi-p.edenred.net/GetDoc/getdoc?APPID=C&KEY1=832&KEY2=725010&KEY3=2019
            system.debug('dateTo::: '+dateTo);
            //Insert value null for method getStatements
            String responseService = getStatements(fCCase[0].IT_Financial_Center__r.IT_Financial_Center__c, null, dateFrom, dateTo, null, null);
            system.debug('responseService::: '+responseService);

            returnJson = returnJson.replace('ns.', 'ns'); 
            system.debug('returnJsonNS::: '+returnJson);
            Request req = (Request) JSON.deserializeStrict(responseService, Request.class);
            List<data> listinvoices = new List<data>();
            listInvoices = req.data;    
            system.debug('req.listInvoices::: '+listInvoices);

            List<data> listinvoicesFiltered = new List<data>();
            Decimal ImportoTot = 0;

            if(dataDa != null && dataA != null){
                system.debug('FILTRATO::: ');
                listinvoicesFiltered = new List<data>();
                for(data singlrTot : listinvoices){
                    if(Date.valueOf(singlrTot.document_date) >= dataDa && Date.valueOf(singlrTot.document_date) <= dataA){
                        listinvoicesFiltered.add(singlrTot);
                    }    
                }
                listInvoices = listinvoicesFiltered;
            }  
            /*
            else{
                system.debug('NON FILTRATO::: ');
                listinvoicesFiltered = new List<data>();
                for(data singlrTot : listinvoices){
                    if(singlrTot.document_date >= Date.today().addMonths(-2) && singlrTot.document_date <= Date.today()){
                        
                        listinvoicesFiltered.add(singlrTot);
                    }    
                }
                listInvoices = listinvoicesFiltered;
            }

*/            
            
            for(data singlerequest : listInvoices){
                    singlerequest.detailURL = 'http://eit-kiwi-p.edenred.net/GetDoc/getdoc?APPID=C&KEY1=832&KEY2='+singlerequest.document_number+'&KEY3='+string.valueof(singlerequest.document_date).split('-')[0];
                    //singlerequest.detailURL = 'https://eit-ssobridge-d.edenred.net/'+singlerequest.application+'?';
                }
            
            return listInvoices;    
        }catch(Exception ecc){
            System.debug('Error invoicesListController: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            return null; 
        }
    } 

    @auraenabled
    public static string getStatements (String clientRef, String clientType, Date dateFrom, Date dateTo, String userProfile, String company){
        String responseBody = '';
        try{
            Http callHttp = new Http();
            HttpRequest req = APER06_WebserviceUtility.getHttpRequest(
                                    '/invoices?client-ref='+clientRef+'&client-type=T&date-from='+string.valueOf(dateFrom)+'&date-to='+string.valueOf(dateTo)+'&user-profile=GIWEBCOCLI&company=832&temporary-table=EC_'+clientRef+'&truncate-temporary-table=true&search-by-vatcode=false&order-by-status=false&order-by-date=false&is-open-document=false&is-balance-programme=false&is-document-history=true&is-notice=false&is-transfert-back=false&is-tax-rate=false',
                                    'GET',
                                    null,
                                    null);
			req.setHeader('Content-Type', 'application/java');
            HttpResponse res = callHttp.send(req);
            responseBody = res.getbody();
            System.debug('responseBody::: '+responseBody);
        }catch(Exception ecc){
            System.debug('Error getStatements: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            return null;
        }
        return responseBody;
    
    }

    public class Request{
        @AuraEnabled
        public meta meta {get;set;}
        @AuraEnabled
        public list<data> data {get;set;}
    }

    public class meta{
        @AuraEnabled
        public list<messages> messages {get;set;}
        @AuraEnabled
        public String status {get;set;}   
    }

    public class messages{
        @AuraEnabled
        public String Error;
    }

    public class data{
        @AuraEnabled
        public String document_number {get;set;}
        @AuraEnabled
        public String document_type {get;set;}
        @AuraEnabled
        public Date document_date {get;set;}
        @AuraEnabled
        public string e_invoice_status {get;set;}
        @AuraEnabled
        public string e_invoice_status_description {get;set;}
        @AuraEnabled
        public Date expiry_date {get;set;}
        @AuraEnabled
        public Decimal amount_due {get;set;}
        @AuraEnabled
        public String detailURL {get;set;}
    }

}