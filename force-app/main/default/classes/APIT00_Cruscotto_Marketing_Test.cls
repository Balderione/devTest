@IsTest
public with sharing class APIT00_Cruscotto_Marketing_Test {

	@testSetup
	static void testSetup() {

		Campaign campaign = new Campaign(Name = 'Campaign Test');
		insert campaign;

		Account account = APIT14_DataFactory.create_BusinessAccount();
        account.ER_VAT_Number__c   = '02824320176';
        account.IT_Fiscal_Code__c  = '01014660417';
        account.IT_Company_Type__c = 'Private';
        account.ER_Registration_Number__c = 'ER_Registration_Number__c';
        account.IT_Legal_Form__c   = 'ASS';
        account.IT_Industry__c     = '106';
        account.ER_BUPicklist__c  = 'IT';
        account.Phone = '3336574564';
        account.ER_Legal_Form__c = 'LegalForm';
        account.ER_Industry__c ='Energy';
        account.ER_Other_Fiscal_ID__c = '01014660417';
        account.BillingStreet = 'Billing';
        account.BillingCity = 'Billing';
        account.BillingState = 'Billing';
        account.BillingPostalCode = 'Billing';
        account.BillingCountry  = 'Billing';
        account.NumberOfEmployees = 50;
		insert account;

		Contact contact = APIT14_DataFactory.create_Contact(account.Id);
		contact.IT_Code__c = 'StringString';
		insert contact;

		CampaignMember campaignMember = new CampaignMember(
			CampaignId = campaign.Id, 
			ContactId = contact.Id, 
			IT_Account__c = account.Id,
			IT_User__c = UserInfo.getUserId()
		);
		
		insert campaignMember;
	}

	@IsTest
	public static void checkMethod(){
		List<APIT00_Cruscotto_Marketing.CampaingResponse> campaigns = APIT00_Cruscotto_Marketing.GetCampaignList();
	
        System.assertEquals(1, campaigns.size(), 'Campaigns');
        
		if(campaigns.size() > 0){
			APIT00_Cruscotto_Marketing.CampaingResponse campaign = campaigns.get(0);

			APIT00_Cruscotto_Marketing.CampaignMemberResponse campaignMembers = APIT00_Cruscotto_Marketing.getCampaignContacts(campaign.recordId);
			System.assertEquals(1, campaignMembers.contacts.size(), 'Campaign Member');
		}
		
	}

    
}