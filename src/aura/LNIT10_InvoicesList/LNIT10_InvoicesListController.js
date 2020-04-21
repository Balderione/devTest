({
    init: function (cmp, event, helper){
        var idCase = cmp.get("v.recordId");
        helper.invoicesListSet(cmp);
        var action = cmp.get("c.callCase");
        action.setParams({
            "idCase": idCase
        })
        action.setCallback(this, function (response) {
            var caseRes = response.getReturnValue();    	
			console.log('caseRes:: '+caseRes);
            cmp.set("v.codCli" , caseRes);
        })
        $A.enqueueAction(action); 
    },

    showInvoices: function (cmp, event, helper) {
        var icona = cmp.find('iconRef');
        $A.util.toggleClass(icona, 'rotator');
        cmp.set('v.loaded', false);
        helper.invoicesListSet(cmp);   
    },

    openAllInvoices: function (cmp, event, helper){
        var idCase = cmp.get("v.recordId");
        var codCli = cmp.get("v.codCli");
        console.log('CODCLI:: '+codCli);
        var evt = $A.get("e.force:navigateToComponent");
        console.log('evt'+evt);
        evt.setParams({
            componentDef : "c:LNIT11_ViewAllInvoices",
            componentAttributes : {
                caseID : idCase,
                codCli : codCli,
                dataStart : cmp.get('v.dataStart'),
                dataEnd : cmp.get('v.dataEnd') 
            }     
        });
        evt.fire();
    },
});