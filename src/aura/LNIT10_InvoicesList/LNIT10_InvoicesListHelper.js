({
	invoicesListSet : function(cmp) {
        var startDate = cmp.get("v.dataStart");
        var endDate = cmp.get("v.dataEnd");
        var socCode = cmp.get("v.CodSociety");
        var idCase = cmp.get("v.recordId");
        
        cmp.set('v.columns', [

            {label: 'N° Doc', fieldName: 'document_number', type: 'text'},
            {label: 'Tipo Doc', fieldName: 'document_type', type: 'text'},
            {label: 'Stato', fieldName: 'e_invoice_status', type: 'text'},
            {label: 'Data Doc', fieldName: 'document_date', type: 'date'},
            {label: 'Data Scadenza', fieldName: 'expiry_date', type: 'date'},
            {label: 'Importo', fieldName: 'amount_due', type: 'number'},
            {label: 'PDF', fieldName: 'detailURL', type: 'url' , typeAttributes: {label: 'PDF', target: '_blank'}},

        ]);

        var arrayOrder = [];
        var uri = encodeURIComponent("https://salesforce.it.dev.edenred.io/v1/statements").toLowerCase();
		console.log('uri '+uri);
		var today = new Date().toISOString();
		console.log('TODAY '+today);
		var requester = 'http://someHost.com';
		var rawHmac = uri + '#' + requester + '#' + today;
		console.log('RAWHMAC '+rawHmac);
        var codCli = cmp.get("v.codCli");
        var action = cmp.get('c.listInvoices');
        action.setParams({
            "dataDa": startDate,
            "dataA": endDate,
            "caseId": idCase,
            "codCli" : codCli
            
        })
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                cmp.set('v.loaded', true);
                console.log('orderListFirst::' + JSON.stringify(response.getReturnValue()));

                var invoicesList = response.getReturnValue();
                if (invoicesList != null && invoicesList != '') {

                    //var res = str.replace("Microsoft", "W3Schools");

                    cmp.set('v.listSize', invoicesList.length);  
                    cmp.set('v.data', invoicesList.slice(0,5));
                    
                    console.log('invoicesList.length::' + invoicesList.length);
                    
                    var today = new Date();
                    var impTot = 0;
                    var i = 0;
                    //var impScaduto = 15266.36;
                    var impScaduto = 0;

                    for (i = 0; i < invoicesList.length; i++) { 
                        impTot = impTot + invoicesList[i].amount_due;
                        var myDate = new Date(invoicesList[i].expiry_date);
                        if(today > myDate ){
                            impScaduto = impScaduto +  invoicesList[i].amount_due;   
                        }
                    }
                    
                   
                    
                    console.log('impTot:: '+impTot.toFixed(2));
                    //cmp.set('v.importTotal',impTot.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, "."));
                    cmp.set('v.importTotal',impTot.toLocaleString('it-IT', {maximumFractionDigits: 2, minimumFractionDigits: 2}));
                    cmp.set('v.scaduto',impScaduto.toLocaleString('it-IT', {maximumFractionDigits: 2, minimumFractionDigits: 2}));

                    let indexes = new Set();
                    invoicesList.forEach(orderResp => indexes.add(orderResp.descrServizio));
                    console.log('indexes list', indexes.size);
                    let array = Array.from(indexes);
                    cmp.set('v.societyListName', array);
                    console.log(array[0].totimportoRes);

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