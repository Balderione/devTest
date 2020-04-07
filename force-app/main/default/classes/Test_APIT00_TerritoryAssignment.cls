@isTest
public class Test_APIT00_TerritoryAssignment {
     
    @isTest static void invalidGetTerritory(){
        
        IT_Territory_Assigment__c t1 = new IT_Territory_Assigment__c (
        IT_Email__c = 'test1@test.com',
        IT_City__c = 'Milano',
        Zip_Code__c = '27100',
        IT_Product__c = 'PAPIER Telesales (0€ - 30.000€)'
        );
        
        insert t1;
        
        System.assertEquals(APIT00_TerritoryAssignment.getTerritory('Milano', '27100').size(), 0);
    
    }
    
    @isTest static void validGetTerritory(){
        
        IT_Territory_Assigment__c t1 = new IT_Territory_Assigment__c (
        IT_Email__c = 'test1@test.com',
        IT_City__c = 'Milano',
        Zip_Code__c = '27100',
        IT_Product__c = 'TestProduct'
        );
        
        insert t1;
        
        System.assertEquals(APIT00_TerritoryAssignment.getTerritory('Milano', '27100').size(),1);
    
    }
    
    
    @isTest static void invalidAssignTerritory(){
        
        List <IT_Territory_Assigment__c> IT_Territory_AssigmentList = new List <IT_Territory_Assigment__c>();
        
       IT_Territory_Assigment__c territory1 = new IT_Territory_Assigment__c (
           IT_City__c = 'Milano',
           IT_Product__c = 'TestProduct',
           IT_Region__c = 'Lomabardia',
           IT_State_Code__c = 'IT',
           Zip_Code__c = '27100',
           IT_Email__c =  'test1@email.com'
       );
        
        IT_Territory_AssigmentList.add(territory1);
        
        IT_Territory_Assigment__c territory2 = new IT_Territory_Assigment__c (
           IT_City__c = 'Milano',
           IT_Product__c = 'TestProduct',
           IT_Region__c = 'Lomabardia',
           IT_State_Code__c = 'IT',
           Zip_Code__c = '27100',
           IT_Email__c =  'test2@email.com'
       );
        
        IT_Territory_AssigmentList.add(territory1);
        
        Account account1 = new Account (
            Name = 'TestAccount',
            ER_VAT_Number__c   = '09429840151',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106'
        );
        
       
      /* List<Territory2Type> territoryTypes = Test.loadData(Territory2Type.SObjectType, 'Account Territory');
        
        Territory2Model territoryModel = new Territory2Model(
            Name = 'Territorytest',
            DeveloperName = 'TerritorytestDev'
        );
        
        insert territoryModel;
        
        List<Territory2Model> Territory2ModelIdString = [Select ID from Territory2Model LIMIT 1 ];
        List<Territory2Type> Territory2TypeIdString = [Select ID from Territory2Type LIMIT 1 ];
        
        Territory2 territory2Object = new Territory2(
            Name = 'Territorytest',
            DeveloperName = 'TerritorytestDev',
            Territory2ModelId = Territory2TypeIdString[0].ID,
            Territory2TypeId = Territory2ModelIdString[0].ID,
            //Territory2TypeId = territoryTypes[0].Id,
            IT_Email__c = 'test1@email.com'
            
            
        );
         
        insert territory2Object;
        */ 
        Test.startTest();
 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User usr = new User(Alias = 'tusr', Email='testingterritory@testorg.com', 
						EmailEncodingKey='UTF-8', LastName='TestingTerritory', LanguageLocaleKey='en_US', 
						LocaleSidKey='en_US', ProfileId = p.Id, ER_Business_Unit__c = 'IT',
						TimeZoneSidKey='America/Los_Angeles', UserName='testingterritory@testorg.com');
         List<Territory2> Territory2ID = [Select ID from Territory2 LIMIT 1 ];
        
			insert usr ;
			System.runAs(usr)
			{
                 insert account1;
                ObjectTerritory2Association objT2A = new ObjectTerritory2Association(
                 OBJECTID = account1.id,
                 AssociationCause = 'Territory2Manual',
                 TERRITORY2ID= 	Territory2ID[0].ID                     //'0MI0E000000D1VGWA0'
                 );

				insert objT2A;
			}
        
        APIT00_TerritoryAssignment.AssignTerritory(account1.id,IT_Territory_AssigmentList);
        
        Test.stopTest(); 
        
    }
    
    @isTest static void validAssignTerritory(){
        
        List <IT_Territory_Assigment__c> IT_Territory_AssigmentList = new List <IT_Territory_Assigment__c>();
        List<Territory2> Territory2ID = [Select ID,IT_Email__c from Territory2 LIMIT 1 ];
       IT_Territory_Assigment__c territory1 = new IT_Territory_Assigment__c (
           IT_City__c = 'Milano',
           IT_Product__c = 'TestProduct',
           IT_Region__c = 'Lomabardia',
           IT_State_Code__c = 'IT',
           Zip_Code__c = '27100',
           IT_Email__c =  Territory2ID[0].IT_Email__c
       );
        
        IT_Territory_AssigmentList.add(territory1);
        
        IT_Territory_Assigment__c territory2 = new IT_Territory_Assigment__c (
           IT_City__c = 'Milano',
           IT_Product__c = 'TestProduct',
           IT_Region__c = 'Lomabardia',
           IT_State_Code__c = 'IT',
           Zip_Code__c = '27100',
           IT_Email__c = Territory2ID[0].IT_Email__c
       );
        
        IT_Territory_AssigmentList.add(territory1);
        
        Account account1 = new Account (
            Name = 'TestAccount',
            ER_VAT_Number__c   = '09429840151',
            IT_Fiscal_Code__c  = '01014660417',
            IT_Company_Type__c = 'Private',
            IT_Legal_Form__c   = 'ASS',
            IT_Industry__c     = '106'
        );
       
        Test.startTest();
 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
			User usr = new User(Alias = 'tusr', Email='testingterritory@testorg.com', 
						EmailEncodingKey='UTF-8', LastName='TestingTerritory', LanguageLocaleKey='en_US', 
						LocaleSidKey='en_US', ProfileId = p.Id, ER_Business_Unit__c = 'IT',
						TimeZoneSidKey='America/Los_Angeles', UserName='testingterritory@testorg.com');  
        
			insert usr ;
			System.runAs(usr)
			{
                 insert account1;
                ObjectTerritory2Association objT2A = new ObjectTerritory2Association(
                 OBJECTID = account1.id,
                 AssociationCause = 'Territory2Manual',
                 TERRITORY2ID= 	Territory2ID[0].ID                     //'0MI0E000000D1VGWA0'
                 );

				insert objT2A;
			}
        
        APIT00_TerritoryAssignment.AssignTerritory(account1.id,IT_Territory_AssigmentList);
        
        Test.stopTest(); 
        
    }
    
}