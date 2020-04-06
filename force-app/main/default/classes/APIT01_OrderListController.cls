public class APIT01_OrderListController {
    @AuraEnabled
    public static List<picklistWrapper> getPicklistValues(String nameObj, String namePicklistField) {
        List<picklistWrapper> lstPWrapper = new List<picklistWrapper>();
        lstPWrapper.add(new picklistWrapper('', ''));
        for(Schema.PicklistEntry f : ((SObject)(Type.forName('Schema.'+nameObj).newInstance())).getSObjectType().getDescribe().fields.getMap().get(namePicklistField).getDescribe().getPicklistValues()){
            lstPWrapper.add(new picklistWrapper(f.getValue(), f.getLabel()));
        }
        return lstPWrapper; 
    }

    @AuraEnabled
    public static Case callCase(String idCase) {
        List<Case> contextualizeCase = new List<Case>();
        contextualizeCase = [Select Id, Account.ER_VAT_Number__c, IT_Financial_Center__r.IT_Financial_Center__c, IT_Financial_Center__r.Name, IT_Circuit__r.IT_Circuit_Code__c From Case Where Id =: idCase limit 1];

        if(contextualizeCase != null && contextualizeCase.size() > 0)
            return contextualizeCase[0]; 
        else
            return null; 
            
    }
    
    @AuraEnabled
    public static List<data> listOrder(Date dataDa, Date dataA, String codeCirc, String codeCli, String piva, String codeServizio, Boolean AllFilter, String rawHmac, String idCase) {
        try{
            List<Case> contextualizeCase = new List<Case>();
        	contextualizeCase = [Select Id, Account.ER_VAT_Number__c, IT_Financial_Center__r.IT_Financial_Center__c, IT_Financial_Center__r.Name, IT_Circuit__r.IT_Circuit_Code__c From Case Where Id =: idCase limit 1];
            
            system.debug('codeCli::: '+codeCli);
            system.debug('piva::: '+piva);
            system.debug('codeServizio::: '+codeServizio);
            String returnJson = '';
            String responseBody = '';
            date dateFrom;
            date dateTo;
            //check date
            if(dataDa == null || dataA == null){
            dateFrom = date.today().addmonths(-2);
            dateTo = date.today();
            }
            else{
            dateFrom = dataDa;
            dateTo = dataA;
            }

            
            //String requestSFDC = 'https://salesforce.it.dev.edenred.io/v1/orders?idRichiedente=SF&codCircuito='+codeCirc+'&codCli='+codeCli+'&partitaIva='+piva+'&dateFrom='+dataDa+'&dateTo='+dataA+'&codServ='+codeServizio;
            String requestSFDC = 'https://salesforce.dev.it.edenred.io/v1/orders?date-from=2019-10-07&date-to=2019-10-07';
            string requestURI = '/orders?applicant-id=SF&date-from='+string.valueOf(dateFrom)+'&date-to='+string.valueOf(dateTo);
            if(contextualizeCase[0].IT_Financial_Center__r.IT_Financial_Center__c != null){
                requestURI +='&client-ref='+contextualizeCase[0].IT_Financial_Center__r.IT_Financial_Center__c;
            }
            if(contextualizeCase[0].IT_Circuit__r.IT_Circuit_Code__c != null){
               requestURI +='&circuit-code='+contextualizeCase[0].IT_Circuit__r.IT_Circuit_Code__c; 
            }
            if(contextualizeCase[0].Account.ER_VAT_Number__c != null){
               requestURI +='&vat-code='+contextualizeCase[0].Account.ER_VAT_Number__c;  
            }                
            system.debug('requestSFDC::: '+requestSFDC);
            Http callHttp = new Http();
            //+'&client-type='+clientType+'&date-from='+dataDa+'&date-to='+dataA+'&user-profile='+userProfile+'&company='+company
            //
            //codeCli = '019562';
            HttpRequest requ = APER06_WebserviceUtility.getHttpRequest(
                requestURI,
                'GET',
                null,
                null);
            requ.setHeader('Content-Type', 'application/java');
            HttpResponse res = callHttp.send(requ);
            responseBody = res.getbody();
            
            system.debug('responseBody::: '+responseBody);

            Request req = (Request) JSON.deserializeStrict(responseBody, Request.class);//RESPONSEBODY WHEN MULE WORKS
            List<data> listOrder = new List<data>();
            listOrder = req.data;
            if (!AllFilter){
                for(data singlerequest : listOrder){
                    string queryString = '?para_funzione=VisOrdineTestata';
                    if(singlerequest.client_ref != null){
                        queryString+='&para_codice_cliente='+singlerequest.client_ref;
                    }
                    if(singlerequest.company_ref != null){
                        queryString+='&para_codice_societa='+singlerequest.company_ref;
                    }
                    if(singlerequest.order_year != null){
                        queryString+='&para_anno_ordine='+singlerequest.order_year;
                    }
                    if(singlerequest.order_ref != null){
                        queryString+='&para_codice_ordine='+singlerequest.order_ref;
                    }
                    if(singlerequest.circuit_code != null){
                        queryString+='&para_codice_circuito='+singlerequest.circuit_code; 
                    }
                    singlerequest.detailURL = '/lightning/cmp/c__LNIT00_iframeOpener?c__calledSystem='+singlerequest.application+'&c__isIframe=false&c__queryString='+EncodingUtil.urlEncode(queryString, 'UTF-8');
                    //singlerequest.detailURL = 'https://eit-ssobridge-d.edenred.net/'+singlerequest.application+'?';
                }
            }
            else{
                for(data singlerequest : listOrder){
                    string queryString = '?para_funzione=VisOrdineTestata';
                    if(singlerequest.client_ref != null){
                        queryString+='&para_codice_cliente='+singlerequest.client_ref;
                    }
                    if(singlerequest.company_ref != null){
                        queryString+='&para_codice_societa='+singlerequest.company_ref;
                    }
                    if(singlerequest.order_year != null){
                        queryString+='&para_anno_ordine='+singlerequest.order_year;
                    }
                    if(singlerequest.order_ref != null){
                        queryString+='&para_codice_ordine='+singlerequest.order_ref;
                    }
                    if(singlerequest.circuit_code != null){
                        queryString+='&para_codice_circuito='+singlerequest.circuit_code; 
                    }
                    singlerequest.detailURL = 'https://eit-ssobridge-d.edenred.net/'+singlerequest.application+queryString;
                    //singlerequest.detailURL = 'https://eit-ssobridge-d.edenred.net/'+singlerequest.application+'?';
                }
            }
           
            system.debug('listOrderSize::: '+listOrder.size());
            system.debug('req::: '+req);     
            system.debug('req.listOrder::: '+req.data);  
            
            return listOrder;    
        }catch(Exception ecc){
            System.debug('Error listviewController: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            return null; 
        }
    }
    
    public class picklistWrapper {      
        @AuraEnabled
        public String strValue {get;set;}
        @AuraEnabled
        public String strLabel {get;set;}

        public picklistWrapper(String strValue, String strLabel) {  
            this.strValue = strValue;
            this.strLabel = strLabel;
        }
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
        public String application {get;set;}
        @AuraEnabled
        public String circuit_code {get;set;}
        @AuraEnabled
        public String company_ref {get;set;}
        @AuraEnabled
        public String client_ref {get;set;}
        @AuraEnabled
        public String order_year {get;set;}
        @AuraEnabled
        public String order_ref {get;set;}
        @AuraEnabled
        public Date upload_date {get;set;}
        @AuraEnabled
        public Date delivery_date {get;set;}
        @AuraEnabled
        public String service_description {get;set;}
        @AuraEnabled
        public String channel_description {get;set;}
        @AuraEnabled
        public String order_type {get;set;}
        @AuraEnabled
        public Decimal order_amount {get;set;}
        @AuraEnabled
        public Integer voucher_number {get;set;}
        @AuraEnabled
        public String payment_description {get;set;}
        @AuraEnabled
        public String order_status_description {get;set;}
        @AuraEnabled
        public String customized {get;set;}
        @AuraEnabled
        public Boolean is_modifiable {get;set;}
        @AuraEnabled
        public String detailURL {get;set;}
    }

    public class response {
        public String ErrorCode;
        public String ErrorDescription;     
    }
}