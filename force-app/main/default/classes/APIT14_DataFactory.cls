public class APIT14_DataFactory {
    public static User create_User() {
        List<Profile> TestProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' or Name = 'Utente standard' LIMIT 1];
        User result = new User(                                                                             
            LastName                    = 'Utente Test',                                        
            CommunityNickname           = 'communitynicknameTest',                              
            Alias                       = 'UserTest',                                                                                                       
            ProfileId                   = TestProfileId[0].Id,                            
            Email                       = 'test@test.com',                                                                                                          
            Username                    = 'test.User@testr.name',                       
            EmailEncodingKey            = 'ISO-8859-1',                 
            TimeZoneSidKey              = 'Europe/Rome',                        
            LanguageLocaleKey           = 'it',                 
            LocaleSidKey                = 'it_IT'                           
        );
        return result;
    }
    
    public static Account create_PersonAccount() {
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType where SobjectType='Account' and Developername='PersonAccount' Limit 1];
        
        Account result = new Account(
            IT_Company_Type__c = 'Institution',
            IT_Legal_Form__c = 'SPA',
            FirstName = 'TestName',
            LastName = 'TestSurname',
            PersonEmail =  'personalEmail@gmail.com',
            Phone = '12345679',
            PersonMobilePhone = '16844838',
            RecordTypeId = personAccountRecordType.Id,
            ER_VAT_Number__c ='12345678901'
        );
        
        return result;
    }
    
    public static Account create_BusinessAccount() {
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType where SobjectType='Account' and Developername != 'PersonAccount' Limit 1];
        
        Account result = new Account(
            IT_Company_Type__c = 'Institution',
            IT_Legal_Form__c = 'SPA',
            Name = 'RagioneSociale',
            Phone = '12345679',
            RecordTypeId = personAccountRecordType.Id,
            ER_VAT_Number__c ='12345678901'
        );
        
        return result;
    }
    
    public static Contact create_Contact(string TestAccount) {
        
        Contact result = new Contact(
            FirstName = 'Test',
            LastName = 'Test',
            Phone = '0255555555',
            AccountId = TestAccount
        );
        
        return result;
    }

    public static IT_Contact_Detail__c create_Contact_Detail(string TestContact) {
        
        IT_Contact_Detail__c result = new IT_Contact_Detail__c(
            IT_Contact_Info__c = 'Test',
            IT_Apparatus_Type__c = '001',
            IT_Contact__c = TestContact
        );
        
        return result;
    }
    
    public static Case create_Case(string TestAccount) {
        
        Case result = new Case(
            Subject = '', 
            AccountId = TestAccount
        );
        
        return result;
    }
    
    public static Contract create_Contract(String TestAccount) {
        Date todayDate = system.today();
        Contract result = new Contract(
            StartDate = todayDate,
            CurrencyIsoCode = 'EUR',
            Status = 'Draft',  
            AccountId = TestAccount,
            ER_Contract_External_ID__c = '' 
            
        );
        
        return result;
    }
    
    public static ER_Financial_Center__c create_FinancialCenter(String TestAccount, String TestContact) {
        ER_Financial_Center__c result = new ER_Financial_Center__c(
            Name = '445566',
            IT_Service__c = '1G',
            ER_Account_Name__c = TestAccount,
            ER_Card_Operational_System_ID__c = '',
            ER_Street__c = 'Via Test Financial',
            ER_City__c = 'Milano',
            ER_Country__c = 'Italy',
            ER_Zip_Code__c = '20123',
            ER_Contact__c = TestContact,
            ER_Payment_Site__c = false,
            ER_Email__c = 'testtest@testten.test',
            ER_Invoicing_Site__c = true
            
        );
        
        return result;
    }
    public static IT_Circuit__c create_Circuit(string TestAccount) {
        
        IT_Circuit__c result = new IT_Circuit__c(
            Name = '7890', 
            IT_Account__c = TestAccount
        );
        
        return result;
    } 
    
    public static Entitlement create_Entitlement(string TestAccount) {
        
        Entitlement result = new Entitlement(
            Name = 'Test', 
            IT_Product__c = 'Flexbenefit',
            Accountid = TestAccount,
            IT_Milestone_Take_Over__c = 30,
            IT_Closing_Milestone_Minute__c = 30
            
        );
        
        return result;
    }

    public static IT_Welfare_Project__c create_WelfareProject() {
        
        IT_Welfare_Project__c result = new IT_Welfare_Project__c(
            Name = 'TestName',
            IT_Complexity_Index__c = '1',
            IT_Beneficiaries_Number__c = 1
        );
        
        return result;
    }
    
    public static Emailmessage create_Emailmessage(id caseId) {
        
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = '[JIRA]Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = caseId;
        
        
        return email;
    }

    public static IT_Plan__c create_Plan(String welfareProjectId) {
        
        IT_Plan__c result = new IT_Plan__c(
            Name = 'PlanTest',
            IT_Welfare_Project__c = welfareProjectId,
            IT_Plan_Start_Date__c = system.today(),
            IT_Plan_End_Date__c = system.today()+1
        );
        
        return result;  
    }
    
    public static ER_Delivery_Site__c create_DeliverySite (string financialCenterId , string accountId){
        ER_Delivery_Site__c delsite = new ER_Delivery_Site__c(
            Name = 'DelTest',
            ER_Financial_Center__c = financialCenterId,
            ER_Account_Name__c = accountId,
            IT_Client_Code__c = '445566',
            IT_Activity_AC__c = 'asd'
            
        );
        return delsite;
    }
    public static ER_Distribution_Point__c create_DistributionPoint (string financialCenterId , string deliveryId){
            ER_Distribution_Point__c distPoint = new ER_Distribution_Point__c(
            Name = 'DistTest',
            IT_Financial_Center__c = financialCenterId,
            ER_Delivery_Site__c = deliveryId, 
            IT_AC_Activity__c = 'asd'
            
        );
        return distPoint;
    }

    public static ER_Bank_Account__c create_BankAccount(string financialCenterId) {
        
        ER_Bank_Account__c result = new ER_Bank_Account__c(
            IT_Client_Code__c = '552233',
            Name = 'AccountBank',
            ER_Bank_Name__c = 'AccountBank',
            IT_SDD_Authorized__c = '2',
            IT_Bank_Account_Code__c = '5635',
            IT_ABI__c = '32156',
            IT_CAB__c = '55896',
            IT_CC__c = '256145897236',
            IT_CIN__c = 'M',
            ER_Country__c = 'IT',
            ER_Financial_Center__c = financialCenterId
        );
        
        return result;
    }

    public static IT_Request__c create_Request(string financialCenterId) {
        
        IT_Request__c result = new IT_Request__c(
            IT_Request_Status__c = '2',
            IT_Financial_Center__c = financialCenterId,
            IT_Contract_Start_Date__c = System.today()
        );
        
        return result;
    }

    public static IT_Group_Code__c create_GroupCode(string financialCenterId) {
        
        IT_Group_Code__c result = new IT_Group_Code__c(
            IT_Client_Code__c = '774455',
            IT_Group_Code__c = '888995',
            IT_Group_Type__c = '01',
            ER_Financial_Center__c = financialCenterId
        );
        
        return result;
    }

    public static IT_Group__c create_Group(string financialCenterId) {
        
        IT_Group__c result = new IT_Group__c(
            IT_Key_Group__c = '88899501',
            IT_Group_Code__c = '888995',
            IT_Group_Type__c = '01',
            IT_Parent_Company__c = financialCenterId,  
            IT_Description__c = 'TestTest'
        );
        
        return result;
    }

    public static ER_ContractLineItem__c create_ContractLineItem(string contractId) {
        
        ER_ContractLineItem__c result = new ER_ContractLineItem__c(
            ER_Contract__c = contractId,
            Name = 'Service1',
            ER_Quantity__c = 0,
            ER_UnitPrice__c = 0
        );
        
        return result;
    }

    public static IT_Contact_Association__c create_ContactASS(string contactDetailId, string financialCenterId) {
        
        IT_Contact_Association__c result = new IT_Contact_Association__c(
            IT_Contact_Detail__c = contactDetailId,
            IT_Financial_Center__c = financialCenterId
        );
        
        return result;
    }

    public static IT_Intent_Declaration__c create_IntentDeclaration(string AccountId) {
        
        IT_Intent_Declaration__c result = new IT_Intent_Declaration__c(
            IT_Account__c = AccountId,
            IT_Validity_Year__c = String.valueOf(system.today().year())
        );
        
        return result;
    }
    
    public static Product2 create_Product() {
        
        Product2 result = new Product2(
            Name = 'TEST CLASS',
            ProductCode = '1G'
        );
        
        return result;
    }

    public static IT_Note__c create_Note(string financialCenterId, String deliveryId) {
        
        IT_Note__c result = new IT_Note__c(
            Name = 'TEST CLASS',
            IT_Financial_Center__c = financialCenterId,
            IT_Delivery_Site__c = deliveryId,
            IT_Title__c = 'TEST TITLE'
        );
        
        return result;
    }

    public static IT_Additional_Expenses__c create_AddExp(string financialCenterId) {
        
        IT_Additional_Expenses__c result = new IT_Additional_Expenses__c(
            IT_Financial_Center__c = financialCenterId,
            IT_Service__c = 'A',
            IT_Code__c = '01',
            IT_Amount__c = 3
        );
        
        return result;
    }
    
}