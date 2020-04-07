@IsTest
public class APIT00_BehaviourTest {
    
    static testMethod void testAPIT00_Behaviour() {
        
        String mess;
        //Campaign camp = new campaign();
     
        Test.startTest();
        APIT00_Behaviour.Debug(mess);
        APIT00_Behaviour.DebugObject('Titolo',mess);
        APIT00_Behaviour.DebugJson('Titolo',mess);
        APIT00_Behaviour.DebugHash('Titolo',mess);
        APIT00_Behaviour.DebugStart('Classe','Metodo');
        APIT00_Behaviour.DebugEnd();
        //APIT00_Behaviour.DebugOn();
        
        //APIT00_Behaviour.DebugList('Titolo',camp);
        
        APIT00_Behaviour.DebugBreak();
        APIT00_Behaviour.DebugLimits(true);
        //APIT00_Behaviour.DebugLimits('Titolo');
        //APIT00_Behaviour.DebugOff();
        //APIT00_Behaviour.DebugLimits(true,'Titolo');
        //APIT00_Behaviour.DebugList('Titolo',mess);
        Test.stopTest();
        
    }

}