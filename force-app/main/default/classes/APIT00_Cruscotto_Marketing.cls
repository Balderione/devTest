public with sharing class APIT00_Cruscotto_Marketing extends APIT00_Behaviour{

    public class DashboardMarketingException extends Exception{}
    
    public class CampaingResponse extends APIT00_AuraResponse{
        @AuraEnabled public String recordId;
        @AuraEnabled public String name;
        
        public CampaingResponse(String recordId, String name){
            this.recordId = recordId;
            this.name = name;
        }
    }

    public class CampaignMemberResponse extends APIT00_AuraResponse{
        @AuraEnabled public List<Contact> contacts;
        @AuraEnabled public List<String> contactInOtherCampaign;
    }
    
    @AuraEnabled
    public static CampaignMemberResponse getCampaignContacts(String campaignId){
        DebugStart('APIT00_Cruscotto_Marketing', 'getCampaignContacts');
        Debug('campaignId', campaignId);

        CampaignMemberResponse response = new CampaignMemberResponse();

        try{
            /**
             * GET ALL CONTACTS FOR CURRENT CAMPAIGN
             */
            List<Contact> listContacts =  [
                SELECT Id, Account.Name,AccountId,Email,Phone,Account.BillingCity,Account.BillingPostalCode,Account.BillingState 
                FROM Contact 
                WHERE Id IN (
                    SELECT ContactId 
                    FROM CampaignMember
                    WHERE CampaignId = :campaignId AND IT_User__c= :userInfo.getUserId()
                )
            ];

            response.contacts = listContacts;

            /**
             * EXTRACT CONTANTS ID FOR CHECK OTHER CAMPAIGNS
             */
            Set<String> contactsIds = new Set<String>();
            for(Contact contact : listContacts){
                contactsIds.add(contact.Id);
            }

            Debug('contactsIds', contactsIds);

            /**
             * RETRIVE CAMPAIGNS MEMBER FOR OTHER CAMPAIGNS
             */
            List<CampaignMember> otherCampaignMembers = [
                SELECT ContactId 
                FROM CampaignMember
                WHERE CampaignId != :campaignId
                AND ContactId IN :contactsIds
                AND IT_User__c= :userInfo.getUserId()
            ];

            Debug('otherCampaignMembers', otherCampaignMembers);

            /**
             * CREATE LIST CONTACTS IN OTHER CAMPAIGNS
             */
            Set<String> contactsIdsOther = new Set<String>();
            for(CampaignMember campaignMember : otherCampaignMembers){
                contactsIdsOther.add(campaignMember.ContactId);
            }

            response.contactInOtherCampaign = new List<String>(contactsIdsOther);
            
            response.isSuccess = true;
        }catch(DashboardMarketingException ex){
            Debug('Exception', ex.getStackTraceString());
            response.errorMessage = ex.getMessage();
        }

        Debug('response', response);
        DebugEnd();
        return response;
    }
    
    @AuraEnabled
    public static List<CampaingResponse> GetCampaignList(){
        DebugStart('APIT00_Cruscotto_Marketing', 'GetCampaignList');

        List<AggregateResult> tDetails =  [
            SELECT Campaign.Id CampaignId, Campaign.Name CampaignName 
            FROM CampaignMember 
            WHERE IT_User__c=: userInfo.getUserId() 
            GROUP BY Campaign.Id, Campaign.Name
        ];
        
        List<CampaingResponse> listCampaigns = new List <CampaingResponse> ();
        
        for(AggregateResult aggregate : tDetails){   
            String campaignId = (String)aggregate.get('CampaignId');
            String campaignName = (String)aggregate.get('CampaignName');

            CampaingResponse newCamp = new CampaingResponse(campaignId, campaignName);
            
            listCampaigns.add(newCamp);
        }
        
        Debug('listCampaigns', listCampaigns);
        DebugEnd();
        return listCampaigns;
    }
}