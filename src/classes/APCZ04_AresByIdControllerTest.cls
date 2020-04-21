@isTest
public class APCZ04_AresByIdControllerTest {
    
    @isTest 
    static void testGetDarvBasWS() {
        //DarvBas
        Test.setMock(HttpCalloutMock.class, new APCZ03_AresCallout_ById_Test.APCZ02_Ares_CalloutResBas_Mock());
        string sJson = APCZ04_AresByIdController.getDarvBasWS('24745391');
        System.debug('JsonDarvBas=' + sJson);
    }
    
    @isTest 
    static void testGetDarvResWS() {
        //DarvRes
        Test.setMock(HttpCalloutMock.class, new APCZ03_AresCallout_ById_Test.APCZ03_Ares_CalloutDarvRes_Mock());
        string sJson = APCZ04_AresByIdController.getDarvResWS('24745391','');
        //System.debug('JsonDarvRes=' + sJson);
    }
    
    @isTest 
    static void testGetAccountWS() {
        Account acc = new Account();
        acc.Name = 'AKO Test';
        //acc.AKO__VAT__c = '24745391';
        insert acc;
        
        Account accSel = APCZ04_AresByIdController.getAccountWS(acc.Id);
        //System.debug('AccountSelect=' + accSel.AKO__VAT__c);       
    }
    
    @isTest
    static void testUpdateAccountWS() {
        Account acc = new Account();
        acc.Name = 'AKO Test';
        //acc.AKO__VAT__c = '24745391';
        insert acc;
        
        //String jsonAcc = '{"accId" : "' + acc.Id + '","sName" : "Edenred CZ s.r.o.","sBillingStreet" : "Pernerova 691/42","sBillingPostalCode" : "18600","sBillingCity" : "Praha","bGetName" : true,"bGetVatNumber" : true,"bGetLegalForm" : true,"bGetZipCode" : true,"bGetStreet" : true,"bGetCity" : true}';   
        String jsonAcc = '{"oId" : "' + acc.Id + '","sName" : "Edenred CZ s.r.o.","sVatNumber" : "CZ24745391","sStreet" : "Pernerova 691/42","sPostalCode" : "18600","sCity" : "Praha","bGetName" : true,"bGetVatNumber" : true,"bGetLegalForm" : true,"bGetZipCode" : true,"bGetStreet" : true,"bGetCity" : true,"sNaceList" : ""}';   
        String sJsonNace  = '[{"n04_Nazev":"Ostatní pomocné činnosti související s finančním zprostředkováním","n04_NACE":"66190","isSelected":false},{"n04_Nazev":"Výroba, obchod a služby neuvedené v přílohách 1 až 3 živnostenského zákona","n04_NACE":"00","isSelected":false},{"n04_Nazev":"Účetnické a auditorské činnosti; daňové poradenství","n04_NACE":"69200","isSelected":false},{"n04_Nazev":"Ostatní profesní, vědecké a technické činnosti","n04_NACE":"74","isSelected":false}]';
        Account accNew = APCZ04_AresByIdController.updateAccountWS(jsonAcc,sJsonNace);
        
        APCZ01_AresEntity.AresPopUp oPopUp = (APCZ01_AresEntity.AresPopUp)JSON.deserialize(jsonAcc, APCZ01_AresEntity.AresPopUp.class); 
        //System.debug('accNew=' + accNew.Name);
    }
    
    @isTest
    static void testUpdateLeadWS() 
	{
        Lead LeadTest = new Lead(LastName='TestLead',
                Status = 'New',
                Company = 'Edenred');
        insert LeadTest;
		APCZ04_AresByIdController.getLeadWS(LeadTest.id);
        APCZ04_AresByIdController.fetchUser();
		String sJsonLead = '{"oId" : "' + LeadTest.Id + '","sName" : "Edenred CZ s.r.o.","sVatNumber" : "CZ24745391","sStreet" : "Pernerova 691/42","sPostalCode" : "18600","sCity" : "Praha","bGetName" : true,"bGetVatNumber" : true,"bGetLegalForm" : true,"bGetZipCode" : true,"bGetStreet" : true,"bGetCity" : true,"sNaceList" : ""}';
		
		String sJsonNaceLead = '[{"n04_Nazev":"Ostatní pomocné činnosti související s finančním zprostředkováním","n04_NACE":"66190","isSelected":false},{"n04_Nazev":"Výroba, obchod a služby neuvedené v přílohách 1 až 3 živnostenského zákona","n04_NACE":"00","isSelected":false},{"n04_Nazev":"Účetnické a auditorské činnosti; daňové poradenství","n04_NACE":"69200","isSelected":false},{"n04_Nazev":"Ostatní profesní, vědecké a technické činnosti","n04_NACE":"74","isSelected":false}]';
		Lead NewLead = APCZ04_AresByIdController.updateLeadWS(sJsonLead, sJsonNaceLead);
		APCZ01_AresEntity.AresPopUp oAccPopUp = (APCZ01_AresEntity.AresPopUp)JSON.deserialize(sJsonLead, APCZ01_AresEntity.AresPopUp.class); 
        //System.debug('NewLead=' + NewLead.Name);
		
	}

}