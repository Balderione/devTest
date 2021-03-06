@isTest
public class APCZ01_AresEntity_Test{
    
    @isTest
    static void testAresDarvBas() 
    {  
        APCZ01_AresEntity.AresDarvBas ent = new APCZ01_AresEntity.AresDarvBas();
   
        ent.n03_ICO_CRN = 'Test';
        ent.n03_DIC_VatNumber = 'Test';
        ent.n03_OF_Name = 'Test';

        ent.n04_NPF_LegalForm = 'Test';
        ent.n04_NS_Country = 'Test';
        ent.n04_N_City = 'Test';
        ent.n04_NCO_District = 'Test';
        ent.n04_NU_Street = 'Test';
        ent.n04_CD_LandRegNumber = 'Test';
        ent.n04_CO_HouseNumber = 'Test';
        ent.n04_PSC_ZipCode = 'Test';
        ent.n04_StreetFull = 'Test';
        
        System.assertEquals('Test', ent.n03_OF_Name, 'It should be *Test*');
    }
    
    @isTest
    static void testAresNace() 
    {         
        APCZ01_AresEntity.AresNace ent = new APCZ01_AresEntity.AresNace();
   
        ent.n04_NACE = 'Test';
        ent.n04_Nazev = 'Test';
        
        System.assertEquals('Test', ent.n04_Nazev, 'It should be *Test*');
    }

     @isTest
    static void testAresAccountPopUp() 
    {         
        APCZ01_AresEntity.AresPopUp ent = new APCZ01_AresEntity.AresPopUp();
   
        ent.oId = 'Test';
        ent.sName = 'Test';
        ent.sStreet = 'Test';
        ent.sPostalCode = 'Test';
        ent.sCity = 'Test';
        ent.bGetName = true;
        ent.bGetVatNumber = true;
        ent.bGetLegalForm = true;
        ent.bGetZipCode = true;
        ent.bGetStreet = true;
        ent.bGetCity = true;
        
        System.assertEquals('Test', ent.oId, 'It should be *Test*');
    }

}