public class APIT02_InvoicesListController extends APIT00_Behaviour{

    public class InvoicesException extends Exception{}
    public class InvoicesResponse extends APIT00_AuraResponse{
        @AuraEnabled public APIT00_InvoicesRest.ResponseModel payload;
    }

    public class FinacialCenterResponse extends APIT00_AuraResponse{
        @AuraEnabled public List<ER_Financial_Center__c> listData;
    }
   
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
        }catch(InvoicesException ex){
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
    public static InvoicesResponse listAccountInvoices(Date startDate, Date endDate, String accountId, String finacialCenter){
        DebugStart('APIT02_InvoicesListController', 'listAccountInvoices');
        Debug('startDate', startDate);
        Debug('dataA', endDate);
        Debug('accountId', accountId);

        InvoicesResponse response = new InvoicesResponse();

        try{
            Date dateFrom;
            Date dateTo;
            
            if(startDate == null || endDate == null){
                dateFrom = date.newinstance(1970, 1, 1);
                dateTo = date.today();
            }else{
                dateFrom = startDate;
                dateTo = endDate;
            }

            APIT00_InvoicesRest.ResponseModel responseCallout = APIT00_InvoicesRest.getInvoices(finacialCenter, null, dateFrom, dateTo, null, null);
            DebugJson('responseCallout', responseCallout);

            if(startDate != null && endDate != null){
                List<APIT00_InvoicesRest.InvoiceModel > listInvoicesFiltered = new List<APIT00_InvoicesRest.InvoiceModel>();
                for(APIT00_InvoicesRest.InvoiceModel singlrTot : responseCallout.data){
                    if(Date.valueOf(singlrTot.document_date) >= startDate && Date.valueOf(singlrTot.document_date) <= endDate){
                        listInvoicesFiltered.add(singlrTot);
                    }    
                }

                responseCallout.data = listInvoicesFiltered;
            }
            
            response.payload = responseCallout;
            response.isSuccess = true;
        }catch(InvoicesException ex){
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
    public static InvoicesResponse listInvoices(Date dataDa, Date dataA, String caseId , String codCli) {
        DebugStart('APIT02_InvoicesListController', 'listInvoices');
        Debug('dataDa', dataDa);
        Debug('dataA', dataA);
        Debug('caseId', caseId);
        Debug('codCli', codCli);

        InvoicesResponse response = new InvoicesResponse();

        try{
            Date dateFrom;
            Date dateTo;
            
            if(dataDa == null || dataA == null){
                dateFrom = date.newinstance(1970, 1, 1);
                dateTo = date.today();
            }else{
                dateFrom = dataDa;
                dateTo = dataA;
            }

            String returnJson = '';
            String codeCli = '';

            List<Case> cases = [
                SELECT Id, IT_Financial_Center__r.IT_Financial_Center__c 
                FROM Case 
                WHERE Id =: caseId
            ];

            Case caseData;
            if(cases.size() == 1){
                caseData = cases.get(0);
            }

            Debug('caseData', caseData);

            if(caseData != null)
                codeCli = caseData.IT_Financial_Center__r.IT_Financial_Center__c;
            if(codCli == null || codCli == ''){
                codeCli = codCLi; 
            }

            APIT00_InvoicesRest.ResponseModel responseCallout = APIT00_InvoicesRest.getInvoices(caseData.IT_Financial_Center__r.IT_Financial_Center__c, null, dateFrom, dateTo, null, null);
            DebugJson('responseCallout', responseCallout);

            if(dataDa != null && dataA != null){
                List<APIT00_InvoicesRest.InvoiceModel > listInvoicesFiltered = new List<APIT00_InvoicesRest.InvoiceModel>();
                for(APIT00_InvoicesRest.InvoiceModel singlrTot : responseCallout.data){
                    if(Date.valueOf(singlrTot.document_date) >= dataDa && Date.valueOf(singlrTot.document_date) <= dataA){
                        listInvoicesFiltered.add(singlrTot);
                    }    
                }

                responseCallout.data = listInvoicesFiltered;
            } 
            
            response.payload = responseCallout;
            response.isSuccess = true;
        }catch(InvoicesException ex){
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

}