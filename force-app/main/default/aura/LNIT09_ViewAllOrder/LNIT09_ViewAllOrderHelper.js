({
	callCaseField : function(cmp, caseIdHelper) {
		var action = cmp.get("c.callCase");
        action.setParams({
            "idCase": caseIdHelper
        })
        action.setCallback(this, function (response) {
            var caseRes = response.getReturnValue();    	
			console.log('caseRes:: '+JSON.stringify(caseRes));
            cmp.set('v.caseContestualize', caseRes);
            cmp.set('v.columns', [
                {label: 'Order Ref', fieldName: 'detailURL', type: 'url' , typeAttributes: {label: { fieldName: 'order_ref' }, target: '_self'}},
                {label: 'Delivery Date', fieldName: 'delivery_date', type: 'date'},
                {label: 'Order Type', fieldName: 'order_type', type: 'text'},
                {label: 'Order Amount', fieldName: 'order_amount', type: 'number'},
                {label: 'Payment Description', fieldName: 'payment_description', type: 'text'},
                
                /*{label: 'Application', fieldName: 'application', type: 'text'},
                {label: 'Codice Circuito', fieldName: 'circuit_code', type: 'text'},
                {label: 'Company Ref', fieldName: 'company_ref', type: 'number'},
                {label: 'Client Ref', fieldName: 'client_ref', type: 'text'},
                {label: 'Order Year', fieldName: 'order_year', type: 'text'},
                {label: 'Upload Date', fieldName: 'upload_date', type: 'date'},
                {label: 'Dervice Description', fieldName: 'service_description', type: 'text'},
                {label: 'Channel Description', fieldName: 'channel_description', type: 'text'}, 
                {label: 'Voucher Number', fieldName: 'voucher_number', type: 'Integer'},
                {label: 'Order Status Description', fieldName: 'order_status_description', type: 'text'},
                {label: 'Customized', fieldName: 'customized', type: 'text'},
                {label: 'Modificabile', fieldName: 'is_modifiable', type: 'checkbox'},*/      
            ]);
        });
        $A.enqueueAction(action);  	
    }
})