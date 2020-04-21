@isTest
public class APIT09_CreatePDFController_Test {
    @isTest
    static void TestCreatePdf() {
        IT_Welfare_Project__c weProTest = APIT14_DataFactory.create_WelfareProject();
        insert weProTest;
        IT_Plan__c planTest = APIT14_DataFactory.create_Plan(weProTest.Id);
        //insert planTest;
        IT_PDF_TemplateMdt__mdt pdfTemp = [Select MasterLabel, IT_Active__c, IT_Object_Name__c, IT_HtmlForPdf__c, (Select IT_Active__c, IT_Child_Object__c, IT_Field_Name__c, IT_Placeholder__c, IT_Replace_Type__c, IT_Object_Name__c, IT_PDF_Template__c, IT_Image__c From Replace_Items__r) From IT_PDF_TemplateMdt__mdt limit 1];

        APIT09_CreatePDFController.ShowPdf(pdfTemp.Id, weProTest.Id, 'IT_Welfare_Project__c'); 
        APIT09_CreatePDFController.ShowPdfList('IT_Welfare_Project__c');

        ApexPages.currentPage().getParameters().put('templateId', String.valueOf(pdfTemp.Id));
    	ApexPages.currentPage().getParameters().put('templateObjectName', String.valueOf('IT_Welfare_Project__c'));
        ApexPages.currentPage().getParameters().put('templateObjectId', String.valueOf(weProTest.Id));
        APIT09_CreatePDFController  testAccPlan = new APIT09_CreatePDFController();

        //APIT09_CreatePDFController.APIT09_CreatePDFControllerReplace(pdfTemp.Id, 'IT_Welfare_Project__c', weProTest.Id);              


    }
}