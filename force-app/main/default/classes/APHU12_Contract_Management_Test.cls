/*
----------------------------------------------------------------------
-- - Name          : APER12_Contract_Management_Test
-- - Author        : OLA
-- - Description   : TEST for Contract Management class
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Feb-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
@isTest
public class APHU12_Contract_Management_Test {
    
    @testSetup
    static void testSetup() {
        
        Account newMerchantAccount = APER07_UtilityTestMethod.getCompany('APHU12_Contract_Management_Test');
        insert newMerchantAccount;
        
        PriceBook2 newPriceBook = APER07_UtilityTestMethod.getpriceBook();
        //update newPriceBook;
        String pricebookId=newPriceBook.id;
        
        Product2 newSolution = APER07_UtilityTestMethod.getsolution('testSolution');
        insert newSolution;
        
        Product2 newService = APER07_UtilityTestMethod.getservice('testService', newSolution.id);
        insert newService;
        
        PriceBookEntry newPriceBookEntry = APER07_UtilityTestMethod.getpriceBookEntry(newPriceBook.id, newService.id);
        insert newPriceBookEntry;
        
        Opportunity newOpportunity = APER07_UtilityTestMethod.getOpportunity('ER_Merchant_Opportunity', 'APHU12_Contract_Management_Test');
        newOpportunity.AccountId = newMerchantAccount.Id;
        insert newOpportunity;
        
        OpportunityLineItem  newOpportunityProduct = APER07_UtilityTestMethod.getOpportunityLineItem(newOpportunity.id, newPriceBookEntry.id);
        insert newOpportunityProduct;
        
        Quote merchantQuote = APER07_UtilityTestMethod.getQuote('ER_Merchant_Quote', 'APHU12_Contract_Management_Test', newOpportunity.id, pricebookId);
        insert merchantQuote;
        
        QuoteLineItem qli = APER07_UtilityTestMethod.getQuoteLineItem(merchantQuote.id, newPriceBookEntry.id);
        insert qli;
    }
    
    static void acceptQuote() {
        
        List<Quote> quoteList = [Select id From Quote where Name='APHU12_Contract_Management_Test' for update];
        
        if (!quoteList.isEmpty()) {
            Quote quoteInst = quoteList[0];
            quoteInst.Status = Label.LABS_SF_Quote_Status_Accepted;
            update quoteInst;
        }
    }
    
    static void denyQuote() {
        
        List<Quote> quoteList = [Select id From Quote where Name='APHU12_Contract_Management_Test' for update];
        
        if (!quoteList.isEmpty()) {
            Quote quoteInst = quoteList[0];
            quoteInst.Status = Label.LABS_SF_Quote_Status_Accepted;
            update quoteInst;
            
            quoteInst.Status = Label.LABS_SF_Quote_Status_Denied;
            update quoteInst;
        }
    }
    static testMethod void testActivateContractAndAmendment() {
        
        APHU12_Contract_Management_Test.acceptQuote();
        
        List<Contract> contractList = [Select id From Contract where status = : Label.LABS_SF_Contract_Status_Draft limit 1];
        
        if (!contractList.isEmpty()) {
            
            contractList = APHU12_Contract_Management.getContract(contractList[0].id);
            if (!contractList.isEmpty()) {
                
                APHU12_Contract_Management.activateContractController(contractList[0], contractList[0].ER_OpportunityId__c);
                Opportunity amendedOpportunity = APHU12_Contract_Management.contractAmendment(contractList[0].id, contractList[0].ER_OpportunityId__c);
                
                if(amendedOpportunity != null){
                    APER04_Opportunity_Management.discardAmendement(amendedOpportunity.Id); 
                }
                
                APHU12_Contract_Management.contractAmendment(contractList[0].id, '');
                contractList = [Select id, Status, AccountId From Contract where status = : Label.LABS_SF_Contract_Status_Activated limit 1];
                if (!contractList.isEmpty()) {
                    
                    try{
                        
                        APHU12_Contract_Management.saveContractEdgWS(contractList[0],'Activation');
                    }catch(Exception e){
                        //
                    }
                    APHU12_Contract_Management.terminateContract(contractList[0]);
                }
                System.debug('#### contractList : '+contractList);
            }
        }
    }
    static testMethod void deleteCLIFromContract() {
        
        APHU12_Contract_Management_Test.acceptQuote();
        
        Map<id,Contract> contractMap = new Map<id,Contract>([Select id From Contract where status = : Label.LABS_SF_Contract_Status_Draft limit 1]);
        
        if (!contractMap.isEmpty()) {
            
            APHU12_Contract_Management.deleteCLIFromContract(contractMap);
        }
    }
    static testMethod void getAccountWS() {
        
        List<Account> accountList = [Select id From Account limit 1];
        if (!accountList.isEmpty()){
            
            APHU12_Contract_Management.getAccountWS(accountList[0].Id);
        }
    }
    static testMethod void beforeEdgWS() {
        
        List<Account> accountList = [Select id From Account limit 1];
        if (!accountList.isEmpty()){
            
            APHU12_Contract_Management.beforeEdgWS(accountList[0].Id);
        }
    }
    static testMethod void saveEdgWS() {
        
        List<Account> accountList = [Select id From Account limit 1];
        if (!accountList.isEmpty()){
            try{
                
                APHU12_Contract_Management.saveEdgWS(accountList[0].Id);
            }catch(Exception e){
                //The rest is covered by an other class
            }
        }
    }
}