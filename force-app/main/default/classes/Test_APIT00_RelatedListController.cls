@isTest
public class Test_APIT00_RelatedListController {
  
    @isTest static void testAccountHirerchyFalse(){
    
     Account parent1 = new Account (
            Name = 'Parent1',
            ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50
           
        );
    
    insert parent1;
    
      Account child1 = new Account (
            Name = 'child1',
            ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50,
            ParentId = parent1.id
          
        );
        
    insert child1;
 
     APIT00_RelatedListController.fetchRecs(parent1.id, 'Account', 'ParentID', '', 'false' ,'ER_VAT_Number__c', 'Name', 'IT_Company_Type__c', 'IT_Industry__c');
         }
    
     @isTest static void testAccountHirerchyTrue (){
    
     Account parent1 = new Account (
            Name = 'Parent1',
            ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50
            
        );
    
    insert parent1;
    
      Account child1 = new Account (
            Name = 'child1',
           ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50,
           
            ParentId = parent1.id
        );
        
    insert child1;
 
     APIT00_RelatedListController.fetchRecs(parent1.id, 'Account', 'ParentID', '', 'true' ,'ER_VAT_Number__c', 'Name', 'IT_Company_Type__c', 'IT_Industry__c');
         }
    
     @isTest static void testAccountStrCriteria(){
    
     Account parent1 = new Account (
            Name = 'Parent1',
            ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50
           
        );
    
    insert parent1;
    
      Account child1 = new Account (
            Name = 'child1',
          ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50,
            ParentId = parent1.id
        );
        
    insert child1;
 
     APIT00_RelatedListController.fetchRecs(parent1.id, 'Account', 'ParentID', 'AND Name = \'AccountTest\'', 'false' ,'ER_VAT_Number__c', 'Name', 'IT_Company_Type__c', 'IT_Industry__c');
         }
    
    
    @isTest(seeAllData=false) static void testAccountHirerchyFalseLimit4(){
    
        List < sObject > listsObjectAccount = new List < sObject >();
        
     Account parent1 = new Account (
            Name = 'Parent1',
           ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50
            
        );
    
    insert parent1;
    
      Account child1 = new Account (
            Name = 'child1',
            ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50,
            ParentId = parent1.id
        );
        
        listsObjectAccount.add(child1);
        
         Account child2 = new Account (
            Name = 'child2',
            ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50,
            ParentId = parent1.id
        );
        
     listsObjectAccount.add(child2);
        
           Account child3 = new Account (
            Name = 'child3',
            ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50,
            ParentId = parent1.id
        );
        
     listsObjectAccount.add(child3);
        
          Account child4 = new Account (
            Name = 'child4',
            ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50,
            ParentId = parent1.id
        );
        
     listsObjectAccount.add(child4);
        
         Account child5 = new Account (
            Name = 'child5',
            ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50,
            ParentId = parent1.id
        );
        
     listsObjectAccount.add(child5);
        
         Account child6 = new Account (
            Name = 'child6',
            ER_VAT_Number__c   = '02824320176',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
             ER_Registration_Number__c = 'ER_Registration_Number__c',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106',
            ER_BUPicklist__c  = 'IT',
            Phone = '3336574564',
            ER_Legal_Form__c = 'LegalForm',
            ER_Industry__c ='Energy',
            ER_Other_Fiscal_ID__c = '01014660417',
            BillingStreet = 'Billing',
            BillingCity = 'Billing',
            BillingState = 'Billing',
            BillingPostalCode = 'Billing',
            BillingCountry  = 'Billing',
            NumberOfEmployees = 50,
            ParentId = parent1.id
        );
        
     listsObjectAccount.add(child6);
        
       
        
        insert listsObjectAccount;
        
        System.debug('Id APrent classe Test ' + parent1.id);
        Test.startTest();
     APIT00_RelatedListController.fetchRecs(parent1.id, 'Account', 'ParentID', '', 'false' ,'ER_VAT_Number__c', 'Name', 'IT_Company_Type__c', 'IT_Industry__c');
        Test.stopTest();   
    }
    
    @isTest static void customObjectHierarchyFalse(){
        
        ER_Store__c store = new ER_Store__c(
        Name = 'Store Test',
       ER_Street__c = 'Street 000 271100'
        );
        insert store;
        
        ER_Store_Line_Item__c storeItem = new ER_Store_Line_Item__c(
        ER_Status__c = 'Accept',
        ER_Store__c = store.id 
        );
        insert storeItem;
        
       APIT00_RelatedListController.fetchRecs(store.id, 'ER_Store_Line_Item__c', 'ER_Store__c', '', 'false' ,'', 'Name', '', '');
        }
    
    @isTest static void customObjectHierarchyTrue(){
        
        ER_Store__c store = new ER_Store__c(
        Name = 'Store Test',
       ER_Street__c = 'Street 000 271100'
        );
        insert store;
        
        ER_Store_Line_Item__c storeItem = new ER_Store_Line_Item__c(
        ER_Status__c = 'Accept',
        ER_Store__c = store.id 
        );
        insert storeItem;
        
       APIT00_RelatedListController.fetchRecs(store.id, 'ER_Store_Line_Item__c', 'ER_Store__c', '', 'True' ,'', 'Name', '', '');
        }
}