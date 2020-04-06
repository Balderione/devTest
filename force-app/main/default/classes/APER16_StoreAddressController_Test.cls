@isTest
public class APER16_StoreAddressController_Test {

@testSetup
static void testSetup() {
    APER05_DoNotRunTrigger donotRunTrigger = new  APER05_DoNotRunTrigger();
        donotRunTrigger.setDoNotRunTrigger(); 
//create Account
String merchantRecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ER_Company_Account_RT').getRecordTypeId();
Account AccTst = new Account(
                Name = 'Test Account',
                ER_Creation_date_in_OS__c = Date.today(),
                RecordTypeId = merchantRecordtypeId,
                ER_Status__c = 'Prospect',
                BillingStreet = 'Soroksári út 132.', BillingCity = 'BUDAPEST', BillingPostalCode = '1095',
                ShippingStreet = 'Soroksári út 132.', ShippingCity = 'BUDAPEST', ShippingPostalCode = '1095'
            );
insert AccTst;

Contact ct = new Contact(
                Salutation = 'Mr.',
                FirstName = 'firstname',
                LastName = 'test',
                AccountId = AccTst.Id,
                Phone = '+36-1-111-1111',
                Fax = '+36-1-111-1111',
                Email = 'test@canadahotel.hu',
                MailingStreet = 'Test Street',
                MailingCity = 'BUDAPEST',
                MailingPostalCode = '1095'
            );
insert ct;

ER_Bank_Account__c bankAcc = new ER_Bank_Account__c(
                Name='BNP',
                ER_Bank_Account_Status__c = 'Open',
                ER_Bank_City__c = 'Paris',
                ER_Bank_Account_Number_Prefix__c = 'FR',
                ER_Bank_Account_Number__c = '14',
                ER_IBAN__c = '30001019-01000006-70670320'
                );
insert bankAcc;

ER_Financial_Center__c fc = new ER_Financial_Center__c(
                Name = 'Test financial center',
                ER_Type__c = Label.LABS_SF_FinancialCenter_Merchant,
                ER_Invoicing_Site__c = true,
                ER_Account_Name__c = AccTst.id,
                ER_Contact__c = ct.id,
                ER_Bank_Account__c = bankAcc.id,
                ER_Email__c = 'levi.mali@programming-pool.com',
                ER_Street__c = 'Aradi u. 62.',
                ER_City__c = 'Budaörs',
                ER_Zip_Code__c = '2040',
                ER_Country__c = 'HUN'
            );
insert fc;

ER_Store__c store = new ER_Store__c(
                Name ='Test Store',
                ER_Merchant__c = AccTst.id,
                ER_Financial_Center__c = fc.id,
                ER_Contact__c = ct.id,
                ER_Street__c = 'Test Street', 
                ER_City__c = 'BUDAPEST', 
                ER_Zip_Code__c = '1095'
                );
Insert store;
}


 @isTest 
static void testUpdateStoreAddress() {
   
List<ER_Store__c> lststore = [select id from ER_Store__c];
//Update Store
            String sJson = '{"oId" : "' + lststore[0].id + '","sStreet" : "Boulevard Gabriel Péri","sPostalCode" : "92240","sCity" : "Malakoff","sLat" : "48.819828","sLong" : "2.309469699999999","sCountry" : "France"}';
APER16_StoreAddressController.updateStore(sJson);
}
//getAddressAutoComplete(String input)
 @isTest 
    static void testgGetAddressAutoComplete() {
        Test.setMock(HttpCalloutMock.class, new AutoComplete_Callout_Mock());
        Test.startTest();
        string sJson = APER16_StoreAddressController.getAddressAutoComplete('187+gabriel+peri');
        Test.stopTest();
        //System.debug('JsonAddressAutoComplete=' + sJson);
    }
//getAddressDetails (String placeid)

 @isTest 
    static void testGetAddressDetails() {
        Test.setMock(HttpCalloutMock.class, new AddressDetail_Callout_Mock());
        Test.startTest();
        string sJson = APER16_StoreAddressController.getAddressDetails('ChIJ8cELEldw5kcRGzVTTIXSmx4');
        Test.stopTest();
        //System.debug('JsonAddressDetail=' + sJson);
    }
   
public class AutoComplete_Callout_Mock implements HttpCalloutMock {
    
     //Implement this interface method
    public HTTPResponse respond(HTTPRequest request) {
        
        String testBody = '{  "predictions": [    {      "description": "187 Avenue Gabriel Péri, Gennevilliers, France",      "id": "a95e8c16cd222fcdee774f1dec8ab9024c8127c4",      "matched_substrings": [        {          "length": 3,          "offset": 0        },        {          "length": 19,          "offset": 4        }      ],      "place_id": "ChIJdTGmMkVv5kcRHrwFhOXUHWY",      "reference": "ChIJdTGmMkVv5kcRHrwFhOXUHWY",      "structured_formatting": {        "main_text": "187 Avenue Gabriel Péri",        "main_text_matched_substrings": [          {            "length": 3,            "offset": 0          },          {            "length": 19,            "offset": 4          }        ],        "secondary_text": "Gennevilliers, France"      },      "terms": [        {          "offset": 0,          "value": "187"        },        {          "offset": 4,          "value": "Avenue Gabriel Péri"        },        {          "offset": 25,          "value": "Gennevilliers"        },        {          "offset": 40,          "value": "France"        }      ],      "types": [        "street_address",        "geocode"      ]    },    {      "description": "187 Rue Gabriel Péri, Colombes, France",      "id": "9b1ddfd5507f2dcc2176a4d708494b24d8544e55",      "matched_substrings": [        {          "length": 3,          "offset": 0        },        {          "length": 16,          "offset": 4        }      ],      "place_id": "ChIJG4HvH8pl5kcRbP76VYcKzgY",      "reference": "ChIJG4HvH8pl5kcRbP76VYcKzgY",      "structured_formatting": {        "main_text": "187 Rue Gabriel Péri",        "main_text_matched_substrings": [          {            "length": 3,            "offset": 0          },          {            "length": 16,            "offset": 4          }        ],        "secondary_text": "Colombes, France"      },      "terms": [        {          "offset": 0,          "value": "187"        },        {          "offset": 4,          "value": "Rue Gabriel Péri"        },        {          "offset": 22,          "value": "Colombes"        },        {          "offset": 32,          "value": "France"        }      ],      "types": [        "street_address",        "geocode"      ]    },    {      "description": "187 Rue Gabriel Péri, Vitry-sur-Seine, France",      "id": "a3e7e9f92ebd4836918ecaba2092c9def4512fbd",      "matched_substrings": [        {          "length": 3,          "offset": 0        },        {          "length": 16,          "offset": 4        }      ],      "place_id": "ChIJtVBUFaJz5kcRw1ieNW-DnhU",      "reference": "ChIJtVBUFaJz5kcRw1ieNW-DnhU",      "structured_formatting": {        "main_text": "187 Rue Gabriel Péri",        "main_text_matched_substrings": [          {            "length": 3,            "offset": 0          },          {            "length": 16,            "offset": 4          }        ],        "secondary_text": "Vitry-sur-Seine, France"      },      "terms": [        {          "offset": 0,          "value": "187"        },        {          "offset": 4,          "value": "Rue Gabriel Péri"        },        {          "offset": 22,          "value": "Vitry-sur-Seine"        },        {          "offset": 39,          "value": "France"        }      ],      "types": [        "street_address",        "geocode"      ]    },    {      "description": "187 Boulevard Gabriel Péri, Malakoff, France",      "id": "7f4cf235a316de1d60589c3ce3cd740d8fd979be",      "matched_substrings": [        {          "length": 3,          "offset": 0        },        {          "length": 22,          "offset": 4        }      ],      "place_id": "ChIJ8cELEldw5kcRGzVTTIXSmx4",      "reference": "ChIJ8cELEldw5kcRGzVTTIXSmx4",      "structured_formatting": {        "main_text": "187 Boulevard Gabriel Péri",        "main_text_matched_substrings": [          {            "length": 3,            "offset": 0          },          {            "length": 22,            "offset": 4          }        ],        "secondary_text": "Malakoff, France"      },      "terms": [        {          "offset": 0,          "value": "187"        },        {          "offset": 4,          "value": "Boulevard Gabriel Péri"        },        {          "offset": 28,          "value": "Malakoff"        },        {          "offset": 38,          "value": "France"        }      ],      "types": [        "street_address",        "geocode"      ]    },    {      "description": "187 Rue Gabriel Péri, Moissy-Cramayel, France",      "id": "484ae0db5763b8cf8f2a2ec850eca418b335157e",      "matched_substrings": [        {          "length": 3,          "offset": 0        },        {          "length": 16,          "offset": 4        }      ],      "place_id": "ChIJtXpEGWrj5UcR0dvsGSX5BC4",      "reference": "ChIJtXpEGWrj5UcR0dvsGSX5BC4",      "structured_formatting": {        "main_text": "187 Rue Gabriel Péri",        "main_text_matched_substrings": [          {            "length": 3,            "offset": 0          },          {            "length": 16,            "offset": 4          }        ],        "secondary_text": "Moissy-Cramayel, France"      },      "terms": [        {          "offset": 0,          "value": "187"        },        {          "offset": 4,          "value": "Rue Gabriel Péri"        },        {          "offset": 22,          "value": "Moissy-Cramayel"        },        {          "offset": 39,          "value": "France"        }      ],      "types": [        "street_address",        "geocode"      ]    }  ],  "status": "OK"}';
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody(testBody);
        
        response.setStatusCode(200);
        return response;
    }    
}
    
public class AddressDetail_Callout_Mock implements HttpCalloutMock {
    
     //Implement this interface method
    public HTTPResponse respond(HTTPRequest request) {
        
        String testBody = '{  "html_attributions": [],  "result": {    "address_components": [      {        "long_name": "187",        "short_name": "187",        "types": [          "street_number"        ]      },      {        "long_name": "Boulevard Gabriel Péri",        "short_name": "Boulevard Gabriel Péri",        "types": [          "route"        ]      },      {        "long_name": "Malakoff",        "short_name": "Malakoff",        "types": [          "locality",          "political"        ]      },      {        "long_name": "Hauts-de-Seine",        "short_name": "Hauts-de-Seine",        "types": [          "administrative_area_level_2",          "political"        ]      },      {        "long_name": "Île-de-France",        "short_name": "Île-de-France",        "types": [          "administrative_area_level_1",          "political"        ]      },      {        "long_name": "France",        "short_name": "FR",        "types": [          "country",          "political"        ]      },      {        "long_name": "92240",        "short_name": "92240",        "types": [          "postal_code"        ]      }    ],    "adr_address": "<span class=\"street-address\">187 Boulevard Gabriel Péri</span>, <span class=\"postal-code\">92240</span> <span class=\"locality\">Malakoff</span>, <span class=\"country-name\">France</span>",    "formatted_address": "187 Boulevard Gabriel Péri, 92240 Malakoff, France",    "geometry": {      "location": {        "lat": 48.819828,        "lng": 2.309469699999999      },      "viewport": {        "northeast": {          "lat": 48.8212132302915,          "lng": 2.310829480291501        },        "southwest": {          "lat": 48.81851526970851,          "lng": 2.308131519708498        }      }    },    "icon": "https://maps.gstatic.com/mapfiles/place_api/icons/geocode-71.png",    "id": "7f4cf235a316de1d60589c3ce3cd740d8fd979be",    "name": "187 Boulevard Gabriel Péri",    "place_id": "ChIJ8cELEldw5kcRGzVTTIXSmx4",    "plus_code": {      "compound_code": "R895+WQ Malakoff, France",      "global_code": "8FW4R895+WQ"    },    "reference": "ChIJ8cELEldw5kcRGzVTTIXSmx4",    "scope": "GOOGLE",    "types": [      "street_address"    ],    "url": "https://maps.google.com/?q=187+Boulevard+Gabriel+P%C3%A9ri,+92240+Malakoff,+France&ftid=0x47e67057120bc1f1:0x1e9bd2854c53351b",    "utc_offset": 120,    "vicinity": "Malakoff"  },  "status": "OK"}';
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody(testBody);
        
        response.setStatusCode(200);
        return response;
    }
}
    
}