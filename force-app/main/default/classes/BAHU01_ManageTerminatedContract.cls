/**
* @author Oussama LASFAR
* @date 14/03/2019 (dd/mm/yyyy)
* @description Batch to Synchronize Terminated Contract
*/
global class BAHU01_ManageTerminatedContract implements Schedulable ,Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    String query;
    
    global BAHU01_ManageTerminatedContract(){
        
        query=Label.LABS_SF_BAHU01_ManageTerminatedContract_Query;
    }
    global BAHU01_ManageTerminatedContract(String query){
        
        this.query = query;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        System.debug('###query : '+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Contract> scope){
        
        for(Contract contractInst : scope){

            APHU12_Contract_Management.saveContractEdgWS(contractInst, 'Termination');
        }
        system.debug('##### execute scope: '+scope);   
    }
    
    global void execute(SchedulableContext sc) {
        
        BAHU01_ManageTerminatedContract terminatedContractBatch = new BAHU01_ManageTerminatedContract(); 
        Database.executeBatch(terminatedContractBatch , Integer.valueOf(Label.LABS_SF_BAHU01_ManageTerminatedContract_batchSize)); 
    }
    global void finish(Database.BatchableContext BC){
        
    }                                               
}