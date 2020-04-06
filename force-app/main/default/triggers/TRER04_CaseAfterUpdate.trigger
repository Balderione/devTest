trigger TRER04_CaseAfterUpdate on Case (after update) {
    if(APER10_User_Management.canTrigger){
    	System.debug('###:TRER04_CaseAfterUpdate after Update IN');
        
        DateTime completionDate = System.now();
        Map<String,List<String>> CaseMilestone = new Map<String,List<String>>();
        List<String> casesStandard;
        List<String> cases2Level;
        for (Case c : Trigger.new) {
            Case oldcase = Trigger.oldmap.get(c.ID);

            if(c.Status != oldcase.Status){

                casesStandard = new List<String>();
                cases2Level = new List<String>();
                
                if( (Test.isRunningTest() || (c.SlaStartDate <= completionDate)) &&(c.SlaExitDate == null)){
                    if(c.isClosed || c.Status == Label.LAB_SF_Case_feedbackSent){

                        if(CaseMilestone.get('Support 2nd Level') != null){
                            cases2Level = CaseMilestone.get('Support 2nd Level');
                        }
                        cases2Level.add(c.id);
                        CaseMilestone.put('Support 2nd Level',cases2Level);
                    } 
                    if (c.isClosed || c.Status == Label.LAB_SF_Case_resolved){

                        if(CaseMilestone.get('Resolution Time') != null){
                            casesStandard = CaseMilestone.get('Resolution Time');
                        }
                        casesStandard.add(c.id);
                        CaseMilestone.put('Resolution Time',casesStandard);
                    }
                }
            }
        }
        
        if(!CaseMilestone.isEmpty()){
            APER08_Case_Management.completeMilestone(CaseMilestone, completionDate);
        }
    }
}