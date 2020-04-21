global class APIT19_BatchGroupAssociations implements Schedulable {
    global void execute(SchedulableContext sc){
        BAIT01_BatchGroupAssociations batchRun = new BAIT01_BatchGroupAssociations();   
        Database.executeBatch(batchRun, 20); 
    }
}