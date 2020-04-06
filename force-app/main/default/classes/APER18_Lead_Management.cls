/*
----------------------------------------------------------------------
-- - Name          : APER18_Lead_Management
-- - Author        : OLA
-- - Description   : Lead Management, This class is used to group all the functionnality linked to the object Lead
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Sep-2019       OLA                 1.0         Initial version
---------------------------------------------------------------------------------------
*/
public class APER18_Lead_Management {
    /*
*
* OLA
* Sep 2019
* manageRating: Manage rating based on lead source value.
*
*/
    public static Void manageRating( List<Lead> leadList) { 
        for(Lead lead : leadList){
            if( Label.LAB_SF_Map_LeadSource_Rating_Cold.Split(';').contains(lead.leadSource)){
                
                lead.Rating = Label.LAB_SF_Lead_Rating_Cold;
            }
            else if( Label.LAB_SF_Map_LeadSource_Rating_Hot.Split(';').contains(lead.leadSource)){
                
                lead.Rating = Label.LAB_SF_Lead_Rating_Hot;
            }
            else if( Label.LAB_SF_Map_LeadSource_Rating_Warm.Split(';').contains(lead.leadSource)){
                
                lead.Rating = Label.LAB_SF_Lead_Rating_Warm;
            }
        }
    }
    
}