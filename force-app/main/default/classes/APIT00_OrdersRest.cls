public with sharing class APIT00_OrdersRest extends APIT00_Behaviour{

	public static final String BASE_URL = '/orders';

	public class ResponseModel{
		@AuraEnabled public MetaModel meta;
		@AuraEnabled public List<OrderModel> data = new List<OrderModel>();
	}

	public class MetaModel{
		@AuraEnabled public List<MessageModel> messages;
		@AuraEnabled public String status;
	}

	public class MessageModel{
	    @AuraEnabled public String code;
	    @AuraEnabled public String level;
	    @AuraEnabled public String text;
	}

	public class OrderModel{
		@AuraEnabled public String application;
		@AuraEnabled public String circuit_code;
		@AuraEnabled public String company_ref;
		@AuraEnabled public String client_ref;
		@AuraEnabled public String order_year;
		@AuraEnabled public String order_ref;
		@AuraEnabled public Date upload_date;
		@AuraEnabled public Date delivery_date;
		@AuraEnabled public String service_description;
		@AuraEnabled public String channel_description;
		@AuraEnabled public String order_type;
		@AuraEnabled public Decimal order_amount;
		@AuraEnabled public Integer voucher_number;
		@AuraEnabled public String payment_description;
		@AuraEnabled public String order_status_description;
		@AuraEnabled public String customized;
		@AuraEnabled public Boolean is_modifiable;
		@AuraEnabled public String detailURL;
	}

	public static ResponseModel getOrders(String clientRef, String circuitCode, String vatCode, Date startDate, Date endDate){
		String startDateString = String.valueOf(startDate);
		String endDateString = String.valueOf(endDate);

		Map<String,String> queryData = new Map<String,String>{
			'applicant-id' => 'SF',
			'date-from' => startDateString,
			'date-to' => endDateString
		};

		if(String.isNotBlank(clientRef)) queryData.put('client-ref', clientRef);
		if(String.isNotBlank(circuitCode)) queryData.put('circuit-code', circuitCode);
		if(String.isNotBlank(vatCode)) queryData.put('vat-code', vatCode);

		return APIT00_OrdersRest.getOrders(queryData);
	}

	public static ResponseModel getOrders(Map<String,String> queryData){
		DebugStart('APIT00_OrdersRest', 'orders');
		Debug('queryData', queryData);

		String endPoint = APIT00_CalloutClient.applyQueryString(APIT00_OrdersRest.BASE_URL, queryData);
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
		
		APIT00_OrdersRest.applyModel(responseObject);

		DebugEnd();
	    return responseObject;
	}

	public static void applyModel(ResponseModel responseObject){
		DebugStart('APIT00_OrdersRest', 'applyModel');

		if(responseObject.data == null) {
			DebugEnd();
			return;
		}

		for(OrderModel order : responseObject.data){
			Map<String, String> params = new Map<String,String>();
			params.put('para_funzione', 'VisOrdineTestata');

			if(order.client_ref != null){
			    params.put('para_codice_cliente', order.client_ref);
			}
			if(order.company_ref != null){
			    params.put('para_codice_societa', order.company_ref);
			}
			if(order.order_year != null){
			    params.put('para_anno_ordine', order.order_year);
			}
			if(order.order_ref != null){
			    params.put('para_codice_ordine', order.order_ref);
			}
			if(order.circuit_code != null){
			    params.put('para_codice_circuito', order.circuit_code); 
			}

			String queryString = APIT00_CalloutClient.applyQueryString('', params);
			Debug('queryString', queryString);

			Map<String,String> detailUrlParams = new Map<String,String>();
			detailUrlParams.put('c__calledSystem', order.application);
			detailUrlParams.put('c__isIframe', 'false');
			detailUrlParams.put('c__queryString', EncodingUtil.urlEncode(queryString, 'UTF-8'));

			String baseURL = '/lightning/cmp/c__LNIT00_iframeOpener';
			String detailUrl = APIT00_CalloutClient.applyQueryString(baseURL, detailUrlParams);
			Debug('detailUrl', detailUrl);

			order.detailURL = detailURL;
		}

		DebugEnd();
	}

}