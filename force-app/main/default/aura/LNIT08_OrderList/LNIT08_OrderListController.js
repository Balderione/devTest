({
    init: function (cmp, event, helper){
        var idCase = cmp.get("v.recordId");
        helper.callCaseField(cmp, idCase);
        
    },

    openAllOrders: function (cmp, event, helper){
        var listOrders = cmp.get("v.dataComplete");
        var listHeaders = cmp.get("v.columns");
        var listSizeJS = cmp.get("v.listSize");
        var idCase = cmp.get("v.recordId");
        var productSet = cmp.get("v.productListName");
        var dataStart = cmp.get("v.dataStart");
        var dataEnd = cmp.get("v.dataEnd");
        var evt = $A.get("e.force:navigateToComponent");
        console.log('evt'+evt);
        evt.setParams({
            componentDef : "c:LNIT09_ViewAllOrder",
            componentAttributes : {
                data : listOrders,
                listSize : listSizeJS,
                caseID : idCase,
                productListName : productSet,
                dataStart : dataStart,
                dataEnd : dataEnd,

            }    
        });
        evt.fire();
    },
    
    showOrders: function (cmp, event, helper) {
        var icona = cmp.find('iconRef');
        $A.util.toggleClass(icona, 'rotator');
        cmp.set('v.productListName', null);
        cmp.set('v.loaded', false);
        helper.orderListSet(cmp, false);   
    },
    
    filterOrders: function (cmp, event, helper) {
        //var codServizio = cmp.get('v.CodServizio');
        var codServizio = cmp.find("levels").get("v.value");
        var fullData = cmp.get('v.fullData');
        console.log('SERVIZIO SELEZIONATO:: '+codServizio);  
        if(codServizio != false ){
            var returnData = [];
            fullData.forEach(function(singleData) {
                if(singleData.service_description == codServizio){
                    returnData.add(singleData);
                }
            });
            cmp.set('v.data' , returnData.slice(0,5));
        }
        
        else{
            cmp.set('v.data' , fullData.slice(0,5));
        }
    }
});