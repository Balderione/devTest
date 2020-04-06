global class APIT20_BatchFinancialCenterChilds implements Schedulable {
    global void execute(SchedulableContext sc){
        BAIT02_BatchFinancialCenterChilds batchRun = new BAIT02_BatchFinancialCenterChilds();   
        Database.executeBatch(batchRun); 
    }
}