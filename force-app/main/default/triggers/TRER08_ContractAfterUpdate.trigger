/*
----------------------------------------------------------------------
-- - Name          : TRER08_ContractAfterUpdate
-- - Author        : SDR
-- - Description   : Contract Management:
1 - Creating a task after contract activation
--
-- Date         Name                Version     Remarks
-- -----------  -----------         --------    ---------------------------------------
--  May-2019       SDR                 1.0         Initial version (1)
---------------------------------------------------------------------------------------
*/
trigger TRER08_ContractAfterUpdate on Contract (after update) {

    List<Task> taskList = new List<Task>();

    Map<Id, Quote> quoMap = new Map<Id, Quote>();

    Map<Id, Contract> contractNewMap = Trigger.newMap;
    Map<Id, Contract> contractOldMap = Trigger.oldMap;

    Date dueDate = Date.today() + 1;

    Set<Id> quoteIds = new Set<Id>();

    if (APER10_User_Management.canTrigger) {

        for (Contract contract : contractNewMap.values()) {
            if (contract.Status == Label.LABS_SF_Contract_Status_Activated && contract.Status != contractOldMap.get(contract.id).Status) {

                quoteIds.add(contract.ER_QuoteId__c);
            }
        }

        if (!quoteIds.isEmpty()) {

            quoMap = new Map<Id, Quote>([SELECT id, ContactId, Account.Name FROM Quote WHERE ID IN :quoteIds]);
        }

        for (Contract contract : Trigger.new) {

            Contract oldContract = Trigger.oldMap != null ? Trigger.oldMap.get(contract.Id) : null;
            Quote quote = quoMap.get(contract.ER_QuoteId__c);

            if (quote != null && contract.Status == Label.LABS_SF_Contract_Status_Activated && contract.Status != oldContract.Status) {

                String subject = Label.LABS_SF_Task_Subject_WelcomeLetter + ' ' + quote.Account.Name;
                Task newTask = APER09_Task_Management.CreateTaskForContractWithoutInsert(subject, contract.CreatedById, dueDate, contract.Id, quote.ContactId);
                taskList.add(newTask);
                System.debug('List of Tasks to insert' + taskList);
            }
        }

        if (!taskList.isEmpty()) {

            insert taskList;
            System.debug('Tasks inserted successfully');
        }
    }
}