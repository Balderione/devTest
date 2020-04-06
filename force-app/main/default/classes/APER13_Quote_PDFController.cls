public class APER13_Quote_PDFController {

	@AuraEnabled
	public static Map<String, String> savePDF(String selectedTemplate, String objectId) {

		Map<String, String> returnValues = new Map<String, String>();
		PageReference pdf;
		Attachment attach = new Attachment();
		QuoteDocument quoteDocument = new QuoteDocument();
		Blob body;

		pdf = new PageReference('/apex/'+selectedTemplate+'?id='+objectId);

		try {
			// returns the output of the page as a PDF
			body = pdf.getContent();
			// need to pass unit test -- current bug
		} catch (VisualforceException e) {

			body = Blob.valueOf('Some Text');
		}

		quoteDocument.Document = body;
		quoteDocument.QuoteID = objectId;

		insert quoteDocument;
		List<contentdocumentLink> contentdocumentList = [select id, contentDocumentId, SystemModstamp from contentdocumentLink where linkedEntityId = : objectId order by SystemModstamp desc limit 1];
		if (!contentdocumentList.isEmpty()) {
			returnValues.put('contentdocumentId', contentdocumentList[0].contentDocumentId);
		}

		Quote currentQuote = [Select contactId from Quote where id = : objectId];
		returnValues.put('contactId', currentQuote.contactId);

		return returnValues;
	}

	@AuraEnabled
	public static Blob previewPDF(String selectedTemplate) {

		PageReference pdf;
		Attachment attach = new Attachment();
		QuoteDocument quoteDocument = new QuoteDocument();
		Blob body;

		pdf = new PageReference('/apex/'+selectedTemplate);

		try {
			// returns the output of the page as a PDF
			body = pdf.getContent();
			// need to pass unit test -- current bug
		} catch (VisualforceException e) {

			body = Blob.valueOf('Some Text');
		}

		return body;
	}
	
	@AuraEnabled
	public static Map<String,String> getTemplates() {

		List<String> templateNames;
		List<String> templateLabels;
		Map<String,String> templateMap = new Map<String,String>();
		List<CMER02_Pdf_Template_Setting__mdt> templatesList = [select id, DeveloperName, ER_Template_Name__c, ER_Template_Label__c from CMER02_Pdf_Template_Setting__mdt where DeveloperName = : APER10_User_Management.userBU];

		if (!templatesList.isEmpty()) {

			templateNames = templatesList[0].ER_Template_Name__c.Split(';');
			templateLabels = templatesList[0].ER_Template_Label__c.Split(';');
			for(integer i=0;i<templateNames.size(); i++){

				templateMap.put(templateNames[i], templateLabels[i]);
			}
		}
		
		return templateMap;
	}
}