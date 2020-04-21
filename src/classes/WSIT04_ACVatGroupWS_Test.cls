@istest
public class WSIT04_ACVatGroupWS_Test {
    @isTest static void testUpsertVatGroupError() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri =
            '/services/apexrest/ac_account/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ "IT_VatGroup":[{ "IT_VAT_Number_Group":"02554698475", "IT_VAT_Group_Naming":"StringString", "IT_VAT_Group_PEC":"test.test@test.test.it", "IT_VAT_Group_SDI":"TestSDI", "IT_AC_User":"StringString", "IT_START_Date":"2019-01-01", "IT_END_Date":"2019-01-01", "IT_Account":[{ "ER_VAT_Number":"02554698475", "IT_Institution":false, "IT_Private_work_for_institution":true, "IT_Foreign_VAT_Number":true, "IT_Fiscal_Code":"StringString", "ER_Legal_Name":"StringString", "IT_Legal_Form":"ASS", "ER_Segment":"A", "IT_Industry":"101M", "NumberOfEmployees":32, "Website":"StringString", "IT_Company_Type":"Private", "IT_Split_Payment":true, "IT_VAT_Group":"02554698475", "IT_Invoice_Naming":"StringString", "IT_Province":"MI", "IT_Toponym":"StringString", "IT_Street":"Via Rossi", "IT_Short_Address":"StringString", "IT_Street_Number":"52", "IT_Postal_Code":"20123", "IT_City":"Milano", "IT_Hamlet":"StringString", "IT_Additional_Locality":"StringString", "IT_City_Code":"001", "IT_Hamlet_Code":"002", "IT_Sestiere_Code":"003", "IT_Street_Code":"008", "IT_Road_Arch_Code":"006", "IT_MetRef_Loc_X":"StringString", "IT_MetRef_Loc_Y":"StringString", "IT_GeoRef_Loc_X":"43", "IT_GeoRef_Loc_Y":"43", "IT_Extra_Urban_Specifications":"StringString", "IT_AC_User":"StringString", "IT_Validity_Start_Date":"2019-01-01", "IT_Validity_End_Date":"2019-01-01", "IT_Intent_Declaration":[{ "IT_Fiscal_Code":"StringString", "IT_Validity_Year":"test", "IT_Progressive":"00005", "IT_Declaration_Number":"StringString", "IT_Type":"StringString", "IT_Presentation_Date":"2019-01-01", "IT_Exporter_Type":"B", "IT_Operation_Type":"1", "IT_Declared_Amount":10.23, "IT_AC_User":"StringString", "IT_Validity_Start_Date":"2019-01-01", "IT_Validity_End_Date":"2019-01-01"}] }] }] }  ');
        RestContext.request = request;
        RestContext.response= res;
        WSIT04_ACVatGroupWS.AnagraficaClientiUpsert();  
    }
    @isTest static void testUpsertVatGroup() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri =
            '/services/apexrest/ac_account/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ "IT_VatGroup":[{ "IT_VAT_Number_Group":"02554698475", "IT_VAT_Group_Naming":"StringString", "IT_VAT_Group_PEC":"test.test@test.test.it", "IT_VAT_Group_SDI":"TestSDI", "IT_AC_User":"StringString", "IT_START_Date":"2019-01-01", "IT_END_Date":"2019-01-01", "IT_Account":[{ "ER_VAT_Number":"02554698475", "IT_Institution":false, "IT_Private_work_for_institution":true, "IT_Foreign_VAT_Number":true, "IT_Fiscal_Code":"StringString", "ER_Legal_Name":"StringString", "IT_Legal_Form":"ASS", "ER_Segment":"A", "IT_Industry":"101", "NumberOfEmployees":32, "Website":"StringString", "IT_Company_Type":"Private", "IT_Split_Payment":true, "IT_VAT_Group":"02554698475", "IT_Invoice_Naming":"StringString", "IT_Province":"MI", "IT_Toponym":"StringString", "IT_Street":"Via Rossi", "IT_Short_Address":"StringString", "IT_Street_Number":"52", "IT_Postal_Code":"20123", "IT_City":"Milano", "IT_Hamlet":"StringString", "IT_Additional_Locality":"StringString", "IT_City_Code":"001", "IT_Hamlet_Code":"002", "IT_Sestiere_Code":"003", "IT_Street_Code":"008", "IT_Road_Arch_Code":"006", "IT_MetRef_Loc_X":"StringString", "IT_MetRef_Loc_Y":"StringString", "IT_GeoRef_Loc_X":"43", "IT_GeoRef_Loc_Y":"43", "IT_Extra_Urban_Specifications":"StringString", "IT_AC_User":"StringString", "IT_Validity_Start_Date":"2019-01-01", "IT_Validity_End_Date":"2019-01-01", "IT_Intent_Declaration":[{ "IT_Fiscal_Code":"StringString", "IT_Validity_Year":"test", "IT_Progressive":"00005", "IT_Declaration_Number":"StringString", "IT_Type":"StringString", "IT_Presentation_Date":"2019-01-01", "IT_Exporter_Type":"B", "IT_Operation_Type":"1", "IT_Declared_Amount":10.23, "IT_AC_User":"StringString", "IT_Validity_Start_Date":"2019-01-01", "IT_Validity_End_Date":"2019-01-01"}] }] }] }');
        RestContext.request = request;
        RestContext.response= res;
        WSIT04_ACVatGroupWS.AnagraficaClientiUpsert();  
    }
    @isTest static void testUpsertVatGroupErrorRequiredField() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri =
            '/services/apexrest/ac_account/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('  { "IT_VatGroup":[{ "IT_VAT_Number_Group":"02554698475", "IT_VAT_Group_Naming":"StringString", "IT_VAT_Group_PEC":"test.test@test.test.it", "IT_VAT_Group_SDI":"TestSDI", "IT_AC_User":"StringString", "IT_START_Date":"2019-01-01", "IT_END_Date":"2019-01-01", "IT_Account":[{ "ER_VAT_Number":"", "IT_Institution":false, "IT_Private_work_for_institution":true, "IT_Foreign_VAT_Number":true, "IT_Fiscal_Code":"", "ER_Legal_Name":"", "IT_Legal_Form":"ASS", "ER_Segment":"A+", "IT_Industry":"101", "NumberOfEmployees":32, "Website":"StringString", "IT_Company_Type":"Private", "IT_Split_Payment":true, "IT_VAT_Group":"02554698475", "IT_Invoice_Naming":"StringString", "IT_Province":"MI", "IT_Toponym":"StringString", "IT_Street":"Via Rossi", "IT_Short_Address":"StringString", "IT_Street_Number":"52", "IT_Postal_Code":"20123", "IT_City":"Milano", "IT_Hamlet":"StringString", "IT_Additional_Locality":"StringString", "IT_City_Code":"001", "IT_Hamlet_Code":"002", "IT_Sestiere_Code":"003", "IT_Street_Code":"008", "IT_Road_Arch_Code":"006", "IT_MetRef_Loc_X":"StringString", "IT_MetRef_Loc_Y":"StringString", "IT_GeoRef_Loc_X":"43", "IT_GeoRef_Loc_Y":"43", "IT_Extra_Urban_Specifications":"StringString", "IT_AC_User":"StringString", "IT_Validity_Start_Date":null, "IT_Validity_End_Date":null, "IT_Intent_Declaration":[{ "IT_Fiscal_Code":"StringString", "IT_Validity_Year":"test", "IT_Progressive":"00005", "IT_Declaration_Number":"StringString", "IT_Type":"StringString", "IT_Presentation_Date":"2019-01-01", "IT_Exporter_Type":"B", "IT_Operation_Type":"1", "IT_Declared_Amount":10.23, "IT_AC_User":"StringString", "IT_Validity_Start_Date":"2019-01-01", "IT_Validity_End_Date":"2019-01-01" }] }] }] }');
        RestContext.request = request;
        RestContext.response= res;
        WSIT04_ACVatGroupWS.AnagraficaClientiUpsert();  
    }
}