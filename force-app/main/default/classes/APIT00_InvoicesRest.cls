public with sharing class APIT00_InvoicesRest extends APIT00_Behaviour{

	public static final String BASE_URL = '/invoices';

	public class ResponseModel{
		@AuraEnabled public MetaModel meta;
		@AuraEnabled public List<InvoiceModel> data = new List<InvoiceModel>();
	}

	public class MetaModel{
		@AuraEnabled public List<MessageModel> messages;
		@AuraEnabled public String status;
	}

	public class MessageModel{
	    @AuraEnabled public String Error;
	}

	public class InvoiceModel{
		@AuraEnabled public String document_number;
		@AuraEnabled public String document_type;
		@AuraEnabled public Date document_date;
		@AuraEnabled public String e_invoice_status;
		@AuraEnabled public String e_invoice_status_description;
		@AuraEnabled public Date expiry_date;
		@AuraEnabled public Decimal amount_due;
		@AuraEnabled public String detailURL;
	}

    public static ResponseModel getInvoices(String clientRef, String clientType, Date dateFrom, Date dateTo, String userProfile, String company){
    	Map<String,String> queryData = new Map<String,String>{
    		'client-ref' 					=> clientRef,
			'client-type' 					=> 'T',
			'date-from' 					=> string.valueOf(dateFrom),
			'date-to' 						=> string.valueOf(dateTo),
			'user-profile' 					=> 'GIWEBCOCLI',
			'company' 						=> '832',
			'temporary-table' 				=> 'EC_' + clientRef,
			'truncate-temporary-table' 		=> String.valueOf(true),
			'search-by-vatcode' 			=> String.valueOf(false),
			'order-by-status' 				=> String.valueOf(false),
			'order-by-date' 				=> String.valueOf(false),
			'is-open-document' 				=> String.valueOf(false),
			'is-balance-programme' 			=> String.valueOf(false),
			'is-document-history' 			=> String.valueOf(true),
			'is-notice' 					=> String.valueOf(false),
			'is-transfert-back' 			=> String.valueOf(false),
			'is-tax-rate' 					=> String.valueOf(false)
    	};

    	return APIT00_InvoicesRest.getInvoices(queryData);
    }

    public static ResponseModel getInvoices(Map<String,String> queryData){
    	DebugStart('APIT00_InvoicesRest', 'getInvoices');
    	Debug('queryData', queryData);

		String endPoint = APIT00_CalloutClient.applyQueryString(APIT00_InvoicesRest.BASE_URL, queryData);
		Debug('endPoint', endPoint);

		HttpRequest request = APER06_WebserviceUtility.getHttpRequest(
			endPoint,
			'GET',
			null,
			null
		);

		request.setHeader('Content-Type', 'application/java');

		Http calloutHttp = new Http();
		HttpResponse response = calloutHttp.send(request);

		String responseBody = response.getbody();
		Debug('responseBody', responseBody);
		
		ResponseModel responseObject = (ResponseModel)JSON.deserialize(responseBody, ResponseModel.class);

		for(InvoiceModel singlerequest : responseObject.data){
		    singlerequest.detailURL = 'http://eit-kiwi-p.edenred.net/GetDoc/getdoc?APPID=C&KEY1=832&KEY2='+singlerequest.document_number+'&KEY3='+string.valueof(singlerequest.document_date).split('-')[0];
		}

		DebugEnd();
	    return responseObject;
    }
}