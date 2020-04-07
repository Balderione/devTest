public class APIT01_OrderListController extends APIT00_Behaviour{

    public class OrdersException extends Exception{}
    public class OrdersResponse extends APIT00_AuraResponse{
        @AuraEnabled public APIT00_OrdersRest.ResponseModel payload;
    }
    public class FinacialCenterResponse extends APIT00_AuraResponse{
        @AuraEnabled public List<ER_Financial_Center__c> listData;
    }

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
    public static Case callCase(String caseId) {
        List<Case> contextualizeCase = [
            SELECT Id, Account.ER_VAT_Number__c, IT_Financial_Center__r.IT_Financial_Center__c, 
                IT_Financial_Center__r.Name, IT_Circuit__r.IT_Circuit_Code__c 
            FROM Case 
            WHERE Id =: caseId 
            LIMIT 1
        ];

        if(contextualizeCase != null && contextualizeCase.size() > 0)
            return contextualizeCase[0]; 
        else
            return null; 
    }

    @AuraEnabled
    public static FinacialCenterResponse getFinancialCenter(String accountId){
        DebugStart('APIT02_InvoicesListController', 'getFinancialCenter');
        Debug('accountId', accountId);

        FinacialCenterResponse response = new FinacialCenterResponse();

        try{
            response.listData = [
                SELECT Name, IT_Financial_Center__c
                FROM ER_Financial_Center__c 
                WHERE ER_Account_Name__c = :accountId
            ];

            response.isSuccess = true;
        }catch(OrdersException ex){
            Debug('Exception', ex.getStackTraceString());
            response.errorMessage = ex.getMessage();
        }catch(Exception ex){
            Debug('Exception', ex.getStackTraceString());
            response.errorMessage = ex.getMessage();
        }

        Debug('response', response);
        DebugEnd();

        return response;
    }

    @AuraEnabled
    public static OrdersResponse listOrderAccount(Date dataDa, Date dataA, String accountId, String finacialCenter){
        DebugStart('APIT01_OrderListController', 'listOrderAccount');
        OrdersResponse response = new OrdersResponse();

        try{
            Date dateFrom;
            Date dateTo;
            
            if(dataDa == null || dataA == null){
                dateFrom = date.today().addmonths(-2);
                dateTo = date.today();
            }else{
                dateFrom = dataDa;
                dateTo = dataA;
            }

            List<Account> accounts = [
                SELECT Id, ER_VAT_Number__c 
                FROM Account
                WHERE Id = :accountId
            ];

            List<ER_Financial_Center__c> finacialCenters = [
                SELECT Name, IT_Financial_Center__c, IT_Circuit_Code__c
                FROM ER_Financial_Center__c 
                WHERE ER_Account_Name__c = :accountId
                AND IT_Financial_Center__c = :finacialCenter
            ];

            if(accounts.size() == 0) throw new OrdersException('Account not found');
            if(finacialCenters.size() == 0) throw new OrdersException('Financial Center not found');

            Account account = accounts.get(0);
            ER_Financial_Center__c finacialCenterObject = finacialCenters.get(0);
            Debug('finacialCenterObject', finacialCenterObject);
            
            APIT00_OrdersRest.ResponseModel responseCallout = APIT00_OrdersRest.getOrders(
                finacialCenter,
                finacialCenterObject.IT_Circuit_Code__c,
                account.ER_VAT_Number__c,
                dateFrom,
                dateTo
            );

            response.payload = responseCallout;

            if(responseCallout.meta.status == 'failed') throw new OrdersException('Error 500');
            response.isSuccess = true;
        }catch(OrdersException ex){
            Debug('Exception', ex.getStackTraceString());
            response.errorMessage = ex.getMessage();
        }catch(Exception ex){
            Debug('Exception', ex.getStackTraceString());
            response.errorMessage = ex.getMessage();
        }

        Debug('response', response);
        DebugEnd();

        return response;
    }
    
    @AuraEnabled
    public static OrdersResponse listOrder(Date dataDa, Date dataA, String caseId) {
        DebugStart('APIT01_OrderListController', 'listOrder');
        OrdersResponse response = new OrdersResponse();

        try{
            Date dateFrom;
            Date dateTo;
            
            if(dataDa == null || dataA == null){
                dateFrom = date.today().addmonths(-2);
                dateTo = date.today();
            }else{
                dateFrom = dataDa;
                dateTo = dataA;
            }

            List<Case> contextualizeCase = new List<Case>();
            contextualizeCase = [
                SELECT Id, Account.ER_VAT_Number__c, IT_Financial_Center__r.IT_Financial_Center__c, 
                    IT_Financial_Center__r.Name, IT_Circuit__r.IT_Circuit_Code__c 
                FROM Case 
                WHERE Id =: caseId 
                LIMIT 1
            ];

            if(contextualizeCase.size() == 0) throw new OrdersException('Case not found');

            Case caseData = contextualizeCase[0];
            APIT00_OrdersRest.ResponseModel responseCallout = APIT00_OrdersRest.getOrders(
                caseData.IT_Financial_Center__r.IT_Financial_Center__c,
                caseData.IT_Circuit__r.IT_Circuit_Code__c,
                caseData.Account.ER_VAT_Number__c,
                dateFrom,
                dateTo
            );

            response.payload = responseCallout;
            if(responseCallout.meta.status == 'failed') throw new OrdersException('Error 500');

            response.isSuccess = true;
        }catch(OrdersException ex){
            Debug('Exception', ex.getStackTraceString());
            response.errorMessage = ex.getMessage();
        }catch(Exception ex){
            Debug('Exception', ex.getStackTraceString());
            response.errorMessage = ex.getMessage();
        }

        Debug('response', response);
        DebugEnd();

        return response;
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