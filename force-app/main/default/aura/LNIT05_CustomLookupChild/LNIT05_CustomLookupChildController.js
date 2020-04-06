({ 
    doinit : function(component, event, helper) {
        console.log("In Child lookup Init");
        var icon = component.get("v.icon");
        var sObject = component.get("v.object");
        
        console.log("icon:: "+icon);
        console.log("Object:: "+sObject);
    },
    
    onOptionClick : function(component, event, helper) {
        var sObject = component.get("v.object");
        if(sObject == "Account"){
            console.log("In child init");
                var selVal  = component.get("v.myContact");
                console.log(selVal);
                
                var evt = component.getEvent("LEVIT02_LookupEventToParent");
                evt.setParams({
                    selectedItem : selVal
                });
                evt.fire();
        }
        else if(sObject == "ER_Financial_Center__c"){
            console.log("In child init");
                var selVal  = component.get("v.FinCenter");
                console.log(selVal);
                
                var evt = component.getEvent("LEVIT02_LookupEventToParent");
                evt.setParams({
                    FinCenter : selVal
                });
                evt.fire();
        }
        else if(sObject == "IT_Circuit__c"){
            console.log("In child init");
                var selVal  = component.get("v.Circuit");
                console.log(selVal);
                
                var evt = component.getEvent("LEVIT02_LookupEventToParent");
                evt.setParams({
                    Circuit : selVal
                });
                evt.fire();
        }
    }
})