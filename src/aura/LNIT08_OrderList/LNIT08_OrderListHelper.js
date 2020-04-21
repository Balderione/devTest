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
            if(caseRes.IT_Financial_Center__r != null){
                cmp.set("v.codCli" , caseRes.IT_Financial_Center__r.IT_Financial_Center__c);
            }
            
            this.orderListSet(cmp, false);
        })
        $A.enqueueAction(action);  	
    },
    
    orderListSet : function(cmp, filterAll) {
        var startDate = cmp.get("v.dataStart");
        var endDate = cmp.get("v.dataEnd");
        var stausOrder = cmp.get("v.orderStatus");
        var typeProdOrder = cmp.get("v.orderType");
        var codServ = cmp.get("v.CodServizio");
        var cintenstCase = cmp.get("v.caseContestualize");
        var codCli = cmp.get("v.codCli");
        var piva = null;
        var CodCir = null;
        console.log('piva:: '+piva);

        if(cintenstCase.IT_Financial_Center__c != null)
            codCli = cintenstCase.IT_Financial_Center__r.IT_Financial_Center__c;   
        if(cintenstCase.Account != null)
            piva = cintenstCase.Account.ER_VAT_Number__c;
        if(cintenstCase.IT_Circuit__c != null)    
            CodCir = cintenstCase.IT_Circuit__r.Name;
        console.log('codCli:: '+codCli);
            cmp.set('v.columns', [

                {label: 'Order Ref', fieldName: 'detailURL', type: 'url' , typeAttributes: {label: { fieldName: 'order_ref' }, target: '_self'}},
                {label: 'Delivery Date', fieldName: 'delivery_date', type: 'date'},
                {label: 'Order Type', fieldName: 'order_type', type: 'text'},
                {label: 'Totale Ordine', fieldName: 'order_amount', type: 'number'},
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

        var arrayOrder = [];
        var uri = encodeURIComponent("https://salesforce.it.dev.edenred.io/v1/orders?date-from=2019-06-20&date-to=2019-06-20").toLowerCase();
		console.log('uri '+uri);
		var today = new Date().toISOString();
		console.log('TODAY '+today);
		var requester = 'http://someHost.com';
		var rawHmac = uri + '#' + requester + '#' + today;
		console.log('RAWHMAC '+rawHmac);
		
        var action = cmp.get('c.listOrder');
        action.setParams({
            "dataDa": startDate,
            "dataA": endDate,
            "codeCirc": CodCir,
            "codeCli": codCli,
            "piva": piva,
            "codeServizio": codServ,
            "AllFilter": filterAll,
            "rawHmac": rawHmac,
            "idCase" : cmp.get("v.recordId")
            
        })
        action.setCallback(this, function(response) {
            
            if (response.getState() == "SUCCESS") {
                cmp.set('v.loaded', true);
                console.log('orderListFirst::' + JSON.stringify(response));

                var orderList = response.getReturnValue();
                if (orderList != null && orderList != '') {
                    console.log('orderList::' + JSON.stringify(orderList));
                    console.log('filterAll::' + filterAll);
                    if(filterAll === false){
                        cmp.set('v.dataComplete', orderList);
                        cmp.set('v.listSize', orderList.length);
                    }    
                    cmp.set('v.fullData', orderList);
                    cmp.set('v.data', orderList.slice(0,5));

                    console.log('orderList.length::' + orderList.length); 
                    let indexes = new Set();
                    orderList.forEach(orderResp => indexes.add(orderResp.service_description));
                    console.log('indexes list', indexes.size);
                    let array = Array.from(indexes);
                    array.push('');
                    cmp.set('v.productListName', array);

                }else{
                    cmp.set('v.data', null);
                    
                }
            }
            else{
                cmp.set('v.loaded', true);
            }
        });
        $A.enqueueAction(action);
    }   
})