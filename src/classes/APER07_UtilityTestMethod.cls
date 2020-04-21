/*
----------------------------------------------------------------------
-- - Name          : APER07_UtilityTestMethod
-- - Author        : OLA
-- - Description   : utility class to insert data
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  JAN-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
public class APER07_UtilityTestMethod {

  /*************************************
  *               Asset
  **************************************/

  //provide a single Asset
  public static Asset getAsset(String name, String recordTypeDeveloperName, String assetType) {
    return new Asset(
             Name = name,
             Status = Label.LAB_SF_ASSET_Status_Active,
             recordtypeid = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get(recordTypeDeveloperName).getRecordTypeId(),
             ER_Asset_Type__c = assetType
           );
  }

  /*************************************
  *               Case
  **************************************/

  //provide a single Case
  public static Case getCase(String recordTypeDeveloperName) {
    return new Case(
             recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeDeveloperName).getRecordTypeId()
           );
  }


  /*************************************
  *           ER_Employee__c
  **************************************/

  //provide a single Employee
  public static ER_Employee__c getEmployee() {
    return new ER_Employee__c(
             name = 'testEmployee',
             ER_Professional_Email__c = 'test@test.com'
           );
  }

  /*************************************
  *               Account
  **************************************/

  //provide a single Company
  public static Account getCompany(String name) {
    return new Account(
             recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ER_Company_Account_RT').getRecordTypeId(),
             ER_Match_Legal_Address__c = true,
             Name = name
           );
  }

  /*************************************
  *               Contact
  **************************************/

  public static Contact getContact(String recordType, String firstName, String lastName) {
    return new Contact(
             FirstName = firstName ,
             LastName = lastName ,
             recordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId()
           );
  }
    
  /*************************************
  *               Financial Center
  **************************************/

  public static ER_Financial_Center__c getFinancialCenter(String name, String accountId, String fcType, String street, String city,String zipCode, String country) {
    return new ER_Financial_Center__c(
             Name = name,
             ER_Account_Name__c = accountId,
             ER_Type__c = fcType,
             ER_Street__c = street,
             ER_City__c = city,
             ER_Zip_Code__c = zipCode,
             ER_Country__c = country
           );
  }
      
  /*************************************
  *               Bank Account
  **************************************/

    public static ER_Bank_Account__c getBankAccount(String finCenterId, String name, String status, String city, String street,String iban) {
        return new ER_Bank_Account__c(
            Name = name,
            ER_Financial_Center__c = finCenterId,
            ER_Bank_Account_Status__c = status,
            ER_Bank_City__c = city,
            ER_IBAN__c = iban
        );
    }  

  /*************************************
  *               Store
  **************************************/

  public static ER_Store__c getStore(String name, String accountId, String financialCenterId, Date startDate, String street, String city,String zipCode, String country) {
    return new ER_Store__c(
             Name = name,
             ER_Merchant__c = accountId,
             ER_Financial_Center__c = financialCenterId,
             ER_Start_date__c = startDate,
             ER_Street__c = street,
             ER_City__c = city,
             ER_Zip_Code__c = zipCode,
             ER_Country__c = country
           );
  }

  /*************************************
  *               Store Line Item
  **************************************/

  public static ER_Store_Line_Item__c getStoreLineItem(String storeId, String status, String solutionId) {
    return new ER_Store_Line_Item__c(
             ER_Store__c = storeId,
             ER_Status__c = status,
             ER_Solution__c = solutionId
           );
  }
    
  /*************************************
  *               Product
  **************************************/

  //provide a single Client
  public static Product2 getProduct(String codeEDG) {
    return new Product2(
             Name = 'testProduct',
             ER_EDG_Product_Ref__c = codeEDG
           );
  }

  /*************************************
  *               Opportunity
  **************************************/

  public static Opportunity getOpportunity(String recordType, String name) {
    return new Opportunity(
             Name = name ,
             recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId(),
             StageName = Label.LABS_SF_Opp_Status_Qualification,
             CloseDate = Date.today().addMonths(1)
           );
  }

  /*************************************
  *        Opportunity Line Item
  **************************************/

  public static OpportunityLineItem getOpportunityLineItem(String opportunityId, String pricebookEntryId) {
    return new OpportunityLineItem(
             opportunityId = opportunityId,
             pricebookEntryId = pricebookEntryId,
             UnitPrice = 1,
             ER_Percentage__c = 2,
             Quantity = 1
           );
  }

  /*************************************
  *               Quote
  **************************************/

  public static Quote getQuote(String recordType, String name, String opportunityId, String priceBookId) {
    return new Quote(
             Name = name,
             OpportunityId = opportunityId,
             Pricebook2Id = priceBookId,
             recordtypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId(),
             Status = Label.LABS_SF_Quote_Status_Draft,
             ExpirationDate = Date.today().addMonths(1)
           );
  }

  /*************************************
  *        Quote Line Item
  **************************************/

  public static QuoteLineItem getQuoteLineItem(String quoteId, String pricebookEntryId) {
    return new QuoteLineItem(
             QuoteId = quoteId,
             pricebookEntryId = pricebookEntryId,
             UnitPrice = 1,
             ER_Percentage__c = 2,
             Quantity = 1
           );
  }

  /*************************************
  *         Service (Product2)
  **************************************/

  public static Product2 getservice(String name, String solutionId) {
    return new Product2(
             Name = name,
             ER_Type__c = 'service',
             ER_Solution__c = solutionId,
             IsActive = true
           );
  }

  /*************************************
  *         Solution (Product2)
  **************************************/

  public static Product2 getsolution(String name) {
    return new Product2(
             Name = name,
             ER_Type__c = 'solution',
             IsActive = true
           );
  }

  /*************************************
  *         PriceBook
  **************************************/

  public static PriceBook2 getpriceBook() {
    return new PriceBook2(
             Id = Test.getStandardPricebookId(),
             ER_Business_Unit__c = APER10_User_Management.userBU,
             IsActive = true
           );
  }

  /*************************************
  *         PriceBookEntry
  **************************************/

  public static PriceBookEntry getpriceBookEntry(String priceBookId, String productId) {
    return new PriceBookEntry(
             Pricebook2Id = priceBookId,
             Product2Id = productId,
             UnitPrice = 1,
             ER_Percentage__c = 1,
             IsActive = true,
             ER_ValueType__c = Label.LABS_SF_Opp_Product_Currency
           );
  }

  /*************************************
  *               Contact
  **************************************/

  public static Contract getContract(String accountId, Date startDate, String status, String priceBookId) {
    return new Contract(
      AccountId = accountId,
      StartDate = startDate,
      Status = status,
      PriceBook2Id = priceBookId
    );
  }

  /*************************************
  *           Contract Line Item
  **************************************/
  public static ER_ContractLineItem__c getContractLineItem(String contractId, String product2Id,String priceBookEntryId, Integer quantity, Decimal unitPrice) {
    return new ER_ContractLineItem__c(
      ER_Contract__c = contractId,
      ER_Product2__c = product2Id,
      ER_PricebookEntryId__c = priceBookEntryId,
      ER_Quantity__c = quantity,
      ER_UnitPrice__c = unitPrice
    );
  }
}