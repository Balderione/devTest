//Class that will be used to call an external system and retrieve
//streets and cities for account fields 

public class APIT03_Addresses_Getter {
    //called in Init, gets the Address record associated with the account and returns it
    @AuraEnabled
    public static string fetchAddress(id recordId , string sObjectName){
        String myQuery = 'Select id , IT_Extra_Urban_Specifications__c, IT_Zone__c,  IT_City_Code__c, IT_Hamlet_Code__c, IT_Sestiere_Code__c, IT_Street_Code__c, IT_Road_Arch_Code__c, IT_Short_Address__c, IT_Toponym__c, IT_Hamlet__c, IT_MetRef_Loc_X__c, IT_MetRef_Loc_Y__c , IT_State_Code__c , IT_Region_Code__c'; //, IT_State__c
        if(sObjectName == 'Account'){
            myQuery += ', BillingCity, BillingLatitude, BillingLongitude, BillingPostalCode, BillingStreet, BillingState';
        }
        else {
            myQuery += ', ER_City__c, ER_Zip_Code__c, ER_Street__c, IT_GeoRef_Loc_X__c, IT_GeoRef_Loc_Y__c, IT_Province__c';
        }
        if (sObjectName == 'ER_Delivery_Site__c'){
            myquery += ', ER_Street_additionnal__c';
        }
        else{
            myQuery += ', IT_Additional_Locality__c';
        }
        
        myQuery += ' FROM '+ sObjectName +' Where Id  = \'' + recordId + '\' LIMIT 1';
        if(recordId != null){
            List<sObject> objectToReturn = database.query(myQuery);
            return JSON.serializePretty(objectToReturn[0]);
        }
        else return '';
        
    }
    
    @auraenabled
    public static string getProvincesStradario(){
        Http h = new Http();
        HttpRequest req = APER06_WebserviceUtility.getHttpRequest(
            '/referential/addresses/provinces',
            'GET',
            null,
            null);
        req.setHeader('Content-Type', 'application/java');
        HttpResponse res = h.send(req);
        String responseBody = res.getbody();
        //string responsebody = '{ "meta":{ "messages":[  ], "status":"succeeded" }, "data":[ { "chief_town_istat_code":"084001", "istat_code":"084", "province_ref":"38000000022", "province_old_ref":"94", "region_ref":"38000000020", "region_old_ref":"19", "name":"AGRIGENTO", "name_display":"Agrigento", "abbreviation":"AG" }, { "chief_town_istat_code":"084001", "istat_code":"084", "province_ref":"34566433422", "province_old_ref":"94", "region_ref":"38000000020", "region_old_ref":"19", "name":"CREMONA", "name_display":"Cremona", "abbreviation":"AG" } ] } ';
        return responseBody;
        
        /*Schema.DescribeFieldResult F = Account.IT_State_Code__c.getDescribe();
Schema.sObjectField T = F.getSObjectField();
List<PicklistEntry> entries = T.getDescribe().getPicklistValues();
system.debug(entries);
return JSON.serialize(entries);*/
        
        
        
        
    }
    @auraenabled
    public static string getMunicipalitiesStradario (string provinceRef){
        Http h = new Http();
        HttpRequest req = APER06_WebserviceUtility.getHttpRequest(
            '/referential/addresses/provinces/'+provinceRef+'/municipalities',
            'GET',
            null,
            null);
        req.setHeader('Content-Type', 'application/java');
        HttpResponse res = h.send(req);
        String responseBody = res.getbody();
        /*string responseBody;
if (provinceRef == '38000000022'){
responseBody='{ "meta": { "messages": [], "status": "succeeded" }, "data": [ { "cab_code": "75250", "cab_cin_code": "752501", "postal_code": "82011", "istat_code": "062001", "cadastral_code": "A110", "municipality_ref": "38000006797", "municipality_old_ref": "6091", "province_ref": "38000000034", "province_old_ref": "75", "short_name": "AIROLA", "name": "AIROLA", "name_display": "Airola", "is_multi_cap": false, "is_visible": true } ,{ "cab_code": "75250", "cab_cin_code": "752501", "postal_code": "82011", "istat_code": "062001", "cadastral_code": "A110", "municipality_ref": "38000006598", "municipality_old_ref": "6091", "province_ref": "38000000034", "province_old_ref": "75", "short_name": "ARAGONA", "name": "ARAGONA", "name_display": "Aragona", "is_multi_cap": false, "is_visible": true } ] } ';
}
else if(provinceRef == '34566433422'){
responseBody='{ "meta": { "messages": [], "status": "succeeded" }, "data": [ { "cab_code": "75250", "cab_cin_code": "752501", "postal_code": "82011", "istat_code": "062001", "cadastral_code": "A110", "municipality_ref": "38000002358", "municipality_old_ref": "6091", "province_ref": "38000000034", "province_old_ref": "75", "short_name": "CASTELVERDE", "name": "CASTELVERDE", "name_display": "Castelverde", "is_multi_cap": false, "is_visible": true } ,{ "cab_code": "75250", "cab_cin_code": "752501", "postal_code": "82011", "istat_code": "062001", "cadastral_code": "A110", "municipality_ref": "38000002374", "municipality_old_ref": "6091", "province_ref": "38000000034", "province_old_ref": "75", "short_name": "CREMA", "name": "CREMA", "name_display": "Crema", "is_multi_cap": false, "is_visible": true } ] } ';
}*/
        return responseBody;
    }
    
    @auraenabled
    public static void insertAndAssociateAddress (sObject obj){
        system.debug('OBJ:: ' +JSON.serializePretty(obj));
        update obj;
        
    }
    @auraenabled
    public static string callNormalize (String jsonToSend){
        Http h = new Http();
        HttpRequest req = APER06_WebserviceUtility.getHttpRequest(
            '/referential/addresses/normalize',
            'POST',
            jsonToSend,
            null);
        HttpResponse res = h.send(req);
        String responseBody = res.getbody();
        return responseBody;
    }
    
    
        @auraenabled
    public static string callAutocomplete (String jsonToSend){
        Http h = new Http();
        HttpRequest req = APER06_WebserviceUtility.getHttpRequest(
            '/referential/addresses/auto-complete',
            'POST',
            jsonToSend,
            null);
        HttpResponse res = h.send(req);
        String responseBody = res.getbody();
        return responseBody;
    }
    
    @auraenabled
    public static string fetchHamlets (String municipRef){
        Http h = new Http();
        HttpRequest req = APER06_WebserviceUtility.getHttpRequest(
            '/referential/addresses/municipalities/'+municipRef+'/hamlets',
            'GET',
            null,
            null);
        req.setHeader('Content-Type', 'application/java');
        HttpResponse res = h.send(req);
        String responseBody = res.getbody();
        return responseBody;
    }
    
    @AuraEnabled
    public static string getSuggestions(String input , String cityRef) {
        Http h = new Http();
        HttpRequest req = APER06_WebserviceUtility.getHttpRequest(
            '/referential/addresses/municipalities/'+cityRef+'/streets?street-name='+input,
            'GET',
            null,
            null);
        req.setHeader('Content-Type', 'application/java');
        HttpResponse res = h.send(req);
        String responseBody = res.getbody();
        system.debug(responseBody);
        return responseBody;
    }
    
    
    @auraenabled
    //TO BE TESTED
    public static void associateAddress (string childString, string cap, string province, string provinceCode, string city, string cityCode, string street, string locagg, string metRefX , string metRefY , string geoRefX , string geoRefY , string toponym , string regionRef , string streetCode , string hamlet , string hamletRef , string urbanSpecs ){
        system.debug('childString:: '+childString);
        string rightstring = childstring.deleteWhitespace().replaceAll(';;', ';').removeEnd(';').removeStart(';');
        system.debug('rightstring:: '+rightstring);
        system.debug('metRef:: '+metRefX);
        system.debug('metRef:: '+metRefY);
        system.debug('geoRefX:: '+geoRefX);
        system.debug('geoRefY:: '+geoRefY);
        list<string> idList = rightstring.deleteWhitespace().split(';');
        system.debug('LIST ID:: '+idList);
        id AccoId;
        id FinCentId;
        list<id> DelSiteIds = new list<String>();
        list<id> DistrPointIds= new list<String>();
        for(string s : idList){
            if(((id)s).getSObjectType().getDescribe().getName() == 'Account'){
                string idtoadd = s.replaceAll( '\\s+', '');
                system.debug('TRIMMERED:: '+idtoadd);
                Accoid = (id)idtoadd;
                system.debug('ACCOID:: '+ Accoid);
            }
            if(((id)s).getSObjectType().getDescribe().getName() == 'ER_Financial_Center__c'){
                string idtoadd = s.replaceAll( '\\s+', '');
                system.debug('TRIMMERED:: '+idtoadd);
                FinCentId = (id)idtoadd;
                system.debug('FINCENTID:: '+ FinCentId);
            }
            if(((id)s).getSObjectType().getDescribe().getName() == 'ER_Delivery_Site__c'){
                string idtoadd = s.replaceAll( '\\s+', '');
                system.debug('TRIMMERED:: '+idtoadd);
                DelSiteIds.add((id)idtoadd);
                system.debug('DelSiteIds:: '+ DelSiteIds);
            }
            if(((id)s).getSObjectType().getDescribe().getName() == 'ER_Distribution_Point__c'){
                string idtoadd = s.replaceAll( '\\s+', '');
                system.debug('TRIMMERED:: '+idtoadd);
                DistrPointIds.add((id)idtoadd);
                system.debug('DistrPointIds:: '+ DistrPointIds);
            }
            
        }
        if(AccoId != null){
            Account acco = [SELECT id, name  FROM Account Where Id =:Accoid];
            acco.BillingStreet = street;
            acco.BillingState = province;
            acco.BillingPostalCode = cap;
            acco.BillingCity = city;
            acco.IT_State_Code__c = provinceCode;
            acco.IT_City_Code__c = cityCode;
            acco.IT_Additional_Locality__c = locagg; 
            if(geoRefX != null){
                acco.BillingLongitude = double.valueof(geoRefX.replace(',' , '.'));
            }
            else{
                acco.BillingLongitude = 0.0;
            }
            if(geoRefY != null){
                acco.BillingLatitude = double.valueof(geoRefY.replace(',' , '.'));
            }
            else{
                acco.BillingLatitude = 0.0;
            }
            acco.IT_Hamlet__c = hamlet;
            acco.IT_Hamlet_Code__c = hamletRef;
            acco.IT_Extra_Urban_Specifications__c = urbanSpecs;
            acco.IT_MetRef_Loc_Y__c = metRefY;
            acco.IT_MetRef_Loc_X__c = metRefX;
            acco.IT_Toponym__c = toponym;
            acco.IT_Region_Code__c = regionRef;
            acco.IT_Street_Code__c = streetCode;
            
            update acco;
        }
        if(FinCentId != null){
            ER_Financial_Center__c fincent = [SELECT id, name  FROM ER_Financial_Center__c Where Id =:FinCentId];
            fincent.ER_Street__c = street;
            fincent.IT_Province__c = province;
            fincent.ER_Zip_Code__c = cap;
            fincent.ER_City__c = city;
            fincent.IT_State_Code__c = provinceCode;
            fincent.IT_City_Code__c = cityCode;
            fincent.IT_Additional_Locality__c = locagg;
            fincent.IT_GeoRef_Loc_Y__c = geoRefY;
            fincent.IT_GeoRef_Loc_X__c = geoRefX;
            fincent.IT_MetRef_Loc_Y__c = metRefY;
            fincent.IT_MetRef_Loc_X__c = metRefX;
            fincent.IT_Toponym__c = toponym;
            fincent.IT_Region_Code__c = regionRef;
            fincent.IT_Street_Code__c = streetCode;
            fincent.IT_Hamlet__c = hamlet;
            fincent.IT_Hamlet_Code__c = hamletRef;
            fincent.IT_Extra_Urban_Specifications__c = urbanSpecs;
            fincent.IT_Change_Address__c = true;
            update fincent;
        }           
        if(DelSiteIds != null && DelSiteIds.size() > 0){
            list<ER_Delivery_Site__c> delSites = [SELECT id, name FROM ER_Delivery_Site__c Where Id IN :DelSiteIds];
            for (ER_Delivery_Site__c d : delSites){
                d.ER_Street__c = street;
                d.IT_Province__c = province;
                d.ER_Zip_Code__c = cap;
                d.ER_City__c = city;
                d.IT_State_Code__c = provinceCode;
                d.IT_City_Code__c = cityCode;
                d.ER_Street_additionnal__c = locagg;
                d.IT_GeoRef_Loc_Y__c = geoRefY;
                d.IT_GeoRef_Loc_X__c = geoRefX;
                d.IT_MetRef_Loc_Y__c = metRefY;
                d.IT_MetRef_Loc_X__c = metRefX;
                d.IT_Toponym__c = toponym;
                d.IT_Region_Code__c = regionRef;
                d.IT_Street_Code__c = streetCode;
                d.IT_Hamlet__c = hamlet;
                d.IT_Hamlet_Code__c = hamletRef;
                d.IT_Extra_Urban_Specifications__c = urbanSpecs;
                d.IT_Change_Address__c = true;
            }
            update delSites;
        }            
        if(DistrPointIds != null && DistrPointIds.size() > 0 ){
            list<ER_Distribution_Point__c> distPoints = [SELECT id, name  FROM ER_Distribution_Point__c Where Id IN :DistrPointIds];
            for (ER_Distribution_Point__c d : distPoints){
                d.ER_Street__c = street;
                d.IT_Province__c = province;
                d.ER_Zip_Code__c = cap;
                d.ER_City__c = city;
                d.IT_State_Code__c = provinceCode;
                d.IT_City_Code__c = cityCode;
                d.IT_Additional_Locality__c = locagg; 
                d.IT_GeoRef_Loc_Y__c = geoRefY;
                d.IT_GeoRef_Loc_X__c = geoRefX;
                d.IT_MetRef_Loc_Y__c = metRefY;
                d.IT_MetRef_Loc_X__c = metRefX;
                d.IT_Toponym__c = toponym;
                d.IT_Region_Code__c = regionRef;
                d.IT_Street_Code__c = streetCode;
                d.IT_Hamlet__c = hamlet;
                d.IT_Hamlet_Code__c = hamletRef;
                d.IT_Extra_Urban_Specifications__c = urbanSpecs;
                d.IT_Change_Address__c = true;
            }
            update distPoints;
        }
    }
}