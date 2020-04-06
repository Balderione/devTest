/*
----------------------------------------------------------------------
-- - Name          : APER11_Quote_Management_Test
-- - Author        : OLA
-- - Description   :
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  FEB-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
@isTest
public class APER11_Quote_Management_Test {
    
    @testSetup
    static void testSetup() {
        
        Account newMerchantAccount = APER07_UtilityTestMethod.getCompany('testCompany');
        insert newMerchantAccount;
        /*
        PriceBook2 newPriceBook = APER07_UtilityTestMethod.getpriceBook();
        //update newPriceBook;
        String pricebookId=newPriceBook.id;
        
        Product2 newSolution = APER07_UtilityTestMethod.getsolution('testSolution');
        insert newSolution;

        Product2 newService = APER07_UtilityTestMethod.getservice('testService', newSolution.id);
        insert newService;
        
        PriceBookEntry newPriceBookEntry = APER07_UtilityTestMethod.getpriceBookEntry(newPriceBook.id, newService.id);
        insert newPriceBookEntry;
        */
        Opportunity newOpportunity = APER07_UtilityTestMethod.getOpportunity('ER_Merchant_Opportunity', 'APER11_Quote_Management_Test');
        newOpportunity.AccountId = newMerchantAccount.Id;
        insert newOpportunity;
        /*
        OpportunityLineItem  newOpportunityProduct = APER07_UtilityTestMethod.getOpportunityLineItem(newOpportunity.id, newPriceBookEntry.id);
        insert newOpportunityProduct;
        */
        Quote merchantQuote = APER07_UtilityTestMethod.getQuote('ER_Merchant_Quote', 'APER11_Quote_Management_Test', newOpportunity.id, null);
        insert merchantQuote;
        /*
        QuoteLineItem qli = APER07_UtilityTestMethod.getQuoteLineItem(merchantQuote.id, newPriceBookEntry.id);
        insert qli;
        */
    }
    
    static testMethod void testSendPDF() {
        
        List<Quote> quoteList = [Select id From Quote];
        
        if (!quoteList.isEmpty()) {
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String emailAddress = 'JustFotTest@edennred.com';
            String[] toAddresses = emailAddress.split(';');
            mail.setToAddresses( toAddresses );
            mail.setPlainTextBody('');
            mail.setWhatId(quoteList[0].Id);
            mail.setSaveAsActivity(true);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}