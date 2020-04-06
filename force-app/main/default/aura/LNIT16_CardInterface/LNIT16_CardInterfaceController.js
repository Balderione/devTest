({
    
    init: function (component, event, helper) {
        var recordId = component.get('v.recordId');
        var action = component.get('c.fetchDPData');
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseDP = response.getReturnValue();
                var singleDP = JSON.parse(responseDP);
                console.log('JSON:: '+responseDP );
                
                component.set('v.showTicketNaming',singleDP.IT_Naming_to_Display__c);
                component.set('v.showAddress',singleDP.IT_Address_to_Display__c);
                component.set('v.showLocality',singleDP.IT_Locality_to_Display__c);
                if(singleDP.IT_Locality_to_Display__c && singleDP.IT_Data_to_Display__c != null){
                    component.set('v.freeLocality',true);
                }
                component.set('v.accountName',singleDP.IT_Financial_Center__r.ER_Account_Name__r.Name);
                component.set('v.ticketNaming',singleDP.IT_Financial_Center__r.IT_Short_Name__c);
                component.set('v.locality',singleDP.IT_Data_Type_To_Display_4__c);
                component.set('v.inputLocality',singleDP.IT_Data_To_Display_4__c);
                
                component.set('v.fixedCity',singleDP.ER_City__c);
                component.set('v.fixedStreet',singleDP.ER_Street__c);
                component.set('v.fixedName',singleDP.IT_Ticket_Naming__c);
                
                component.set('v.fullAddress',singleDP.IT_Data_Type_To_Display_3__c);
                component.set('v.inputAddress',singleDP.IT_Data_To_Display_3__c);
                if(singleDP.IT_Validity_Start_Date__c != null && singleDP.IT_Validity_Start_Date__c != undefined){
                    component.set('v.validityStartDateOLD',singleDP.IT_Validity_Start_Date__c);
                    component.set('v.validityStartDate',singleDP.IT_Validity_Start_Date__c);
                }
                else{
                    component.set('v.validityStartDateOLD',new Date());
                    component.set('v.validityStartDate',new Date());
                }
                
                
                /*if(!singleDP.IT_Financial_Center__r.IT_Single_Client_Multiactivity__c){
                    component.set('v.singleClient' , true);
                    component.set('v.showTicketNaming',true);
                    component.set('v.showAddress',true);
                    component.set('v.showLocality',true);
                }*/
                if(singleDP.IT_Data_To_Display_4__c != null && singleDP.IT_Data_To_Display_4__c != undefined){
                    component.set('v.freeLocality',true);
                }
                if(singleDP.IT_Data_To_Display_3__c != null && singleDP.IT_Data_To_Display_3__c != undefined){
                    component.set('v.freeAddress',true);
                }
            }
            var action2 = component.get('c.fetchDataType');
            action2.setParams({
                "recordId": recordId,
                "service" : singleDP.IT_Service__c
            });
            action2.setCallback(this, function(response2) {
                if (response2.getState() == "SUCCESS") {
                    var responseData = response2.getReturnValue();
                    var dataTypes = JSON.parse(responseData);
                    console.log('CONTROLS:: '+responseData );
                    var row3 = [];
                    var row4 = [];
                    dataTypes.forEach(function(element) {
                        if(element.IT_CLN_Line_number__c == '3'){
                            row3.push({'key' : element.IT_CLN_Ticket_exposure_type__c , 'value' : element.IT_CLN_Ticket_exposure_Code__c});
                        }
                        else{
                            row4.push({'key' : element.IT_CLN_Ticket_exposure_type__c , 'value' : element.IT_CLN_Ticket_exposure_Code__c});
                        }
                        //row4.push({'key' : element.IT_CLN_Ticket_exposure_type__c , 'value' : element.IT_CLN_Ticket_exposure_Code__c});
                    });
                    component.set('v.addressList' , row3);
                    if(!(row3.length > 0)){
                        component.set('v.freeAddress' ,true);
                    }
                    component.set('v.localityList' , row4);
                    if(!(row4.length > 0)){
                        component.set('v.freeLocality' ,true);
                    }
                }
                
            });
            $A.enqueueAction(action2);
            
        });
        $A.enqueueAction(action);
    },
    
    addressDeFlag : function(component, event, helper) {
        //component.set('v.freeAddress',true);
    },
    localityDeFlag : function(component, event, helper) {
        //component.set('v.freeLocality',true);
    },
    
    handleSave : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var objName = component.get("v.sObjectName");
        var sObj = {'sobjectType':objName,'Id':recordId};
        var workspaceAPI = component.find("workspaceAPI");
        sObj.IT_Naming_to_Display__c = component.get('v.showTicketNaming');
        sObj.IT_Address_to_Display__c = component.get('v.showAddress');
        sObj.IT_Locality_to_Display__c = component.get('v.showLocality');
        if(component.get('v.validityStartDate') != component.get('v.validityStartDateOLD')){
            sObj.IT_Validity_Start_Date__c = component.get('v.validityStartDate');
        }
        else{
            sObj.IT_Validity_Start_Date__c = new Date();
        }
        
        var validated = true;
        if(component.get('v.freeAddress')){
            sObj.IT_Data_To_Display_3__c = component.get('v.inputAddress');
            sObj.IT_Data_Type_To_Display_3__c = null;
            
        }
        else{
            if(component.get('v.fullAddress') != null && component.get('v.fullAddress') != undefined){
                sObj.IT_Data_Type_To_Display_3__c = component.get('v.fullAddress');
                sObj.IT_Data_To_Display_3__c = null;
            }
            else{
                sObj.IT_Data_To_Display_3__c = component.get('v.inputAddress');
                sObj.IT_Data_Type_To_Display_3__c = null;
            }
            
        }
        if(component.get('v.freeLocality')){
            sObj.IT_Data_To_Display_4__c = component.get('v.inputLocality');
            sObj.IT_Data_Type_To_Display_4__c = null;
        }
        else{
            if(component.get('v.locality') != null && component.get('v.locality') != undefined){
                sObj.IT_Data_Type_To_Display_4__c = component.get('v.locality');
                sObj.IT_Data_To_Display_4__c = null;
            }
            else{
                sObj.IT_Data_To_Display_4__c = component.get('v.inputLocality');
                sObj.IT_Data_Type_To_Display_4__c = null;
            }
        }
        if(component.get('v.showTicketNaming')){
            sObj.IT_Data_To_Display_2__c = component.get('v.ticketNaming');
        }
	    var action = component.get("c.updateRecord");
            action.setParams({
                "distPoint" : sObj
            })
            action.setCallback(this, function (response) {
                if (response.getState() == "SUCCESS") {
                    console.log('SUCCESS');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Successo!",
                        "message": "Valori salvati correttamente."
                    });
                    toastEvent.fire();
                    workspaceAPI.getFocusedTabInfo().then(function (response) {
                        var focusedTabId = response.tabId;
                        console.log('focusedTabId'+focusedTabId);
                        workspaceAPI.refreshTab({
                            tabId: focusedTabId,
                            includeAllSubtabs: false
                        });
                    });
                }
                else{
                    
                    var errors = response.getError();
                    console.log(JSON.stringify(errors));
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Errore!",
                        "message": "Si è verificato il seguente errore: " + errors[0].pageErrors[0].message
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);

    },
    returnToGeneric : function(component, event, helper) {
        if(component.get('v.returnGeneric')){
            component.set('v.showTicketNaming',true);
            component.set('v.showAddress',true);
            component.set('v.showLocality',true);
            component.set('v.returnGeneric',false);
        }
    },
    
})