@isTest
public class APIT18_FileUploadController_Test {
    @isTest
    static void TestFileUpload() {
        Date myDate = date.newinstance(2020, 2, 17);
        
        Account accountTest = APIT14_DataFactory.create_BusinessAccount();
        Case caseTest = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest.Subject = '123456';
        caseTest.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Consip_Case_RT').getRecordTypeId();
        caseTest.IT_Statement__c = 'Consip BP 8';
        insert caseTest;
        Case caseTest2 = APIT14_DataFactory.create_Case(accountTest.Id);
        caseTest2.Subject = '123456';
        caseTest2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IT_Client_Consip_Case_RT').getRecordTypeId();
        caseTest2.IT_Statement__c = 'Consip BPE 1';
        insert casetest2;
        IT_Edenred_Document__c bdoc = new IT_Edenred_Document__c (
            IT_Type__c = 'ODA',
            IT_Version__c = 1,
            Name = 'test',
            IT_Case__c = caseTest.id,
            IT_Is_Last_Version__c = true,
            IT_Accepted__c = false
        );
        insert bdoc;
        IT_Edenred_Document__c bdoc2 = new IT_Edenred_Document__c (
            IT_Type__c = 'Altro - Test',
            IT_Version__c = 1,
            Name = 'test2',
            IT_Case__c = caseTest.id,
            IT_Is_Last_Version__c = true,
            IT_Accepted__c = false
        );
        insert bdoc2;
        bdoc2.IT_Accepted__c = true;
        update bdoc2;
        
        ContentVersion contentVersion1 = new ContentVersion(
            Title = 'Penguini_Sch_hello',
            PathOnClient = 'Penguini.jpg',
            VersionData = Blob.valueOf('Testing Content'),
            IsMajorVersion = true
        );
        insert contentVersion1;
        ContentVersion contentVersion2 = new ContentVersion(
            Title = 'Penguini_hello',
            PathOnClient = 'Penguini.jpg',
            VersionData = Blob.valueOf('Testing Content'),
            IsMajorVersion = true
        );
        insert contentVersion2;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        
        APIT18_FileUploadController.returnCurrentAttachment(casetest.id , 'RDA');
        APIT18_FileUploadController.getPickListValuesIntoList(casetest.id);
        string bdocId = APIT18_FileUploadController.newAttachmentVer(casetest.id, documents[0].id, 'RDA', 'test', null, false, myDate, true, true, true);
        APIT18_FileUploadController.createLink(bdocId , documents[0].id);
        APIT18_FileUploadController.newAttachmentUpdate(bdocId, documents[1].id, 'test2');
        APIT18_FileUploadController.getSuggestions('Tes', casetest.id);
        APIT18_FileUploadController.deleteLastVersion(bdocId);
        APIT18_FileUploadController.getMilestoneName(casetest.id);
        APIT18_FileUploadController.updateMilestoneFields(casetest.id);
        
    }
}