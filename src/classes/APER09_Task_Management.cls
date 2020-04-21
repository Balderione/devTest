public class APER09_Task_Management {
    
    Public Static Task CreateTask(String Subject, String Status, String WhatId){
        
        Task newTask = new Task();
        newTask.WhatId = WhatId;
        newTask.Subject = Subject;
        newTask.Status = Status;
        insert newTask;
        return newTask;
    }

    Public Static Task CreateTaskForContractWithoutInsert(String Subject, Id OwnerId, Date DueDate, Id WhatId, Id WhoId){
        
        Task newTask = new Task();
        newTask.Subject = Subject;
        newTask.OwnerId = OwnerId; 
        newTask.ActivityDate = DueDate;
        newTask.WhatId = WhatId;
        newTask.WhoId = WhoId;
        return newTask;
    }
}