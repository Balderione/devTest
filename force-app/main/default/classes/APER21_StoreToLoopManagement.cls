public class APER21_StoreToLoopManagement {   
    
    public static void ManageStoreToLoop(List<ER_Account_to_Loop__c> AccountToLoopList) 
    {
        
        Map<id,List<ER_Account_to_Loop__c>> AccountToAccountLoopMap = new map<id,List<ER_Account_to_Loop__c>>();
        Map<id,List<ER_Account_to_Loop__c>> AccountIdAccountToLoopListMap = New Map<id,List<ER_Account_to_Loop__c>>();
        Map<id, List<ER_Store_to_Loop__c>> LoopToListStoreToLoopMap = new Map<id, List<ER_Store_to_Loop__c>>();
        Map<id, List<ER_Store_to_Loop__c>> StoreToListStoreToLoopMap = new Map<id, List<ER_Store_to_Loop__c>>();
        List<ER_Account_to_Loop__c> AccountLoopList = new List<ER_Account_to_Loop__c>();
        List<ER_Store_to_Loop__c> StoreToLoopList;
        List<ER_Store_to_Loop__c> StoreToLoopList2;
        List<ER_Store_to_Loop__c> StoreToLoopListCheck;
        List<ER_Account_to_Loop__c> AccountToAccountLoopList  = new List<ER_Account_to_Loop__c>();
        List<ER_Account_to_Loop__c> AccountLoopList2  = new List<ER_Account_to_Loop__c>();
        List<ER_Account_to_Loop__c> AccountToLoopListcheckDuplicate  = new List<ER_Account_to_Loop__c>();
        List <ER_Store_to_Loop__c> StoreToLoopToInsert = new List <ER_Store_to_Loop__c>();
        List <ER_Store_to_Loop__c> StoreToLoopToUpdate = new List <ER_Store_to_Loop__c>();
        List <ER_Store_to_Loop__c> ListStoreToLoop = new List <ER_Store_to_Loop__c>();
        Set <Id> AccountIds = new Set <Id> ();
        ER_Store_to_Loop__c NewStoreToLoop;
        ER_Store_to_Loop__c UpdateStoreToLoop;
        
        for( ER_Account_to_Loop__c AccLopp : AccountToLoopList)
        {
            AccountLoopList = new List<ER_Account_to_Loop__c>();
            AccountLoopList.add(AccLopp);
            AccountIds.add(AccLopp.ER_Account__c);
            if(AccountToAccountLoopMap.containsKey(AccLopp.ER_Account__c))
            {
                AccountLoopList.addAll(AccountToAccountLoopMap.get(AccLopp.ER_Account__c));
            }
            AccountToAccountLoopMap.put(AccLopp.ER_Account__c, AccountLoopList); 
            
        }
        List <ER_Account_to_Loop__c> AccountToLoops = [select Id, Name, ER_Account__c, ER_Loop__c, ER_Behaviour__c, ER_Business_Unit__c from ER_Account_to_Loop__c where ER_Account__c in :AccountIds and id not in :AccountToLoopList];
        for(ER_Account_to_Loop__c accToLoops : AccountToLoops)
        {    
            
            if(AccountIdAccountToLoopListMap.containsKey(accToLoops.ER_Account__c))
            {
                AccountLoopList2.addAll(AccountIdAccountToLoopListMap.get(accToLoops.ER_Account__c));
            } 
            AccountLoopList2.add(accToLoops);
            
            
            AccountIdAccountToLoopListMap.put(accToLoops.ER_Account__c,AccountLoopList2);
            
        }
        
        for(ER_Account_to_Loop__c AccLopp : AccountToLoopList)
        {
            if(AccountIdAccountToLoopListMap.containsKey(AccLopp.ER_Account__c)) 
            {
                AccountToLoopListcheckDuplicate = AccountIdAccountToLoopListMap.get(AccLopp.ER_Account__c);
                for(ER_Account_to_Loop__c acctoloop : AccountToLoopListcheckDuplicate)
                {
                    if(acctoloop.ER_Loop__c == AccLopp.ER_Loop__c)
                    {
                        AccLopp.adderror(Label.LABS_SF_Duplicate_Value + acctoloop.Id);
                    }
                }
            }
            
        }
        
        List <ER_Store_to_Loop__c> StoreToLoops = [select Id, Name, ER_Store__c, ER_Loop__c, ER_Behaviour__c, ER_Business_Unit__c from ER_Store_to_Loop__c where ER_Store__r.ER_Financial_Center__r.ER_Account_Name__c in : AccountToAccountLoopMap.keySet()];
        List <ER_Store__c> Stores = [Select id,ER_Merchant__c,ER_Financial_Center__r.ER_Account_Name__c  from ER_Store__c where ER_Financial_Center__r.ER_Account_Name__c in : AccountToAccountLoopMap.keySet() ];
        for(ER_Store_to_Loop__c StrLoop : StoreToLoops)
        {
            StoreToLoopList = new List<ER_Store_to_Loop__c>();
            StoreToLoopList.add(StrLoop);
            StoreToLoopList2 = new List<ER_Store_to_Loop__c>();
            StoreToLoopList2.add(StrLoop);
            if(StoreToListStoreToLoopMap.containsKey(StrLoop.ER_Store__c))
            {
                StoreToLoopList.addAll(StoreToListStoreToLoopMap.get(StrLoop.ER_Store__c));
            }
            StoreToListStoreToLoopMap.put(StrLoop.ER_Store__c,StoreToLoopList);
            if(LoopToListStoreToLoopMap.containsKey(StrLoop.ER_Loop__c))
            {
                StoreToLoopList2.addAll(LoopToListStoreToLoopMap.get(StrLoop.ER_Loop__c));
            }
            LoopToListStoreToLoopMap.put(StrLoop.ER_Loop__c,StoreToLoopList2);
        }
        
        for(ER_Store__c Strs : Stores)
        {
            AccountToAccountLoopList = AccountToAccountLoopMap.get(Strs.ER_Financial_Center__r.ER_Account_Name__c); 
            if(!StoreToListStoreToLoopMap.containsKey(Strs.id))
            {
                for(ER_Account_to_Loop__c AccToLoop : AccountToAccountLoopList)
                {
                    NewStoreToLoop = new ER_Store_to_Loop__c(ER_Loop__c=AccToLoop.ER_Loop__c,ER_Store__c=Strs.id,ER_Behaviour__c=AccToLoop.ER_Behaviour__c);
                    StoreToLoopToInsert.add(NewStoreToLoop);
                } 
            }
            else
            {
                ListStoreToLoop = StoreToListStoreToLoopMap.get(Strs.id);
                for(ER_Account_to_Loop__c AccToLoop : AccountToAccountLoopList)
                {
                    if(!LoopToListStoreToLoopMap.containsKey(AccToLoop.ER_Loop__c))
                    {
                        NewStoreToLoop = new ER_Store_to_Loop__c(ER_Loop__c=AccToLoop.ER_Loop__c,ER_Store__c=Strs.id,ER_Behaviour__c=AccToLoop.ER_Behaviour__c);
                        StoreToLoopToInsert.add(NewStoreToLoop);    
                    }
                    else
                    {
                        StoreToLoopListCheck = LoopToListStoreToLoopMap.get(AccToLoop.ER_Loop__c);
                        system.debug('StoreToLoopListCheck : '+StoreToLoopListCheck);
                        for(ER_Store_to_Loop__c StrToLoopCheck : StoreToLoopListCheck)
                        {
                            if(StrToLoopCheck.ER_Store__c == Strs.Id)
                            {
                                UpdateStoreToLoop = StrToLoopCheck;
                                UpdateStoreToLoop.ER_Behaviour__c = AccToLoop.ER_Behaviour__c;
                                StoreToLoopToUpdate.add(UpdateStoreToLoop); 
                            }
                        }
                    }
                }
                
            }
        }
        
        if (!StoreToLoopToInsert.isEmpty()) 
        {
            Insert StoreToLoopToInsert;
        }    
        system.debug('StoreToLoopToUpdate : '+StoreToLoopToUpdate);
        if(!StoreToLoopToUpdate.isEmpty())
        {
            Update StoreToLoopToUpdate;
        }
        
    }
	
	public static void CreatenewStoreToLoopOnStoreInsert(List<ER_Store__c> NewStoreList)  
    {
        Set <Id> AccountSet = new Set <Id> ();
    Set <Id> FinancialCenterSet = new Set <Id> ();
    Map<Id, List<ER_Store__c>> AccountToStoreListMap = new Map<id, List<ER_Store__c>>();
    List <ER_Store__c> StoreList;
        for(ER_Store__c InsertedStores: NewStoreList)
        {
            FinancialCenterSet.add(InsertedStores.ER_Financial_Center__c);
        }
        List<ER_Financial_Center__c> relatedAccounts = [Select id,ER_Account_Name__c from ER_Financial_Center__c where id in :FinancialCenterSet];
        Map<id,id> FcToAccountMap = new Map<Id,Id>();
        for(ER_Financial_Center__c fctoaccount :relatedAccounts)
        {
            FcToAccountMap.put(fctoaccount.id,fctoaccount.ER_Account_Name__c);
            AccountSet.add(fctoaccount.ER_Account_Name__c);
        }
           
        for(ER_Store__c stores: NewStoreList)
        {
            Id Accountid = FcToAccountMap.get(stores.ER_Financial_Center__c);
            system.debug('stores.ER_Financial_Center__c : '+stores.ER_Financial_Center__c);
            system.debug('Account id : '+FcToAccountMap.get(stores.ER_Financial_Center__c));
            StoreList = new List<ER_Store__c>();
			StoreList.add(stores);
            if(AccountToStoreListMap.containsKey(Accountid))
            {
                StoreList.addAll(AccountToStoreListMap.get(Accountid));
            }
            AccountToStoreListMap.put(Accountid, StoreList);
         }
        system.debug('AccountSet : '+AccountSet);
        List <ER_Account_to_Loop__c> AccountToLoops = [select Id, Name, ER_Account__c, ER_Loop__c, ER_Behaviour__c, ER_Business_Unit__c from ER_Account_to_Loop__c where ER_Account__c in :AccountSet];
        system.debug('AccountToLoops : '+AccountToLoops);
        List<ER_Store__c> StoreToAdd;
        List<ER_Store_to_Loop__c> StoreToLoopToAdd = new List<ER_Store_to_Loop__c>();
        ER_Store_to_Loop__c NewStoreToLoop;
        for(ER_Account_to_Loop__c accToLoops : AccountToLoops)
        {
            StoreToAdd = AccountToStoreListMap.get(accToLoops.ER_Account__c);
            for(ER_Store__c strToLoopToAdd : StoreToAdd)
            {
                NewStoreToLoop = new ER_Store_to_Loop__c(ER_Store__c=strToLoopToAdd.Id,ER_Behaviour__c=accToLoops.ER_Behaviour__c,ER_Loop__c=accToLoops.ER_Loop__c);
            	StoreToLoopToAdd.add(NewStoreToLoop);
            }
        }
        system.debug('StoreToLoopToAdd : '+StoreToLoopToAdd);
        if (!StoreToLoopToAdd.isEmpty()) 
        {
        	Insert StoreToLoopToAdd;
    	}
    
    }
	//CreatenewAcceptorToLoopOnAcceptorInsert    
}