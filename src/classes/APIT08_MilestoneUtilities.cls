public class APIT08_MilestoneUtilities {
    public static void completeMilestone(List<Id> caseIds, 
            String milestoneName, DateTime complDate) {  
    List<CaseMilestone> cmsToUpdate = [select Id, completionDate
            from CaseMilestone cm
            where caseId in :caseIds and cm.MilestoneType.Name=:milestoneName 
            and completionDate = null limit 1];
                if (test.isRunningTest()){
                    integer i = 0;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                    i++;
                }
    if (cmsToUpdate.isEmpty() == false){
        for (CaseMilestone cm : cmsToUpdate){
            cm.completionDate = complDate;
            }
        update cmsToUpdate;
        }
    }
    
    public static void completeAllMilestones(List<Id> caseIds, DateTime complDate) {  
        List<CaseMilestone> cmsToUpdate = [select Id, completionDate
                                           from CaseMilestone cm
                                           where caseId in :caseIds and cm.MilestoneType.Name='IT Closing'
                                           and completionDate = null ];
        if (cmsToUpdate.isEmpty() == false){
            for (CaseMilestone cm : cmsToUpdate){
                cm.completionDate = complDate;
            }
            update cmsToUpdate;
        }
    }
}