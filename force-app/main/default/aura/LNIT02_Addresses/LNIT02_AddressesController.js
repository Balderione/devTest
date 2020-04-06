({

    init: function (component, event, helper) {
       //INIT TO CALL STRADARIO GET PROVINCES
        console.log('IN' + component.get('v.flowRegionRef') + 'FLOW? ' +component.get('v.isFlow'));
        var action = component.get('c.getProvincesStradario');
        action.setCallback(this, function(response) {
           
            if (response.getState() == "SUCCESS") {
                var stage = response.getReturnValue();
                //console.log('RESPONSE '+stage.toString());
                var returnMap = [];
                var response = JSON.parse(stage);
                var provinces = response.data;
                returnMap.push({'key' : '' , 'value' : '--Seleziona una Provincia--' , 'regionRef' : ''});
                provinces.forEach(function(element) {
                    //returnMap.push(element.province_ref , element.name_display);
                    returnMap.push({'key' : element.province_ref , 'value' : element.name_display , 'regionRef' : element.region_ref});  
                });
                component.set('v.provinceMap' , returnMap);
                component.set('v.actualProvince' ,returnMap[1].key );
                console.log('MAPPASETTATA:: ' +returnMap[1].key + 'REGIONE: '+returnMap[1].regionRef);
                //component.set ('v.hmacString' ,stage.toString() );
                //***ADD PREPOPULATION***
                var recordId = component.get("v.recordId");
                var objName = component.get("v.sObjectName");
                if(component.get('v.isFlow')){
                   objName = 'ER_Financial_Center__c';
                }
                var action2 = component.get("c.fetchAddress");
                action2.setParams({
                   "recordId": recordId,
                   "sObjectName": objName
               })
               action2.setCallback(this, function(response2){
                console.log('TRY:: ');
                   if (response2.getState() == "SUCCESS") {
                       if(response2.getReturnValue() != null && response2.getReturnValue() != ''){
                           var record = JSON.parse(response2.getReturnValue());
                           console.log('RECORD ADDRESS:: '+response2.getReturnValue());
                       }
                       console.log('FLOW' + component.get('v.flowProvince'));
                       if(component.get('v.isFlow')){
                           console.log('ENTRATO FLOW BACK');
                           component.set('v.firstProvChange' , false);
                           component.set('v.CAP' , component.get('v.flowCAP'));
                           var hamletMap = [];
                           hamletMap.push({ 'key' : component.get('v.flowHamletCode'), 'value' : component.get('v.flowHamlet')});
                           hamletMap.push('');
                           component.set('v.hamletMap' , hamletMap);
                           component.set('v.toponym' , component.get('v.flowToponym'));
                           component.set('v.Civico' , component.get('v.flowStreet').split(', ')[1]);
                           component.set('v.streetWrap' , component.get('v.flowStreetCode') + '§' + component.get('v.flowStreet').split(', ')[0] + '§' + component.get('v.flowToponym'));
                           component.set('v.streetInput' , component.get('v.flowStreet').split(', ')[0]);
                           component.set('v.cityWrap' , component.get('v.flowCityCode') + '§' + component.get('v.flowCity'));
                           component.set('v.provinceWrap' , component.get('v.flowProvinceCode') + '§' + component.get('v.flowProvince') + '§' + component.get('v.flowRegionRef'));
                           component.set('v.provinceKey' , component.get('v.flowProvinceCode'));
                           component.set('v.regionRef' , component.get('v.flowRegionRef'));
                           component.set('v.cityKey' , component.get('v.flowCityCode'));
                           component.set('v.metRefX' , component.get("v.flowMetRefX"));
                           component.set('v.metRefY' , component.get("v.flowMetRefY"));
                           component.set('v.geoRefX' , component.get("v.flowGeoRefX"));
                           component.set('v.geoRefY' , component.get("v.flowGeoRefY"));
                           component.set('v.LocAgg' , component.get("v.flowLocAgg"));
                           component.set('v.esteroCity' , component.get('v.flowCity'));
                           component.set('v.esteroStreet' , component.get('v.flowStreet').split(', ')[0]);
                           component.find("provinceList").set("v.text", component.get('v.flowProvince'));
                           component.find("provinceList").set("v.value", component.get('v.flowProvinceCode') + '§' + component.get('v.flowProvince') + '§' + component.get('v.flowRegionRef'));
                           component.find('provinceList').focus();
                           provinces.forEach(function(element) {
                               //returnMap.push(element.province_ref , element.name_display);|| element.province_ref == record.IT_State_Code__c
                               if(element.province_ref == component.get('v.flowProvinceCode')){ //Essendo un indirizzo da 0 non ho nè region nè province code.l
                                   component.set('v.regionRef' , element.region_ref);
                                   component.set('v.provinceWrap' , component.get('v.flowProvinceCode') + '§' + component.get('v.flowProvince') + '§' +element.region_ref );
                                   console.log('REGION REF LOOP FOUND: '+element.region_ref + ' - ' + element.province_ref)
                               }
                               /*else if(element.province_ref == record.IT_State_Code__c){
                                       component.set('v.regionRef' , element.region_ref);
                                   }*/
                           });
                       }
                       else{
                           if(objName == 'Account'){
                               
                               component.set('v.regionRef' , record.IT_Region_code__c);
                               component.set('v.CAP' , record.BillingPostalCode);
                               console.log('HAMLETS '+record.IT_Hamlet_Code__c + '§' + record.IT_Hamlet__c);
                               var hamletMap = [];
                               hamletMap.push({'key' : record.IT_Hamlet_Code__c , 'value' : record.IT_Hamlet__c});
                               hamletMap.push('');
                               component.set('v.hamletMap' , hamletMap);
                               component.set('v.toponym' , record.IT_Toponym__c);
                               component.set('v.Civico' , record.BillingStreet.split(', ')[1]);
                               component.set('v.streetWrap' ,  record.IT_Street_Code__c + '§' + record.BillingStreet.split(', ')[0] + '§' + record.IT_Toponym__c);
                               component.set('v.streetInput' , record.BillingStreet.split(', ')[0]);
                               component.set('v.cityWrap' , record.IT_City_Code__c + '§' + record.BillingCity);
                               component.set('v.provinceWrap' , record.IT_State_Code__c + '§' + record.BillingState + '§' +record.IT_Region_code__c);
                               component.set('v.provinceKey' , record.IT_State_Code__c);
                               component.set('v.cityKey' , record.IT_City_Code__c);
                               component.set('v.geoRefX' , record.BillingLongitude);
                               component.set('v.geoRefY' , record.BillingLatitude);
                               component.set('v.metRefX' , record.IT_MetRef_Loc_X__c);
                               component.set('v.metRefY' , record.IT_MetRef_Loc_Y__c);
                               component.set('v.LocAgg' , record.IT_Additional_Locality__c);
                               component.set('v.esteroCity' , record.BillingCity);
                               component.set('v.esteroStreet' , record.BillingStreet.split(', ')[0]);
                               component.find("provinceList").set("v.text", record.BillingState);
                               component.find("provinceList").set("v.value", record.IT_State_Code__c + '§' + record.BillingState + '§' +record.IT_Region_code__c);
                               provinces.forEach(function(element) {
                                   //returnMap.push(element.province_ref , element.name_display);|| element.province_ref == record.IT_State_Code__c
                                   if(element.province_ref == record.IT_State_Code__c){
                                       component.set('v.regionRef' , element.region_ref);
                                       component.set('v.provinceWrap' , record.IT_State_Code__c + '§' + record.BillingState + '§' +element.region_ref );
                                       console.log('REGION REF LOOP FOUND ACCOUNT: '+element.region_ref + ' - ' + element.province_ref);
                                   }
                                   /*else if(element.province_ref == record.IT_State_Code__c){
                                       component.set('v.regionRef' , element.region_ref);
                                   }*/
                               });
                               
                           }
                           else{
                               component.set('v.regionRef' , record.IT_Region_code__c);
                               component.set('v.CAP' , record.ER_Zip_Code__c);
                               component.set('v.toponym' , record.IT_Toponym__c);
                               component.set('v.Civico' , record.ER_Street__c.split(', ')[1]);
                               var hamletMap = [];
                               hamletMap.push({'key' : record.IT_Hamlet_Code__c , 'value' : record.IT_Hamlet__c});
                               hamletMap.push('');
                               component.set('v.hamletMap' , hamletMap);
                               //component.set('v.hamletMap' , record.IT_Hamlet_Code__c + '§' + record.IT_Hamlet__c);
                               component.set('v.streetWrap' ,  record.IT_Street_Code__c + '§' + record.ER_Street__c.split(', ')[0] + '§' + record.IT_Toponym__c);
                               //component.set('v.streetInput' , record.BillingStreet.split(', ')[0]);
                               component.set('v.cityWrap' , record.IT_City_Code__c + '§' + record.ER_City__c);
                               component.set('v.provinceWrap' , record.IT_State_Code__c + '§' + record.IT_Province__c + '§' +record.IT_Region_code__c);
                               component.set('v.metRefX' , record.IT_MetRef_Loc_X__c);
                               component.set('v.metRefY' , record.IT_MetRef_Loc_Y__c);
                               component.set('v.geoRefX' , record.IT_GeoRef_Loc_X__c);
                               component.set('v.geoRefY' , record.IT_GeoRef_Loc_Y__c);
                               component.set('v.esteroCity' , record.ER_City__c);
                               component.set('v.esteroStreet' , record.ER_Street__c.split(', ')[0]);
                               component.find("provinceList").set("v.text", record.IT_Province__c);
                               component.find("provinceList").set("v.value", record.IT_State_Code__c + '§' + record.IT_Province__c + '§' +record.IT_Region_code__c);
                               
                               if(objName == 'ER_Delivery_Site__c'){
                                   component.set('v.LocAgg' , record.ER_Street_additionnal__c);
                               }
                               else{
                                   component.set('v.LocAgg' , record.IT_Additional_Locality__c);
                               }


                           }
                           if(component.get('v.isFlow')){
                               component.find('provinceList').focus();
                               console.log('REGIONCODE: '+component.get('v.provinceWrap'));

                           }
                               var action3 = component.get('c.provinceChangeStradario');
                               $A.enqueueAction(action3);
                       }
                   }
               });
               $A.enqueueAction(action2);
            }
        });
        $A.enqueueAction(action);
        
   },

       provinceChangeStradario: function (component, event, helper) {
           //when a value is selected, apex automatically populates the next picklist
           console.log('WRAPPROVINCESTART:: ' + event);
           var provinceRef = component.get('v.provinceWrap').split('§');
           console.log('PROVINCEREF SIZE:: '+provinceRef.length);
           //component.set('v.regionRef' , provinceRef[2]);
           console.log('WRAPPROVINCE:: '+provinceRef);
           var action = component.get('c.getMunicipalitiesStradario');
           console.log('IN1');
           action.setParams({
               "provinceRef" : provinceRef[0]
           })
           action.setCallback(this, function(response) {
               console.log('IN');
               console.log('PROVINCE CODE: '+provinceRef);
               if (response.getState() == "SUCCESS") {
                   var stage = response.getReturnValue();
                   //console.log('RESPONSE '+stage.toString());
                   var returnMap = [];
                   var responso = JSON.parse(stage);
                   console.log('RESPONSE PARSATA');
                   var provinces = responso.data;
                   provinces.forEach(function(element) {
                       //returnMap.push(element.province_ref , element.name_display);
                       returnMap.push({'key' : element.municipality_ref , 'value' : element.name_display});  
                   });
                   component.set('v.municipalityMap' , returnMap);
                   console.log('MAPPASETTATA:: ' +returnMap[0].key);
                   if(!component.get('v.firstProvChange')){
                       component.set('v.hamletMap' , '');
                       component.set('v.toponym' , '');
                       component.set('v.Civico' , '');
                       component.set('v.CAP' , '');
                       component.set('v.streetWrap' , '');
                       component.set('v.streetInput' , '');
                       component.set('v.metRefX' , '');
                       component.set('v.metRefY' , '');
                       component.set('v.geoRefX' , '');
                       component.set('v.geoRefY' , '');
                       component.set('v.LocAgg' , '');
                       component.set('v.regionRef' , component.get('v.provinceWrap').split('§')[2]);
                       
                   }
                   else if(component.get("v.sObjectName") == 'Account'){
                       component.set('v.regionRef' , component.get('v.provinceWrap').split('§')[2]);
                   }
                   component.set('v.firstProvChange' , false);
                   
                   console.log('REGIONREG '+component.get('v.regionRef'));
                   
                   //component.set ('v.hmacString' ,stage.toString() );
                   //***ADD PREPOPULATION ONCE IT_ADDRESS IS GONE***
               }
               else if(state === 'ERROR'){
                   var errors = resp.getError();
                   for(var i = 0 ;i < errors.length;i++){
                       console.log(errors[i].message);
                   }
               }
           });
           $A.enqueueAction(action);
           
       },
   
   onPicklistChange: function (component, event, helper) {
       //when a value is selected, apex automatically populates the next picklist
       console.log('Entrato per Strade');

       var city = component.get("v.cityWrap").split("§")[0];
       var evntsource = event.getSource();
       var Value = evntsource.get("v.value");
       console.log('VALUEEVENT:: ' + evntsource.get("v.value"));
       //component.set('v.newAddress.IT_City__c', city);
       console.log('VALUESTRADE:: ' + city);
       component.set('v.hamletMap' , '');
       component.set('v.toponym' , '');
       component.set('v.Civico' , '');
       component.set('v.CAP' , '');
       component.set('v.streetWrap' , '');
       component.set('v.streetInput' , '');
       component.set('v.metRefX' , '');
       component.set('v.metRefY' , '');
       component.set('v.geoRefX' , '');
       component.set('v.geoRefY' , '');
       component.set('v.LocAgg' , '');
       /*var action = component.get('c.fetchStreets');
       action.setParams({
           "provincia": city
       })
       action.setCallback(this, function (response) {
           if (response.getState() == "SUCCESS") {
               var listaVie = response.getReturnValue();
               if (listaVie != null && listaVie != '') {
                   component.set("v.listaVie", listaVie);
                   //console.log('VIE PRESE::' + listaVie);
                   component.set('v.hamletMap' , null);
                   component.set('v.toponym' , '');
                   component.set('v.Civico' , '');
                   component.set('v.CAP' , '');
                   component.set('v.streetWrap' , '');
                   component.set('v.streetInput' , '');
                   component.set('v.metRefX' , '');
                   component.set('v.metRefY' , '');
                   component.set('v.geoRefX' , '');
                   component.set('v.geoRefY' , '');
                   component.set('v.LocAgg' , '');
                   
                   //component.set('v.firstStreetChange' , false);
               }
           }
       });
       $A.enqueueAction(action);*/

   },

   streetChange: function (component, event, helper) {
       //when a value is selected, apex automatically populates the next picklist
       console.log('Entrato in streetChange');
       var evntsource = event.getSource();
       var Value = evntsource.get("v.value");
       console.log('Valore:: ' + Value);
       //component.set('v.newAddress.IT_Street__c', Value);
       var action = component.get('c.fetchZipCode');
       action.setParams({
           "street": Value
       })
       action.setCallback(this, function (response) {
           if (response.getState() == "SUCCESS") {
               var CAP = response.getReturnValue();
               if (CAP != null && CAP != '') {
                   component.set("v.CAP", CAP);
                   console.log('CAP PRESO::' + CAP);
               }
           }
       });
       $A.enqueueAction(action);

       var action2 = component.get('c.fetchLocation');
       action2.setParams({
           "street": Value
       })
       action2.setCallback(this, function (response) {
           if (response.getState() == "SUCCESS") {
               var LOC = response.getReturnValue();
               if (LOC != null && LOC != '') {
                   component.set("v.LocAgg", LOC);
               }
           }
       });
       $A.enqueueAction(action2);


   },

   
   getCities: function (component, event, helper) {
       /*if(component.get('v.streetBoolean')){
       component.set('v.streetBoolean',false);
       this.timeoutStreets(component, event, helper);*/
       console.log("GET CITIES");
       var input = component.get('v.streetInput');
       input=input.replace(/(\s+)/g, "+");
       var cityRef = component.get('v.cityWrap').split('§')[0];
       if (input.length > 1) {
           var action = component.get("c.getSuggestions");
           action.setParams({
               "input": input,
               "cityRef": cityRef
           })
           action.setCallback(this, function (response) {
               if (response.getState() == "SUCCESS") {
                   var LOC = response.getReturnValue();
                   var responso = JSON.parse(LOC);
                   console.log('RESPONSE PARSATA' + responso +LOC);
                   var streets = responso.data;
                   var returnMap = [];
                   streets.forEach(function(element) {
                       console.log('ELEMENT:: '+element.name);
                       console.log('ELEMENT:: '+element.street_ref);
                       //returnMap.push(element.province_ref , element.name_display);
                       returnMap.push({'key' : element.street_ref , 'value' : element.name , 'toponym' : element.standard_dug});  
                   });
                   component.set('v.predictions' , returnMap);
               }
           });
           $A.enqueueAction(action);
       } else {
           component.set('v.predictions', null);
       }
       

   },

   //hidePredictions: function (component, event, helper) {component.set('v.predictions', null);},


   getCityDetails: function (component, event, helper) {
       console.log("SELECTED CITY");
       var selectedItem = event.currentTarget;
       var placeid = selectedItem.dataset.placeid;
       component.set('v.streetWrap', placeid);
       component.set('v.streetInput', placeid.split('§')[1]);
       component.set('v.toponym', placeid.split('§')[2]);
       component.set('v.predictions', []);
   },
   civicoBlur2: function (component, event, helper) {
       if (component.get("v.Civico") != null) {
           helper.addressNormalize(component , event);
       }
   },
   civicoBlur: function (component, event, helper) {
       if (component.get("v.Civico") != null) {
           helper.addressNormalize(component , event);
           var placeid = component.get('v.streetWrap');
           if (placeid != null) {
               var action = component.get('c.fetchZipCode');
               action.setParams({
                   "street": placeid
               })
               action.setCallback(this, function (response) {
                   if (response.getState() == "SUCCESS") {
                       var CAP = response.getReturnValue();
                       if (CAP != null && CAP != '') {
                           component.set("v.CAP", CAP);
                           console.log('CAP PRESO::' + CAP);
                       }
                   }
               });
               $A.enqueueAction(action);

               var action2 = component.get('c.fetchLocation');
               action2.setParams({
                   "street": placeid
               })
               action2.setCallback(this, function (response) {
                   if (response.getState() == "SUCCESS") {
                       var LOC = response.getReturnValue();
                       if (LOC != null && LOC != '') {
                           component.set("v.LocAgg", LOC);
                       }
                   }
               });
               $A.enqueueAction(action2);
           }
       }
   },
   
   invoke: function (component, event, helper) {
       //var workspaceAPI = component.find("workspace");
       //CALLED BY FLOW, ASSOCIATES ADDRESS TO ALL RECORDS SELECTED BY USER
       console.log('SUBMITTED');
       var cap = component.get('v.flowCAP');
       if(cap == undefined){
           cap = null;
       }
       var province = component.get('v.flowProvince');
       if(province == undefined){
           province = null;
       }
       var provinceCode = component.get('v.flowProvinceCode');
       if(provinceCode == undefined){
           provinceCode = null;
       }
       var city = component.get('v.flowCity');
       if(city == undefined){
           city = null;
       }
       var cityCode = component.get('v.flowCityCode');
       if(cityCode == undefined){
           cityCode = null;
       }
       var street = component.get('v.flowStreet');
       if(street == undefined){
           street = null;
       }
       var locagg = component.get('v.flowLocAgg');
       if(locagg == undefined){
           locagg = null;
       }
       var metRefX = component.get('v.flowMetRefX');
       if(metRefX == undefined){
           metRefX = null;
       }
       var metRefY = component.get('v.flowMetRefY');
       if(metRefY == undefined){
           metRefY = null;
       }
       var geoRefX = component.get('v.flowGeoRefX');
       if(geoRefX == undefined){
           geoRefX = null;
       }
       var geoRefY = component.get('v.flowGeoRefY');
       if(geoRefY == undefined){
           geoRefY = null;
       }
       var toponym = component.get('v.flowToponym');
       if(toponym == undefined){
           toponym = null;
       }
       var regionRef = component.get('v.flowRegionRef');
       if(regionRef == undefined){
           regionRef = null;
       }
       var streetCode = component.get('v.flowStreetCode');
       if(streetCode == undefined){
           streetCode = null;
       }
       var hamlet = component.get('v.flowHamlet');
       if(hamlet == undefined){
           hamlet = null;
       }
       var hamletRef = component.get('v.flowHamletRef');
       if(hamletRef == undefined){
           hamletRef = null;
       }
       var urbanSpecs = component.get('v.flowExtraSpec');
       if(urbanSpecs == undefined){
           urbanSpecs = null;
       }
       console.log('Entrato in INVOKE');
       var childIds = component.get('v.updateIdString');
       console.log('Stringa Sospetta: ' + childIds);
       var action = component.get('c.associateAddress');
       console.log("INDIRIZZO AGGIORNATO CORRETTAMENTE" + childIds + cap + provinceCode + province);
       action.setParams({
           "childString": childIds,
           "cap" : cap ,
           "province" : province ,
           "provinceCode" : provinceCode ,
           "city" : city ,
           "cityCode" : cityCode ,
           "street" : street ,
           "streetCode" : streetCode,
           "locagg" : locagg,
           "metRefX": metRefX,
           "metRefY": metRefY,
           "geoRefX": geoRefX,
           "geoRefY": geoRefY,
           "toponym": toponym,
           "regionRef": regionRef,
           "hamlet": hamlet,
           "hamletRef": hamletRef,
           "urbanSpecs": urbanSpecs
       })
       action.setCallback(this, function (response) {
           if (response.getState() == "SUCCESS") {
               console.log("SUCCESS");
               console.log("INDIRIZZO AGGIORNATO CORRETTAMENTE");
              /* workspaceAPI.getFocusedTabInfo().then(function (response) {
                   var focusedTabId = response.tabId;
                   workspaceAPI.refreshTab({
                       tabId: focusedTabId,
                       includeAllSubtabs: true
                   });
               });*/
           } else {
               console.log(response.getError());
           }
       });
       $A.enqueueAction(action);
   },

   onButtonPressed: function(component, event, helper) {
       //CHECK IF FIIELDS ARE OK
       //gets address from component, populates its fields and sends it to apex. then refreshes the page.
       var actionClicked = event.getSource().getLocalId();
       if(actionClicked == 'BACK'){
           var navigate = component.get('v.navigateFlow');
           navigate(actionClicked);
       }
       else{
           var estero = false;
           if(component.get('v.provinceWrap') == '0§Estero§0'){
               estero = true;
           }
           if(!estero){
               helper.addressValidate(component , event);
               
           }
           if(component.get('v.validated')){
               console.log('SUBMITTED');
               component.set('v.flowCAP' , component.get("v.CAP"));
               //component.set('v.flowProvince' , component.get("v.provinceWrap").split('§')[1]);
               component.set('v.flowProvince' , component.get("v.shortProvince"));
               component.set('v.flowProvinceCode' , component.get("v.provinceWrap").split('§')[0]);
               component.set('v.flowCity' , component.get("v.cityWrap").split('§')[1]);
               component.set('v.flowCityCode' , component.get("v.cityWrap").split('§')[0]);
               component.set('v.flowStreet' , component.get("v.streetWrap").split('§')[1] + ', ' + component.get("v.Civico"));
               component.set('v.flowStreetCode' , component.get("v.streetWrap").split('§')[0]);
               component.set('v.flowLocAgg' , component.get("v.LocAgg"));
               component.set('v.flowMetRefX' , component.get("v.metRefX"));
               component.set('v.flowMetRefY' , component.get("v.metRefY"));
               component.set('v.flowGeoRefX' , component.get("v.geoRefX"));
               component.set('v.flowGeoRefY' , component.get("v.geoRefY"));
               component.set('v.flowToponym', component.get('v.toponym'));
               component.set('v.flowRegionRef' , component.get('v.provinceWrap').split('§')[2]);
               component.set('v.flowHamlet', component.get('v.hamlet').split('§')[1]);
               component.set('v.flowHamletCode', component.get('v.hamlet').split('§')[0]);
               component.set('v.flowExtraSpec', component.get('v.extraSpecs'));
               console.log('SUBMITTED' + component.get("v.flowProvince"));
               console.log('SUBMITTED' + component.get("v.flowStreet"));
               var navigate = component.get('v.navigateFlow');
               navigate(actionClicked);
           }
           else if(estero){
               console.log('SUBMITTED');
               component.set('v.flowCAP' , component.get("v.CAP"));
               //component.set('v.flowProvince' , component.get("v.provinceWrap").split('§')[1]);
               component.set('v.flowProvince' , '  ');
               component.set('v.flowProvinceCode' , '0');
               component.set('v.flowCity' , component.get("v.esteroCity"));
               component.set('v.flowCityCode' , '0');
               component.set('v.flowStreet' , component.get("v.esteroStreet") + ', ' + component.get("v.Civico"));
               component.set('v.flowStreetCode' , '0');
               component.set('v.flowLocAgg' , component.get("v.LocAgg"));
               component.set('v.flowMetRefX' , '0');
               component.set('v.flowMetRefY' , '0');
               component.set('v.flowGeoRefX' , '0.0000000000000000');
               component.set('v.flowGeoRefY' , '0.0000000000000000');
               component.set('v.flowToponym', component.get('v.toponym'));
               component.set('v.flowRegionRef' , '0');
               component.set('v.flowHamlet', null);
               component.set('v.flowHamletCode', null);
               component.set('v.flowExtraSpec', component.get('v.extraSpecs'));
               console.log('SUBMITTED' + component.get("v.flowProvince"));
               console.log('SUBMITTED' + component.get("v.flowStreet"));
               var navigate = component.get('v.navigateFlow');
               navigate(actionClicked);
           }
       }
    },

    NewSubmitStradario: function (component, event, helper) {
       //gets address from component, populates its fields and sends it to apex. then refreshes the page.
        console.log('SUBMITTED');
        var estero = false;
        if(component.get('v.provinceWrap') == '0§Estero§0'){
            estero = true;
        }
        if(!estero){
            helper.addressValidate(component , event);
            
        }
        
        if(component.get('v.validated')){
            var recordId = component.get("v.recordId");
            var objName = component.get("v.sObjectName");
            var sObj = {'sobjectType':objName,'Id':recordId};
            console.log('SOBJECT' +sObj);
            var workspaceAPI = component.find("workspace");
            if(objName == 'Account'){
                sObj.BillingStreet = component.get('v.streetWrap').split('§')[1] + ', ' + component.get("v.Civico");
                sObj.BillingState = component.get('v.shortProvince');
                sObj.BillingPostalCode = component.get("v.CAP");
                sObj.BillingCountry = 'Italy';
                sObj.BillingCity = component.get('v.cityWrap').split('§')[1];
                sObj.BillingLatitude = component.get('v.geoRefY');
                sObj.BillingLongitude = component.get('v.geoRefX');
            }
            else{
                sObj.ER_Street__c = component.get('v.streetWrap').split('§')[1] + ', ' + component.get("v.Civico");
                sObj.IT_Province__c = component.get('v.shortProvince');
                sObj.ER_Zip_Code__c = component.get("v.CAP");
                sObj.ER_City__c = component.get('v.cityWrap').split('§')[1];
                sObj.IT_GeoRef_Loc_Y__c = component.get('v.geoRefY').toString();
                sObj.IT_GeoRef_Loc_X__c = component.get('v.geoRefX').toString();
            }
            if(component.get('v.hamlet') != null && component.get('v.hamlet') != ''){
                sObj.IT_Hamlet__c = component.get('v.hamlet').split('§')[1];
                sObj.IT_Hamlet_Code__c = component.get('v.hamlet').split('§')[0];
            }
            else{
                sObj.IT_Hamlet__c = null;
                sObj.IT_Hamlet_Code__c = null;
            }
            sObj.IT_Extra_Urban_Specifications__c = component.get('v.extraSpecs');
            sObj.IT_Toponym__c = component.get('v.toponym');
            sObj.IT_MetRef_Loc_Y__c = component.get('v.metRefY').toString();
            sObj.IT_MetRef_Loc_X__c = component.get('v.metRefX').toString();
            sObj.IT_State_Code__c = component.get('v.provinceWrap').split('§')[0];
            sObj.IT_City_Code__c = component.get('v.cityWrap').split('§')[0];
            sObj.IT_Street_Code__c = component.get('v.streetWrap').split('§')[0];
            sObj.IT_Region_code__c = component.get('v.provinceWrap').split('§')[2];
            if(objName != 'Account'){
                sObj.IT_Change_Address__c = true;  
            }
            if(objName == 'ER_Delivery_Site__c'){
                sObj.ER_Street_additionnal__c = component.get('v.LocAgg'); 
            }
            else{
                sObj.IT_Additional_Locality__c = component.get('v.LocAgg'); 
            }
            console.log('SUBMITTEDADDRESS:: '+JSON.stringify(sObj));
            var action = component.get("c.insertAndAssociateAddress");
            action.setParams({
                "obj" : sObj
            })
            action.setCallback(this, function (response) {
                if (response.getState() == "SUCCESS") {
                    console.log('SUCCESS');
                    $A.get("e.force:closeQuickAction").fire();
                    workspaceAPI.getFocusedTabInfo().then(function (response) {
                        var focusedTabId = response.tabId;
                        workspaceAPI.refreshTab({
                            tabId: focusedTabId,
                            includeAllSubtabs: false
                        });
                    });
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Ops!",
                        "message": "Qualcosa è andato storto."
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
        
        // SOLO ESTERO //
        
        else if (estero){
            var recordId = component.get("v.recordId");
            var objName = component.get("v.sObjectName");
            var sObj = {'sobjectType':objName,'Id':recordId};
            console.log('SOBJECT' +sObj);
            var workspaceAPI = component.find("workspace");
            if(objName == 'Account'){
                sObj.BillingStreet = component.get('v.esteroStreet') + ', ' + component.get("v.Civico");
                sObj.BillingState = '  ';
                sObj.BillingPostalCode = component.get("v.CAP");
                sObj.BillingCountry = 'Estero';
                sObj.BillingCity = component.get('v.esteroCity');
                sObj.BillingLatitude = 0;
                sObj.BillingLongitude = 0;
            }
            else{
                sObj.ER_Street__c = component.get('v.esteroStreet') + ', ' + component.get("v.Civico");
                sObj.IT_Province__c = '  ';
                sObj.ER_Zip_Code__c = component.get("v.CAP");
                sObj.ER_City__c = component.get('v.esteroCity');
                sObj.IT_GeoRef_Loc_Y__c = '0';
                sObj.IT_GeoRef_Loc_X__c = '0';
            }
            if(component.get('v.hamlet') != null && component.get('v.hamlet') != ''){
                sObj.IT_Hamlet__c = null;
                sObj.IT_Hamlet_Code__c = null;
            }
            else{
                sObj.IT_Hamlet__c = null;
                sObj.IT_Hamlet_Code__c = null;
            }
            sObj.IT_Extra_Urban_Specifications__c = component.get('v.extraSpecs');
            sObj.IT_Toponym__c = component.get('v.toponym');
            sObj.IT_MetRef_Loc_Y__c = '0';
            sObj.IT_MetRef_Loc_X__c = '0';
            sObj.IT_State_Code__c = '0';
            sObj.IT_City_Code__c = '0';
            sObj.IT_Street_Code__c = '0';
            sObj.IT_Region_code__c = '0';
            if(objName != 'Account'){
                sObj.IT_Change_Address__c = true;  
            }
            if(objName == 'ER_Delivery_Site__c'){
                sObj.ER_Street_additionnal__c = component.get('v.LocAgg'); 
            }
            else{
                sObj.IT_Additional_Locality__c = component.get('v.LocAgg'); 
            }
            console.log('SUBMITTEDADDRESS:: '+JSON.stringify(sObj));
            var action = component.get("c.insertAndAssociateAddress");
            action.setParams({
                "obj" : sObj
            })
            action.setCallback(this, function (response) {
                if (response.getState() == "SUCCESS") {
                    console.log('SUCCESS');
                    $A.get("e.force:closeQuickAction").fire();
                    workspaceAPI.getFocusedTabInfo().then(function (response) {
                        var focusedTabId = response.tabId;
                        workspaceAPI.refreshTab({
                            tabId: focusedTabId,
                            includeAllSubtabs: false
                        });
                    });
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Ops!",
                        "message": "Qualcosa è andato storto: "+JSON.stringify(response.getError())
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
            
        }
        
        // SOLO ESTERO //
        
        
        
    },
   
   provinceChangeStradarioFOCUS: function (component, event, helper) {
       //when a value is selected, apex automatically populates the next picklist
       console.log('WRAPPROVINCESTART:: ' + event);
       var provinceRef = component.get('v.provinceWrap').split('§');
       console.log('PROVINCEREF SIZE:: '+provinceRef.length);
       //component.set('v.regionRef' , provinceRef[2]);
       console.log('WRAPPROVINCE:: '+provinceRef);
       var action = component.get('c.getMunicipalitiesStradario');
       console.log('IN1');
       action.setParams({
           "provinceRef" : provinceRef[0]
       })
       action.setCallback(this, function(response) {
           console.log('IN');
           console.log('PROVINCE CODE: '+provinceRef);
           if (response.getState() == "SUCCESS") {
               var stage = response.getReturnValue();
               //console.log('RESPONSE '+stage.toString());
               var returnMap = [];
               var responso = JSON.parse(stage);
               console.log('RESPONSE PARSATA');
               var provinces = responso.data;
               provinces.forEach(function(element) {
                   //returnMap.push(element.province_ref , element.name_display);
                   returnMap.push({'key' : element.municipality_ref , 'value' : element.name_display});  
               });
               component.set('v.municipalityMap' , returnMap);
               console.log('MAPPASETTATA:: ' +returnMap[0].key);
               
               //component.set ('v.hmacString' ,stage.toString() );
               //***ADD PREPOPULATION ONCE IT_ADDRESS IS GONE***
           }
           else if(state === 'ERROR'){
               var errors = resp.getError();
               for(var i = 0 ;i < errors.length;i++){
                   console.log(errors[i].message);
               }
           }
       });
       $A.enqueueAction(action);
       
   },
   

   
   timeoutStreets: function (component, event, helper) {
       window.setTimeout(function(){ component.set('v.streetBoolean' , true); }, 250);  
   }
})