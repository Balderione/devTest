/*
----------------------------------------------------------------------
-- - Name          : BAHU01_ManageTerminatedContract
-- - Author        : OLA
-- - Description   : Batch to Synchronize Terminated Contract
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  Mar-2019       OLA                 1.0         Initial version
--  Nov-2019       OLA                 2.0         Replace old query : business Unit is now dynamically taken from user.
---------------------------------------------------------------------------------------
*/
global class BAHU01_ManageTerminatedContract implements Schedulable ,Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    String query;
    
    global BAHU01_ManageTerminatedContract(){
        String userBu = APER10_User_Management.userBU;
        query=Label.LABS_SF_BAHU01_ManageTerminatedContract_Query;
        query = query.replace('{0}','\''+userBu+'\'');
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