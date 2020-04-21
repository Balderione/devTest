public class APER22_AcceptorToLoopManagement {
    
    public static void ManageAcceptorToLoop(List<ER_Store_to_Loop__c> NewStoreToLoopList) {
        
        Map<id,ER_Acceptor_to_Loop__c> LoopToAcceptorToLoopMap = new Map<id,ER_Acceptor_to_Loop__c>();
        Map<id,List<ER_Acceptor_to_Loop__c>> LoopToListAcceptorToLoopMap = new Map<id,List<ER_Acceptor_to_Loop__c>>();
        Map<id,List<ER_Acceptor_to_Loop__c>> AcceptorToListAcceptorToLoopMap = new Map<id,List<ER_Acceptor_to_Loop__c>>();
        Map<id,List<ER_Store_to_Loop__c>> StoreIdStoreToLoopListMap = New Map<id,List<ER_Store_to_Loop__c>>();
        Map<id,List<ER_Store_to_Loop__c>> StoreToStoreToloopMap = new map<id,List<ER_Store_to_Loop__c>>();
        List<ER_Acceptor_to_Loop__c> AcceptorToLoopList;
        List<ER_Acceptor_to_Loop__c> AcceptorToLoopList2;
        List <ER_Acceptor__c> LstAcceptorToLoopToAdd = new List <ER_Acceptor__c>();
        List <ER_Acceptor_to_Loop__c> LstAcceptorToLoopToUpdate = new List <ER_Acceptor_to_Loop__c>();
        List <ER_Acceptor_to_Loop__c> AcceptorToLoopToInsert = new List <ER_Acceptor_to_Loop__c>();
        List <ER_Acceptor_to_Loop__c> ListAcceptorToLoop = new List <ER_Acceptor_to_Loop__c>();
        List <ER_Acceptor_to_Loop__c> ListAcceptorTocheck = new List <ER_Acceptor_to_Loop__c>();
        List<ER_Store_to_Loop__c> StoreToStoreToLoopList = new List<ER_Store_to_Loop__c>();
        List<ER_Store_to_Loop__c> StoreToLoopListcheckDuplicate  = new List<ER_Store_to_Loop__c>();
        List<ER_Store_to_Loop__c> StoreToLoopList;
        ER_Acceptor_to_Loop__c NewAcceptorToLoop;
        ER_Acceptor_to_Loop__c UpdateAcceptorToLoop;
        Set <Id> StoreIds = new Set <Id> ();
        
        List<ER_Store_to_Loop__c> StoreLoopList2 = new List<ER_Store_to_Loop__c>();
        
        for( ER_Store_to_Loop__c StoreLopp : NewStoreToLoopList)
        {
            StoreToLoopList = new List<ER_Store_to_Loop__c>();
            StoreToLoopList.add(StoreLopp);
            StoreIds.add(StoreLopp.ER_Store__c);
            if(StoreToStoreToloopMap.containsKey(StoreLopp.ER_Store__c))
            {
                StoreToLoopList.addAll(StoreToStoreToloopMap.get(StoreLopp.ER_Store__c));
            }
            StoreToStoreToloopMap.put(StoreLopp.ER_Store__c, StoreToLoopList);
            
        }
        
        List <ER_Store_to_Loop__c> StoreToLoops = [select Id, Name, ER_Store__c, ER_Loop__c, ER_Behaviour__c, ER_Business_Unit__c from ER_Store_to_Loop__c where ER_Store__c in :StoreIds and id not in :NewStoreToLoopList];
        for(ER_Store_to_Loop__c StrToLoops : StoreToLoops)
        {    
            
            if(StoreIdStoreToLoopListMap.containsKey(StrToLoops.ER_Store__c))
            {
                StoreLoopList2.addAll(StoreIdStoreToLoopListMap.get(StrToLoops.ER_Store__c));
            } 
            StoreLoopList2.add(StrToLoops);
            
            
            StoreIdStoreToLoopListMap.put(StrToLoops.ER_Store__c,StoreLoopList2);
            
        }
        
        for(ER_Store_to_Loop__c StrLopp : NewStoreToLoopList)
        {
            if(StoreIdStoreToLoopListMap.containsKey(StrLopp.ER_Store__c)) 
            {
                StoreToLoopListcheckDuplicate = StoreIdStoreToLoopListMap.get(StrLopp.ER_Store__c);
                for(ER_Store_to_Loop__c strtoloop : StoreToLoopListcheckDuplicate)
                {
                    if(strtoloop.ER_Loop__c == StrLopp.ER_Loop__c)
                    {
                        StrLopp.adderror(Label.LABS_SF_Duplicate_Value + strtoloop.Id);
                    }
                }
            }
            
        }
        
        
        List <ER_Acceptor_to_Loop__c> ListAcceptToLoop = [select ER_Acceptor__c,ER_Store_Name__c,ER_Loop__c,ER_Behaviour__c from ER_Acceptor_to_Loop__c  where ER_Acceptor__r.ER_Store__c in :StoreToStoreToloopMap.keySet()];
        List <ER_Acceptor__c> Acceptors = [Select id,ER_Store__c from ER_Acceptor__c where ER_Store__c in :StoreToStoreToloopMap.keySet() ];
        
        for(ER_Acceptor_to_Loop__c AccLoop : ListAcceptToLoop)
        {
            LoopToAcceptorToLoopMap.put(AccLoop.ER_Loop__c, AccLoop);
            AcceptorToLoopList = new List<ER_Acceptor_to_Loop__c>();
            AcceptorToLoopList2 = new List<ER_Acceptor_to_Loop__c>();
            AcceptorToLoopList.add(AccLoop);
            AcceptorToLoopList2.add(AccLoop);
            if(AcceptorToListAcceptorToLoopMap.containsKey(AccLoop.ER_Acceptor__c))
            {
                AcceptorToLoopList.addAll(AcceptorToListAcceptorToLoopMap.get(AccLoop.ER_Acceptor__c));
            }
            AcceptorToListAcceptorToLoopMap.put(AccLoop.ER_Acceptor__c, AcceptorToLoopList);
            if(LoopToListAcceptorToLoopMap.containsKey(AccLoop.ER_Loop__c))
            {
                AcceptorToLoopList2.addAll(LoopToListAcceptorToLoopMap.get(AccLoop.ER_Loop__c));
            }
            LoopToListAcceptorToLoopMap.put(AccLoop.ER_Loop__c,AcceptorToLoopList2);
            
        }
        
        for(ER_Acceptor__c Accptrs : Acceptors)
        {
            StoreToStoreToLoopList = StoreToStoreToloopMap.get(Accptrs.ER_Store__c);
            
            if(!AcceptorToListAcceptorToLoopMap.containsKey(Accptrs.id))
            {
                for(ER_Store_to_Loop__c StrToLoop : StoreToStoreToLoopList)
                {
                    NewAcceptorToLoop = new ER_Acceptor_to_Loop__c(ER_Acceptor__c=Accptrs.id,ER_Behaviour__c=StrToLoop.ER_Behaviour__c,ER_Loop__c=StrToLoop.ER_Loop__c);
                    AcceptorToLoopToInsert.add(NewAcceptorToLoop);
                }
            }
            else
            {
                ListAcceptorToLoop = AcceptorToListAcceptorToLoopMap.get(Accptrs.id);
                for(ER_Store_to_Loop__c StrToLoop : StoreToStoreToLoopList)
                {
                    if(!LoopToListAcceptorToLoopMap.containsKey(StrToLoop.ER_Loop__c))
                    {
                        NewAcceptorToLoop = new ER_Acceptor_to_Loop__c(ER_Acceptor__c=Accptrs.id,ER_Behaviour__c=StrToLoop.ER_Behaviour__c,ER_Loop__c=StrToLoop.ER_Loop__c);
                        AcceptorToLoopToInsert.add(NewAcceptorToLoop);
                    }
                    else
                    {
                        ListAcceptorTocheck = LoopToListAcceptorToLoopMap.get(StrToLoop.ER_Loop__c);
                        for(ER_Acceptor_to_Loop__c AccToLoop : ListAcceptorTocheck)
                        {
                            if(AccToLoop.ER_Acceptor__c == Accptrs.Id)
                            {
                                UpdateAcceptorToLoop = AccToLoop;
                                UpdateAcceptorToLoop.ER_Behaviour__c = StrToLoop.ER_Behaviour__c;
                                LstAcceptorToLoopToUpdate.add(UpdateAcceptorToLoop);
                            }
                        }
                        
                    }
                }
            }
        }  
        
        if (!AcceptorToLoopToInsert.isEmpty()) {
            Insert AcceptorToLoopToInsert;
        }
        if(!LstAcceptorToLoopToUpdate.isEmpty())
        {
            Update LstAcceptorToLoopToUpdate;
        }
    }
    
    public static void CheckAcceptorToLoop(List<ER_Acceptor_to_Loop__c> NewAcceptorToLoopList) {
        
        Map<id,List<ER_Acceptor_to_Loop__c>> AcceptorIdAcceptorToLoopListMap = New Map<id,List<ER_Acceptor_to_Loop__c>>();
        List<ER_Acceptor_to_Loop__c> AcceptorToLoopListcheckDuplicate  = new List<ER_Acceptor_to_Loop__c>();
        Set <Id> AcceptorIds = new Set <Id> ();
        List<ER_Acceptor_to_Loop__c> AcceptorLoopList2 = new List<ER_Acceptor_to_Loop__c>();
        
        for(ER_Acceptor_to_Loop__c AccptrLopp : NewAcceptorToLoopList)
        {
            AcceptorIds.add(AccptrLopp.ER_Acceptor__c);
            
        }
        
        
        List <ER_Acceptor_to_Loop__c> AcceptorToLoops = [select Id, Name, ER_Acceptor__c, ER_Loop__c, ER_Behaviour__c, ER_Business_Unit__c from ER_Acceptor_to_Loop__c where ER_Acceptor__c in :AcceptorIds and id not in :NewAcceptorToLoopList];
        for(ER_Acceptor_to_Loop__c AccptrToLoops : AcceptorToLoops)
        {    
            
            if(AcceptorIdAcceptorToLoopListMap.containsKey(AccptrToLoops.ER_Acceptor__c))
            {
                AcceptorLoopList2.addAll(AcceptorIdAcceptorToLoopListMap.get(AccptrToLoops.ER_Acceptor__c));
            } 
            AcceptorLoopList2.add(AccptrToLoops);
            
            
            AcceptorIdAcceptorToLoopListMap.put(AccptrToLoops.ER_Acceptor__c,AcceptorLoopList2);
            
        }
        
        for(ER_Acceptor_to_Loop__c AccptrLopp : NewAcceptorToLoopList)
        {
            if(AcceptorIdAcceptorToLoopListMap.containsKey(AccptrLopp.ER_Acceptor__c)) 
            {
                AcceptorToLoopListcheckDuplicate = AcceptorIdAcceptorToLoopListMap.get(AccptrLopp.ER_Acceptor__c);
                for(ER_Acceptor_to_Loop__c Accptrtoloop : AcceptorToLoopListcheckDuplicate)
                {
                    if(Accptrtoloop.ER_Loop__c == AccptrLopp.ER_Loop__c)
                    {
                        AccptrLopp.adderror(Label.LABS_SF_Duplicate_Value + Accptrtoloop.Id);
                    }
                }
            }
            
        }
        
    }
    
    public static void CreatenewAcceptorToLoopOnAcceptorInsert(List<ER_Acceptor__c> NewAcceptorsList)
    {
        Set <Id> StoreSet = new Set <Id> ();
    	Map<id, List<ER_Acceptor__c>> StoreToAcceptorListMap = new Map<id, List<ER_Acceptor__c>>();
    	List<ER_Acceptor__c> AcceptorList;
        for(ER_Acceptor__c accPoint: NewAcceptorsList)
        {
            StoreSet.add(accPoint.ER_Store__c);
            
            AcceptorList = new List<ER_Acceptor__c>();
        	AcceptorList.add(accPoint);
        	if(StoreToAcceptorListMap.containsKey(accPoint.ER_Store__c))
        	{
            	AcceptorList.addAll(StoreToAcceptorListMap.get(accPoint.ER_Store__c));
        	}
        	StoreToAcceptorListMap.put(accPoint.ER_Store__c,AcceptorList);
        }
        List <ER_Store_to_Loop__c> StoreToLoops = [select Id, Name, ER_Store__c, ER_Loop__c, ER_Behaviour__c, ER_Business_Unit__c from ER_Store_to_Loop__c where ER_Store__c in :StoreSet];
        List<ER_Acceptor__c> AcceptorListLoopToAdd;
        List <ER_Acceptor_to_Loop__c> AcceptorToLoopToInsert = new List <ER_Acceptor_to_Loop__c>();
    	ER_Acceptor_to_Loop__c NewAcceptorToLoop;
        for(ER_Store_to_Loop__c strtoloop : StoreToLoops)
        {
            AcceptorListLoopToAdd = StoreToAcceptorListMap.get(strtoloop.ER_Store__c);
            for(ER_Acceptor__c AcceptorToAddLoopto : AcceptorListLoopToAdd)
            {
                NewAcceptorToLoop = new ER_Acceptor_to_Loop__c(ER_Acceptor__c=AcceptorToAddLoopto.id,ER_Behaviour__c=strtoloop.ER_Behaviour__c,ER_Loop__c=strtoloop.ER_Loop__c);
                AcceptorToLoopToInsert.add(NewAcceptorToLoop);
            }
        }
        
        if (!AcceptorToLoopToInsert.isEmpty()) 
        {
        	Insert AcceptorToLoopToInsert;
    	}
        
    
    }
}